extends Area3D
## EJERCICIO (clase 039): recolectable 3D, el primo de la moneda del lab 2D.
##
## El cristal ya gira y flota en su sitio, pero no hace nada al tocarlo.
## Es un Area3D: no colisiona, solo DETECTA.

@export var giro_velocidad: float = 2.0
@export var flote_alto: float = 0.18
@export var flote_velocidad: float = 2.5

var _recogido: bool = false
var _y_base: float = 0.0
var _t: float = 0.0

@onready var malla: MeshInstance3D = $Malla
@onready var sfx: AudioStreamPlayer3D = $Sfx


func _ready() -> void:
	_y_base = malla.position.y
	# Desfase por posición: así los cristales no laten todos a la vez.
	_t = global_position.x + global_position.z
	# TODO 1: conecta la señal body_entered a _on_body_entered.
	#         Pista: body_entered.connect(_on_body_entered)
	pass


func _process(delta: float) -> void:
	if _recogido:
		return
	_t += delta
	malla.rotate_y(giro_velocidad * delta)
	malla.position.y = _y_base + sin(_t * flote_velocidad) * flote_alto


func _on_body_entered(body: Node3D) -> void:
	# TODO 2: si ya está recogido o el cuerpo no es un Jugador, return.
	# TODO 3: marca _recogido, avisa con GameState.recoger_cristal()
	#         y reproduce sfx.play().
	# TODO 4 (juice): desactiva la detección con
	#         set_deferred("monitoring", false) y anima el cristal con
	#         create_tween() (que suba y encoja) antes de queue_free().
	#         Fíjate en cómo lo hace moneda.gd en el lab 2D: es idéntico salvo
	#         que aquí las posiciones y escalas son Vector3.
	pass
