extends CharacterBody2D
class_name Enemigo
## El enemigo: percepción, memoria y un behavior tree que decide (clase 125).
##
## Aquí está el grueso de la Parte 5. El reparto es:
##   - el ÁRBOL (scripts/bt/) decide QUÉ hacer,
##   - este script sabe CÓMO hacerlo (ver, moverse, recordar),
##   - el BLACKBOARD es lo único que comparten.
##
## Esa separación es el motivo de usar un BT y no una FSM: añadir un
## comportamiento es añadir una rama, no repasar todas las transiciones que ya
## tenías (clases 109 y 111).

signal estado_cambiado(nombre: String)

@export var velocidad: float = 85.0
@export var velocidad_persecucion: float = 130.0
## Alcance de la vista, en píxeles.
@export var vista_radio: float = 260.0
## Apertura TOTAL del cono, en grados. 90 = 45 a cada lado.
@export var vista_angulo: float = 90.0
## Cuánto recuerda al jugador tras perderlo de vista, en segundos.
@export var memoria: float = 3.0
## A qué distancia da por alcanzado un punto.
@export var margen: float = 6.0

var blackboard: Dictionary = {
	"objetivo": null,        ## el jugador, si lo veo AHORA
	"ultima_pos": Vector2.ZERO,  ## dónde lo vi por última vez
	"tiene_memoria": false,  ## ¿me queda algo que investigar?
	"estado": "patrulla",
}

var _arbol: NodoBT
var _nav: Navegador
var _patrulla: Array[Vector2] = []
var _jugador: Node2D = null
var _ruta: PackedVector2Array = PackedVector2Array()
var _indice_patrulla: int = 0
var _memoria_restante: float = 0.0
var _mirando: Vector2 = Vector2.RIGHT
var _estado_previo: String = ""

@onready var rayo: RayCast2D = $Rayo


func configurar(nav: Navegador, patrulla: Array[Vector2], jugador: Node2D) -> void:
	## Se llama ANTES de entrar al árbol de escena: el enemigo no sale a buscar
	## sus dependencias por el árbol de nodos, se las dan. Así este script no
	## sabe nada del Mundo — que además evita que Godot se muerda la cola al
	## cargar la escena.
	_nav = nav
	_patrulla = patrulla
	_jugador = jugador


func _ready() -> void:
	_arbol = _construir_arbol()
	print("Árbol construido: %d nodos\n%s" % [_arbol.contar(), _arbol.describir()])


# --- El árbol -----------------------------------------------------------------
func _construir_arbol() -> NodoBT:
	## El orden de los hijos del selector ES el diseño de la IA: lo de arriba
	## gana. Combatir manda sobre buscar, y buscar sobre patrullar.
	var combatir := Secuencia.new("combatir", [
		HojaBT.Condicion.new("¿veo al jugador?", _cond_veo_jugador),
		HojaBT.AccionBT.new("perseguir", _acc_perseguir),
	] as Array[NodoBT])

	var buscar := Secuencia.new("buscar", [
		HojaBT.Condicion.new("¿me queda memoria?", _cond_tiene_memoria),
		HojaBT.AccionBT.new("ir a la última posición", _acc_investigar),
	] as Array[NodoBT])

	var patrullar := Secuencia.new("patrullar", [
		HojaBT.AccionBT.new("recorrer los puntos", _acc_patrullar),
	] as Array[NodoBT])

	return Selector.new("raíz", [combatir, buscar, patrullar] as Array[NodoBT])


func _physics_process(delta: float) -> void:
	_percibir(delta)
	_arbol.tick(self, blackboard)
	move_and_slide()
	_avisar_estado()


func _avisar_estado() -> void:
	var e: String = str(blackboard["estado"])
	if e != _estado_previo:
		_estado_previo = e
		estado_cambiado.emit(e)
		# La CI lee estas líneas: son la prueba de que la IA decide de verdad.
		print("IA: %s" % e)


# --- Percepción (clase 116) ---------------------------------------------------
func _percibir(delta: float) -> void:
	if _jugador != null and _puedo_ver(_jugador.global_position):
		blackboard["objetivo"] = _jugador
		blackboard["ultima_pos"] = _jugador.global_position
		blackboard["tiene_memoria"] = true
		_memoria_restante = memoria
		return

	# No lo veo: el objetivo desaparece, pero la memoria dura un rato. Sin esto
	# el enemigo es tonto de una forma muy reconocible: te pierde de vista y se
	# olvida de ti en el mismo frame.
	blackboard["objetivo"] = null
	if _memoria_restante > 0.0:
		_memoria_restante = maxf(_memoria_restante - delta, 0.0)
		if _memoria_restante == 0.0:
			blackboard["tiene_memoria"] = false


