extends CharacterBody2D
class_name JugadorRed
## EJERCICIO ÚNICO del laboratorio: el avatar en red.
##
## Todo lo demás (lobby, conexión, spawn, HUD, arranque headless) ya está hecho.
## Aquí está TODO lo que enseña la Parte 7, y se completa en este orden:
##
##   TODO 1 · la simulación compartida        (clase 145)
##   TODO 2 · predicción del cliente          (clase 145)
##   TODO 3 · validación en el servidor       (clases 148 y 154)
##   TODO 4 · confirmación al dueño           (clase 141)
##   TODO 5 · reconciliación del cliente      (clase 145)
##   TODO 6 · interpolación de los remotos    (clase 146)
##
## Arranca ya y verás dos avatares quietos: el servidor los crea y el spawner los
## reparte, pero nadie los mueve todavía. Ese es tu punto de partida.
##
## Las tres reglas que lo gobiernan todo:
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
## interpolación del TODO 6: se vería exactamente el tirón que quieres quitar.
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
	## LA función del laboratorio. Cliente y servidor moverán al jugador llamando
	## aquí, y solo aquí.
	##
	## Es `static` y pura a propósito: no lee el reloj, ni el input, ni el estado
	## del nodo. Solo (posición, dirección, delta) -> posición. Así el cliente
	## puede ejecutarla para predecir, el servidor para decidir, y el cliente otra
	## vez para reaplicar al reconciliar — y los tres obtienen el MISMO resultado.
	##
	# TODO 1: devuelve la posición nueva:
	#   var p := pos + dir.limit_length(1.0) * VEL * dt
	#   return p.clamp(Arena.LIMITE_MIN, Arena.LIMITE_MAX)
	#
	# El limit_length y el clamp NO son un detalle: son reglas de la simulación.
	# Cualquier regla que dejes fuera de esta función la aplicará el servidor y
	# no el cliente, y entonces tu predicción fallará siempre que se active
	# (por ejemplo, cada vez que toques un borde). Esa es la lección: la
	# predicción solo funciona si las dos puntas hacen la MISMA cuenta.
	return pos


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

	# TODO 2 (predicción): muévete YA, sin esperar al servidor. Es lo que hace
	#   que el juego responda al instante aunque el servidor esté a 100 ms.
	#   1. global_position = aplicar_input(global_position, dir, delta)
	#   2. guarda el input hasta que el servidor lo confirme:
	#      _historial.append({"seq": _seq, "dir": dir})
	#      if _historial.size() > MAX_HISTORIAL: _historial.pop_front()
	#   3. mándaselo al servidor, y SOLO al servidor (peer 1):
	#      enviar_input.rpc_id(1, _seq, dir)
	#
	# Pruébalo con solo el paso 1: te moverás de maravilla... hasta que el
	# TODO 5 empiece a corregirte. Los pasos 2 y 3 son los que hacen que el
	# servidor se entere de que existes.
	pass


