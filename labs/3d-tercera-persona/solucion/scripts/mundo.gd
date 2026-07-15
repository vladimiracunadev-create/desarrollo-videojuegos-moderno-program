extends Node3D
## Construye el nivel 3D a partir de dos mapas ASCII y orquesta la partida.
##
## Nota didáctica: la clase 047 enseña a montar escenas 3D en el editor, y la
## 065 a usar GridMap. Aquí el nivel se genera desde texto por la misma razón
## que en el lab 2D: es legible, editable con cualquier editor y revisable en un
## diff. El resultado en pantalla es equivalente.
##
## El nivel son DOS capas superpuestas del mismo tamaño:
##   ALTURAS   → el relieve: '.' abismo, '1'..'9' altura de la columna en niveles.
##   ENTIDADES → lo que se coloca encima: 'P' inicio, 'o' cristal, 'F' meta.

## Lado de cada celda en metros. El mundo mide CELDA * ancho del mapa.
const CELDA: float = 2.0
## Altura de un nivel de relieve. Un escalón de 1 nivel se sube saltando.
const NIVEL_ALTO: float = 0.6

const ALTURAS: Array[String] = [
	"........................",
	"....111111111111........",
	"...11111111111111.......",
	"...11122222222111.......",
	"...11122222222111.......",
	"...11122333322111.......",
	"...11122333322111....11.",
	"...11122333322111.....1.",
	"...11122222222111.....1.",
	"...111111111111111111111",
	"...11111111111111.......",
	"....1111111111..........",
	"........11..............",
	"........11..............",
	"......111111............",
	"......112211............",
	"......111111............",
	"........................",
]

const ENTIDADES: Array[String] = [
	"........................",
	".....o........o.........",
	"........................",
	"....o..........o........",
	"........................",
	"..........FF............",
	"..........FF.........o..",
	"........................",
	"........................",
	"...................o....",
	"........................",
	".....o........o.........",
	"........................",
	"........................",
	"........o...o...........",
	".........P..............",
	"........................",
	"........................",
]

const ESC_JUGADOR: PackedScene = preload("res://escenas/jugador.tscn")
const ESC_CRISTAL: PackedScene = preload("res://escenas/cristal.tscn")
const ESC_BLOQUE: PackedScene = preload("res://escenas/bloque.tscn")
const ESC_META: PackedScene = preload("res://escenas/meta.tscn")

# Un material por altura: el relieve se lee de un vistazo por el color.
const COLORES: Array[Color] = [
	Color(0.36, 0.55, 0.30),  # nivel 1 — hierba
	Color(0.45, 0.60, 0.32),  # nivel 2
	Color(0.58, 0.64, 0.38),  # nivel 3
	Color(0.68, 0.66, 0.48),  # nivel 4+
]

var _spawn: Vector3 = Vector3(0.0, 4.0, 0.0)
var _jugador: Jugador = null
var _limite_caida: float = -12.0
var _n_bloques: int = 0
var _n_cristales: int = 0
var _metas: Array[Vector3] = []
var _materiales: Array[StandardMaterial3D] = []

@onready var nivel_root: Node3D = $Nivel
@onready var entidades: Node3D = $Entidades


func _ready() -> void:
	_validar_mapas()
	_preparar_materiales()
	_construir_relieve()
	_colocar_entidades()
	GameState.reiniciar_partida(_n_cristales)
	GameState.partida_terminada.connect(_on_partida_terminada)
	_crear_jugador()

	# Resumen del nivel: te dice de un vistazo si los mapas se leyeron bien.
	# La CI también lo usa como prueba de que el nivel se construyó de verdad.
	print("Nivel construido: %d bloques, %d cristales, %d metas (%dx%d celdas)"
		% [_n_bloques, _n_cristales, _metas.size(), ALTURAS[0].length(), ALTURAS.size()])


func _process(_delta: float) -> void:
	# Caerse del mundo te devuelve al inicio (clásico de plataformas 3D).
	if _jugador != null and _jugador.global_position.y < _limite_caida:
		_reaparecer()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reiniciar"):
		get_tree().reload_current_scene()


# --- Validación ---------------------------------------------------------------
func _validar_mapas() -> void:
	## Un mapa mal alineado produce un nivel absurdo y difícil de depurar; mejor
	## gritar aquí que dejar que el jugador caiga por un agujero fantasma.
	var ancho: int = ALTURAS[0].length()
	for i in ALTURAS.size():
		assert(ALTURAS[i].length() == ancho,
			"ALTURAS: la fila %d mide %d y debería medir %d" % [i, ALTURAS[i].length(), ancho])
	assert(ENTIDADES.size() == ALTURAS.size(),
		"ENTIDADES tiene %d filas y ALTURAS %d" % [ENTIDADES.size(), ALTURAS.size()])
	for i in ENTIDADES.size():
		assert(ENTIDADES[i].length() == ancho,
			"ENTIDADES: la fila %d mide %d y debería medir %d" % [i, ENTIDADES[i].length(), ancho])


