# 🌐 Lab — Multijugador

> [⬅️ Volver a los labs](../README.md) · [📚 Parte 7 del curso](../../classes/parte-7-multijugador-y-networking/README.md)

El proyecto que acompaña a la **Parte 7** (clases 138–155) y a su [capstone (clase 155)](../../classes/parte-7-multijugador-y-networking/155-capstone-parte-7-un-juego-en-red-minimo-cliente-servidor/README.md).

## 🌐 Qué es

Una **arena en red estilo `.io`**: un servidor autoritativo y varios clientes que se mueven por ella. Es el lab que junta toda la Parte 7 en un solo archivo de 6 `TODO`:

- **Servidor autoritativo** (clase 148): el servidor decide dónde estás. El cliente no manda: pide.
- **Predicción del cliente** (clase 145): te mueves al instante, sin esperar al servidor.
- **Reconciliación** (clase 145): cuando llega la verdad del servidor, se reaplica lo que aún no había visto — sin el tirón hacia atrás.
- **Interpolación de remotos** (clase 146): los demás llegan a 30 paquetes por segundo y aun así se ven suaves.
- **Validación anti-cheat** (clase 154): un input imposible se rechaza y no mueve nada.
- **Arranque headless** (clase 151): el servidor se ejecuta sin ventana, como un servidor dedicado de verdad.

Sin backends, sin Docker, sin cuentas: **ENet puro**, lo que enseña la clase 140. Tampoco hay assets — todo son rectángulos.

**Controles:** `WASD` o flechas.

## 📁 Estructura

```text
multijugador/
├── inicio/      ← empieza aquí: completa los TODO
│   ├── project.godot
│   ├── escenas/         (lobby, arena, jugador)
│   └── scripts/
│       ├── network_manager.gd   (autoload: roles, conexión, señales — resuelto)
│       ├── lobby.gd             (resuelto)
│       ├── arena.gd             (spawn por peer — resuelto)
│       ├── hud_arena.gd         (resuelto)
│       └── jugador.gd           ← TU TRABAJO: los 6 TODO
└── solucion/    ← referencia completa
```

Todo lo aburrido del multijugador (elegir rol, crear el peer, el lobby, el spawn, el HUD, el cierre) viene resuelto. **El ejercicio entero cabe en `jugador.gd`**, porque ahí es donde está la Parte 7.

## 🚀 Cómo empezar

1. Instala **Godot 4.3+** desde <https://godotengine.org/download>.
2. Godot → *Import* → `labs/multijugador/inicio/project.godot`.
3. Arranca **un servidor y dos clientes**. Desde la terminal es lo más cómodo:

```bash
# Terminal 1 — servidor dedicado, sin ventana
godot --headless --path labs/multijugador/inicio -- --server

# Terminales 2 y 3 — dos clientes
godot --path labs/multijugador/inicio -- --conectar 127.0.0.1
godot --path labs/multijugador/inicio -- --conectar 127.0.0.1
```

Verás dos avatares… quietos. El servidor los ha creado y el spawner los ha repartido, pero nadie los mueve todavía. Ese es tu punto de partida.

> Sin argumentos (`godot --path .` o pulsando F5) sale el **lobby** con dos botones, para probar sin terminal.

4. Abre `scripts/jugador.gd` y completa los `TODO` **en orden**:

| TODO | Qué consigues | Clase |
|---|---|---|
| 1 | La simulación compartida: la cuenta que hacen cliente **y** servidor | 145 |
| 2 | Predicción: te mueves al instante | 145 |
| 3 | El servidor valida y aplica (y rechaza lo imposible) | 148, 154 |
| 4 | El servidor te confirma dónde estás de verdad | 141 |
| 5 | Reconciliación: aceptas la corrección sin dar el tirón | 145 |
| 6 | Interpolación: los demás se ven suaves | 146 |

> ¿Atascado? Abre `solucion/scripts/jugador.gd` y compara. No es hacer trampa: leer código bueno es parte de aprender.

## 🔬 Cómo saber si te ha salido bien (y no solo "si se mueve")

Cualquier cliente puede cerrarse solo e **imprimir un informe** de lo que ha visto:

```bash
godot --headless --path labs/multijugador/solucion -- --conectar 127.0.0.1 --bot --segundos 8
```

```text
--- Informe de CLIENTE 1754091539 ---
Avatares en la arena: 2
  Avatar #1754091539 (local): 177 confirmacion(es), 0 correccion(es), 1 pendiente(s), pos (255, 574)
  Avatar #1484982918 (remoto): interpolando hacia (491, 242), pos (485, 227)
```

**La cifra que importa es `correccion(es)`.** Es cuántas veces el servidor te ha tenido que mover porque tu predicción no coincidía con la suya. Si tu predicción está bien, debe ser **prácticamente cero**. Si se parece al número de confirmaciones, tu cliente y tu servidor no están haciendo la misma cuenta: eso en pantalla es el **efecto goma**, tu avatar tirando hacia atrás sin parar.

Estos son números reales de este lab durante su construcción, y cuentan la historia mejor que cualquier explicación:

