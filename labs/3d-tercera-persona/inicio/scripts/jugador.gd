extends CharacterBody3D
class_name Jugador
## EJERCICIO PRINCIPAL del laboratorio (clase 056).
##
## El proyecto arranca tal cual: verás el nivel y al personaje… flotando quieto.
## Tu tarea es darle vida. Ve completando los TODO en orden; tras cada uno,
## ejecuta (F5) y comprueba el resultado. La solución está en ../solucion/.
##
## La diferencia clave con el plataformas 2D no es el eje extra: es que en 3D el
## mando NO manda en coordenadas del mundo, sino RELATIVAS A LA CÁMARA. "Adelante"
## significa "hacia donde mira la cámara" (ver TODO 3, y la clase 048).

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
	# En Godot 4, move_and_slide() usa 'velocity' y NO recibe argumentos.
	move_and_slide()
	_orientar_malla(dir, delta)
	_detectar_aterrizaje()


func _temporizadores(delta: float) -> void:
	# TODO 2 (coyote time): recarga _coyote a coyote_max cuando is_on_floor(),
	#        y si no, réstale delta sin bajar de 0 (usa maxf).
	# TODO 2b (jump buffer): si Input.is_action_just_pressed("jump"), pon
	#         _buffer = buffer_max; si no, réstale delta sin bajar de 0.
	#         Es lo mismo que hiciste en el lab 2D: el tacto se nota igual en 3D.
	pass


func _aplicar_gravedad(delta: float) -> void:
	# TODO 1: si NO estamos en el suelo, RESTA gravedad * delta a velocity.y.
	#         Ojo: en 3D el eje Y apunta hacia ARRIBA, así que la gravedad resta.
	#         (En 2D sumaba, porque allí la Y crece hacia abajo.)
	pass


func _direccion_deseada() -> Vector3:
	## EL CONCEPTO CLAVE DEL LABORATORIO.
	# TODO 3: convierte la entrada del mando en una dirección del MUNDO:
	#   1. var entrada := Input.get_vector("move_left", "move_right",
	#                                      "move_forward", "move_back")
	#   2. si entrada == Vector2.ZERO devuelve Vector3.ZERO
	#   3. var dir := Vector3(entrada.x, 0.0, entrada.y)
	#      (la Y del mando va al eje Z: en Godot "adelante" es -Z)
	#   4. rótala con el yaw de la cámara:
	#      dir = dir.rotated(Vector3.UP, brazo.global_rotation.y)
	#   5. devuélvela normalizada.
	#
	# Sin el paso 4 el personaje ignora hacia dónde mira la cámara: pulsar
	# "adelante" lo movería siempre al mismo punto cardinal. Pruébalo sin él.
	return Vector3.ZERO


func _mover_horizontal(dir: Vector3, delta: float) -> void:
	# TODO 4: acelera y frena en el plano XZ (la Y no se toca: es la del salto).
	#   - objetivo = velocidad_correr si Input.is_action_pressed("correr"),
	#     y si no velocidad_max.
	#   - var plano := Vector2(velocity.x, velocity.z)
	#   - si dir != Vector3.ZERO: plano = plano.move_toward(
	#         Vector2(dir.x, dir.z) * objetivo, aceleracion * delta)
	#   - si no: plano = plano.move_toward(Vector2.ZERO, friccion * delta)
	#   - vuelca el resultado en velocity.x y velocity.z (¡ojo: plano.y es la Z!).
	pass


func _gestionar_salto() -> void:
	# TODO 5: salta si _buffer > 0.0 y _coyote > 0.0 →
	#         velocity.y = fuerza_salto (positivo: en 3D la Y va hacia arriba),
	#         resetea ambos a 0 y sfx_salto.play()
	pass


func _orientar_malla(dir: Vector3, delta: float) -> void:
	## El cuerpo NO rota: rota solo la malla (el nodo Pivote). Así la física sigue
	## siendo una cápsula alineada con el mundo y el personaje mira a donde corre.
	# TODO 6: si dir == Vector3.ZERO no hagas nada; si no:
	#   - var objetivo := atan2(-dir.x, -dir.z)
	#     (los dos signos son por la convención de Godot: "adelante" es -Z)
	#   - pivote.rotation.y = lerp_angle(pivote.rotation.y, objetivo,
	#                                    giro_velocidad * delta)
	#   Usa lerp_angle y no lerp: interpola por el camino corto, así girar de
	#   179° a -179° son dos grados y no una vuelta completa.
	pass


func _detectar_aterrizaje() -> void:
	var en_suelo: bool = is_on_floor()
	if en_suelo and not _en_suelo_previo:
		aterrizo.emit()
	_en_suelo_previo = en_suelo


# --- API pública (ya resuelta: la usa el mundo al ganar) ----------------------
func celebrar() -> void:
	if _celebrando:
		return
	_celebrando = true
	var tw := create_tween().set_loops()
	tw.tween_property(pivote, "rotation:y", pivote.rotation.y + TAU, 1.2)
