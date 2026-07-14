# Clase 218 — PixiJS y renderizado 2D acelerado

> Parte: **12 — Juegos web y HTML5** · Fuente: *Documentación oficial de PixiJS (pixijs.com)*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

**PixiJS** no es un motor de juego: es un **renderer 2D** que usa **WebGL** (con respaldo a Canvas) para dibujar miles de sprites a alta velocidad. Donde Phaser te da física, escenas e input, Pixi te da lo esencial del dibujo ultrarrápido y te deja a ti la lógica. En esta clase entenderás sus piezas: **`Application`** (que crea el lienzo y el bucle), **`Sprite`** (imagen dibujable), **`Container`** (nodo que agrupa y transforma hijos) y **`ticker`** (el reloj del bucle de render).

El laboratorio es una prueba de fuerza: renderizarás y animarás cientos de sprites con `app.ticker.add()` y medirás el rendimiento. Al terminar sabrás cuándo elegir Pixi (necesitas rendimiento de render y control propio) frente a Phaser (quieres un framework completo).

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Inicializar una `PIXI.Application` y añadir su canvas al DOM.
2. Crear y posicionar `Sprite` y agruparlos en un `Container`.
3. Animar objetos con `app.ticker.add()` usando el delta del ticker.
4. Renderizar cientos de sprites y medir los FPS resultantes.
5. Explicar por qué Pixi es un renderer y no un motor completo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Renderer WebGL 2D | Aprovecha la GPU para miles de sprites. |
| 2 | `Application` | Crea canvas, renderer y ticker en una llamada. |
| 3 | `Sprite` y texturas | Unidad visual básica que se dibuja. |
| 4 | `Container` | Agrupa y transforma jerarquías de objetos. |
| 5 | `ticker` | El bucle de render con su propio delta. |
| 6 | Batching | Pixi agrupa draw calls para ir rápido. |
| 7 | Pixi vs Phaser | Renderer puro frente a framework de juego. |
| 8 | Medir rendimiento | FPS y cantidad de sprites como métrica. |

## 📖 Definiciones y características

- **Renderer**: componente que traduce objetos a píxeles en la GPU. Clave: Pixi es, ante todo, esto.
- **`PIXI.Application`**: objeto que agrupa renderer, stage y ticker. Clave: punto de entrada de casi todo proyecto Pixi.
- **stage**: `Container` raíz donde cuelga todo lo visible. Clave: lo que no está en el stage no se dibuja.
- **`Sprite`**: objeto visual creado desde una textura. Clave: tiene `x`, `y`, `rotation`, `scale`, `anchor`.
- **`Container`**: nodo que agrupa hijos y aplica transformaciones. Clave: mover el contenedor mueve todo su contenido.
- **`Texture`**: imagen en memoria lista para dibujarse. Clave: varias sprites pueden compartir una textura.
- **`ticker`**: reloj que llama a tus funciones cada cuadro con un `deltaTime`. Clave: aquí va la animación.
- **Batching**: agrupar sprites con la misma textura en pocas draw calls. Clave: la razón de su velocidad.

## 🧰 Herramientas y preparación