| Correcciones | Causa |
|---|---|
| **414 / 414 (100 %)** | El cliente simulaba a 60 Hz y el servidor a 30: cada input avanzaba el doble en el servidor. |
| **35 / 205 (17 %)** | Los límites de la arena los aplicaba solo el servidor, así que cada roce con un borde divergía. |
| **1 / 207 (0,5 %)** | Ya con `aplicar_input()` compartida: solo quedaba la corrección del primer paquete. |
| **0 / 177 (0 %)** | Con la posición inicial replicada en el spawn. |

De ahí sale la regla del `TODO 1`: **cada regla de la simulación que no esté en `aplicar_input()` es una divergencia esperando a pasar.** Si añades rozamiento, empujones o muros, van ahí.

## 🕵️ Comprueba tú mismo que el anti-cheat sirve

Hay un cliente tramposo incluido: manda un vector de movimiento de longitud 5 (cinco veces la velocidad máxima), como haría un cliente modificado.

```bash
godot --headless --path labs/multijugador/solucion -- --conectar 127.0.0.1 --tramposo --segundos 8
```

En el log del servidor verás el rechazo, y el tramposo no avanzará ni un píxel de más:

```text
Input rechazado del peer 1159961219: paso de 36.7 px (máx 8.8)
```

Su informe delata la trampa: **147 confirmaciones y 147 correcciones**. El servidor lo devuelve a su sitio en todos y cada uno de los paquetes. Compáralo con el cliente honesto (1 corrección de 177) y verás para qué sirve validar en el servidor.

Ahora prueba a **quitar la validación** del `TODO 3` y repite: el tramposo vuela por la arena. Esa es la clase 154 en treinta segundos.

## 🧠 Los tres conceptos que cuestan

1. **Autoridad ≠ dueño del input.** El nodo lo controla `set_multiplayer_authority(1)`: el **servidor**. Tu cliente no mueve tu avatar — lo *predice*, y el servidor confirma. Es el error clásico de la parte (clases 148 y 155).
2. **Predicción para el tuyo, interpolación para los ajenos.** No son alternativas ni dos formas de lo mismo: no puedes predecir a otro (no tienes su input) ni interpolar el tuyo (se sentiría con retraso). Clase 146.
3. **No repliques `position` directamente.** Este lab replica `pos_red` y persigue ese valor. Si el `MultiplayerSynchronizer` escribiera en `position`, teletransportaría el nodo 30 veces por segundo y machacaría la interpolación: verías justo el tirón que intentas quitar.

## ✅ Retos para ampliarlo

1. **Latencia real**: la CI y tu PC usan `127.0.0.1`, donde no hay lag. Simula 100 ms y pérdida de paquetes (clase 153) y mira si tu reconciliación aguanta. Es la prueba de fuego.
2. **Disparos con lag compensation**: valida los impactos contra el historial de posiciones, no contra el presente (clase 147).
3. **Rate limiting**: un cooldown por peer para las acciones (clase 154).
4. **Ancho de banda**: manda deltas en vez de posiciones absolutas y mide la diferencia (clase 149).
5. **Lobby de verdad**: lista de salas y estado "listo" antes de empezar (clase 150).
6. **Interpolación con buffer**: renderiza 100 ms en el pasado con un buffer de snapshots, en vez del `lerp` simple (clase 146).
7. **Un backend**: sustituye el matchmaking casero por Nakama o Steam manteniendo la lógica autoritativa (clase 152).

## 🔍 Verificación

Este lab se comprueba en CI de dos formas:

1. Como los demás labs: los dos proyectos importan y arrancan headless (sin ventana y sin argumentos, el proyecto se arranca como **servidor dedicado**).
2. Con una **prueba de red real**: la CI levanta un servidor y **tres clientes headless** contra él —dos honestos y un tramposo— y exige que se conecten los tres, que el spawner reparta los avatares, que el servidor confirme el estado, que **la predicción no diverja** (menos de un 20 % de correcciones) y que **el tramposo sea rechazado**. Esa prueba solo corre sobre `solucion/`: `inicio/` tiene los `TODO` sin hacer y no podría pasarla.

Puedes hacer lo mismo en local:

```bash
godot --headless --path labs/multijugador/solucion -- --server --segundos 30 &
godot --headless --path labs/multijugador/solucion -- --conectar 127.0.0.1 --bot --segundos 12
```

> **Un error que verás y que no es tuyo.** Al desconectarse un cliente, a veces
> aparece `ERROR: Unable to send packet on channel 0, max channels: 0`. Lo emite
> ENet cuando un peer se va y todavía había algo en vuelo hacia él: una carrera
> entre la desconexión y el siguiente envío. No es un fallo de este lab —
> desactivando todos sus RPC, el mensaje sigue saliendo (lo emiten el
> `MultiplayerSynchronizer` y el `Spawner`), y desde GDScript no se puede cerrar
> esa ventana. La CI lo filtra explícitamente, y solo a él.
>
> Lo que sí está en tu mano, y el lab lo hace, es no empeorarlo: antes de
> contestarle a alguien, comprueba que sigue conectado
> (`multiplayer.get_peers().has(peer_id)`). Un servidor de verdad no le habla a
> quien se ha ido.
