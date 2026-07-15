# Clase 155 — Capstone Parte 7: un juego en red mínimo cliente-servidor

> Parte: **7 — Multijugador y networking** · Fuente: *Documentación de Godot 4 (High-level multiplayer, MultiplayerSpawner, MultiplayerSynchronizer) + síntesis de las clases 150–154*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**
>
> 🧪 **Proyecto de referencia:** este capstone tiene un laboratorio ejecutable en
> [`labs/multijugador`](../../../labs/multijugador/README.md): abre `inicio/` para construirlo tú
> (con `TODO` guiados) o `solucion/` para ver la implementación completa y jugable.
> La CI lo verifica levantando un servidor y tres clientes headless de verdad.

---

## 🎯 Objetivo

Integrar toda la Parte 7 en un **juego en red mínimo pero completo**: una arena top-down estilo `.io` con lobby, spawn por peer, movimiento con predicción y reconciliación, interpolación de remotos, servidor autoritativo con validación y arranque headless. Es el ensamblaje que demuestra que sabes conectar matchmaking, autoridad, sincronización, testing y seguridad en un producto jugable, verificable con dos instancias y su definition of done.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Estructurar un juego en red con un `NetworkManager` (Autoload) que decide rol y ciclo de vida.
- Spawnear un avatar por peer con `MultiplayerSpawner` y sincronizarlo con `MultiplayerSynchronizer`.
- Implementar predicción del propio movimiento y reconciliación contra el servidor.
- Interpolar jugadores remotos para un movimiento suave pese a la latencia.
- Ejecutar el mismo proyecto como servidor headless o como cliente y probarlo con dos instancias.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Arquitectura del NetworkManager | Un único punto de control del rol y la conexión |
| 2 | Lobby y arranque | Reúne jugadores antes de spawnear la partida |
| 3 | Spawn por peer | Cada jugador necesita su avatar autoritativo |
| 4 | Predicción del cliente | Respuesta inmediata al input pese al ping |
| 5 | Reconciliación | Corregir sin saltos cuando el servidor discrepa |
| 6 | Interpolación de remotos | Movimiento suave de los demás jugadores |
| 7 | Servidor autoritativo + validación | Estado justo y anti-cheat de la Clase 154 |
| 8 | Modo headless | Desplegar el mismo binario como servidor |

## 📖 Definiciones y características

- **NetworkManager**: Autoload que centraliza crear servidor/cliente, señales de conexión y transición de escenas. Clave: evita lógica de red dispersa.
- **MultiplayerSpawner**: replica automáticamente la instanciación de escenas en todos los peers. Clave: spawnear un avatar en el servidor lo crea en los clientes.
- **MultiplayerSynchronizer**: replica propiedades seleccionadas de un nodo entre peers. Clave: mantiene posición/estado en sincronía sin RPC manuales.
- **Predicción**: el cliente aplica su input de inmediato sin esperar al servidor. Clave: hace el juego responsivo.
- **Reconciliación**: al recibir el estado autoritativo, el cliente reaplica los inputs no confirmados desde esa base. Clave: corrige sin teletransportar.
- **Interpolación de remotos**: renderizar a los demás suavizando entre estados con un leve retraso. Clave: oculta jitter y pérdida.
- **Servidor autoritativo**: única fuente de verdad que valida movimiento y acciones. Clave: seguridad y equidad (Clase 154).
- **Definition of Done**: lista objetiva que declara el capstone terminado. Clave: elimina la ambigüedad de "ya casi está".

## 🧰 Herramientas y preparación

