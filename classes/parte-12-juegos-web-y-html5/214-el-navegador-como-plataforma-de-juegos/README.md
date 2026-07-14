# Clase 214 — El navegador como plataforma de juegos

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — Canvas API y WebAssembly*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El navegador es hoy una plataforma de ejecución completa: sin instalar nada, un jugador abre una URL y en segundos está jugando. En esta clase entenderás qué hace del navegador un destino serio para videojuegos, qué te regala (alcance masivo, cero fricción de instalación, actualización instantánea) y qué te cobra (rendimiento acotado, memoria limitada, un *sandbox* de seguridad estricto que aísla la pestaña del sistema operativo).

También situarás las piezas del ecosistema: **Canvas 2D** y **WebGL** para dibujar, **WebAssembly (WASM)** para correr código nativo compilado a velocidad casi nativa, y los portales (itch.io, Poki, Newgrounds) como canal de distribución. Al final montarás un "hola mundo" web que dibuja en un `<canvas>` y lo servirás por HTTP local, sentando la base de todas las clases siguientes.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Enumerar tres ventajas y tres límites del navegador como plataforma de juegos.
2. Explicar qué es WebAssembly y por qué importa para juegos exigentes.
3. Describir qué restringe el *sandbox* del navegador y por qué existe.
4. Crear una página con un `<canvas>` que dibuje una figura con la Canvas 2D API.
5. Servir la página por HTTP local con `python -m http.server` y abrirla en el navegador.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Cero instalación y alcance | El juego llega a cualquiera con un navegador, sin tienda ni descarga. |
| 2 | Actualización instantánea | Publicas una vez y todos juegan la última versión al recargar. |
| 3 | Límites de rendimiento | La pestaña comparte CPU/GPU y tiene presupuesto acotado. |
| 4 | Memoria y recolección de basura | El GC de JS puede causar pausas si no cuidas las asignaciones. |
| 5 | El *sandbox* de seguridad | Aísla el juego del sistema; no hay acceso libre a disco ni red. |
| 6 | WebAssembly | Permite correr C/C++/Rust/Godot a velocidad casi nativa. |
| 7 | El ecosistema y los portales | Canvas, WebGL, WebAudio y sitios como itch.io forman la cadena. |
| 8 | Cuándo elegir web | Prototipos, game jams y alcance viral frente a AAA de escritorio. |

## 📖 Definiciones y características

- **HTML5**: conjunto de estándares (HTML, CSS, JS y APIs) que convierte al navegador en plataforma de aplicaciones. Clave: no es un formato de juego, es el entorno.
- **Canvas 2D**: superficie de dibujo por píxeles controlada desde JavaScript. Clave: ideal para juegos 2D sin dependencias.
- **WebGL / WebGL2**: API de gráficos acelerados por GPU basada en OpenGL ES. Clave: la usan Three.js y PixiJS por debajo.
- **WebAssembly (WASM)**: formato binario que el navegador ejecuta a velocidad casi nativa. Clave: destino de compilación de motores como Godot o Unity.
- **Sandbox**: aislamiento que impide a la página tocar el sistema fuera de las APIs permitidas. Clave: protege al usuario, pero limita al desarrollador.
- **Servidor HTTP**: proceso que entrega los archivos por el protocolo `http://`. Clave: muchos juegos web no funcionan abiertos como `file://`.
- **Portal de juegos**: sitio que aloja y distribuye juegos web (itch.io, Poki). Clave: canal de descubrimiento sin publicar en tiendas.
- **Presupuesto de frame**: los ~16.6 ms disponibles para dibujar a 60 FPS. Clave: gobierna cuánto trabajo cabe por cuadro.

## 🧰 Herramientas y preparación

Solo necesitas un navegador moderno (Chrome, Firefox o Edge) y **Python 3** para el servidor local. Verifica Python con `python --version`; viene incluido en la mayoría de sistemas o se descarga desde <https://www.python.org/downloads/>. Como editor sirve cualquiera; recomendamos VS Code (<https://code.visualstudio.com/>).

