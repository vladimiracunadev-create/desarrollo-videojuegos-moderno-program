# Clase 223 — Networking web: WebSockets y WebRTC

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — WebSockets API y WebRTC API*
> ⏱️ Duración estimada: **65 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El multijugador en la web se apoya en dos tecnologías con propósitos distintos. **WebSocket** abre un canal bidireccional sobre TCP: es fiable y ordenado, perfecto para lobbies, chat y juegos por turnos donde no importan unos milisegundos. **WebRTC** establece conexiones peer-to-peer con canales de datos sobre UDP: baja latencia y posibilidad de mensajes no fiables, ideal para acción en tiempo real, aunque exige un proceso de *signaling* para que los pares se encuentren.

En esta clase distinguimos ambos, entendemos cuándo usar cada uno y montamos un **eco por WebSocket** (cliente en el navegador + servidor Node mínimo). Después trazamos el flujo completo de WebRTC para tiempo real y mencionamos cómo Godot expone estos peers con `WebSocketMultiplayerPeer` y `WebRTCMultiplayerPeer`.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diferenciar WebSocket (TCP, fiable) de WebRTC (UDP, baja latencia).
2. Elegir el transporte adecuado según el tipo de juego.
3. Implementar un cliente y un servidor de eco por WebSocket.
4. Describir el flujo de signaling y conexión de WebRTC.
5. Relacionar estos transportes con los peers de red de Godot.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | TCP vs UDP en juegos | Fiabilidad frente a latencia: un compromiso clave. |
| 2 | WebSocket: handshake y mensajes | Canal persistente sobre HTTP. |
| 3 | Cliente WebSocket en el navegador | La API que usa tu juego. |
| 4 | Servidor WebSocket (Node) | El otro extremo del canal. |
| 5 | WebRTC: `RTCPeerConnection` | Conexión directa entre pares. |
| 6 | `RTCDataChannel` | Envío de datos de juego con baja latencia. |
| 7 | Signaling | Cómo se encuentran los pares antes de conectar. |
| 8 | Peers de Godot | Integración con motor para multijugador web. |

## 📖 Definiciones y características

- **WebSocket**: protocolo de canal full-dúplex sobre una conexión TCP única. Clave: fiable, ordenado y con URL `ws://` o `wss://`.
- **TCP**: transporte que garantiza entrega y orden. Clave: retransmite paquetes perdidos, lo que añade latencia (head-of-line blocking).
- **WebRTC**: conjunto de APIs para comunicación P2P en el navegador. Clave: usa UDP y permite datos no fiables/no ordenados.
- **`RTCPeerConnection`**: objeto que gestiona la conexión entre dos pares. Clave: negocia códecs, red (ICE) y seguridad (DTLS).
- **`RTCDataChannel`**: canal de datos arbitrarios sobre WebRTC. Clave: configurable como fiable u ordenado, o ni lo uno ni lo otro para máxima velocidad.
- **Signaling**: intercambio inicial de descripciones (SDP) y candidatos ICE. Clave: WebRTC no lo define; lo implementas tú, a menudo por WebSocket.
- **ICE / STUN / TURN**: mecanismos para atravesar NAT y firewalls. Clave: STUN descubre tu IP pública; TURN reenvía si no hay conexión directa.
- **`WebSocketMultiplayerPeer` / `WebRTCMultiplayerPeer`**: peers de alto nivel de Godot 4. Clave: exponen estos transportes a la API de red del motor.

## 🧰 Herramientas y preparación

Para el laboratorio necesitas Node.js instalado (verifica con `node --version`) y la librería `ws` para el servidor WebSocket. Un navegador moderno hace de cliente. WebRTC se estudia a nivel de flujo; no requiere servidor propio en esta clase, pero conviene entender que en producción usarías un servidor de signaling y, a veces, STUN/TURN.

Instala la dependencia con:

```bash
npm init -y
npm install ws
```

Referencias: WebSockets en <https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API> y WebRTC en <https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API>.

## 🧪 Laboratorio guiado

Montaremos un servidor de eco y un cliente que le envía mensajes.

1. Crea `server.js`. Al recibir un mensaje, lo reenvía al mismo cliente (eco):

```javascript
import { WebSocketServer } from "ws";

const wss = new WebSocketServer({ port: 8080 });
console.log("Servidor de eco en ws://localhost:8080");

wss.on("connection", (socket) => {
  socket.on("message", (data) => {
    const texto = data.toString();
    console.log("Recibido:", texto);
    socket.send(`eco: ${texto}`);   // devuelve el mensaje
  });
  socket.send("Bienvenido al servidor de eco");
});
```

2. Arranca el servidor:

```bash
node server.js
```

3. Crea `index.html` con un input y un log:

```html
<input id="msg" placeholder="Escribe algo" />
<button id="enviar">Enviar</button>
<ul id="log"></ul>
<script type="module" src="./client.js"></script>
```

4. En `client.js`, abre la conexión y maneja los eventos del ciclo de vida:

```javascript
const ws = new WebSocket("ws://localhost:8080");
const log = document.getElementById("log");

function agregar(texto) {
  const li = document.createElement("li");
  li.textContent = texto;
  log.appendChild(li);
}

ws.addEventListener("open", () => agregar("Conectado ✔"));
ws.addEventListener("message", (e) => agregar(e.data));
ws.addEventListener("close", () => agregar("Conexión cerrada"));
ws.addEventListener("error", () => agregar("Error de conexión"));
```