# --- Construcción del relieve -------------------------------------------------
func _preparar_materiales() -> void:
	for c in COLORES:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = c
		mat.roughness = 0.9
		_materiales.append(mat)


func _construir_relieve() -> void:
	for fila in ALTURAS.size():
		var linea: String = ALTURAS[fila]
		for col in linea.length():
			var ch: String = linea[col]
			if ch == ".":
				continue
			var niveles: int = ch.to_int()
			if niveles > 0:
				_crear_columna(col, fila, niveles)


func _crear_columna(col: int, fila: int, niveles: int) -> void:
	## Una columna del relieve es UN solo bloque del alto que toque: menos nodos
	## que apilar cubos y, sobre todo, menos colisiones que resolver (clase 066).
	##
	## El bloque viene de una escena de 1x1x1 y se ESCALA. Escalar el nodo (y no
	## el tamaño de la malla) reaprovecha la misma malla y el mismo shape para
	## los cientos de bloques del nivel, en vez de generar uno nuevo por celda.
	var alto: float = niveles * NIVEL_ALTO
	var bloque: StaticBody3D = ESC_BLOQUE.instantiate()
	bloque.position = Vector3(_x(col), alto * 0.5, _z(fila))
	bloque.scale = Vector3(CELDA, alto, CELDA)
	bloque.get_node("Malla").material_override = _materiales[mini(niveles - 1, _materiales.size() - 1)]

	nivel_root.add_child(bloque)
	_n_bloques += 1


# --- Entidades ----------------------------------------------------------------
func _colocar_entidades() -> void:
	for fila in ENTIDADES.size():
		var linea: String = ENTIDADES[fila]
		for col in linea.length():
			match linea[col]:
				"P":
					_spawn = _superficie(col, fila) + Vector3(0.0, 1.2, 0.0)
				"o":
					_crear_cristal(col, fila)
				"F":
					_metas.append(_superficie(col, fila))

	if not _metas.is_empty():
		_crear_meta()


func _crear_cristal(col: int, fila: int) -> void:
	var n := ESC_CRISTAL.instantiate()
	n.position = _superficie(col, fila) + Vector3(0.0, 1.0, 0.0)
	entidades.add_child(n)
	_n_cristales += 1


func _crear_meta() -> void:
	## El portal se planta en el centro de las celdas 'F' y tiene un tamaño fijo:
	## si las repartes por el mapa en vez de juntarlas, el centro te saldrá en
	## tierra de nadie. Ponlas en bloque.
	var centro := Vector3.ZERO
	for p in _metas:
		centro += p
	centro /= float(_metas.size())

	var area: Area3D = ESC_META.instantiate()
	area.position = centro + Vector3(0.0, 1.5, 0.0)
	area.scale = Vector3(CELDA * 0.9, 3.0, CELDA * 0.9)
	area.body_entered.connect(_on_meta_entrada)
	entidades.add_child(area)


func _crear_jugador() -> void:
	_jugador = ESC_JUGADOR.instantiate()
	_jugador.position = _spawn
	entidades.add_child(_jugador)


# --- Coordenadas --------------------------------------------------------------
func _x(col: int) -> float:
	## El mapa se centra en el origen: así la cámara y el sol no dependen del tamaño.
	return (col - ALTURAS[0].length() * 0.5 + 0.5) * CELDA


func _z(fila: int) -> float:
	return (fila - ALTURAS.size() * 0.5 + 0.5) * CELDA


func _superficie(col: int, fila: int) -> Vector3:
	## Punto sobre el que se apoya lo que se coloque en esa celda.
	var ch: String = ALTURAS[fila][col]
	var niveles: int = 0 if ch == "." else ch.to_int()
	return Vector3(_x(col), niveles * NIVEL_ALTO, _z(fila))


# --- Eventos de partida -------------------------------------------------------
func _reaparecer() -> void:
	_jugador.velocity = Vector3.ZERO
	_jugador.global_position = _spawn


func _on_meta_entrada(body: Node3D) -> void:
	if body is Jugador and GameState.puede_terminar():
		GameState.terminar(true)


func _on_partida_terminada(_victoria: bool) -> void:
	if _jugador != null:
		_jugador.celebrar()
