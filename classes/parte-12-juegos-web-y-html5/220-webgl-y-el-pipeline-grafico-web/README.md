# Clase 220 — WebGL y el pipeline gráfico web

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — WebGL API y Khronos WebGL2*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Three.js y PixiJS son cómodos porque esconden **WebGL**, la API de bajo nivel que habla directamente con la GPU. En esta clase levantarás el capó: WebGL/WebGL2 es **OpenGL ES dentro del navegador**, y para dibujar cualquier cosa necesitas darle datos (**buffers** de vértices), un programa de sombreado en **GLSL** (un **vertex shader** y un **fragment shader**) y una orden de dibujo (**draw call**).

El laboratorio es el clásico rito de iniciación gráfica: dibujar un triángulo con **WebGL2 puro**. Escribirás shaders, subirás vértices a un buffer, los conectarás a un atributo y ejecutarás `drawArrays`. Al terminar entenderás exactamente qué hacen Three y Pixi por debajo cada cuadro, y tendrás el modelo mental del **pipeline gráfico**.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Obtener un contexto `webgl2` desde un canvas.
2. Escribir y compilar un vertex shader y un fragment shader en GLSL.
3. Enlazar shaders en un programa y activarlo.
4. Subir vértices a un buffer y conectarlos a un atributo con `vertexAttribPointer`.
5. Ejecutar una draw call y explicar el flujo del pipeline gráfico.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Contexto WebGL2 | La puerta a la GPU desde el canvas. |
| 2 | Pipeline gráfico | Modelo mental de cómo se dibuja. |
| 3 | Vertex shader | Coloca cada vértice en pantalla. |
| 4 | Fragment shader | Decide el color de cada píxel. |
| 5 | Programa (link) | Une ambos shaders en algo ejecutable. |
| 6 | Buffers y atributos | Cómo llegan los datos a la GPU. |
| 7 | Draw calls | La orden que dispara el dibujo. |
| 8 | Qué hacen Three/Pixi | Automatizan todo este proceso por ti. |

## 📖 Definiciones y características

- **WebGL2**: API de gráficos basada en OpenGL ES 3.0 expuesta al navegador. Clave: acceso directo a la GPU desde JS.
- **Contexto**: objeto `gl` con todas las funciones y constantes. Clave: se obtiene con `getContext('webgl2')`.
- **Shader**: pequeño programa que corre en la GPU. Clave: hay dos etapas obligatorias, vértices y fragmentos.
- **GLSL**: lenguaje tipo C de los shaders. Clave: en WebGL2 empieza con `#version 300 es`.
- **Vertex shader**: procesa cada vértice y fija `gl_Position`. Clave: transforma coordenadas al espacio de recorte.
- **Fragment shader**: produce el color de cada fragmento en `out`. Clave: define el aspecto de la superficie.
- **Buffer**: bloque de memoria en la GPU con datos (vértices). Clave: se llena con `bufferData`.
- **Draw call**: orden `drawArrays`/`drawElements` que dibuja. Clave: cada una tiene coste; menos es más rápido.

## 🧰 Herramientas y preparación

