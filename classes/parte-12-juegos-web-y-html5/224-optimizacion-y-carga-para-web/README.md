# Clase 224 — Optimización y carga para web

> Parte: **12 — Juegos web y HTML5** · Fuente: *web.dev — Fast load times y MDN Web Docs — HTTP compression*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

En la web, la primera batalla no es el gameplay: es lograr que el juego **cargue rápido**. Un usuario abandona en segundos si ve una pantalla en blanco descargando 40 MB. La optimización web ataca dos frentes: reducir el **peso** (bundle de código, texturas, audio) y mejorar la **estrategia de carga** (diferir lo no esencial, comprimir en tránsito, cachear). El objetivo es minimizar el *time-to-play*: el tiempo desde que se abre la URL hasta que se puede jugar.

En esta clase medimos el peso y el tiempo de carga de un build web, aplicamos técnicas concretas —compresión gzip/brotli, carga diferida, atlas de texturas— y comparamos el antes y el después con números reales tomados de las herramientas del navegador. Aprenderás a razonar sobre cada kilobyte que envías al jugador.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Medir el peso de un build y el tiempo de carga con las DevTools.
2. Reducir el tamaño de assets con atlas y compresión de imágenes.
3. Aplicar compresión gzip/brotli en la transferencia HTTP.
4. Diferir la carga de recursos no esenciales (lazy loading, streaming).
5. Comparar métricas de carga antes y después de optimizar.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Time-to-play | La métrica que decide si el jugador se queda. |
| 2 | Peso del bundle | Menos JS/WASM = arranque más rápido. |
| 3 | Peso de los assets | Imágenes y audio suelen dominar el total. |
| 4 | Atlas de texturas | Menos peticiones y mejor compresión. |
| 5 | Compresión gzip/brotli | Reduce bytes en tránsito sin tocar el asset. |
| 6 | Carga diferida | Cargar solo lo necesario para empezar. |
| 7 | Streaming de assets | Traer niveles/sonidos bajo demanda. |
| 8 | Caché | Evitar volver a descargar lo ya bajado. |

## 📖 Definiciones y características

- **Time-to-play (TTP)**: tiempo desde abrir la URL hasta poder jugar. Clave: es la métrica de negocio más importante en juegos web.
- **Bundle**: paquete de código (JS/WASM) que el navegador descarga y ejecuta. Clave: se reduce con *minificación* y *tree-shaking*.
- **Atlas de texturas**: imagen única que agrupa muchos sprites. Clave: una petición en vez de decenas, mejor empaquetado y menos cambios de estado GPU.
- **gzip / brotli**: algoritmos de compresión HTTP. Clave: el servidor comprime la respuesta y el navegador la descomprime; brotli suele ganar en texto/código.
- **Lazy loading (carga diferida)**: postergar la descarga de lo no visible/necesario. Clave: acelera el arranque cargando el resto después.
- **Streaming de assets**: descargar recursos por partes o bajo demanda. Clave: entras al juego sin esperar a que todo esté en memoria.
- **Caché (HTTP)**: reutilización de recursos ya descargados. Clave: cabeceras `Cache-Control` y nombres con hash evitan re-descargas.
- **Minificación**: eliminar espacios, comentarios y nombres largos del código. Clave: reduce el bundle sin cambiar el comportamiento.

## 🧰 Herramientas y preparación

Usaremos las **DevTools** del navegador (pestaña Network y Lighthouse) para medir, y un servidor local que soporte compresión. Puedes servir con `http-server` (Node) activando gzip/brotli, o usar herramientas como `vite build` que ya minifican. Para atlas de texturas hay empaquetadores como TexturePacker o `free-tex-packer` (web).

Instala un servidor con compresión para las pruebas:

```bash
npm install -g http-server
```

Referencias: guía de rendimiento en <https://web.dev/explore/fast> y compresión HTTP en <https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression>.

## 🧪 Laboratorio guiado

Mediremos un build, lo optimizaremos y compararemos.

1. Sirve tu build web actual y **mide la línea base**. Abre DevTools → Network, marca "Disable cache", recarga y anota: número de peticiones, peso total transferido (`Transferred`) y tiempo de `Load`.

2. Corre Lighthouse (DevTools → Lighthouse → Analyze) en modo Performance y guarda la puntuación y el "Total Blocking Time" como referencia.

3. **Comprime imágenes**. Convierte los PNG grandes a formatos modernos y ajusta calidad. Con `sharp` (Node) por ejemplo:

```bash
npx sharp-cli -i "assets/*.png" -o assets-web --format webp --quality 80
```

4. **Crea un atlas**. Agrupa los sprites sueltos en una sola textura y su JSON de coordenadas. Esto reduce peticiones y aprovecha mejor la compresión. Carga el atlas y recorta cada sprite por sus coordenadas en vez de pedir 30 archivos.