func _puedo_ver(punto: Vector2) -> bool:
	## Tres filtros, del más barato al más caro. El orden importa: el raycast
	## cuesta lo suyo, así que solo se lanza si los dos primeros pasan.
	var hacia: Vector2 = punto - global_position

	# 1) ¿Está lo bastante cerca?
	if hacia.length() > vista_radio:
		return false

	# 2) ¿Está dentro del cono? Producto punto contra el coseno del semiángulo:
	#    comparar ángulos con acos() daría lo mismo y costaría más.
	var coseno_limite: float = cos(deg_to_rad(vista_angulo * 0.5))
	if _mirando.normalized().dot(hacia.normalized()) < coseno_limite:
		return false

	# 3) ¿Hay un muro en medio? force_raycast_update() lo resuelve AQUÍ, sin
	#    esperar al siguiente paso de física.
	rayo.target_position = to_local(punto)
	rayo.force_raycast_update()
	return not rayo.is_colliding()


func mirando() -> Vector2:
	return _mirando


# --- Condiciones del árbol ----------------------------------------------------
func _cond_veo_jugador(_a: Node, bb: Dictionary) -> bool:
	return bb["objetivo"] != null


func _cond_tiene_memoria(_a: Node, bb: Dictionary) -> bool:
	return bool(bb["tiene_memoria"])


# --- Acciones del árbol -------------------------------------------------------
func _acc_perseguir(_a: Node, bb: Dictionary) -> int:
	bb["estado"] = "persecucion"
	var objetivo: Node2D = bb["objetivo"]
	_ir_hacia(objetivo.global_position, velocidad_persecucion)
	# Perseguir no "termina": mientras lo vea, sigo. Eso es EN_CURSO, y hace que
	# el selector no baje a las otras ramas.
	return NodoBT.Estado.EN_CURSO


func _acc_investigar(_a: Node, bb: Dictionary) -> int:
	bb["estado"] = "busqueda"
	var destino: Vector2 = bb["ultima_pos"]
	if global_position.distance_to(destino) < margen * 2.0:
		# He llegado y no está: se acabó la pista.
		bb["tiene_memoria"] = false
		_memoria_restante = 0.0
		return NodoBT.Estado.EXITO
	_ir_hacia(destino, velocidad)
	return NodoBT.Estado.EN_CURSO


func _acc_patrullar(_a: Node, bb: Dictionary) -> int:
	bb["estado"] = "patrulla"
	var puntos: Array[Vector2] = _patrulla
	if puntos.is_empty():
		return NodoBT.Estado.FALLO

	var destino: Vector2 = puntos[_indice_patrulla % puntos.size()]
	if global_position.distance_to(destino) < margen * 2.0:
		_indice_patrulla = (_indice_patrulla + 1) % puntos.size()
		destino = puntos[_indice_patrulla]

	_ir_hacia(destino, velocidad)
	return NodoBT.Estado.EN_CURSO


# --- Movimiento ---------------------------------------------------------------
func _ir_hacia(destino: Vector2, vel: float) -> void:
	_ruta = _nav.ruta(global_position, destino)

	# A* devuelve la ruta entera; solo necesitamos el siguiente punto. El [0] es
	# la celda en la que ya estamos, de ahí el [1].
	#
	# Y cuando la ruta trae UN solo punto es que ya estamos en la celda del
	# destino: entonces hay que ir derecho a él. Si en ese caso parásemos, el
	# enemigo se quedaría clavado a medio tile de su objetivo, sin llegar nunca
	# y sin pasar al siguiente. (Es exactamente lo que pasaba aquí.)
	var siguiente: Vector2 = destino if _ruta.size() < 2 else _ruta[1]

	var dir: Vector2 = siguiente - global_position
	if dir.length() < margen:
		velocity = Vector2.ZERO
		return
	dir = dir.normalized()
	velocity = dir * vel
	# El enemigo mira hacia donde anda: si no, el cono de visión apuntaría
	# siempre al mismo sitio y no vería nada nunca.
	_mirando = _mirando.slerp(dir, 0.2)


func ruta_actual() -> PackedVector2Array:
	return _ruta
