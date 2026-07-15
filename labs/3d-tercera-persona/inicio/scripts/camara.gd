extends SpringArm3D
## EJERCICIO (clase 056): cámara orbital de tercera persona.
##
## Va en un SpringArm3D, que es el nodo que hace el trabajo sucio: lanza un rayo
## hacia la cámara y la acerca si hay una pared en medio. Sin esto, la cámara se
## mete dentro del terreno cada vez que te pegas a un muro.
##
## Lo que YA funciona: el brazo cuelga del jugador pero no hereda su rotación
## (top_level), y lo persigue con suavizado. Lo que falta: girarlo con el ratón.
## Mientras no lo hagas, la cámara te seguirá pero mirando siempre al mismo sitio.

@export_range(0.05, 1.0) var sensibilidad: float = 0.25
## Límites de inclinación: sin esto la cámara da la vuelta de campana.
@export var pitch_min_grados: float = -60.0
@export var pitch_max_grados: float = 25.0
@export var altura_objetivo: float = 1.2
## Suavizado del seguimiento: la cámara persigue al jugador, no va pegada a él.
@export var suavizado: float = 12.0

var _yaw: float = 0.0
var _pitch: float = -15.0

@onready var _objetivo: Node3D = get_parent()


func _ready() -> void:
	# El brazo se coloca en el mundo por su cuenta (ver _process).
	top_level = true
	global_position = _objetivo.global_position + Vector3.UP * altura_objetivo
	_aplicar_rotacion()
	_capturar_raton(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# TODO 1 (orbitar): usa event.relative para girar la cámara.
		#   - _yaw   -= event.relative.x * sensibilidad
		#   - _pitch -= event.relative.y * sensibilidad
		#   (van RESTANDO: mover el ratón a la derecha debe girar la vista a la
		#    derecha, lo que equivale a girar el brazo en negativo).
		# TODO 2 (límites): _pitch = clampf(_pitch, pitch_min_grados, pitch_max_grados)
		#   Quita el clamp un momento y mira al cielo: entenderás para qué está.
		# TODO 3: llama a _aplicar_rotacion() para que el cambio se vea.
		pass
	elif event.is_action_pressed("liberar_raton"):
		_capturar_raton(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED)
	elif event is InputEventMouseButton and event.pressed:
		# Volver a capturar el ratón al hacer clic en la ventana.
		_capturar_raton(true)


func _process(delta: float) -> void:
	if not is_instance_valid(_objetivo):
		return
	var destino: Vector3 = _objetivo.global_position + Vector3.UP * altura_objetivo
	# Interpolación estable a cualquier framerate (clase 025).
	var t: float = 1.0 - exp(-suavizado * delta)
	global_position = global_position.lerp(destino, t)


func _aplicar_rotacion() -> void:
	rotation_degrees = Vector3(_pitch, _yaw, 0.0)


func _capturar_raton(capturar: bool) -> void:
	# En headless no hay ratón que capturar; llamarlo igual es inofensivo.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if capturar else Input.MOUSE_MODE_VISIBLE
