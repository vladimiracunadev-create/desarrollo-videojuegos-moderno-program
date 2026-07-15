extends Node2D
## Construye el escenario desde un mapa ASCII y reparte lo que cada uno necesita.
##
## Infraestructura del lab: el ejercicio está en el árbol (scripts/bt/) y en la
## percepción de enemigo.gd.
##
## El nivel se genera desde texto por lo mismo que en los otros labs: es legible,
## se edita con cualquier editor y se revisa en un diff.
##
## Leyenda del mapa:
##   '#' muro   '.' suelo   'P' jugador   'E' enemigo   'o' punto de patrulla

const CELDA: int = 32

const MAPA: Array[String] = [
	"########################",
	"#o.....#........#.....o#",
	"#......#........#......#",
	"#......#...##...#......#",
	"#..................#...#",
	"#..E...#...##...#..#...#",
	"#......#........#......#",
	"#......#........#......#",
	"#####..#..####..#..#####",
	"#.........#............#",
	"#.........#............#",
	"#..####...#...####.....#",
	"#.....#...#......#.....#",
	"#.....#........P.#.....#",
	"#o....#..........#....o#",
	"########################",
]

const ESC_ENEMIGO: PackedScene = preload("res://escenas/enemigo.tscn")
const ESC_JUGADOR: PackedScene = preload("res://escenas/jugador.tscn")

var nav: Navegador

@onready var nivel: Node2D = $Nivel
@onready var entidades: Node2D = $Entidades


func _ready() -> void:
	_validar_mapa()
	nav = Navegador.new(MAPA, CELDA)
	_pintar_muros()

	var patrulla: Array[Vector2] = []
	var pos_enemigo := Vector2.ZERO
	var pos_jugador := Vector2.ZERO
	for y in MAPA.size():
		for x in MAPA[y].length():
			var p: Vector2 = nav.centro(Vector2i(x, y))
			match MAPA[y][x]:
				"o": patrulla.append(p)
				"E": pos_enemigo = p
				"P": pos_jugador = p

	var jugador: CharacterBody2D = ESC_JUGADOR.instantiate()
	jugador.position = pos_jugador
	jugador.configurar(nav)
	entidades.add_child(jugador)

	var enemigo: CharacterBody2D = ESC_ENEMIGO.instantiate()
	enemigo.position = pos_enemigo
	# El enemigo no busca el mundo: el mundo le da lo que necesita. Así el
	# enemigo depende del Navegador y de un Node2D al que seguir, y de nada más.
	enemigo.configurar(nav, patrulla, jugador)
	entidades.add_child(enemigo)

	# Resumen: te dice de un vistazo si el mapa se leyó bien. La CI lo usa como
	# prueba de que el nivel se construyó de verdad.
	print("Nivel construido: %d muros, %d puntos de patrulla (%dx%d celdas)"
		% [nav.muros(), patrulla.size(), MAPA[0].length(), MAPA.size()])


func _validar_mapa() -> void:
	## Un mapa descuadrado da un nivel absurdo y muy difícil de depurar: mejor
	## gritar aquí.
	var ancho: int = MAPA[0].length()
	for i in MAPA.size():
		assert(MAPA[i].length() == ancho,
			"MAPA: la fila %d mide %d y debería medir %d" % [i, MAPA[i].length(), ancho])


func _pintar_muros() -> void:
	for y in MAPA.size():
		for x in MAPA[y].length():
			if MAPA[y][x] != "#":
				continue
			var cuerpo := StaticBody2D.new()
			cuerpo.position = nav.centro(Vector2i(x, y))
			cuerpo.collision_layer = 1
			cuerpo.collision_mask = 0

			var forma := CollisionShape2D.new()
			var rect := RectangleShape2D.new()
			rect.size = Vector2(CELDA, CELDA)
			forma.shape = rect
			cuerpo.add_child(forma)

			var vis := ColorRect.new()
			vis.offset_left = -CELDA / 2.0
			vis.offset_top = -CELDA / 2.0
			vis.offset_right = CELDA / 2.0
			vis.offset_bottom = CELDA / 2.0
			vis.color = Color(0.22, 0.24, 0.30)
			cuerpo.add_child(vis)

			nivel.add_child(cuerpo)
