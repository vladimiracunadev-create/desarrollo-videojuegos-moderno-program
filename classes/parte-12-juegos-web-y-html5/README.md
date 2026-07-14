# Parte 12 — Juegos web y HTML5

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-11-movil-consolas-y-plataformas/README.md) · [⏭️ Parte siguiente](../parte-13-vr-ar-y-experiencias-inmersivas/README.md)

**14 clases** · rango 214–227 · Juegos que corren en el navegador: Godot a WebAssembly, Phaser, PixiJS, Three.js, WebGL/WebGPU, networking web y distribución en portales

**Fuentes de referencia de esta parte:**

- Documentación de [Phaser](https://phaser.io/learn), [PixiJS](https://pixijs.com/) y [Three.js](https://threejs.org/docs/).
- [MDN Web Docs — WebGL / WebGPU / Canvas](https://developer.mozilla.org/).
- Documentación de [exportación web de Godot](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).
- Documentación de [itch.io](https://itch.io/docs/) y portales HTML5.

---

## 🎯 ¿De qué trata esta parte?

La web es la plataforma más accesible del mundo: un enlace y el jugador ya está jugando, sin instalar nada. Esta parte enseña a llevar juegos al navegador por dos vías. La primera es exportar **Godot a HTML5/WebAssembly** y entender sus particularidades (servir por HTTP, cabeceras, tamaño de descarga). La segunda son los **frameworks nativos de la web**: **JavaScript** con Canvas, **Phaser** (2D), **PixiJS** (render 2D acelerado) y **Three.js** (3D en el navegador), sobre **WebGL** y el emergente **WebGPU**.

Cubre también lo específico de la web: **audio e input** en el navegador (con sus restricciones), **networking** con WebSockets y WebRTC, **optimización y carga** (assets, streaming, tamaño), la **distribución** en itch.io, Poki y portales HTML5, y las **PWAs** para juegos instalables. El **capstone** publica un juego web funcionando.

## 🧩 Problemas que resuelve

- Exportar a web y que "no cargue" por cabeceras, rutas o servir desde file://.
- No saber elegir entre Godot-web, Phaser, PixiJS o Three.js según el proyecto.
- Audio que no suena hasta que el usuario interactúa (política de autoplay).
- Juegos web pesados que tardan una eternidad en cargar.
- Multijugador web que no funciona porque UDP/ENet no existe en el navegador.
- No saber dónde ni cómo publicar un juego HTML5.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Exportar un juego de Godot a HTML5/WebAssembly y servirlo correctamente.
- Crear juegos web con JavaScript, Phaser, PixiJS y Three.js.
- Entender WebGL y el rol de WebGPU en el render web.
- Gestionar audio, input y networking (WebSockets/WebRTC) en el navegador.
- Optimizar la carga y el tamaño de un juego web.
- Distribuir en itch.io y portales, y empaquetar como PWA instalable.

## 🧱 Prerrequisitos

- Partes 0, 1 y 7 (fundamentos, 2D y networking; WebSockets/WebRTC se retoman aquí).
- Nociones de JavaScript (Parte 0 introduce el lenguaje); Node.js para las herramientas web.

## 📚 Las 14 clases

| # | Clase |
|---|---|
| 214 | [El navegador como plataforma de juegos](214-el-navegador-como-plataforma-de-juegos/README.md) |
| 215 | [Exportar Godot a HTML5 y WebAssembly](215-exportar-godot-a-html5-y-webassembly/README.md) |
| 216 | [JavaScript para juegos: el bucle y Canvas](216-javascript-para-juegos-el-bucle-y-canvas/README.md) |
| 217 | [Motores web: Phaser (2D)](217-motores-web-phaser-2d/README.md) |
| 218 | [PixiJS y renderizado 2D acelerado](218-pixijs-y-renderizado-2d-acelerado/README.md) |
| 219 | [Three.js: 3D en el navegador](219-three-js-3d-en-el-navegador/README.md) |
| 220 | [WebGL y el pipeline gráfico web](220-webgl-y-el-pipeline-grafico-web/README.md) |
| 221 | [WebGPU: el futuro del render web](221-webgpu-el-futuro-del-render-web/README.md) |
| 222 | [Audio e input en la web](222-audio-e-input-en-la-web/README.md) |
| 223 | [Networking web: WebSockets y WebRTC](223-networking-web-websockets-y-webrtc/README.md) |
| 224 | [Optimización y carga para web](224-optimizacion-y-carga-para-web/README.md) |
| 225 | [Distribución: itch.io, Poki y portales HTML5](225-distribucion-itch-io-poki-y-portales-html5/README.md) |
| 226 | [PWAs y juegos instalables](226-pwas-y-juegos-instalables/README.md) |
| 227 | [Capstone Parte 12: un juego web publicado](227-capstone-parte-12-un-juego-web-publicado/README.md) |

---

> La [Parte 13](../parte-13-vr-ar-y-experiencias-inmersivas/README.md) da el salto a lo inmersivo: realidad virtual y aumentada.
