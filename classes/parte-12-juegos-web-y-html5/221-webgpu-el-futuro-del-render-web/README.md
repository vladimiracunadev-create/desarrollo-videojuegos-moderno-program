# Clase 221 — WebGPU: el futuro del render web

> Parte: **12 — Juegos web y HTML5** · Fuente: *WebGPU Specification (W3C) y MDN Web Docs — WebGPU API*
> ⏱️ Duración estimada: **65 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Durante más de una década, el render en la web dependió de **WebGL**, una API basada en OpenGL ES que envejece: verbosa, con estado global y sin acceso real a la GPU moderna (cómputo, pipelines explícitos). **WebGPU** es su sucesor, diseñado sobre las ideas de Vulkan, Metal y Direct3D 12. En esta clase entendemos qué cambia, por qué importa para los juegos y cómo se ve el flujo mínimo para dibujar en pantalla.

El laboratorio detecta el soporte de WebGPU en el navegador y, si está disponible, renderiza un triángulo con un pipeline y shaders WGSL escritos desde cero. Si no lo está, aprenderás a comunicarlo con elegancia y a preparar un **fallback a WebGL**. Al terminar tendrás la base conceptual para el render web moderno que usan motores como Babylon.js, Three.js (WebGPURenderer) y Unity Web.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar las diferencias arquitectónicas entre WebGL y WebGPU.
2. Detectar el soporte de WebGPU con `navigator.gpu` y solicitar adaptador y dispositivo.
3. Describir las piezas de un render pipeline (shaders, formato, canvas).
4. Escribir un shader mínimo en WGSL con etapas `@vertex` y `@fragment`.
5. Implementar una estrategia de fallback cuando WebGPU no está disponible.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | WebGL vs WebGPU | Entender qué mejora y por qué migrar. |
| 2 | `navigator.gpu` y detección | Sin él, no hay WebGPU; hay que comprobarlo. |
| 3 | Adapter y Device | Son la puerta de entrada a la GPU. |
| 4 | Configurar el canvas | El contexto `webgpu` conecta GPU y pantalla. |
| 5 | Render pipeline | Define cómo se transforman y colorean los vértices. |
| 6 | Shaders WGSL | Lenguaje propio de WebGPU para la GPU. |
| 7 | Command encoder y render pass | Cómo se envían órdenes de dibujo. |
| 8 | Estado de soporte y fallback | No todos los navegadores lo traen aún. |

## 📖 Definiciones y características

- **WebGPU**: API JavaScript para acceso moderno a la GPU (render y cómputo). Clave: pipelines explícitos y menos estado global que WebGL.
- **Adapter (`GPUAdapter`)**: representa una GPU física del sistema. Clave: se obtiene con `navigator.gpu.requestAdapter()` y puede ser `null`.
- **Device (`GPUDevice`)**: interfaz lógica para crear recursos y enviar comandos. Clave: todo (buffers, pipelines, shaders) nace de él.
- **WGSL (WebGPU Shading Language)**: lenguaje de shaders de WebGPU. Clave: reemplaza a GLSL; usa atributos como `@vertex` y `@location`.
- **Render pipeline (`GPURenderPipeline`)**: objeto que agrupa shaders, formato y topología. Clave: se crea una vez y se reutiliza cada frame.
- **Command encoder (`GPUCommandEncoder`)**: graba una lista de comandos GPU. Clave: se "finaliza" y se envía a la cola con `device.queue.submit()`.
- **Render pass**: bloque dentro del encoder que dibuja sobre una textura (el canvas). Clave: define color de fondo y operaciones de carga/guardado.
- **Fallback**: alternativa cuando la API preferida no existe. Clave: WebGL sigue siendo el plan B universal en 2026.

## 🧰 Herramientas y preparación

Necesitas un navegador con WebGPU habilitado: Chrome y Edge lo traen estable desde la versión 113 (2023); Firefox y Safari lo han ido activando progresivamente. Un editor de texto y un servidor local bastan (WebGPU requiere contexto seguro: `https://` o `localhost`). Para servir la carpeta puedes usar `npx serve` o la extensión Live Server de VS Code.

Consulta la referencia oficial en MDN (<https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API>) y el estado de soporte en <https://caniuse.com/webgpu>. Para experimentar con WGSL sin montar todo el pipeline, la web <https://webgpufundamentals.org/> ofrece ejemplos interactivos.

## 🧪 Laboratorio guiado

Vamos a comprobar el soporte y, si existe, **dibujar un triángulo** con WebGPU.

1. Crea `index.html` con un canvas y un módulo:

```html
<!doctype html>
<html lang="es">
  <head><meta charset="utf-8" /><title>Triángulo WebGPU</title></head>
  <body>
    <canvas id="lienzo" width="512" height="512"></canvas>
    <p id="estado"></p>
    <script type="module" src="./main.js"></script>
  </body>
</html>
```

2. En `main.js`, detecta el soporte antes de nada:

```javascript
const estado = document.getElementById("estado");

if (!navigator.gpu) {
  estado.textContent = "WebGPU no está disponible. Se usaría un fallback a WebGL.";
  throw new Error("WebGPU no soportado");
}
```

3. Solicita adaptador y dispositivo (ambos son asíncronos):

```javascript
const adapter = await navigator.gpu.requestAdapter();
if (!adapter) throw new Error("No se encontró un adaptador GPU");
const device = await adapter.requestDevice();
```

4. Configura el contexto del canvas con el formato preferido:

```javascript
const canvas = document.getElementById("lienzo");
const context = canvas.getContext("webgpu");
const format = navigator.gpu.getPreferredCanvasFormat();
context.configure({ device, format, alphaMode: "opaque" });
```

5. Escribe los shaders WGSL. El vertex shader genera 3 vértices sin buffer usando el índice:

```javascript
const shaderCode = /* wgsl */ `
  @vertex
  fn vs(@builtin(vertex_index) i: u32) -> @builtin(position) vec4f {
    var pos = array<vec2f, 3>(
      vec2f( 0.0,  0.5),
      vec2f(-0.5, -0.5),
      vec2f( 0.5, -0.5)
    );
    return vec4f(pos[i], 0.0, 1.0);
  }

  @fragment
  fn fs() -> @location(0) vec4f {
    return vec4f(0.2, 0.7, 1.0, 1.0); // celeste
  }
`;
const module = device.createShaderModule({ code: shaderCode });
```

6. Crea el render pipeline enlazando ambas etapas:

```javascript
const pipeline = device.createRenderPipeline({
  layout: "auto",
  vertex: { module, entryPoint: "vs" },
  fragment: { module, entryPoint: "fs", targets: [{ format }] },
  primitive: { topology: "triangle-list" },
});
```

7. Graba y envía el render pass. Esto es lo que dibuja:

```javascript
const encoder = device.createCommandEncoder();
const pass = encoder.beginRenderPass({
  colorAttachments: [{
    view: context.getCurrentTexture().createView(),
    clearValue: { r: 0.05, g: 0.05, b: 0.1, a: 1 },
    loadOp: "clear",
    storeOp: "store",
  }],
});
pass.setPipeline(pipeline);
pass.draw(3);       // 3 vértices
pass.end();
device.queue.submit([encoder.finish()]);
estado.textContent = "Triángulo renderizado con WebGPU ✔";
```

8. Sirve la carpeta (`npx serve`) y ábrela en `localhost`. Deberías **ver un triángulo celeste** sobre fondo azul oscuro. Si el navegador no soporta WebGPU, verás el mensaje de fallback del paso 2.

## ✍️ Ejercicios

1. Cambia el color del triángulo modificando el `vec4f` del fragment shader.
2. Mueve los tres vértices para obtener un triángulo distinto y explica el sistema de coordenadas (clip space -1 a 1).
3. Añade un cuarto vértice y cambia a `topology: "triangle-strip"` para dibujar un cuadrado.
4. Envuelve el render en una función y llámala dentro de `requestAnimationFrame` para redibujar cada frame.
5. Registra en consola las `adapter.features` disponibles en tu equipo.
6. Escribe el mensaje de fallback como un `<canvas>` alternativo que explique al usuario qué navegador usar.

## 📝 Reto verificable

Construye una página que, al cargar, detecte WebGPU y muestre en pantalla **un triángulo con color configurable** por el usuario (un `<input type="color">` que actualice el fragment shader o un uniform). Si WebGPU no está disponible, la página debe mostrar un mensaje claro indicando el navegador recomendado en lugar de romperse.

**Criterio de aceptación**: la página funciona sobre `localhost`; con WebGPU disponible se ve el triángulo y su color responde al control; sin WebGPU se muestra el mensaje de fallback sin errores no controlados en consola; el código usa `navigator.gpu`, `requestAdapter`, `requestDevice`, un pipeline y shaders WGSL.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| `navigator.gpu is undefined` | Navegador sin WebGPU o servido por `file://`. Usa Chrome/Edge actual y sirve por `localhost`/`https`. |
| `requestAdapter()` devuelve `null` | No hay GPU compatible o está bloqueada. Prueba en otro equipo o revisa flags del navegador. |
| Pantalla en negro sin errores | Olvidaste `pass.end()` o `queue.submit()`. Asegúrate de finalizar y enviar el encoder. |
| Error de compilación WGSL | Sintaxis GLSL en vez de WGSL. Usa `vec4f`, `@vertex`, `@location`; revisa el log del `shaderModule`. |
| El triángulo aparece deformado | Coordenadas fuera de clip space. Mantén los vértices en el rango -1 a 1. |

## ❓ Preguntas frecuentes

**❓ ¿Debo abandonar WebGL ya?** No. WebGPU es el futuro, pero en 2026 conviene detectar soporte y ofrecer fallback a WebGL para máxima compatibilidad. Muchos motores lo hacen de forma transparente.

**❓ ¿WGSL reemplaza a GLSL?** Sí, en WebGPU. WGSL es el único lenguaje de shaders de la API. Si vienes de GLSL, la sintaxis cambia pero los conceptos (vertex/fragment, uniforms) son los mismos.

**❓ ¿WebGPU sirve solo para gráficos?** No: también expone **compute shaders**, lo que permite usar la GPU para física, simulaciones o IA directamente en el navegador, algo imposible con WebGL sin trucos.

**❓ ¿Por qué todo es asíncrono (`await`)?** Solicitar adaptador y dispositivo puede requerir inicializar la GPU; la API usa promesas para no bloquear el hilo principal mientras eso ocurre.

## 🔗 Referencias

- MDN — WebGPU API: <https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API>
- W3C — WebGPU Specification: <https://www.w3.org/TR/webgpu/>
- WebGPU Fundamentals: <https://webgpufundamentals.org/>
- Can I use — WebGPU: <https://caniuse.com/webgpu>

## ➡️ Siguiente clase

[Clase 222 - Audio e input en la web](../222-audio-e-input-en-la-web/README.md)
