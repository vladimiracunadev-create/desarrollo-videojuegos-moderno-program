extends Node
## Gestor de red (Autoload). Decide el rol, crea el peer y avisa por señales.
##
## Es la pieza de infraestructura del lab: aquí no hay ejercicio. Lo que se
## aprende está en jugador.gd (predicción, reconciliación, interpolación y
## validación). Ver clases 140 (MultiplayerAPI), 150 (salas) y 151 (headless).
##
## Roles según los argumentos de la línea de comandos (clase 151):
##   --server            arranca como servidor dedicado y no abre ventana
##   --conectar <ip>     arranca como cliente y se conecta solo
##   --bot               (solo cliente) mueve el avatar con un patrón fijo
##   --tramposo          (solo cliente) manda inputs imposibles, para ver que el
##                       servidor los rechaza. Es una prueba, no una trampa real.
##   --segundos <n>      se cierra solo pasados n segundos
## Sin argumentos, el lobby te deja elegir con dos botones.

signal jugador_entro(id: int)
signal jugador_salio(id: int)
signal estado_cambiado(texto: String)
signal partida_lista

const PUERTO: int = 8910
const MAX_JUGADORES: int = 8
## Ritmo de simulación, en Hz. 30 basta para una arena .io y es la mitad de
## tráfico que 60 (clase 149).
##
## Y va en las DOS puntas, cliente y servidor, a propósito: si el cliente
## simulara a 60 y el servidor a 30, cada input avanzaría el doble en el
## servidor que en la predicción del cliente, y la reconciliación estaría
## corrigiendo en todos y cada uno de los frames. En pantalla eso es el efecto
## goma: tu avatar tirando hacia atrás sin parar. La predicción solo funciona
## si las dos simulaciones hacen exactamente la misma cuenta (clase 145).
const TICKS: int = 30

var es_servidor: bool = false
var modo_bot: bool = false
var modo_tramposo: bool = false
var jugadores: Array[int] = []

var _cerrar_en: float = 0.0


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_conectado)
	multiplayer.peer_disconnected.connect(_on_peer_desconectado)
	multiplayer.connected_to_server.connect(_on_conectado)
	multiplayer.connection_failed.connect(_on_conexion_fallida)
	multiplayer.server_disconnected.connect(_on_servidor_caido)

	var args := _argumentos()
	modo_bot = args.has("--bot")
	modo_tramposo = args.has("--tramposo")

	var segundos: float = _valor_de(args, "--segundos", 0.0)
	if segundos > 0.0:
		_cerrar_en = segundos

	# DisplayServer 'headless' significa que no hay ventana: si nadie va a ver
	# nada, esto solo puede ser un servidor dedicado (clase 151).
	var sin_ventana: bool = DisplayServer.get_name() == "headless"
	if args.has("--conectar"):
		iniciar_cliente(_texto_de(args, "--conectar", "127.0.0.1"))
	elif args.has("--server") or sin_ventana:
		iniciar_servidor()


func _process(delta: float) -> void:
	if _cerrar_en > 0.0:
		_cerrar_en -= delta
		if _cerrar_en <= 0.0:
			_informe_final()
			get_tree().quit()


func _informe_final() -> void:
	## Solo para las pruebas automáticas: al cerrarse, cada instancia cuenta qué
	## ha visto. Es lo que permite verificar en CI que la red hizo su trabajo,
	## en vez de dar por bueno "no ha petado".
	var arena := get_tree().current_scene
	var lista: Node = arena.get_node_or_null("Jugadores") if arena != null else null
	var avatares: int = lista.get_child_count() if lista != null else 0

	print("--- Informe de %s ---" % ("SERVIDOR" if es_servidor else "CLIENTE %d" % multiplayer.get_unique_id()))
	print("Avatares en la arena: %d" % avatares)
	if lista != null:
		for j in lista.get_children():
			if j.has_method("resumen"):
				print("  " + j.resumen())
	print("Cierre programado: fin de la prueba")