5. Envía mensajes desde el botón:

```javascript
document.getElementById("enviar").addEventListener("click", () => {
  const input = document.getElementById("msg");
  if (ws.readyState === WebSocket.OPEN && input.value) {
    ws.send(input.value);
    input.value = "";
  }
});
```

6. Sirve el HTML (`npx serve`) y ábrelo. Escribe un texto y pulsa Enviar: **verás el eco** llegar de vuelta. Abre dos pestañas para comprobar que cada una tiene su propio canal.

7. Ahora el flujo de **WebRTC** (a nivel conceptual, para tiempo real). El par A crea la conexión y un canal de datos:

```javascript
const pc = new RTCPeerConnection({
  iceServers: [{ urls: "stun:stun.l.google.com:19302" }],
});
const canal = pc.createDataChannel("juego");
canal.addEventListener("open", () => canal.send("hola par B"));

const oferta = await pc.createOffer();
await pc.setLocalDescription(oferta);
// La 'oferta' (SDP) se envía al par B por el canal de signaling (p. ej. WebSocket).
```

El par B recibe la oferta por signaling, hace `setRemoteDescription`, crea una `answer` y la devuelve; ambos intercambian candidatos ICE. Una vez conectados, `RTCDataChannel` mueve los datos de juego directamente entre pares, sin pasar por tu servidor.

8. Regla de decisión: **turnos, lobby, chat → WebSocket**; **acción rápida en tiempo real → WebRTC**. En Godot, `WebSocketMultiplayerPeer` y `WebRTCMultiplayerPeer` te dan estos transportes bajo la misma API `MultiplayerAPI`.

## ✍️ Ejercicios

1. Modifica el servidor para que reenvíe cada mensaje a **todos** los clientes conectados (broadcast tipo chat).
2. Añade un contador de clientes conectados y muéstralo en cada mensaje del servidor.
3. Envía objetos JSON (`JSON.stringify`) en vez de texto plano y parsea en el cliente.
4. Implementa reconexión automática en el cliente cuando el socket se cierre.
5. Dibuja en una tabla qué transporte usarías para: chat, ranking, disparos, movimiento de jugador, y justifícalo.
6. Investiga qué es un servidor TURN y en qué situación de red se vuelve imprescindible.

## 📝 Reto verificable

Construye un **chat en tiempo real** por WebSocket donde varios clientes (varias pestañas) vean los mensajes de los demás con el nombre del autor, y acompáñalo de un diagrama del flujo de WebRTC (oferta → answer → ICE → data channel) explicando por qué usarías WebRTC en lugar de WebSocket para un juego de acción.

**Criterio de aceptación**: el servidor hace broadcast a todos los clientes; los mensajes incluyen autor y se ven en todas las pestañas abiertas; el diagrama nombra `RTCPeerConnection`, `RTCDataChannel`, signaling e ICE; y se justifica la elección de transporte según latencia y fiabilidad.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| `WebSocket connection failed` | Servidor apagado o URL/puerto incorrecto. Verifica que `node server.js` corre y usa el puerto correcto. |
| `Cannot send, socket not open` | Enviaste antes de `open`. Comprueba `ws.readyState === WebSocket.OPEN`. |
| WebRTC conecta en local pero no entre redes | Falta STUN/TURN o el firewall bloquea. Añade servidores ICE; usa TURN si no hay ruta directa. |
| El eco llega duplicado | Registraste el listener `message` más de una vez. Añádelo una sola vez. |
| `wss` requerido en producción | En HTTPS no puedes usar `ws://`. Sirve el socket con `wss://` (TLS). |

## ❓ Preguntas frecuentes

**❓ ¿WebSocket sirve para juegos de acción rápidos?** Funciona, pero al ir sobre TCP, un paquete perdido bloquea los siguientes (head-of-line blocking) y añade latencia. Para acción competitiva, WebRTC con datos no fiables es mejor.

**❓ ¿Por qué WebRTC necesita signaling si es peer-to-peer?** Los pares no conocen sus direcciones de antemano. El signaling (a menudo por WebSocket) intercambia las descripciones SDP y candidatos ICE para que puedan encontrarse; después la conexión es directa.

**❓ ¿Qué hace un servidor STUN/TURN?** STUN ayuda a cada par a descubrir su IP pública detrás del NAT. TURN reenvía el tráfico cuando no es posible una conexión directa, a costa de latencia y ancho de banda.

**❓ ¿Cómo encaja Godot en esto?** Godot 4 ofrece `WebSocketMultiplayerPeer` y `WebRTCMultiplayerPeer`, que conectan estos transportes a su `MultiplayerAPI`. Así usas RPC y sincronización de nodos sin manejar los sockets a mano.

## 🔗 Referencias

- MDN — WebSockets API: <https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API>
- MDN — WebRTC API: <https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API>
- Godot Docs — High-level multiplayer: <https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html>
- ws (librería Node): <https://github.com/websockets/ws>

## ➡️ Siguiente clase

[Clase 224 - Optimización y carga para web](../224-optimizacion-y-carga-para-web/README.md)