func _leer_input() -> Vector2:
	if NetworkManager.modo_tramposo:
		# Un cliente modificado puede mandar LO QUE QUIERA: aquí, un vector de
		# longitud 5 para ir cinco veces más rápido. El límite del cliente no
		# protege nada, porque el tramposo es justo quien lo ha quitado. Por eso
		# el que valida tiene que ser el servidor (TODO 3).
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
	# TODO 3 (el servidor manda): este RPC lo llama el cliente, así que TODO lo
	#   que llega es sospechoso. Ve por orden:
	#
	#   1. Si no eres el servidor, vete: sin esta guarda un cliente podría
	#      llamar este RPC en OTRO cliente y moverle el avatar.
	#      if not multiplayer.is_server(): return
	#
	#   2. El emisor solo puede mover SU avatar. get_remote_sender_id() es la
	#      única fuente fiable de quién llama: los argumentos los pone el cliente.
	#      if multiplayer.get_remote_sender_id() != peer_id:
	#          _rechazados += 1
	#          return
	#
	#   3. Descarta inputs viejos o repetidos ('unreliable_ordered' pierde
	#      paquetes, y un tramposo puede reenviar el mismo seq):
	#      if seq_cliente <= _ultimo_seq_visto: return
	#      _ultimo_seq_visto = seq_cliente
	#
	#   4. Valida el paso contra lo físicamente posible. Ojo: valida el 'dir'
	#      CRUDO, antes de limitarlo — si lo limitas primero, no hay nada que
	#      detectar:
	#      var dt := 1.0 / float(Engine.physics_ticks_per_second)
	#      var paso := dir * VEL * dt
	#      if paso.length() <= VEL * dt * TOLERANCIA:
	#          global_position = aplicar_input(global_position, dir, dt)
	#      else:
	#          _rechazados += 1
	#          print("Input rechazado del peer %d: paso de %.1f px (máx %.1f)"
	#              % [peer_id, paso.length(), VEL * dt * TOLERANCIA])
	#
	# TODO 4: dile al dueño dónde está de verdad y hasta qué input has aplicado:
	#      if multiplayer.get_peers().has(peer_id):
	#          confirmar_estado.rpc_id(peer_id, global_position, seq_cliente)
	#
	#      Ese 'if' no sobra: entre que el cliente mandó el input y ahora, ha
	#      podido desconectarse, y su paquete llegar igual (venía en vuelo).
	#      Contestar a un peer que ya no está hace que ENet proteste con
	#      "Unable to send packet on channel 0".
	#
	# Cuando lo tengas, arranca un cliente con --tramposo y mira el log del
	# servidor: verás los rechazos, y al tramposo sin avanzar ni un píxel.
	pass


# --- Cliente: reconciliación --------------------------------------------------
@rpc("authority", "call_remote", "unreliable_ordered")
func confirmar_estado(pos_servidor: Vector2, seq_confirmado: int) -> void:
	if not _es_local():
		return
	_confirmaciones += 1

	# TODO 5 (reconciliación): el servidor te dice dónde estás DE VERDAD, pero
	#   ese dato ya viene con retraso: desde que lo envió, tú has seguido
	#   pulsando teclas. Si te limitas a hacer global_position = pos_servidor,
	#   pegarás un tirón hacia atrás en cada paquete (el efecto goma).
	#
	#   Lo correcto es "rewind & replay":
	#   1. tira los inputs que el servidor ya aplicó:
	#      _historial = _historial.filter(func(e): return int(e["seq"]) > seq_confirmado)
	#   2. parte de la verdad del servidor y reaplica lo que él aún no ha visto:
	#      var pos := pos_servidor
	#      var dt := 1.0 / float(Engine.physics_ticks_per_second)
	#      for e in _historial:
	#          pos = aplicar_input(pos, e["dir"], dt)
	#   3. corrige SOLO si se nota (reconciliar siempre es temblar):
	#      if pos.distance_to(global_position) > UMBRAL_RECONCILIACION:
	#          global_position = pos
	#          _correcciones += 1
	#
	# Cómo saber si te ha salido bien: mira el informe al cerrar el cliente
	# (--segundos 8). Si _correcciones es casi tan alto como _confirmaciones,
	# algo no cuadra entre tu predicción y el servidor. Con esto bien hecho,
	# las correcciones deben ser prácticamente cero.
	pass


# --- Remotos: interpolación ---------------------------------------------------
func _process(delta: float) -> void:
	# El servidor no dibuja nada, y tu avatar ya va por predicción.
	if multiplayer.is_server() or _es_local():
		return

	# TODO 6 (interpolación): las posiciones de los demás llegan a saltos (30 por
	#   segundo). Si las aplicas tal cual, los ves a tirones. Persíguelas:
	#      var t := clampf(delta * 12.0, 0.0, 1.0)
	#      global_position = global_position.lerp(_objetivo_remoto, t)
	#
	#   Esto va en _process y NO en _physics_process a propósito: es suavizado
	#   visual, así que debe ir al ritmo de los fotogramas, no al de la física
	#   (clase 146).
	pass


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
