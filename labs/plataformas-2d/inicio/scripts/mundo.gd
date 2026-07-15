extends Node2D
## Construye el nivel a partir de un mapa ASCII y orquesta la partida.
##
## Nota didáctica: la clase 035 enseña a pintar niveles con TileMapLayer en el
## editor. Aquí el nivel se genera desde texto para que el proyecto sea legible
## y revisable en un diff (y para que puedas editarlo con cualquier editor).
## El resultado en pantalla es equivalente.
##
## Leyenda del mapa:
##   '#' suelo   'S' piedra   '=' plataforma de madera
##   'o' moneda  'e' enemigo  'P' inicio del jugador  'F' meta

const TILE: int = 16

const NIVEL: Array[String] = [
	"............................................................",
	"............................................................",
	"............................................................",
	"...................ooo......................................",
	"..................=====.....................................",
	"............................................................",
	".........ooo..............................ooo...............",
	"........=====............................=====..............",
	"............................................................",
	"...............................eoo..........................",
	".............................=======........................",
	"............................................................",
	"....ooo..............ooo.................ooo................",
	"...SSSSS.............SSSS...............SSSSS...............",
	"............................................................",
	"..P.............e.................e...............e.....F...",
	"##########...############....##############...##############",
	"##########...############....##############...##############",
	"##########...############....##############...##############",
	"##########...############....##############...##############",
]

# Columna del tileset (64x16 = 4 tiles de 16px) por tipo de bloque.
const TILE_HIERBA: int = 0
const TILE_TIERRA: int = 1
const TILE_PIEDRA: int = 2
const TILE_MADERA: int = 3

const ESC_JUGADOR: PackedScene = preload("res://escenas/jugador.tscn")
const ESC_MONEDA: PackedScene = preload("res://escenas/moneda.tscn")
const ESC_ENEMIGO: PackedScene = preload("res://escenas/enemigo.tscn")
const TEX_TILESET: Texture2D = preload("res://assets/tileset.png")

var _spawn: Vector2 = Vector2(32, 32)
var _jugador: Jugador = null
var _limite_caida: float = 0.0
var _n_bloques: int = 0
var _n_monedas: int = 0
var _n_enemigos: int = 0

@onready var nivel_root: Node2D = $Nivel
@onready var entidades: Node2D = $Entidades


func _ready() -> void:
	_limite_caida = NIVEL.size() * TILE + 96.0
	GameState.reiniciar_partida()
	GameState.partida_terminada.connect(_on_partida_terminada)
	_construir_nivel()
	_crear_jugador()


func _process(_delta: float) -> void:
	# Caer fuera del mundo cuesta una vida (clásico de plataformas).
	if _jugador != null and _jugador.global_position.y > _limite_caida:
		_al_caer()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reiniciar"):
		get_tree().reload_current_scene()


# --- Construcción -------------------------------------------------------------
func _construir_nivel() -> void:
	for fila in NIVEL.size():
		var linea: String = NIVEL[fila]
		for col in linea.length():
			match linea[col]:
				"#":
					# Si arriba está despejado se ve hierba; si no, tierra.
					var arriba_libre: bool = fila == 0 or NIVEL[fila - 1][col] != "#"
					_crear_bloque(col, fila, TILE_HIERBA if arriba_libre else TILE_TIERRA)
				"S":
					_crear_bloque(col, fila, TILE_PIEDRA)
				"=":
					_crear_bloque(col, fila, TILE_MADERA)
				"o":
					_crear_entidad(ESC_MONEDA, col, fila)
					_n_monedas += 1
				"e":
					_crear_entidad(ESC_ENEMIGO, col, fila)
					_n_enemigos += 1
				"P":
					_spawn = _centro(col, fila)
				"F":
					_crear_meta(col, fila)

	# Resumen del nivel: te dice de un vistazo si el mapa se leyó bien.
	# La CI también lo usa como prueba de que el nivel se construyó de verdad.
	print("Nivel construido: %d bloques, %d monedas, %d enemigos (%dx%d tiles)"
		% [_n_bloques, _n_monedas, _n_enemigos, NIVEL[0].length(), NIVEL.size()])


func _centro(col: int, fila: int) -> Vector2:
	return Vector2(col * TILE + TILE / 2.0, fila * TILE + TILE / 2.0)


func _crear_bloque(col: int, fila: int, region: int) -> void:
	var cuerpo := StaticBody2D.new()
	cuerpo.position = _centro(col, fila)
	cuerpo.collision_layer = 1  # Mundo
	cuerpo.collision_mask = 0

	var forma := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(TILE, TILE)
	forma.shape = rect
	cuerpo.add_child(forma)

	var spr := Sprite2D.new()
	spr.texture = TEX_TILESET
	spr.region_enabled = true
	spr.region_rect = Rect2(region * TILE, 0, TILE, TILE)
	cuerpo.add_child(spr)

	nivel_root.add_child(cuerpo)
	_n_bloques += 1


func _crear_entidad(escena: PackedScene, col: int, fila: int) -> void:
	var n := escena.instantiate()
	n.position = _centro(col, fila)
	entidades.add_child(n)


func _crear_meta(col: int, fila: int) -> void:
	var area := Area2D.new()
	area.position = _centro(col, fila)
	area.collision_layer = 8   # Recolectable
	area.collision_mask = 2    # detecta al Jugador

	var forma := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(16, 40)
	forma.shape = rect
	forma.position = Vector2(4, -12)
	area.add_child(forma)

	var mastil := Polygon2D.new()
	mastil.polygon = PackedVector2Array([Vector2(-1, -30), Vector2(1, -30), Vector2(1, 8), Vector2(-1, 8)])
	mastil.color = Color(0.55, 0.40, 0.25)
	area.add_child(mastil)

	var bandera := Polygon2D.new()
	bandera.polygon = PackedVector2Array([Vector2(1, -30), Vector2(15, -23), Vector2(1, -16)])
	bandera.color = Color(0.95, 0.75, 0.20)
	area.add_child(bandera)

	area.body_entered.connect(_on_meta_alcanzada)
	entidades.add_child(area)


func _crear_jugador() -> void:
	_jugador = ESC_JUGADOR.instantiate()
	_jugador.position = _spawn
	entidades.add_child(_jugador)

	# Límites de cámara al tamaño del nivel (clase 032).
	var cam: Camera2D = _jugador.get_node("Camera2D")
	cam.limit_left = 0
	cam.limit_top = -160
	cam.limit_right = NIVEL[0].length() * TILE
	cam.limit_bottom = NIVEL.size() * TILE


# --- Eventos de partida -------------------------------------------------------
func _al_caer() -> void:
	GameState.perder_vida()
	if GameState.esta_terminada():
		_jugador.morir()
		return
	# Reaparece en el inicio.
	_jugador.velocity = Vector2.ZERO
	_jugador.global_position = _spawn


func _on_meta_alcanzada(body: Node2D) -> void:
	if body is Jugador:
		GameState.terminar(true)


func _on_partida_terminada(_victoria: bool) -> void:
	if _jugador != null:
		_jugador.morir()