Cargaremos PixiJS desde CDN (<https://cdn.jsdelivr.net/npm/pixi.js@8/dist/pixi.min.js>) para no instalar nada. Sirve por HTTP con `python -m http.server` para evitar restricciones. La documentación está en <https://pixijs.com/> y la guía de inicio en <https://pixijs.com/8.x/guides>.

Crea `pixi-sprites/` con `index.html` y `juego.js`. En Pixi 8 la inicialización es asíncrona (`await app.init(...)`), detalle que cuidaremos en el código.

## 🧪 Laboratorio guiado

Renderizarás cientos de sprites que rebotan y medirás el rendimiento.

1. `index.html` carga Pixi y tu script como módulo diferido:

```html
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Pixi Sprites</title></head>
<body>
  <div id="fps" style="position:fixed;top:8px;left:8px;color:#fff;font-family:sans-serif"></div>
  <script src="https://cdn.jsdelivr.net/npm/pixi.js@8/dist/pixi.min.js"></script>
  <script src="juego.js"></script>
</body>
</html>
```

2. En `juego.js` inicializa la aplicación (asíncrona en Pixi 8) y añade su canvas:

```javascript
async function iniciar() {
  const app = new PIXI.Application();
  await app.init({ width: 800, height: 600, background: '#101828', antialias: true });
  document.body.appendChild(app.canvas);

  // Textura compartida: un círculo blanco generado con Graphics.
  const plantilla = new PIXI.Graphics().circle(0, 0, 8).fill(0xffffff);
  const textura = app.renderer.generateTexture(plantilla);

  const contenedor = new PIXI.Container();
  app.stage.addChild(contenedor);

  crearSprites(app, contenedor, textura);
}
iniciar();
```

3. Crea muchos sprites, cada uno con velocidad propia, guardados en un arreglo:

```javascript
const objetos = [];

function crearSprites(app, contenedor, textura) {
  const total = 500;
  for (let i = 0; i < total; i++) {
    const s = new PIXI.Sprite(textura);
    s.anchor.set(0.5);
    s.x = Math.random() * app.screen.width;
    s.y = Math.random() * app.screen.height;
    s.tint = Math.random() * 0xffffff;             // Color aleatorio.
    contenedor.addChild(s);
    objetos.push({ s, vx: (Math.random() - 0.5) * 300, vy: (Math.random() - 0.5) * 300 });
  }
  animar(app);
}
```

4. Anima con `app.ticker.add()`. El ticker entrega `deltaTime` en "cuadros" (~1 a 60 FPS); lo convertimos a segundos dividiendo por 60:

```javascript
function animar(app) {
  const fps = document.getElementById('fps');
  app.ticker.add((ticker) => {
    const dt = ticker.deltaTime / 60;   // Aprox. segundos.
    for (const o of objetos) {
      o.s.x += o.vx * dt;
      o.s.y += o.vy * dt;
      // Rebote contra los bordes.
      if (o.s.x < 0 || o.s.x > app.screen.width)  o.vx *= -1;
      if (o.s.y < 0 || o.s.y > app.screen.height) o.vy *= -1;
    }
    fps.textContent = `Sprites: ${objetos.length} · FPS: ${Math.round(app.ticker.FPS)}`;
  });
}
```

5. Sirve la carpeta (`python -m http.server 8000`) y abre <http://localhost:8000/>. Verás 500 círculos de colores rebotando y el contador de FPS arriba a la izquierda.

6. Sube `total` a 2000, 5000 y 10000. Observa cómo el FPS se mantiene alto gracias al *batching* de Pixi (todos comparten una textura), hasta que la CPU del bucle se convierte en el cuello de botella.

Has comprobado la fortaleza de Pixi: dibujar muchísimos objetos por cuadro sin hundir el framerate.

## ✍️ Ejercicios

1. Haz que cada sprite rote sobre sí mismo cambiando `s.rotation` con `dt`.
2. Agrupa la mitad de los sprites en un segundo `Container` y desplázalo entero.
3. Escala los sprites de forma pulsante con una función seno del tiempo.
4. Añade un control (input) para crear 100 sprites más al pulsar una tecla.
5. Sustituye la textura generada por una imagen cargada con `PIXI.Assets.load`.
6. Compara el FPS con `antialias: true` y `false` y anota la diferencia.

## 📝 Reto verificable

Crea una "lluvia" de al menos 1000 sprites que caen desde arriba con velocidades distintas y reaparecen en el tope al salir por abajo; muestra en pantalla el número de sprites y los FPS en vivo.

**Criterio de aceptación**: se ven 1000+ sprites cayendo y reciclándose sin acumularse, el contador de FPS se actualiza cada cuadro y se mantiene fluido (idealmente cerca de 60), sin errores en consola.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Canvas nunca aparece | Olvidaste `await app.init` o `appendChild(app.canvas)`. Inicializa antes de añadir. |
| "PIXI is not defined" | El CDN no cargó o el orden de scripts es incorrecto. Cárgalo antes de `juego.js`. |
| Los sprites no se mueven | No los añadiste al ticker o no guardaste la referencia. Recórrelos en `ticker.add`. |
| FPS bajísimo con pocos sprites | Estás recreando texturas por sprite. Genera una textura y compártela entre todos. |
| Movimiento dependiente del monitor | No usaste el delta del ticker. Multiplica por `ticker.deltaTime`. |

## ❓ Preguntas frecuentes

**❓ ¿Pixi reemplaza a Phaser?** No directamente: Pixi solo dibuja. Si necesitas física, escenas, audio e input integrados, Phaser (que de hecho puede usar Pixi por debajo en versiones antiguas) o tu propia capa sobre Pixi.

**❓ ¿Por qué Pixi es tan rápido?** Agrupa sprites que comparten textura en pocas draw calls (batching) y delega el dibujo a la GPU vía WebGL.

**❓ ¿Qué es el stage?** Es el `Container` raíz de la aplicación. Todo lo que quieras ver debe colgar de él directa o indirectamente.

**❓ ¿El delta del ticker está en segundos?** No: por defecto está en "cuadros" relativos a 60 FPS. Divide por 60 para segundos, o usa `ticker.deltaMS/1000`.

## 🔗 Referencias

- PixiJS — Sitio oficial: <https://pixijs.com/>
- PixiJS — Guías (v8): <https://pixijs.com/8.x/guides>
- PixiJS — API Reference: <https://pixijs.download/release/docs/index.html>
- MDN — WebGL: <https://developer.mozilla.org/es/docs/Web/API/WebGL_API>

## ➡️ Siguiente clase

[Clase 219 - Three.js: 3D en el navegador](../219-three-js-3d-en-el-navegador/README.md)