Solo necesitas un navegador con soporte WebGL2 (todos los modernos) y un editor. Sirve por HTTP con `python -m http.server` por consistencia, aunque este ejemplo también funciona en local simple. Abre la consola con **F12** para ver errores de compilación de shaders, que son frecuentes al aprender. La referencia es el tutorial de WebGL de MDN (<https://developer.mozilla.org/es/docs/Web/API/WebGL_API/Tutorial>).

Crea `webgl-triangulo/` con `index.html` y `juego.js`. El código GLSL irá como cadenas de texto dentro del JS.

## 🧪 Laboratorio guiado

Dibujarás un triángulo de colores con WebGL2 puro.

1. `index.html` con un canvas y el script:

```html
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Triángulo WebGL2</title></head>
<body>
  <canvas id="lienzo" width="500" height="500"></canvas>
  <script src="juego.js"></script>
</body>
</html>
```

2. En `juego.js`, obtén el contexto WebGL2 y define los dos shaders como cadenas GLSL:

```javascript
const canvas = document.getElementById('lienzo');
const gl = canvas.getContext('webgl2');
if (!gl) throw new Error('WebGL2 no está disponible en este navegador.');

// Vertex shader: recibe posición y color por vértice; fija gl_Position.
const vsFuente = `#version 300 es
in vec2 aPos;
in vec3 aColor;
out vec3 vColor;
void main() {
  vColor = aColor;
  gl_Position = vec4(aPos, 0.0, 1.0);
}`;

// Fragment shader: pinta con el color interpolado entre vértices.
const fsFuente = `#version 300 es
precision mediump float;
in vec3 vColor;
out vec4 color;
void main() {
  color = vec4(vColor, 1.0);
}`;
```

3. Escribe una función que compile un shader y reporte errores:

```javascript
function compilar(tipo, fuente) {
  const sh = gl.createShader(tipo);
  gl.shaderSource(sh, fuente);
  gl.compileShader(sh);
  if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
    throw new Error('Error de shader: ' + gl.getShaderInfoLog(sh));
  }
  return sh;
}
```

4. Enlaza ambos shaders en un programa y actívalo:

```javascript
const programa = gl.createProgram();
gl.attachShader(programa, compilar(gl.VERTEX_SHADER, vsFuente));
gl.attachShader(programa, compilar(gl.FRAGMENT_SHADER, fsFuente));
gl.linkProgram(programa);
if (!gl.getProgramParameter(programa, gl.LINK_STATUS)) {
  throw new Error('Error al enlazar: ' + gl.getProgramInfoLog(programa));
}
gl.useProgram(programa);
```

5. Sube los datos del triángulo (posición x,y + color r,g,b por vértice) a un buffer:

```javascript
// Tres vértices: cada uno con 2 de posición y 3 de color.
const vertices = new Float32Array([
  //  x,     y,    r, g, b
   0.0,  0.6,   1, 0, 0,   // arriba, rojo
  -0.6, -0.6,   0, 1, 0,   // izquierda, verde
   0.6, -0.6,   0, 0, 1,   // derecha, azul
]);

const buffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);
```

6. Conecta los atributos `aPos` y `aColor` describiendo cómo leer el buffer (stride de 5 floats):

```javascript
const bytes = 5 * 4;   // 5 floats por vértice, 4 bytes cada float.

const locPos = gl.getAttribLocation(programa, 'aPos');
gl.enableVertexAttribArray(locPos);
gl.vertexAttribPointer(locPos, 2, gl.FLOAT, false, bytes, 0);

const locColor = gl.getAttribLocation(programa, 'aColor');
gl.enableVertexAttribArray(locColor);
gl.vertexAttribPointer(locColor, 3, gl.FLOAT, false, bytes, 2 * 4);
```

7. Limpia la pantalla y ejecuta la draw call:

```javascript
gl.clearColor(0.06, 0.09, 0.16, 1.0);
gl.clear(gl.COLOR_BUFFER_BIT);
gl.drawArrays(gl.TRIANGLES, 0, 3);   // Dibuja 3 vértices como un triángulo.
```

8. Sirve la carpeta y abre <http://localhost:8000/>. Verás un triángulo con vértices rojo, verde y azul y un degradado suave entre ellos: la GPU interpoló los colores por ti.

Acabas de recorrer a mano el pipeline que Three.js y PixiJS ejecutan por debajo miles de veces por segundo.

## ✍️ Ejercicios

1. Cambia los colores de los vértices y observa cómo cambia el degradado.
2. Añade un segundo triángulo (6 vértices) para formar un cuadrado.
3. Mueve el triángulo modificando las posiciones y anima con `requestAnimationFrame`.
4. Pasa un `uniform` de tiempo al vertex shader para hacer latir el triángulo.
5. Provoca a propósito un error de sintaxis en GLSL y lee el mensaje de `getShaderInfoLog`.
6. Cambia `gl.TRIANGLES` por `gl.LINE_LOOP` y describe el resultado.

## 📝 Reto verificable

Dibuja un cuadrado (dos triángulos) de colores en las cuatro esquinas que rote de forma continua usando un `uniform` de ángulo actualizado en un bucle con `requestAnimationFrame`, aplicando la rotación dentro del vertex shader.

**Criterio de aceptación**: al abrir la página se ve un cuadrado con degradado de color girando suavemente, la rotación se calcula en el vertex shader mediante un uniform, y la consola no muestra errores de compilación ni de enlace.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Canvas negro sin triángulo | Faltó `clear`/`drawArrays` o el atributo no está enlazado. Revisa el orden de los pasos. |
| "ERROR: version directive must be first" | El `#version 300 es` no está en la primera línea de la cadena. Quita espacios/saltos antes. |
| Atributo siempre en 0 | No llamaste a `enableVertexAttribArray` o el nombre no coincide. Verifica `getAttribLocation`. |
| Colores planos, sin degradado | Declaraste mal `in`/`out` entre shaders. El `out` del vertex debe coincidir con el `in` del fragment. |
| "gl is null" | El navegador no dio contexto WebGL2. Comprueba soporte y que el id del canvas sea correcto. |

## ❓ Preguntas frecuentes

**❓ ¿Qué relación hay entre WebGL y OpenGL?** WebGL2 es esencialmente OpenGL ES 3.0 expuesto a JavaScript; los conceptos (shaders, buffers, draw calls) son los mismos.

**❓ ¿Por qué necesito dos shaders?** El vertex shader coloca los vértices y el fragment shader colorea los píxeles resultantes; son etapas obligatorias distintas del pipeline.

**❓ ¿Por qué el color se degrada si solo di tres colores?** La GPU interpola linealmente los valores `out` del vertex shader entre vértices antes de pasarlos al fragment shader.

**❓ ¿Debo escribir siempre este código?** No en producción: Three.js y PixiJS lo generan por ti. Hacerlo a mano una vez te da el modelo mental para depurar rendimiento y efectos.

## 🔗 Referencias

- MDN — WebGL API: <https://developer.mozilla.org/es/docs/Web/API/WebGL_API>
- MDN — Tutorial de WebGL: <https://developer.mozilla.org/es/docs/Web/API/WebGL_API/Tutorial>
- WebGL2 Fundamentals: <https://webgl2fundamentals.org/>
- Khronos — WebGL 2.0 Specification: <https://registry.khronos.org/webgl/specs/latest/2.0/>

## ➡️ Siguiente clase

[Clase 221 - WebGPU: el futuro del render web](../221-webgpu-el-futuro-del-render-web/README.md)
