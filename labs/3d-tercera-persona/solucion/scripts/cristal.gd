extends Area3D
## Recolectable 3D (equivalente a la moneda del lab 2D, clase 039).
##
## Es un Area3D: no colisiona, solo DETECTA. Gira y flota para que se vea que es
## recogible sin necesidad de explicarlo (clase 193, feedback y juice).

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
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if _recogido:
		return
	_t += delta
	malla.rotate_y(giro_velocidad * delta)
	malla.position.y = _y_base + sin(_t * flote_velocidad) * flote_alto


func _on_body_entered(body: Node3D) -> void:
	if _recogido or not body is Jugador:
		return
	_recogido = true
	GameState.recoger_cristal()
	sfx.play()

	# Feedback: sube, encoge y desaparece; se libera al terminar el tween.
	set_deferred("monitoring", false)
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(malla, "position:y", _y_base + 1.0, 0.3)
	tw.tween_property(malla, "scale", Vector3.ZERO, 0.3).set_ease(Tween.EASE_IN)
	# Esperamos también al sonido para no cortarlo al liberar el nodo.
	tw.chain().tween_interval(0.2)
	tw.chain().tween_callback(queue_free)