5. **Activa compresión en el servidor**. `http-server` sirve `.gz` automáticamente si existen; genera las versiones comprimidas:

```bash
# Genera .gz y .br junto a cada asset de texto/código
find dist -type f \( -name "*.js" -o -name "*.json" -o -name "*.wasm" \) \
  -exec gzip -k9 {} \; -exec brotli -k {} \;
http-server dist -g -b   # -g gzip, -b brotli
```

6. **Difiere lo no esencial**. Carga primero el menú y difiere niveles/sonidos secundarios. Con `import()` dinámico:

```javascript
// Se descarga solo cuando el jugador entra al nivel 2
async function cargarNivel2() {
  const { crearNivel2 } = await import("./niveles/nivel2.js");
  return crearNivel2();
}
```

7. **Configura caché**. Sirve los assets con hash en el nombre (`juego.a1b2c3.js`) y cabeceras de caché largas, de modo que el navegador no vuelva a descargarlos entre visitas.

8. **Vuelve a medir** con Network y Lighthouse tras estos cambios. Registra los mismos números que en los pasos 1-2 y calcula la mejora: cuántos KB y cuántos milisegundos ahorraste. Documenta el antes/después en una pequeña tabla.

## ✍️ Ejercicios

1. Convierte un PNG de 1 MB a WebP con calidad 80 y compara el peso resultante.
2. Mide el peso de 20 sprites sueltos frente al mismo contenido en un solo atlas.
3. Compara el tamaño de tu `bundle.js` sin comprimir, con gzip y con brotli.
4. Difiere con `import()` un módulo pesado y verifica en Network que solo se descarga al usarlo.
5. Añade `Cache-Control: max-age=31536000` a los assets con hash y explica por qué es seguro.
6. Ejecuta Lighthouse antes y después y anota la variación de la puntuación de Performance.

## 📝 Reto verificable

Toma un build web (propio o de ejemplo) y **redúcele el peso transferido al menos un 30%** aplicando al menos tres técnicas (compresión de imágenes, atlas, gzip/brotli, carga diferida o caché), documentando en una tabla el antes/después de: peso total transferido, número de peticiones y tiempo de carga.

**Criterio de aceptación**: la tabla muestra métricas reales tomadas de DevTools antes y después; la reducción de peso transferido es ≥ 30%; se nombran y justifican las técnicas aplicadas; el juego sigue funcionando igual tras optimizar (nada roto por diferir o comprimir).

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El peso no baja pese a comprimir | El servidor no envía `Content-Encoding`. Verifica que sirve `.gz`/`.br` y las cabeceras. |
| Sprites cortados o desplazados tras el atlas | Coordenadas mal leídas del JSON. Revisa origen y tamaño de cada frame. |
| El juego rompe al diferir un módulo | Se usó antes de que `import()` resolviera. Espera la promesa antes de invocarlo. |
| Assets viejos tras un deploy | Caché agresiva sin hash en el nombre. Usa nombres con hash para invalidar. |
| Lighthouse da resultados distintos cada vez | Ruido de red/CPU. Mide varias veces y en modo incógnito sin extensiones. |

## ❓ Preguntas frecuentes

**❓ ¿gzip o brotli?** Brotli suele comprimir mejor texto y código (JS, JSON, WASM) que gzip, a costa de algo más de CPU al comprimir. Genera ambas versiones y deja que el navegador elija según `Accept-Encoding`.

**❓ ¿El atlas siempre conviene?** Casi siempre para sprites 2D: reduce peticiones y cambios de textura en GPU. Ojo con atlas gigantescos que superen el tamaño máximo de textura del dispositivo; divídelos si hace falta.

**❓ ¿Qué diferencia hay entre carga diferida y streaming?** La carga diferida pospone recursos completos hasta que se necesitan; el streaming trae un mismo recurso por partes (por ejemplo, texturas progresivas o audio por chunks). Ambas mejoran el TTP.

**❓ ¿Comprimir imágenes con pérdida no baja la calidad?** Sí, un poco, pero a calidad 75-85 suele ser imperceptible en juego y ahorra mucho. Compara visualmente y ajusta; para arte con bordes nítidos considera formatos sin pérdida o WebP lossless.

## 🔗 Referencias

- web.dev — Fast load times: <https://web.dev/explore/fast>
- MDN — HTTP Compression: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression>
- web.dev — Lazy loading: <https://web.dev/articles/lazy-loading>
- MDN — HTTP caching: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching>

## ➡️ Siguiente clase

[Clase 225 - Distribución: itch.io, Poki y portales HTML5](../225-distribucion-itch-io-poki-y-portales-html5/README.md)
