# Clase 227 — Capstone Parte 12: un juego web publicado

> Parte: **12 — Juegos web y HTML5** · Fuente: *Síntesis de la Parte 12 (WebGPU/WebGL, Web Audio, WebSocket/WebRTC, optimización, itch.io/portales, PWA)*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Es hora de integrar todo lo aprendido en la Parte 12 en un entregable real: un **juego web publicado y verificable online**. No se trata de crear un juego nuevo desde cero, sino de tomar uno existente —exportado de Godot a HTML5, o hecho en Phaser, Pixi o Three.js— y llevarlo a producción con estándares web correctos: render moderno, audio e input que respetan las políticas del navegador, carga rápida y, opcionalmente, instalable como PWA.

Esta clase es una **especificación de proyecto** con checklist y *definition of done*. El laboratorio consiste en publicar el juego (típicamente en itch.io) y verificarlo desde otra máquina o dispositivo. Al terminar tendrás un enlace público que demuestra dominio del ciclo completo de un juego web moderno, listo para tu portfolio.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Integrar audio, input, optimización y distribución web en un solo entregable.
2. Publicar un juego HTML5 en un canal público y verificarlo online.
3. Aplicar una checklist de calidad web antes de publicar.
4. Medir y justificar el tiempo de carga de su juego.
5. Redactar un *definition of done* y validar el proyecto contra él.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Selección del juego base | Partir de algo jugable ahorra tiempo. |
| 2 | Export/build a HTML5 | El artefacto que se publica. |
| 3 | Audio e input web correctos | Autoplay y controles unificados. |
| 4 | Optimización de carga | Time-to-play bajo, menos abandono. |
| 5 | Publicación en itch.io | Enlace público y jugable. |
| 6 | PWA opcional | Instalable y offline como plus. |
| 7 | Verificación online | Probar como lo haría un jugador. |
| 8 | Definition of done | Criterio objetivo de "terminado". |

## 📖 Definiciones y características

- **Capstone**: proyecto integrador que consolida una parte del curso. Clave: demuestra competencia end-to-end, no una técnica aislada.
- **Build de producción**: artefacto final optimizado y minificado. Clave: es lo que subes, no tu carpeta de desarrollo.
- **Definition of done (DoD)**: lista de condiciones que definen "terminado". Clave: elimina la ambigüedad; o se cumple o no.
- **Checklist de calidad**: verificación previa a publicar (carga, audio, input, errores). Clave: atrapa fallos antes que el jugador.
- **Verificación online**: probar el juego en su URL pública, en otro dispositivo/red. Clave: revela problemas de rutas, HTTPS o caché invisibles en local.
- **Time-to-play**: tiempo hasta poder jugar desde abrir la URL. Clave: métrica objetivo del capstone (idealmente pocos segundos).
- **Gesto de usuario**: interacción que desbloquea el audio. Clave: el juego debe arrancar sonido tras un clic/tecla, no antes.
- **Regresión**: algo que funcionaba y se rompió al optimizar/empaquetar. Clave: la verificación online la detecta.

## 🧰 Herramientas y preparación

Reúne todo lo de las clases previas: el juego jugable, su export/build HTML5, cuenta de itch.io y las DevTools para medir. Si tu juego usa Godot, exporta con el preset **Web**; si usa Phaser/Pixi/Three, genera el build de producción de tu bundler (`vite build`, por ejemplo). Ten a mano los iconos y el `manifest.json`/`sw.js` si harás la variante PWA (clase 226).

Repasa las clases 222 (audio/input), 224 (optimización), 225 (distribución) y 226 (PWA): este capstone las combina. Verifica que el build corre sin errores en `localhost` antes de publicar.

Antes de empezar, conviene fijar el alcance por escrito. Un capstone no busca un juego enorme, sino uno **completo y pulido en su publicación**: mejor un juego de dos minutos que carga rápido, suena bien y se juega sin fricción en cualquier dispositivo, que uno ambicioso que no llega a estar online. Define en una frase el juego, su stack y la variante que harás (con o sin PWA) antes de tocar el build.

## 🧪 Laboratorio guiado

Publicaremos y verificaremos el juego web siguiendo la especificación.

1. **Elige el juego base**. Debe ser jugable de principio a fin (aunque sea corto). Anota su stack (Godot Web, Phaser, Pixi, Three).

2. **Genera el build de producción**. Godot: export preset Web → produce `index.html` y assets. Bundler: `npm run build` → carpeta `dist/`. Confirma que `index.html` queda en la raíz.

3. **Verifica audio e input web**. Comprueba que el sonido arranca solo tras un gesto del usuario (autoplay) y que el control funciona con al menos teclado y puntero (y gamepad si aplica). Corrige si el audio intenta sonar al cargar.

4. **Optimiza la carga**. Aplica al menos dos técnicas de la clase 224 (compresión gzip/brotli, atlas, carga diferida o caché). Mide el peso transferido y el tiempo de carga en DevTools → Network.

5. **(Opcional) Conviértelo en PWA**. Añade `manifest.json` y `sw.js` (clase 226) para que sea instalable y cargue offline. Verifica instalabilidad en Application.

6. **Empaqueta y publica en itch.io**. Comprime el contenido del build (con `index.html` en la raíz del ZIP), sube el proyecto como **HTML**, marca "played in the browser", ajusta el tamaño del embed y completa la ficha (portada, descripción, controles).

7. **Verifica online**. Abre la URL pública en **otro dispositivo o red** (o en modo incógnito). Recorre esta checklist:

```text
[ ] El juego carga sin errores en consola
[ ] Time-to-play aceptable (anota los segundos medidos)
[ ] El audio suena tras el primer gesto (no antes)
[ ] Los controles responden (teclado/puntero/gamepad)
[ ] El juego es jugable de inicio a fin en el embed
[ ] Sin assets 404 (rutas relativas correctas)
[ ] (PWA) Instalable y abre offline, si aplica
```

8. **Valida contra el Definition of Done** (abajo). Si todos los puntos se cumplen, el capstone está terminado. Registra la URL pública, las métricas de carga (antes/después de optimizar) y qué variante hiciste (con o sin PWA).

**Definition of Done**: el juego está publicado en una URL pública; carga y es jugable de inicio a fin desde otra máquina; el audio respeta la política de autoplay; el input funciona con al menos dos métodos; se aplicaron y midieron optimizaciones de carga; no hay errores críticos ni assets 404 en consola.

9. Documenta el proyecto para tu portfolio. Guarda una breve ficha con: la URL pública, el stack usado, las tres o cuatro técnicas de la Parte 12 que aplicaste (render, audio/input, optimización, distribución, PWA), y las métricas de carga antes/después. Este resumen convierte el capstone en una pieza mostrable, no solo en un enlace suelto.

## ✍️ Ejercicios

1. Mide el time-to-play de tu juego publicado en una conexión lenta (throttling "Fast 3G" en DevTools).
2. Prueba el juego en un móvil real y anota qué falla respecto al escritorio.
3. Añade una pantalla de "toca para empezar" que desbloquee el audio limpiamente.
4. Compara el peso transferido de tu build antes y después de optimizar en una tabla.
5. Pide a un compañero que juegue desde su red y recoge tres observaciones de usabilidad.
6. Escribe el texto de la ficha del juego orientado a atraer jugadores del portal.

## 📝 Reto verificable

Publica tu juego web en una URL pública (itch.io u otro portal HTML5) que cualquiera pueda abrir y jugar, cumpliendo el **Definition of Done** completo, y entrega: la URL, una tabla de métricas de carga (antes/después de optimizar) y la checklist de verificación online rellenada desde un dispositivo distinto al de desarrollo.

**Criterio de aceptación**: la URL abre y el juego es jugable de inicio a fin en otro dispositivo/red; el audio solo suena tras un gesto del usuario; el input funciona con al menos dos métodos; se demuestra al menos una optimización con métricas antes/después; no hay errores críticos ni assets 404 en consola; y todos los puntos del Definition of Done están marcados con evidencia.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Funciona en local pero no en la URL pública | Rutas absolutas o mayúsculas de archivos. Usa rutas relativas y respeta el case exacto. |
| El audio no suena en producción | Se intenta arrancar sin gesto. Añade "toca para empezar" que reanude el `AudioContext`. |
| Carga eterna en móvil | Build sin optimizar y red lenta. Aplica compresión/atlas y difiere lo no esencial. |
| Pantalla en blanco en el embed | `index.html` no está en la raíz del ZIP. Recomprime con el HTML en la raíz. |
| PWA no instala en producción | Falta HTTPS o manifest/SW inválido. itch.io sirve por HTTPS; revisa Application → Manifest. |
| El juego se ve recortado en el embed | Tamaño del embed distinto al canvas. Ajusta el viewport en Embed options a la resolución real del juego. |
| Rendimiento peor que en desarrollo | El build de producción usa otro renderer o config. Perfila en el entorno publicado, no solo en local. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo usar un juego de una parte anterior del curso?** Sí, es lo recomendado. El objetivo del capstone es el ciclo de publicación web, no crear contenido nuevo. Reutiliza un juego jugable y enfócate en audio, input, carga y distribución.

**❓ ¿La PWA es obligatoria para aprobar?** No, es opcional (un plus valorado). El Definition of Done se cumple sin ella; si la añades, verifica instalabilidad y offline como en la clase 226.

**❓ ¿Por qué verificar desde otro dispositivo o red?** Porque en local el navegador cachea y las rutas absolutas "funcionan por casualidad". Otra máquina o incógnito revela 404, problemas de HTTPS y regresiones reales que verá el jugador.

**❓ ¿Qué time-to-play es aceptable?** Cuanto menor, mejor; para juegos casuales apunta a pocos segundos en una conexión media. Lo importante es medirlo, justificarlo y demostrar que optimizar lo redujo.

**❓ ¿Y si mi juego no está terminado a nivel de contenido?** No importa para este capstone: basta con que sea jugable de inicio a fin, aunque sea un solo nivel. El foco de la Parte 12 es el ciclo web (render, audio, input, carga, publicación), no la cantidad de contenido.

**❓ ¿Puedo publicar en otro sitio en vez de itch.io?** Sí, siempre que la URL sea pública y jugable (tu propio hosting, GitHub Pages, un portal HTML5). itch.io es el camino recomendado por su rapidez, pero el criterio es que cualquiera pueda abrir el enlace y jugar.

## 🔗 Referencias

- itch.io — HTML5 games: <https://itch.io/docs/creators/html5>
- web.dev — Fast load times: <https://web.dev/explore/fast>
- MDN — Autoplay guide: <https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide>
- MDN — Progressive web apps: <https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps>

## ➡️ Siguiente clase

[Clase 228 - Panorama de XR: VR, AR y MR](../../parte-13-vr-ar-y-experiencias-inmersivas/228-panorama-de-xr-vr-ar-y-mr/README.md)
