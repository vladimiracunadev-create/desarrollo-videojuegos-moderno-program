extends CharacterBody3D
class_name Jugador
## Controlador en tercera persona (clase 056).
##
## La diferencia clave con el plataformas 2D no es el eje extra: es que en 3D el
## mando NO manda en coordenadas del mundo, sino RELATIVAS A LA CÁMARA. "Adelante"
## significa "hacia donde mira la cámara", así que la entrada hay que rotarla con
## la orientación del brazo de cámara antes de usarla (ver clase 048, bases y
## transformaciones).

signal aterrizo

@export_group("Movimiento")
@export var velocidad_max: float = 6.0
@export var velocidad_correr: float = 9.5
@export var aceleracion: float = 40.0
@export var friccion: float = 55.0
## Lo rápido que el personaje se gira hacia donde va (radianes por segundo).
@export var giro_velocidad: float = 12.0

@export_group("Salto")
@export var fuerza_salto: float = 8.0
@export var gravedad: float = 24.0
## Margen para saltar justo después de salir de una plataforma.
@export var coyote_max: float = 0.12
## Margen para recordar una pulsación hecha justo antes de aterrizar.
@export var buffer_max: float = 0.12

var _coyote: float = 0.0
var _buffer: float = 0.0
var _en_suelo_previo: bool = true
var _celebrando: bool = false

@onready var pivote: Node3D = $Pivote
@onready var brazo: SpringArm3D = $BrazoCamara
@onready var sfx_salto: AudioStreamPlayer3D = $SfxSalto


func _physics_process(delta: float) -> void:
	if _celebrando:
		# Al ganar seguimos aplicando gravedad para no quedar flotando.
		velocity.x = 0.0
		velocity.z = 0.0
		_aplicar_gravedad(delta)
		move_and_slide()
		return

	_temporizadores(delta)
	_aplicar_gravedad(delta)
	var dir: Vector3 = _direccion_deseada()
	_mover_horizontal(dir, delta)
	_gestionar_salto()
	move_and_slide()
	_orientar_malla(dir, delta)
	_detectar_aterrizaje()


func _temporizadores(delta: float) -> void:
	# Coyote: se recarga en el suelo y decrece en el aire.
	if is_on_floor():
		_coyote = coyote_max
	else:
		_coyote = maxf(_coyote - delta, 0.0)

	# Buffer: recuerda la pulsación durante un instante.
	if Input.is_action_just_pressed("jump"):
		_buffer = buffer_max
	else:
		_buffer = maxf(_buffer - delta, 0.0)


func _aplicar_gravedad(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta


func _direccion_deseada() -> Vector3:
	## Convierte la entrada 2D del mando en una dirección del MUNDO, rotándola con
	## el yaw del brazo de cámara. Es el corazón del control en tercera persona.
	var entrada: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if entrada == Vector2.ZERO:
		return Vector3.ZERO
	# -Z es "adelante" en Godot: por eso la Y del mando va al eje Z con signo.
	var dir := Vector3(entrada.x, 0.0, entrada.y)
	dir = dir.rotated(Vector3.UP, brazo.global_rotation.y)
	return dir.normalized()


func _mover_horizontal(dir: Vector3, delta: float) -> void:
	var objetivo: float = velocidad_correr if Input.is_action_pressed("correr") else velocidad_max
	var plano := Vector2(velocity.x, velocity.z)
	if dir != Vector3.ZERO:
		var deseada := Vector2(dir.x, dir.z) * objetivo
		plano = plano.move_toward(deseada, aceleracion * delta)
	else:
		plano = plano.move_toward(Vector2.ZERO, friccion * delta)
	velocity.x = plano.x
	velocity.z = plano.y


func _gestionar_salto() -> void:
	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = fuerza_salto
		_buffer = 0.0
		_coyote = 0.0
		sfx_salto.play()


func _orientar_malla(dir: Vector3, delta: float) -> void:
	## El cuerpo NO rota: rota solo la malla. Así la física sigue siendo una
	## cápsula alineada con el mundo y el personaje mira hacia donde corre.
	if dir == Vector3.ZERO:
		return
	# Los dos signos son por la convención de Godot: "adelante" es -Z, así que
	# para mirar hacia 'dir' hay que apuntar el -Z de la malla en esa dirección.
	var objetivo: float = atan2(-dir.x, -dir.z)
	# lerp_angle interpola por el camino corto: sin él, girar de 179° a -179°
	# daría una vuelta completa en vez de dos grados.
	pivote.rotation.y = lerp_angle(pivote.rotation.y, objetivo, giro_velocidad * delta)


func _detectar_aterrizaje() -> void:
	var en_suelo: bool = is_on_floor()
	if en_suelo and not _en_suelo_previo:
		aterrizo.emit()
	_en_suelo_previo = en_suelo


# --- API pública --------------------------------------------------------------
func celebrar() -> void:
	if _celebrando:
		return
	_celebrando = true
	var tw := create_tween().set_loops()
	tw.tween_property(pivote, "rotation:y", pivote.rotation.y + TAU, 1.2)
