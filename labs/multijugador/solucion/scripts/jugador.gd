extends CharacterBody2D
class_name JugadorRed
## El avatar en red: predicción, reconciliación, interpolación y validación.
##
## Aquí está TODO lo que enseña la Parte 7. Las tres reglas que lo gobiernan:
##
##   1. La autoridad del nodo es el SERVIDOR (peer 1), siempre. El cliente NO
##      manda: predice. Confundir "dueño del input" con "autoridad" es el error
##      clásico de la parte (clases 148 y 155).
##   2. Predicción para tu propio avatar; interpolación para los ajenos
##      (clase 146). No son alternativas: cada una es para un caso.
##   3. El servidor nunca se fía del cliente: valida cada input contra lo que es
##      físicamente posible (clases 148 y 154).

## Velocidad en píxeles/segundo. La comparten cliente y servidor: si no
## coincidieran, la reconciliación pelearía con la predicción para siempre.
const VEL: float = 220.0
## Margen de tolerancia del servidor al validar un paso. 1.2 deja hueco al
## jitter de red sin permitir un speedhack (clase 154).
const TOLERANCIA: float = 1.2
## Si el servidor y yo diferimos menos que esto, no corrijo: reconciliar por
## medio píxel se ve como un temblor constante.
const UMBRAL_RECONCILIACION: float = 0.5
## Cuántos inputs sin confirmar guardo como mucho. A 30 Hz son ~2 s: si el
## servidor tarda más, el historial no es el problema.
const MAX_HISTORIAL: int = 64

var peer_id: int = 1

## Lo que el MultiplayerSynchronizer replica. OJO: replicamos ESTA propiedad y
## no 'position' directamente, y es a propósito. Si el synchronizer escribiera
## en 'position', teletransportaría el nodo 30 veces por segundo y machacaría la
## interpolación: se vería exactamente el tirón que intentamos quitar. Así, la
## posición replicada entra por aquí y el nodo la persigue suave (clase 146).
@export var pos_red: Vector2:
	set(v):
		pos_red = v
		_objetivo_remoto = v

# --- Estado del cliente (predicción) ---
var _seq: int = 0
var _historial: Array[Dictionary] = []

# --- Estado del remoto (interpolación) ---
var _objetivo_remoto: Vector2 = Vector2.ZERO

# --- Estado del servidor (validación) ---
var _ultimo_seq_visto: int = 0
var _rechazados: int = 0

# --- Diagnóstico (no es parte del juego: lo lee la CI) ---
var _confirmaciones: int = 0
var _correcciones: int = 0

@onready var etiqueta: Label = $Etiqueta


# --- La simulación compartida -------------------------------------------------
static func aplicar_input(pos: Vector2, dir: Vector2, dt: float) -> Vector2:
	## LA función del laboratorio. Cliente y servidor mueven al jugador llamando
	## aquí, y solo aquí.
	##
	## Es `static` y pura a propósito: no lee el reloj, ni el input, ni el estado
	## del nodo. Solo (posición, dirección, delta) -> posición. Así el cliente
	## puede ejecutarla para predecir, el servidor para decidir, y el cliente otra
	## vez para reaplicar al reconciliar — y los tres obtienen el MISMO resultado.
	##
	## Cada regla que se escriba fuera de aquí (un límite, un rozamiento, un
	## empujón) es una regla que el servidor aplicará y el cliente no: divergencia
	## garantizada y goma en pantalla. Si añades una mecánica, añádela aquí
	## (clase 145).
	var p: Vector2 = pos + dir.limit_length(1.0) * VEL * dt
	return p.clamp(Arena.LIMITE_MIN, Arena.LIMITE_MAX)


func _ready() -> void:
	peer_id = str(name).to_int()
	# En el cliente, 'position' NO se replica: la posición buena llega en pos_red
	# junto con el spawn. Sin esto, el avatar nacería en (0,0) y su primer
	# movimiento sería un viaje desde la esquina hasta su sitio.
	if pos_red != Vector2.ZERO:
		global_position = pos_red
	_objetivo_remoto = global_position
	etiqueta.text = "#%d" % peer_id
	# Tu avatar se pinta distinto: sin esto, en una arena .io no sabes cuál eres.
	if _es_local():
		$Cuerpo.color = Color(0.35, 0.85, 0.45)
		etiqueta.text = "#%d (tú)" % peer_id


func _es_local() -> bool:
	## "Mío" = lo controla este cliente. NO es lo mismo que ser la autoridad:
	## la autoridad del nodo es el servidor.
	return peer_id == multiplayer.get_unique_id()


# --- Cliente: predicción ------------------------------------------------------
func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		# La autoridad publica su verdad; el synchronizer la reparte.
		pos_red = global_position
		return
	if not _es_local():
		return

	var dir: Vector2 = _leer_input()
	_seq += 1

	# Predicción: muevo YA, sin esperar al servidor. Es lo que hace que el juego
	# responda al instante aunque el servidor esté a 100 ms.
	global_position = aplicar_input(global_position, dir, delta)

	# Guardo el input hasta que el servidor lo confirme: si hay que corregir,
	# habrá que reaplicar todos estos.
	_historial.append({"seq": _seq, "dir": dir})
	if _historial.size() > MAX_HISTORIAL:
		_historial.pop_front()

	enviar_input.rpc_id(1, _seq, dir)