Ten a mano la referencia de Canvas de MDN (<https://developer.mozilla.org/es/docs/Web/API/Canvas_API>). No hace falta framework alguno: todo lo de esta clase es HTML y JavaScript nativos servidos por HTTP.

## 🧪 Laboratorio guiado

Crearás un "hola mundo" web: una página con un `<canvas>` que dibuja un rectángulo, servida por HTTP.

1. Crea una carpeta `hola-canvas/` y dentro un archivo `index.html`.

2. Escribe la estructura HTML con un lienzo de 400×300 px:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Hola Canvas</title>
  <style>body { background:#111; } canvas { border:1px solid #444; }</style>
</head>
<body>
  <h1 style="color:#eee">Mi primer canvas</h1>
  <canvas id="lienzo" width="400" height="300"></canvas>
  <script src="juego.js"></script>
</body>
</html>
```

3. Junto a él crea `juego.js`. Obtén el contexto 2D y dibuja un fondo y un rectángulo:

```javascript
// Obtenemos el elemento canvas y su contexto de dibujo 2D.
const canvas = document.getElementById('lienzo');
const ctx = canvas.getContext('2d');

// Pintamos el fondo completo.
ctx.fillStyle = '#1e2a44';
ctx.fillRect(0, 0, canvas.width, canvas.height);

// Dibujamos un rectángulo naranja centrado.
ctx.fillStyle = '#ff9f43';
ctx.fillRect(150, 110, 100, 80);

// Añadimos un texto para confirmar que el script corrió.
ctx.fillStyle = '#ffffff';
ctx.font = '16px sans-serif';
ctx.fillText('¡Canvas funcionando!', 110, 40);
```

4. Abre una terminal **dentro** de la carpeta `hola-canvas/` y levanta un servidor HTTP local:

```bash
cd hola-canvas
python -m http.server 8000
```

5. En el navegador visita <http://localhost:8000/>. Deberías ver el rectángulo naranja y el texto sobre fondo azul.

6. Compara: abre ahora el mismo `index.html` con doble clic (URL `file://...`). En este ejemplo simple funciona, pero verás en las clases siguientes que muchos casos (módulos, WASM, `fetch`) fallan bajo `file://` y exigen servir por HTTP.

7. Detén el servidor con `Ctrl+C` cuando termines.

Con esto tienes el flujo mínimo del desarrollo web de juegos: editar archivos, servir por HTTP y recargar el navegador.

## ✍️ Ejercicios

1. Cambia el color y el tamaño del rectángulo, y añade un segundo rectángulo en otra posición.
2. Dibuja un círculo usando `ctx.arc()` y `ctx.fill()`; consulta la firma en MDN.
3. Sirve el proyecto en el puerto 3000 en vez del 8000 y ábrelo.
4. Escribe tu nombre con `fillText` y prueba tres fuentes distintas.
5. Redimensiona el canvas a 640×480 y observa cómo cambia la posición relativa del rectángulo.
6. Anota tres juegos web reales que hayas jugado e identifica cuáles usan Canvas 2D y cuáles 3D.

## 📝 Reto verificable

Crea una página que dibuje una "bandera" compuesta por al menos tres rectángulos de colores distintos, un círculo y una línea de texto con un título, todo sobre un canvas de 500×300. Sírvela con `python -m http.server` y ábrela en el navegador.

**Criterio de aceptación**: al visitar `http://localhost:8000/` se ven las tres franjas de color, el círculo y el título, sin errores en la consola del navegador (F12).

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El canvas aparece en blanco | El script se cargó antes del canvas o falló. Coloca `<script>` al final del `<body>` y revisa la consola (F12). |
| "Cannot read properties of null" en `getContext` | El `id` del canvas no coincide con el buscado en `getElementById`. Verifica que ambos digan `lienzo`. |
| La figura se ve borrosa o estirada | Usaste CSS para el tamaño en vez de los atributos `width`/`height`. Define el tamaño en el propio `<canvas>`. |
| `python: command not found` | Python no está instalado o no está en el PATH. Prueba `python3 -m http.server` o instálalo. |
| El navegador muestra el código en vez de la página | Abriste un archivo suelto o el puerto equivocado. Sirve desde la carpeta y visita `http://localhost:8000/`. |

## ❓ Preguntas frecuentes

**❓ ¿El navegador puede correr juegos exigentes?** Sí, con WebGL/WebGPU y WebAssembly hay juegos 3D notables; el techo es menor que en escritorio nativo, pero el alcance es enorme.

**❓ ¿Por qué debo servir por HTTP y no abrir el archivo?** El *sandbox* aplica reglas de origen que bloquean muchas APIs bajo `file://`. Servir por HTTP evita esos problemas desde el inicio.

**❓ ¿Qué gano usando WebAssembly?** Ejecutas código compilado (C++, Rust, o el runtime de Godot) a velocidad cercana a la nativa, ideal para lógica pesada de física o motores completos.

**❓ ¿Necesito una tienda para publicar?** No. Puedes subirlo a un portal como itch.io o a tu propio hosting; el jugador solo abre una URL.

## 🔗 Referencias

- MDN — Canvas API: <https://developer.mozilla.org/es/docs/Web/API/Canvas_API>
- MDN — WebAssembly: <https://developer.mozilla.org/es/docs/WebAssembly>
- MDN — Anatomía de un videojuego (bucle): <https://developer.mozilla.org/es/docs/Games/Anatomy>
- itch.io — Publicar juegos HTML5: <https://itch.io/docs/creators/html5>

## ➡️ Siguiente clase

[Clase 215 - Exportar Godot a HTML5 y WebAssembly](../215-exportar-godot-a-html5-y-webassembly/README.md)
