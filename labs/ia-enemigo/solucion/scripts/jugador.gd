extends CharacterBody2D
## El jugador. Infraestructura del lab: aquí no hay ejercicio — el ejercicio es
## el enemigo que te busca.
##
## Con `--bot` recorre solo un circuito fijo. No es parte del juego: es lo que
## permite que la CI compruebe la IA sin que nadie toque una tecla, y que la
## compruebe SIEMPRE IGUAL (el recorrido es determinista, no aleatorio).
##
## El bot usa el mismo A* que el enemigo. En línea recta se quedaría pegado al
## primer muro, y entonces la prueba no probaría nada.

@export var velocidad: float = 110.0

## Celdas del circuito. Están elegidas para que el bot entre y salga del cono de
## visión del enemigo: así el árbol recorre patrulla → persecución → búsqueda.
const CIRCUITO: Array[Vector2i] = [
	Vector2i(15, 13), Vector2i(5, 13), Vector2i(5, 5), Vector2i(15, 5),
]

var _bot: bool = false
var _nav: Navegador = null
var _i: int = 0


func configurar(nav: Navegador) -> void:
	_nav = nav


func _ready() -> void:
	var args := OS.get_cmdline_args()
	args.append_array(OS.get_cmdline_user_args())
	_bot = args.has("--bot")


func _physics_process(_delta: float) -> void:
	if _bot and _nav != null:
		_mover_bot()
	else:
		var dir := Input.get_vector("izq", "der", "arriba", "abajo")
		velocity = dir.limit_length(1.0) * velocidad
	move_and_slide()


func _mover_bot() -> void:
	var destino: Vector2 = _nav.centro(CIRCUITO[_i])
	if global_position.distance_to(destino) < 10.0:
		_i = (_i + 1) % CIRCUITO.size()
		destino = _nav.centro(CIRCUITO[_i])

	var ruta: PackedVector2Array = _nav.ruta(global_position, destino)
	var siguiente: Vector2 = destino if ruta.size() < 2 else ruta[1]
	velocity = (siguiente - global_position).normalized() * velocidad
