extends Node2D
class_name Arena
## La partida: el servidor crea un avatar por peer y el MultiplayerSpawner los
## replica en todos los clientes (clase 142).
##
## Infraestructura del lab: el ejercicio está en jugador.gd.

## Límites del terreno de juego. Los usa el servidor al validar (jugador.gd):
## nadie puede salirse, ni con un cliente modificado.
const LIMITE_MIN: Vector2 = Vector2(24, 24)
const LIMITE_MAX: Vector2 = Vector2(776, 576)

const ESC_JUGADOR: PackedScene = preload("res://escenas/jugador.tscn")

@onready var jugadores: Node2D = $Jugadores
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	if not multiplayer.is_server():
		# El cliente no crea nada: los avatares le llegan por el spawner. Si
		# los creara también, tendría dos por jugador.
		jugadores.child_entered_tree.connect(_on_avatar_recibido)
		print("Arena lista (cliente): esperando avatares del servidor")
		return

	NetworkManager.jugador_entro.connect(_crear_avatar)
	NetworkManager.jugador_salio.connect(_borrar_avatar)

	# Los que ya estaban dentro cuando arrancó la arena.
	for id in NetworkManager.jugadores:
		if id != 1:
			_crear_avatar(id)

	print("Arena lista (servidor): %d avatares" % jugadores.get_child_count())


# --- Solo cliente -------------------------------------------------------------
func _on_avatar_recibido(n: Node) -> void:
	## Lo dispara el MultiplayerSpawner al replicar un avatar. El cliente no ha
	## instanciado nada: le ha llegado. Es la prueba de que el spawner funciona.
	var quien: String = "el mío" if str(n.name).to_int() == multiplayer.get_unique_id() else "remoto"
	print("Avatar recibido del servidor: #%s (%s), total %d"
		% [n.name, quien, jugadores.get_child_count()])


# --- Solo servidor ------------------------------------------------------------
func _crear_avatar(id: int) -> void:
	if jugadores.has_node(str(id)):
		return

	var j: JugadorRed = ESC_JUGADOR.instantiate()
	# El nombre del nodo ES el peer id: así el mismo nodo tiene el mismo nombre
	# en todas las máquinas y los RPC llegan a su destino (clase 142).
	j.name = str(id)
	j.position = _punto_de_aparicion(id)
	# Y la posición replicada, también: el synchronizer manda 'pos_red' en el
	# propio spawn, así que si no la ponemos aquí el avatar nace en (0,0) en el
	# cliente y aparece cruzando la pantalla hasta su sitio.
	j.pos_red = j.position

	# LA LÍNEA IMPORTANTE: la autoridad es el SERVIDOR (peer 1), no el dueño.
	# El cliente solo predice; el servidor decide. Cambia esto por
	# set_multiplayer_authority(id) y tendrás un juego que se puede trampear
	# desde el primer minuto (clases 148 y 155).
	j.set_multiplayer_authority(1)

	jugadores.add_child(j, true)
	print("Avatar creado para el peer %d en %s (total %d)"
		% [id, j.position, jugadores.get_child_count()])


func _borrar_avatar(id: int) -> void:
	if not jugadores.has_node(str(id)):
		return
	jugadores.get_node(str(id)).queue_free()
	print("Avatar retirado del peer %d" % id)


func _punto_de_aparicion(id: int) -> Vector2:
	## Reparte a la gente en círculo alrededor del centro: así dos que entran a
	## la vez no aparecen uno dentro del otro.
	var centro: Vector2 = (LIMITE_MIN + LIMITE_MAX) * 0.5
	var angulo: float = float(id % 8) * TAU / 8.0
	return centro + Vector2(cos(angulo), sin(angulo)) * 160.0
