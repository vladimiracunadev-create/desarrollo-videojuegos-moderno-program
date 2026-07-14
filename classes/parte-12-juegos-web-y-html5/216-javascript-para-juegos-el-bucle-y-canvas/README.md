# Clase 216 — JavaScript para juegos: el bucle y Canvas

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — Anatomy of a video game y requestAnimationFrame*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Todo juego web nace de un **bucle**: actualizar el estado y dibujarlo, muchas veces por segundo. En esta clase construirás ese bucle con **`requestAnimationFrame` (rAF)**, la API que el navegador ofrece para sincronizar tu dibujo con el refresco de la pantalla. Aprenderás a medir el **delta time** (tiempo entre cuadros) a partir del *timestamp* que rAF entrega, para que el movimiento sea igual de rápido en un monitor de 60 Hz que en uno de 144 Hz.

Sobre **Canvas 2D** dibujarás y moverás objetos, y capturarás **input** de teclado y puntero. Al final tendrás un mini-juego en JavaScript puro: un cuadrado que se mueve con las flechas y rebota contra los bordes, con la estructura clásica `actualizar()` / `dibujar()` que reutilizarás en toda la parte web.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Implementar un bucle de juego con `requestAnimationFrame`.
2. Calcular el delta time desde el timestamp y usarlo para mover a velocidad constante.
3. Separar la lógica en funciones `actualizar(dt)` y `dibujar()`.
4. Capturar teclado (`keydown`/`keyup`) y puntero (`pointermove`) para controlar un objeto.
5. Detectar colisiones con los bordes del canvas y hacer rebotar un objeto.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | `requestAnimationFrame` | Sincroniza el dibujo con el refresco y ahorra batería. |
| 2 | Delta time | Independiza la velocidad del framerate del monitor. |
| 3 | Estructura actualizar/dibujar | Separa lógica de render, base de todo motor. |
| 4 | Dibujo en Canvas 2D | `clearRect`, `fillRect` y estado del contexto. |
| 5 | Input de teclado | Estado de teclas con `keydown`/`keyup`. |
| 6 | Input de puntero | Posición del ratón/dedo con eventos `pointer`. |
| 7 | Colisión con bordes | Mantiene al objeto dentro del área jugable. |
| 8 | Rebote y velocidad | Introduce vectores de velocidad y reflexión simple. |

## 📖 Definiciones y características

- **Game loop**: ciclo que actualiza y dibuja el estado en cada cuadro. Clave: el corazón de todo juego en tiempo real.
- **`requestAnimationFrame(cb)`**: pide al navegador ejecutar `cb` antes del próximo repintado, pasándole un timestamp. Clave: reemplaza a `setInterval` para animación fluida.
- **Delta time (dt)**: segundos transcurridos desde el cuadro anterior. Clave: multiplica velocidades para movimiento uniforme.
- **Contexto 2D**: objeto `CanvasRenderingContext2D` con los métodos de dibujo. Clave: se obtiene con `getContext('2d')`.
- **`clearRect`**: borra una región del canvas. Clave: limpia el cuadro anterior antes de redibujar.
- **Estado de input**: estructura que guarda qué teclas están presionadas. Clave: se consulta en `actualizar`, no en el evento.
- **Vector de velocidad**: par `(vx, vy)` en píxeles por segundo. Clave: sumado por `dt` produce el desplazamiento.
- **Rebote**: invertir el signo de la componente de velocidad al tocar un borde. Clave: colisión elástica simple.

## 🧰 Herramientas y preparación