Usarás **Godot 4.x** con la API de alto nivel: `ENetMultiplayerPeer`, `@rpc`, `MultiplayerSpawner`, `MultiplayerSynchronizer` y las técnicas de las clases previas. La referencia central es la guía de multijugador de Godot (<https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html>) y los nodos de replicación (<https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html>, <https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html>). Para externalizar matchmaking o persistencia, integra Nakama (<https://heroiclabs.com/docs/>) o los lobbies de Steam con GodotSteam (<https://godotsteam.com/>). Estructura el proyecto con `NetworkManager.gd` (Autoload), `Lobby.tscn`, `Arena.tscn` (con `MultiplayerSpawner`) y `Jugador.tscn` (con `MultiplayerSynchronizer`).

## 🧩 Tabla de features

| Feature | Autoridad | Técnica | Clase base |
|---------|-----------|---------|------------|
| Lobby y conexión | Servidor | ENet + señales | 150 |
| Arranque headless | Servidor | `--server` / `DisplayServer` | 151 |
| Spawn por peer | Servidor | MultiplayerSpawner | 155 |
| Movimiento propio | Cliente (predicción) | input local + reconciliación | 153 |
| Movimiento remoto | Servidor | MultiplayerSynchronizer + interpolación | 153 |
| Validación de movimiento | Servidor | límite de velocidad/tick | 154 |
| Rate limiting de acciones | Servidor | marca de tiempo por peer | 154 |

## 🧪 Laboratorio guiado

Ensamblaremos el juego en red: el `NetworkManager`, el spawn por peer, la predicción/reconciliación y la interpolación de remotos.

**Paso 1 — NetworkManager (Autoload).** Decide rol, crea el peer y expone señales de alto nivel.

```gdscript
# NetworkManager.gd — Autoload
extends Node

const PUERTO := 9000
const MAX_JUGADORES := 8

signal jugador_conectado(id: int)
signal jugador_desconectado(id: int)

func _ready() -> void:
	var args := OS.get_cmdline_args()
	if args.has("--server") or DisplayServer.get_name() == "headless":
		iniciar_servidor()

func iniciar_servidor() -> void:
	Engine.physics_ticks_per_second = 30
	var peer := ENetMultiplayerPeer.new()
	if peer.create_server(PUERTO, MAX_JUGADORES) != OK:
		push_error("No se pudo crear el servidor")
		get_tree().quit(1)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(func(id): jugador_conectado.emit(id))
	multiplayer.peer_disconnected.connect(func(id): jugador_desconectado.emit(id))
	print("Servidor de arena en :%d" % PUERTO)

func iniciar_cliente(ip: String = "127.0.0.1") -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, PUERTO)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(func(): print("Conectado a la arena"))
```

**Paso 2 — Spawn por peer.** En la arena, el servidor crea un avatar por cada jugador conectado; `MultiplayerSpawner` lo replica.

```gdscript
# arena.gd — raíz de Arena.tscn, con nodo $MultiplayerSpawner (spawn_path a $Jugadores)
extends Node2D

@export var escena_jugador: PackedScene

func _ready() -> void:
	if multiplayer.is_server():
		NetworkManager.jugador_conectado.connect(_spawn_jugador)
		NetworkManager.jugador_desconectado.connect(_despawn_jugador)
		_spawn_jugador(1)  # el propio servidor/host, si aplica

func _spawn_jugador(id: int) -> void:
	var jugador := escena_jugador.instantiate()
	jugador.name = str(id)                 # nombre único = peer id
	jugador.set_multiplayer_authority(1)   # el SERVIDOR es autoritativo
	$Jugadores.add_child(jugador, true)

func _despawn_jugador(id: int) -> void:
	if $Jugadores.has_node(str(id)):
		$Jugadores.get_node(str(id)).queue_free()
```

**Paso 3 — Predicción y reconciliación del jugador propio.** El cliente aplica input al instante y guarda un historial; al recibir el estado autoritativo, reaplica los inputs pendientes.

```gdscript
# jugador.gd — Jugador.tscn (CharacterBody2D + $MultiplayerSynchronizer)
extends CharacterBody2D

const VEL := 200.0
var _peer_id := 1
var _historial: Array = []        # {seq, dir}
var _seq := 0

func _ready() -> void:
	_peer_id = str(name).to_int()

func _es_local() -> bool:
	return _peer_id == multiplayer.get_unique_id()

func _physics_process(delta: float) -> void:
	if not _es_local():
		return
	var dir := Input.get_vector("izq", "der", "arriba", "abajo").normalized()
	_seq += 1
	_historial.append({"seq": _seq, "dir": dir})
	global_position += dir * VEL * delta   # predicción: mover ya
	enviar_input.rpc_id(1, _seq, dir)

@rpc("any_peer", "call_remote", "unreliable_ordered")
func enviar_input(_seq_cliente: int, _dir: Vector2) -> void:
	pass  # implementado en el servidor (valida y responde)

@rpc("authority", "call_remote", "unreliable_ordered")
func confirmar_estado(pos: Vector2, ultimo_seq: int) -> void:
	# Reconciliación: partir del estado del servidor y reaplicar inputs no confirmados.
	global_position = pos
	var dt := 1.0 / Engine.physics_ticks_per_second
	_historial = _historial.filter(func(e): return e["seq"] > ultimo_seq)
	for e in _historial:
		global_position += (e["dir"] as Vector2) * VEL * dt
```

**Paso 4 — Servidor autoritativo e interpolación de remotos.** El servidor valida y confirma; los remotos se suavizan.

```gdscript
# En jugador.gd — corre en el servidor
@rpc("any_peer", "call_remote", "unreliable_ordered")
func enviar_input(seq_cliente: int, dir: Vector2) -> void:
	if not multiplayer.is_server():
		return
	var dt := 1.0 / Engine.physics_ticks_per_second
	var paso := dir.normalized() * VEL * dt
	if paso.length() <= VEL * dt * 1.2:      # validación de la Clase 154
		global_position += paso
	# El MultiplayerSynchronizer replica global_position; confirmamos al dueño.
	confirmar_estado.rpc_id(_peer_id, global_position, seq_cliente)

# Interpolación de remotos: en clientes, suavizar hacia el valor replicado.
var _objetivo_remoto: Vector2
func _process(delta: float) -> void:
	if _es_local() or multiplayer.is_server():
		return
	global_position = global_position.lerp(_objetivo_remoto, clamp(delta * 12.0, 0.0, 1.0))
```

Ejecución y prueba con dos instancias:

```bash
# 1) Servidor headless
godot --headless --path . --server

# 2) Dos clientes (cada uno llama NetworkManager.iniciar_cliente() desde el lobby)
godot --path .
godot --path .
```

Observable: cada cliente ve su avatar responder al instante (predicción) y a los demás moverse suave (interpolación); un input imposible no avanza (validación); si fuerzas una discrepancia, el propio avatar se corrige sin saltos bruscos (reconciliación).

## ✍️ Ejercicios

1. Añade un lobby con lista de jugadores conectados y un botón "Empezar" que solo el host puede pulsar.
2. Implementa rate limiting de un "dash" (empuje) reutilizando el patrón de la Clase 154.
3. Muestra el RTT y el número de correcciones de reconciliación por segundo en pantalla.
4. Añade recogida de un ítem: el servidor decide quién lo toma y lo replica con un `MultiplayerSpawner`.
5. Haz que al desconectarse un jugador su avatar desaparezca en todos los clientes sin errores.
6. Prueba el capstone bajo netem/clumsy (Clase 153) y ajusta el factor de interpolación.

## 📝 Reto verificable

Entrega la **arena en red jugable** con: lobby y conexión, spawn por peer, movimiento propio con predicción y reconciliación, remotos interpolados, servidor autoritativo que valida el movimiento, y arranque headless. Debe probarse con dos instancias contra un servidor.

**Definition of Done**:

- El servidor arranca headless con `--server` sin abrir ventana.
- Dos clientes se conectan, aparecen ambos avatares en las dos pantallas.
- El movimiento propio es inmediato (predicción) y no "tira" al recibir estado (reconciliación).
- Los remotos se mueven suave incluso con 100 ms de latencia simulada.
- Un input imposible es rechazado por el servidor y no altera la posición.
- Al desconectar un cliente, su avatar desaparece en el resto sin errores en consola.

**Criterio de aceptación**: se cumplen los seis puntos de la Definition of Done verificados con dos instancias cliente contra el servidor headless, incluyendo al menos una prueba con latencia simulada activa.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Los avatares no aparecen en los clientes | El spawn no ocurre bajo el `MultiplayerSpawner` o el `spawn_path` es incorrecto |
| El movimiento propio "tira" hacia atrás | Reconciliación mal hecha: no filtras el historial por `ultimo_seq` |
| Los remotos se mueven a saltos | No interpolas; suaviza hacia el valor replicado en `_process` |
| "Authority" incorrecta al mover | Confundes autoridad del nodo con dueño del input; el servidor es autoridad, el cliente predice |
| Errores al desconectar | No liberas el avatar en `peer_disconnected`; conéctalo y usa `queue_free` |
| Funciona en local pero falla con lag | No lo probaste degradado; valida con netem/clumsy y ajusta márgenes |

## ❓ Preguntas frecuentes

**¿Predicción y reconciliación son obligatorias?** Para movimiento responsivo con latencia, sí. Sin predicción el juego se siente "pegajoso"; sin reconciliación la predicción deriva y se desincroniza.

**¿MultiplayerSynchronizer sustituye a los RPC?** Para replicar propiedades (posición, estado) es más cómodo y eficiente. Los RPC siguen siendo la vía para eventos e intención (input, disparos).

**¿Puedo usar este capstone con un backend?** Sí: sustituye el matchmaking casero por Nakama o Steam y mantén la lógica autoritativa. El transporte puede ser ENet, WebSocket (para HTML5) o el peer de Steam.

**¿Y si quiero exportarlo a la web?** Cambia `ENetMultiplayerPeer` por `WebSocketMultiplayerPeer` (o WebRTC), ya que UDP/ENet no funciona en el navegador. La arquitectura del capstone no cambia.

## 🔗 Referencias

- Godot Docs — High-level multiplayer: <https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html>
- Godot Docs — MultiplayerSpawner: <https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html>
- Godot Docs — MultiplayerSynchronizer: <https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html>
- Heroic Labs — Documentación de Nakama: <https://heroiclabs.com/docs/>
- GodotSteam — Documentación: <https://godotsteam.com/>

## ➡️ Siguiente paso

¡Enhorabuena! Has completado las Partes 0 a 7: de los fundamentos a un juego multijugador. Las siguientes partes del programa (game design, arte, plataformas, web, VR/AR, optimización, tooling y publicación) están en el [roadmap](../../../ROADMAP.md). Repasa, pule tus capstones y arma tu portfolio con lo construido.