# --- Arranque -----------------------------------------------------------------
func iniciar_servidor() -> void:
	Engine.physics_ticks_per_second = TICKS

	var peer := ENetMultiplayerPeer.new()
	var err: int = peer.create_server(PUERTO, MAX_JUGADORES)
	if err != OK:
		push_error("No se pudo crear el servidor en el puerto %d (error %d)" % [PUERTO, err])
		get_tree().quit(1)
		return

	multiplayer.multiplayer_peer = peer
	es_servidor = true
	jugadores = [1]

	# La CI usa esta línea para saber que el servidor está en pie.
	print("Servidor escuchando: puerto %d, %d jugadores máx, %d ticks/s"
		% [PUERTO, MAX_JUGADORES, TICKS])
	estado_cambiado.emit("Servidor en marcha (puerto %d)" % PUERTO)
	_ir_a_la_arena()


func iniciar_cliente(ip: String) -> void:
	# El mismo ritmo que el servidor: ver el comentario de TICKS.
	Engine.physics_ticks_per_second = TICKS

	var peer := ENetMultiplayerPeer.new()
	var err: int = peer.create_client(ip, PUERTO)
	if err != OK:
		push_error("No se pudo crear el cliente hacia %s:%d (error %d)" % [ip, PUERTO, err])
		get_tree().quit(1)
		return

	multiplayer.multiplayer_peer = peer
	es_servidor = false
	print("Cliente conectando a %s:%d..." % [ip, PUERTO])
	estado_cambiado.emit("Conectando a %s..." % ip)


func desconectar() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	jugadores.clear()
	es_servidor = false


# --- Señales de red -----------------------------------------------------------
func _on_peer_conectado(id: int) -> void:
	# Solo el servidor lleva la lista real de quién está dentro.
	if es_servidor:
		jugadores.append(id)
		print("Peer conectado: %d (total %d)" % [id, jugadores.size()])
	jugador_entro.emit(id)


func _on_peer_desconectado(id: int) -> void:
	if es_servidor:
		jugadores.erase(id)
		print("Peer desconectado: %d (quedan %d)" % [id, jugadores.size()])
	jugador_salio.emit(id)


func _on_conectado() -> void:
	print("Cliente conectado: mi id es %d" % multiplayer.get_unique_id())
	estado_cambiado.emit("Conectado (id %d)" % multiplayer.get_unique_id())
	_ir_a_la_arena()


func _on_conexion_fallida() -> void:
	push_error("Conexión rechazada: ¿está el servidor arrancado?")
	estado_cambiado.emit("No se pudo conectar")
	multiplayer.multiplayer_peer = null


func _on_servidor_caido() -> void:
	print("El servidor se ha caído")
	estado_cambiado.emit("El servidor se ha caído")
	desconectar()
	get_tree().change_scene_to_file("res://escenas/lobby.tscn")


# --- Utilidades ---------------------------------------------------------------
func _argumentos() -> PackedStringArray:
	## Acepta las dos formas, porque las dos se ven en la vida real:
	##   godot --headless --path . --server        (va a get_cmdline_args)
	##   godot --headless --path . -- --server     (va a get_cmdline_user_args)
	## La segunda es la recomendada: el '--' deja claro a Godot que lo que sigue
	## es del juego y no suyo.
	var args := OS.get_cmdline_args()
	args.append_array(OS.get_cmdline_user_args())
	return args


func _ir_a_la_arena() -> void:
	# Diferido a propósito: esto se llama desde _ready() del autoload (o desde
	# una señal de red), y en ese momento el árbol está montando la escena
	# actual. Cambiarla en caliente hace que Godot proteste con
	# "Parent node is busy adding/removing children".
	get_tree().change_scene_to_file.call_deferred("res://escenas/arena.tscn")
	partida_lista.emit()


func _texto_de(args: PackedStringArray, clave: String, por_defecto: String) -> String:
	## Lee "--clave valor" de la línea de comandos.
	var i: int = args.find(clave)
	if i >= 0 and i + 1 < args.size():
		return args[i + 1]
	return por_defecto


func _valor_de(args: PackedStringArray, clave: String, por_defecto: float) -> float:
	var t: String = _texto_de(args, clave, "")
	return t.to_float() if t.is_valid_float() else por_defecto