func _leer_input() -> Vector2:
	if NetworkManager.modo_tramposo:
		# Un cliente modificado puede mandar LO QUE QUIERA: aquí, un vector de
		# longitud 5 para ir cinco veces más rápido. El límite del cliente no
		# protege nada, porque el tramposo es justo quien lo ha quitado. Por eso
		# el que valida tiene que ser el servidor (clase 154).
		return _input_de_bot() * 5.0
	if NetworkManager.modo_bot:
		return _input_de_bot()
	return Input.get_vector("izq", "der", "arriba", "abajo").limit_length(1.0)


func _input_de_bot() -> Vector2:
	## Modo de prueba (no es parte del juego): un patrón determinista para poder
	## verificar en CI que el movimiento en red funciona sin que nadie toque una
	## tecla. Un círculo, que recorre los cuatro cuadrantes.
	var t: float = float(Time.get_ticks_msec()) / 1000.0
	return Vector2(cos(t * 1.5), sin(t * 1.5))


# --- Servidor: recibir, validar y confirmar -----------------------------------
@rpc("any_peer", "call_remote", "unreliable_ordered")
func enviar_input(seq_cliente: int, dir: Vector2) -> void:
	# 1) Solo el servidor procesa inputs. Sin esta guarda, un cliente podría
	#    llamar este RPC en otro cliente y moverle el avatar (clase 154).
	if not multiplayer.is_server():
		return

	# 2) El emisor solo puede mover SU avatar. get_remote_sender_id() es la
	#    única fuente fiable de quién llama: el resto lo pone el cliente.
	if multiplayer.get_remote_sender_id() != peer_id:
		_rechazados += 1
		push_warning("Peer %d intentó mover el avatar de %d"
			% [multiplayer.get_remote_sender_id(), peer_id])
		return

	# 3) Descarta inputs viejos o repetidos: 'unreliable_ordered' puede perder
	#    paquetes, y un cliente tramposo podría reenviar el mismo seq.
	if seq_cliente <= _ultimo_seq_visto:
		return
	_ultimo_seq_visto = seq_cliente

	# 4) Validación: un vector más largo que 1 es un speedhack de manual. Ojo,
	#    se valida el 'dir' CRUDO que mandó el cliente, antes de normalizar nada:
	#    si limitáramos primero, no habría nada que detectar.
	var dt: float = 1.0 / float(Engine.physics_ticks_per_second)
	var paso: Vector2 = dir * VEL * dt
	if paso.length() <= VEL * dt * TOLERANCIA:
		global_position = aplicar_input(global_position, dir, dt)
	else:
		_rechazados += 1
		print("Input rechazado del peer %d: paso de %.1f px (máx %.1f)"
			% [peer_id, paso.length(), VEL * dt * TOLERANCIA])

	# 5) Le devuelvo al dueño dónde está de verdad y hasta qué input he aplicado.
	confirmar_estado.rpc_id(peer_id, global_position, seq_cliente)


# --- Cliente: reconciliación --------------------------------------------------
@rpc("authority", "call_remote", "unreliable_ordered")
func confirmar_estado(pos_servidor: Vector2, seq_confirmado: int) -> void:
	if not _es_local():
		return
	_confirmaciones += 1

	# Tiro los inputs que el servidor ya ha aplicado.
	_historial = _historial.filter(func(e: Dictionary) -> bool:
		return int(e["seq"]) > seq_confirmado)

	# Rewind & replay: parto de la verdad del servidor y reaplico lo que él aún
	# no ha visto. Si mi predicción era correcta, acabo donde ya estaba y no se
	# nota nada. Si no, aparezco corregido pero sin perder los inputs en vuelo.
	var pos: Vector2 = pos_servidor
	var dt: float = 1.0 / float(Engine.physics_ticks_per_second)
	for e in _historial:
		pos = aplicar_input(pos, e["dir"], dt)

	# Solo corrijo si la diferencia se nota: reconciliar siempre es temblar.
	if pos.distance_to(global_position) > UMBRAL_RECONCILIACION:
		global_position = pos
		_correcciones += 1


# --- Remotos: interpolación ---------------------------------------------------
func _process(delta: float) -> void:
	# El servidor no dibuja nada, y mi avatar ya va por predicción.
	if multiplayer.is_server() or _es_local():
		return

	# Los ajenos llegan a saltos (30 Hz): sin esto se ven a tirones. Va en
	# _process y no en _physics_process porque esto es puro suavizado visual
	# (clase 146).
	var t: float = clampf(delta * 12.0, 0.0, 1.0)
	global_position = global_position.lerp(_objetivo_remoto, t)


# --- Diagnóstico (no es parte del juego: lo lee la CI) ------------------------
func resumen() -> String:
	if multiplayer.is_server():
		return "Avatar #%d (servidor): %d input(s) rechazado(s), pos %s" \
			% [peer_id, _rechazados, _txt(global_position)]
	if _es_local():
		return "Avatar #%d (local): %d confirmacion(es), %d correccion(es), %d pendiente(s), pos %s" \
			% [peer_id, _confirmaciones, _correcciones, _historial.size(), _txt(global_position)]
	return "Avatar #%d (remoto): interpolando hacia %s, pos %s" \
		% [peer_id, _txt(_objetivo_remoto), _txt(global_position)]


func _txt(v: Vector2) -> String:
	## %v imprime los Vector2 con seis decimales: ilegible en un informe.
	return "(%d, %d)" % [roundi(v.x), roundi(v.y)]


func inputs_rechazados() -> int:
	return _rechazados


func confirmaciones() -> int:
	return _confirmaciones