Solo necesitas un navegador y un editor de texto; opcionalmente un servidor local como `python -m http.server` (recomendado para futuras clases con módulos). Abre las herramientas de desarrollo con **F12** para ver la consola y depurar. La referencia clave es "Anatomy of a video game" de MDN (<https://developer.mozilla.org/es/docs/Games/Anatomy>).

Crea una carpeta `mini-juego-js/` con un `index.html` y un `juego.js`. Trabajaremos sin frameworks: JavaScript y Canvas nativos.

## 🧪 Laboratorio guiado

Construirás un cuadrado que se mueve con las flechas y rebota en los bordes.

1. Crea `index.html` con un canvas y la referencia al script:

```html
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Cuadrado móvil</title></head>
<body>
  <canvas id="lienzo" width="480" height="320" style="background:#101828"></canvas>
  <script src="juego.js"></script>
</body>
</html>
```

2. En `juego.js`, prepara el contexto y el estado del jugador y del input:

```javascript
const canvas = document.getElementById('lienzo');
const ctx = canvas.getContext('2d');

// Estado del jugador: posición, tamaño y velocidad en px/segundo.
const jugador = { x: 220, y: 140, lado: 40, vx: 120, vy: 90, velTeclado: 200 };

// Registro de teclas presionadas.
const teclas = {};
addEventListener('keydown', (e) => { teclas[e.key] = true; });
addEventListener('keyup',   (e) => { teclas[e.key] = false; });
```

3. Escribe `actualizar(dt)`: aplica el input de flechas y suma la velocidad de rebote, multiplicando siempre por `dt`:

```javascript
function actualizar(dt) {
  // Movimiento por teclado (flechas).
  if (teclas['ArrowLeft'])  jugador.x -= jugador.velTeclado * dt;
  if (teclas['ArrowRight']) jugador.x += jugador.velTeclado * dt;
  if (teclas['ArrowUp'])    jugador.y -= jugador.velTeclado * dt;
  if (teclas['ArrowDown'])  jugador.y += jugador.velTeclado * dt;

  // Movimiento automático de rebote.
  jugador.x += jugador.vx * dt;
  jugador.y += jugador.vy * dt;

  // Rebote e límites contra los bordes del canvas.
  if (jugador.x < 0) { jugador.x = 0; jugador.vx *= -1; }
  if (jugador.y < 0) { jugador.y = 0; jugador.vy *= -1; }
  if (jugador.x + jugador.lado > canvas.width)  { jugador.x = canvas.width  - jugador.lado; jugador.vx *= -1; }
  if (jugador.y + jugador.lado > canvas.height) { jugador.y = canvas.height - jugador.lado; jugador.vy *= -1; }
}
```

4. Escribe `dibujar()`: limpia el cuadro y pinta el cuadrado:

```javascript
function dibujar() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#4ade80';
  ctx.fillRect(jugador.x, jugador.y, jugador.lado, jugador.lado);
}
```

5. Arma el bucle con `requestAnimationFrame` calculando `dt` en segundos desde el timestamp:

```javascript
let anterior = performance.now();

function bucle(ahora) {
  // dt en segundos; el timestamp llega en milisegundos.
  const dt = (ahora - anterior) / 1000;
  anterior = ahora;

  actualizar(dt);
  dibujar();
  requestAnimationFrame(bucle);
}

requestAnimationFrame(bucle);
```

6. Sirve la carpeta (`python -m http.server 8000`) o abre `index.html`, y prueba: el cuadrado rebota solo y responde a las flechas. Verás que la velocidad es la misma aunque cambie el framerate, porque todo se multiplica por `dt`.

Con esta estructura tienes un motor mínimo reutilizable: cambia `actualizar` y `dibujar` para hacer otros juegos.

## ✍️ Ejercicios

1. Añade una segunda tecla (barra espaciadora) que duplique temporalmente `velTeclado`.
2. Controla el cuadrado con el ratón usando `pointermove` para fijar su posición.
3. Muestra el valor de FPS aproximado (`1/dt`) con `fillText` en una esquina.
4. Cambia el color del cuadrado cada vez que rebota contra un borde.
5. Añade un segundo cuadrado con velocidad distinta y detecta cuándo se solapan.
6. Limita la velocidad diagonal para que no sea más rápida que la horizontal.

## 📝 Reto verificable

Crea un mini-juego donde un cuadrado "jugador" (controlado por flechas) debe tocar un cuadrado "objetivo" que rebota por la pantalla; al tocarlo, el objetivo reaparece en una posición aleatoria y un contador sube en pantalla.

**Criterio de aceptación**: el jugador se mueve con las flechas a velocidad constante independiente del framerate, el objetivo rebota en los cuatro bordes, y al colisionar el contador aumenta y el objetivo se reubica, sin errores en consola.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El objeto va muy rápido o muy lento en otro monitor | No multiplicaste por `dt`. Aplica `velocidad * dt` a todo movimiento. |
| Se ve un rastro de cuadrados | No limpias el canvas. Llama a `clearRect` al inicio de `dibujar`. |
| El primer cuadro da un dt enorme | Inicializaste mal `anterior`. Usa `performance.now()` antes de arrancar el bucle. |
| Las flechas hacen scroll de la página | El evento no se controla. Llama a `e.preventDefault()` en `keydown` para las flechas. |
| El objeto se sale del canvas | Faltó el límite de un borde. Revisa las cuatro comparaciones con ancho/alto. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué usar rAF y no `setInterval`?** rAF se sincroniza con el refresco de pantalla, pausa en pestañas ocultas y da un timestamp preciso; `setInterval` desincroniza y desperdicia recursos.

**❓ ¿Qué unidad tiene el delta time?** Aquí lo convertimos a segundos, así las velocidades se expresan en píxeles por segundo, más intuitivas.

**❓ ¿Debo leer el input dentro del evento o del bucle?** Guarda el estado en el evento y consúltalo en `actualizar`. Así el movimiento es continuo mientras la tecla está presionada.

**❓ ¿Cómo evito que un dt muy grande rompa la física?** Acota `dt` a un máximo (por ejemplo 0.05 s) para que un salto de cuadro no teletransporte objetos.

## 🔗 Referencias

- MDN — Anatomy of a video game: <https://developer.mozilla.org/es/docs/Games/Anatomy>
- MDN — window.requestAnimationFrame: <https://developer.mozilla.org/es/docs/Web/API/Window/requestAnimationFrame>
- MDN — CanvasRenderingContext2D: <https://developer.mozilla.org/es/docs/Web/API/CanvasRenderingContext2D>
- MDN — Pointer events: <https://developer.mozilla.org/es/docs/Web/API/Pointer_events>

## ➡️ Siguiente clase

[Clase 217 - Motores web: Phaser (2D)](../217-motores-web-phaser-2d/README.md)
