# Clase 222 — Audio e input en la web

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — Web Audio API y Gamepad API*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego web sin sonido ni control preciso se siente muerto. La **Web Audio API** ofrece un grafo de audio de baja latencia (mezcla, buses, efectos) muy superior al viejo `<audio>`, pero impone una regla que sorprende a todos: por la **política de autoplay**, el navegador no deja sonar nada hasta que el usuario interactúe. Del lado del control, la web moderna unifica teclado, puntero y mandos físicos mediante APIs específicas.

En esta clase montamos el flujo correcto: crear el `AudioContext`, **arrancarlo tras un gesto del usuario**, reproducir un efecto de sonido a través de un `GainNode` para controlar el volumen, y leer un mando con la **Gamepad API**. El laboratorio produce algo audible y visible: un botón que dispara un SFX y una lectura en vivo del gamepad conectado.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Crear y arrancar un `AudioContext` respetando la política de autoplay.
2. Reproducir un sonido con `AudioBufferSourceNode` y controlar volumen con `GainNode`.
3. Organizar el audio en buses (SFX, música) mediante nodos de ganancia.
4. Capturar entrada de teclado y de puntero con Pointer Events.
5. Leer el estado de un mando físico con la Gamepad API.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Web Audio API vs `<audio>` | El grafo da mezcla y latencia baja. |
| 2 | Política de autoplay | Sin gesto del usuario no suena nada. |
| 3 | `AudioContext` y su ciclo de vida | Es el corazón del audio; puede estar suspendido. |
| 4 | `AudioBufferSourceNode` | Reproduce muestras (SFX cortos). |
| 5 | `GainNode` y buses | Controlan volumen por categoría. |
| 6 | Input de teclado | `keydown`/`keyup` para acciones. |
| 7 | Pointer Events | Unifican ratón, táctil y lápiz. |
| 8 | Gamepad API | Soporte de mandos físicos por polling. |

## 📖 Definiciones y características

- **Web Audio API**: sistema de audio basado en un grafo de nodos. Clave: conectas fuentes → efectos → destino para mezclar en tiempo real.
- **`AudioContext`**: contenedor y reloj del grafo de audio. Clave: nace en estado `suspended` y debe reanudarse con `resume()` tras un gesto.
- **Política de autoplay**: regla del navegador que bloquea audio automático. Clave: el primer sonido debe originarse en un evento de usuario (clic, tecla, toque).
- **`AudioBufferSourceNode`**: fuente que reproduce un `AudioBuffer` decodificado. Clave: es de un solo uso; se crea uno nuevo por cada reproducción.
- **`GainNode`**: nodo que multiplica la amplitud (volumen). Clave: agrupando fuentes bajo un mismo `GainNode` obtienes un bus (p. ej. "SFX").
- **Pointer Events**: eventos unificados (`pointerdown`, `pointermove`) para ratón, táctil y lápiz. Clave: un solo código cubre las tres entradas.
- **Gamepad API**: acceso a mandos vía `navigator.getGamepads()`. Clave: se consulta por *polling* dentro del bucle, no por eventos continuos.
- **Bus de audio**: canal de mezcla que agrupa sonidos afines. Clave: permite bajar toda la música sin tocar los efectos.

## 🧰 Herramientas y preparación

Solo necesitas un navegador moderno y un servidor local (`npx serve` o Live Server); no hace falta ninguna librería. Ten a mano un archivo de sonido corto (`.wav`, `.ogg` o `.mp3`) para el SFX. Para probar la Gamepad API, conecta un mando por USB o Bluetooth (los de Xbox y PlayStation se detectan sin drivers en Chrome/Edge/Firefox).

Referencias base: Web Audio API en <https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API>, la guía de autoplay en <https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide> y la Gamepad API en <https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API>.

## 🧪 Laboratorio guiado

Haremos sonar un SFX tras un clic y leeremos un mando en vivo.

1. HTML con un botón y una zona de estado:

```html
<button id="disparar">Reproducir SFX</button>
<pre id="mando">Sin mando conectado.</pre>
<script type="module" src="./main.js"></script>
```

2. En `main.js`, crea el contexto y los buses una sola vez. No suena todavía:

```javascript
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
const busSfx = audioCtx.createGain();
busSfx.gain.value = 0.8;          // volumen del bus de efectos
busSfx.connect(audioCtx.destination);
```

3. Carga y decodifica el sonido a un `AudioBuffer`:

```javascript
async function cargarSonido(url) {
  const resp = await fetch(url);
  const datos = await resp.arrayBuffer();
  return await audioCtx.decodeAudioData(datos);
}
const bufferSfx = await cargarSonido("./salto.wav");
```

4. Escribe una función que dispare el SFX. Cada reproducción crea su propia fuente:

```javascript
function reproducir(buffer, destino) {
  const fuente = audioCtx.createBufferSource();
  fuente.buffer = buffer;
  fuente.connect(destino);
  fuente.start();
}
```

5. Conecta el botón. Aquí respetamos la **política de autoplay**: reanudamos el contexto dentro del gesto del usuario:

```javascript
document.getElementById("disparar").addEventListener("click", async () => {
  if (audioCtx.state === "suspended") await audioCtx.resume();
  reproducir(bufferSfx, busSfx);
});
```

6. Añade Pointer Events como alternativa (funciona en táctil y ratón):

```javascript
document.body.addEventListener("pointerdown", async (e) => {
  if (audioCtx.state === "suspended") await audioCtx.resume();
});
```

7. Lee el gamepad por polling dentro del bucle de animación:

```javascript
const salida = document.getElementById("mando");
function bucle() {
  const mandos = navigator.getGamepads();
  const gp = mandos[0];
  if (gp) {
    const ejeX = gp.axes[0].toFixed(2);
    const botonA = gp.buttons[0].pressed;
    salida.textContent = `Mando: ${gp.id}\nEje X: ${ejeX}  Botón A: ${botonA}`;
  }
  requestAnimationFrame(bucle);
}
window.addEventListener("gamepadconnected", () => requestAnimationFrame(bucle));
```

8. Sirve la carpeta y ábrela. Pulsa el botón: **debes oír el SFX**. Conecta un mando, mueve el stick y pulsa A: verás cómo cambian el eje y el botón en pantalla.

## ✍️ Ejercicios

1. Añade un bus de música (`busMusica`) con su propio `GainNode` y un slider que ajuste su volumen sin afectar los SFX.
2. Reproduce el SFX también al pulsar la barra espaciadora con `keydown`.
3. Aplica un `detune` aleatorio a cada reproducción para que el SFX no suene idéntico siempre.
4. Muestra en pantalla el `pointerType` (`mouse`, `touch`, `pen`) en cada `pointerdown`.
5. Mapea el stick del gamepad para mover un cuadrado por el canvas.
6. Añade un `mute` global que ponga a 0 la ganancia del destino y explica por qué es mejor que parar todas las fuentes.

## 📝 Reto verificable

Crea una mini-demo donde un cuadrado se mueve por la pantalla con **teclado, puntero o gamepad** (los tres deben funcionar) y donde cada colisión con el borde reproduce un SFX mediante la Web Audio API con un bus de efectos cuyo volumen sea ajustable.

**Criterio de aceptación**: el primer sonido solo suena tras un gesto del usuario (autoplay respetado); el cuadrado responde a las tres formas de entrada; existe un `GainNode` de SFX cuyo slider cambia el volumen en vivo; no hay errores de "audio blocked" en consola.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| `The AudioContext was not allowed to start` | Intentaste sonar sin gesto. Llama a `audioCtx.resume()` dentro de un evento de usuario. |
| El SFX solo suena la primera vez | Reutilizaste el `AudioBufferSourceNode`. Crea uno nuevo en cada reproducción. |
| `decodeAudioData` falla | Formato no soportado o ruta mal servida. Usa `.wav`/`.ogg`/`.mp3` y sirve por HTTP. |
| `getGamepads()` devuelve todo `null` | El mando aún no envió input. Pulsa un botón; se activa tras la primera señal. |
| El volumen del bus no cambia nada | Conectaste las fuentes directo a `destination`. Conéctalas al `GainNode` del bus. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué el audio no arranca solo al cargar la página?** Por la política de autoplay: los navegadores bloquean el sonido automático para no molestar. El `AudioContext` empieza `suspended` y solo se reanuda tras clic, tecla o toque.

**❓ ¿Uso eventos o polling para el gamepad?** Los eventos `gamepadconnected`/`disconnected` avisan de conexión, pero el estado de ejes y botones se lee por **polling** con `navigator.getGamepads()` en cada frame.

**❓ ¿Pointer Events reemplaza a mouse y touch events?** Sí, los unifica: un solo `pointerdown` cubre ratón, táctil y lápiz. Simplifica el código frente a manejar `mousedown` y `touchstart` por separado.

**❓ ¿Cuántos sonidos puedo reproducir a la vez?** Muchos: cada uno es un nodo ligero en el grafo. Para SFX crea una fuente por disparo; el motor de audio los mezcla automáticamente en el destino.

## 🔗 Referencias

- MDN — Web Audio API: <https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API>
- MDN — Autoplay guide: <https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide>
- MDN — Gamepad API: <https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API>
- MDN — Pointer events: <https://developer.mozilla.org/en-US/docs/Web/API/Pointer_events>

## ➡️ Siguiente clase

[Clase 223 - Networking web: WebSockets y WebRTC](../223-networking-web-websockets-y-webrtc/README.md)
