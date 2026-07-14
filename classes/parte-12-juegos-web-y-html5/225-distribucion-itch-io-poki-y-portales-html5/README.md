# Clase 225 — Distribución: itch.io, Poki y portales HTML5

> Parte: **12 — Juegos web y HTML5** · Fuente: *itch.io — Creator docs y documentación pública de Poki/CrazyGames for developers*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Tener un juego web optimizado no sirve de nada si nadie lo juega. La distribución es el puente entre tu build y el público. En la web hay dos rutas principales: **itch.io**, una plataforma abierta donde subes un ZIP con tu `index.html` y en minutos tienes una página jugable y compartible; y los **portales** (Poki, CrazyGames), con enorme tráfico pero requisitos técnicos e integración de su **SDK**, a cambio de reparto de ingresos por publicidad.

En esta clase empaquetamos correctamente un juego HTML5, lo subimos a itch.io como build embebido y lo probamos en el navegador. Luego repasamos qué piden los portales, cómo funciona su SDK (anuncios, eventos) y el modelo de monetización web, para que sepas elegir dónde publicar según tu objetivo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Empaquetar un juego HTML5 en un ZIP válido con `index.html` en la raíz.
2. Publicar y configurar un build jugable embebido en itch.io.
3. Comparar itch.io con portales como Poki y CrazyGames.
4. Describir qué hace el SDK de un portal (anuncios, eventos de juego).
5. Explicar el modelo de monetización por publicidad de los portales.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Empaquetado HTML5 | Un ZIP mal armado no carga. |
| 2 | `index.html` en la raíz | El portal busca ahí el punto de entrada. |
| 3 | itch.io: subir y configurar | La vía más rápida y abierta. |
| 4 | Embed vs descarga | Jugar en el navegador vs bajar un ZIP. |
| 5 | Portales (Poki/CrazyGames) | Mucho tráfico, más requisitos. |
| 6 | SDK del portal | Integra anuncios y eventos obligatorios. |
| 7 | Monetización web | Cómo se generan ingresos por ads. |
| 8 | Checklist de publicación | Evita rechazos y builds rotos. |

## 📖 Definiciones y características

- **itch.io**: plataforma abierta de distribución de juegos indie. Clave: subes un ZIP HTML5 y obtienes una página jugable sin revisión previa.
- **Build HTML5**: carpeta con `index.html` y sus assets, comprimida en ZIP. Clave: `index.html` debe estar en la raíz del ZIP, no dentro de subcarpetas.
- **Embed (juego embebido)**: el juego corre dentro de un `<iframe>` en la página. Clave: en itch.io se activa marcando "This file will be played in the browser".
- **Portal HTML5**: sitio con catálogo y tráfico masivo (Poki, CrazyGames). Clave: exige integrar su SDK y cumplir requisitos técnicos y de contenido.
- **SDK del portal**: librería JS que el portal te da. Clave: gestiona anuncios (intersticiales, rewarded), y eventos como "gameplay start/stop".
- **Anuncio rewarded**: vídeo que el jugador ve a cambio de una recompensa. Clave: fuente de ingresos habitual; lo dispara tu juego vía SDK.
- **Revenue share**: reparto de ingresos publicitarios entre portal y desarrollador. Clave: sustituye al precio de venta; no cobras por descarga.
- **Checklist de portal**: lista de requisitos técnicos y legales. Clave: cumplirla antes de enviar evita rechazos y retrabajo.

## 🧰 Herramientas y preparación

Necesitas una cuenta gratuita en itch.io (<https://itch.io>) y tu juego exportado a HTML5 (desde Godot, Phaser, Pixi o Three.js, todos generan un `index.html`). Para el ZIP basta el compresor de tu sistema operativo. Para los portales, revisa sus páginas de desarrolladores: Poki (<https://developers.poki.com>) y CrazyGames (<https://developer.crazygames.com>), donde documentan SDK y requisitos.

Verifica antes de subir que tu build corre en `localhost` sin errores en consola: los portales rechazan builds que fallan al cargar. Ten a mano una imagen de portada y capturas para la ficha del juego.

Conviene entender de antemano la diferencia de filosofía entre canales. itch.io es **abierto y sin curaduría**: cualquiera publica en minutos y controla precio y visibilidad, a costa de conseguir tráfico por su cuenta. Los portales son **cerrados y curados**: aportan la audiencia, pero deciden qué entra y exigen integración técnica. Saber esto de entrada evita frustraciones al enviar a un portal esperando la inmediatez de itch.io.

## 🧪 Laboratorio guiado

Publicaremos un juego HTML5 en itch.io como build embebido.

1. Prepara la carpeta del build. Debe contener el punto de entrada en la raíz:

```bash
mi-juego/
├── index.html      # <- en la raíz, obligatorio
├── juego.js
├── assets/
└── style.css
```

2. Comprime el **contenido** de la carpeta (no la carpeta en sí) en un ZIP. En la raíz del ZIP debe quedar `index.html` directamente:

```bash
cd mi-juego
zip -r ../mi-juego-web.zip .
```

3. Entra a itch.io, pulsa "Upload new project" y rellena título, descripción corta y una URL amigable.

4. En **Kind of project** elige **HTML**. Esto habilita la opción de juego jugable en el navegador.

5. Sube el ZIP. Cuando aparezca, marca la casilla **"This file will be played in the browser"**. itch.io usará su `index.html` como punto de entrada del iframe.

6. Configura el **Embed options**: fija el tamaño del viewport (por ejemplo 960×540), activa "Fullscreen button" y "Mobile friendly" si aplica. Un tamaño acorde a tu canvas evita barras de scroll.

7. Sube una **portada** (630×500 recomendado) y capturas. Guarda el proyecto como **Draft** primero.

8. Pulsa "View page" y **prueba el juego embebido**: debe cargar y ser jugable dentro de itch.io. Revisa la consola del navegador por si faltan assets (rutas relativas rotas son el fallo más común). Cuando funcione, cambia la visibilidad a **Public**.

9. Comparativa con portales: anota que Poki/CrazyGames no aceptan un simple ZIP público; exigen integrar su **SDK** (para anuncios y eventos), pasar una revisión de calidad y cumplir requisitos de contenido y rendimiento. A cambio, ofrecen millones de jugadores y **revenue share** por publicidad. Cierra el laboratorio con un checklist de 8 puntos para enviar a un portal.

10. Familiarízate con la forma del SDK de portal. Aunque cada uno tiene su API, el patrón es similar: inicializas el SDK, avisas cuándo empieza y termina el gameplay, y solicitas un anuncio en pausas naturales. Un pseudocódigo ilustrativo del flujo típico:

```javascript
// Patrón general (la API real depende del portal)
await PortalSDK.init();
PortalSDK.gameplayStart();          // el jugador empieza a jugar
// ... al llegar a una pausa natural (fin de nivel):
PortalSDK.gameplayStop();
await PortalSDK.commercialBreak();  // muestra un anuncio intersticial
PortalSDK.gameplayStart();          // se reanuda el juego
```

El principio clave: **nunca interrumpas la acción con un anuncio**; dispáralo en transiciones (fin de nivel, menú), y usa anuncios *rewarded* solo cuando el jugador elige verlos a cambio de algo.

## ✍️ Ejercicios

1. Sube dos versiones del mismo juego (una con `index.html` en la raíz y otra dentro de una subcarpeta) y comprueba cuál carga.
2. Ajusta el tamaño del embed para que coincida exactamente con tu canvas y desaparezcan los scrolls.
3. Redacta la ficha del juego (título, tagline, descripción, controles) como si fuera pública.
4. Investiga tres requisitos técnicos concretos de Poki o CrazyGames y anótalos.
5. Explica en qué se diferencia un anuncio intersticial de uno rewarded y cuándo dispararías cada uno.
6. Elabora un checklist propio de 8 ítems para publicar en un portal HTML5.

## 📝 Reto verificable

Publica un juego HTML5 propio en **itch.io** como build embebido, con ficha completa (portada, descripción, controles) y visibilidad al menos como enlace compartible, y entrega la URL junto con un **checklist de portal** que compare qué faltaría para enviar ese mismo juego a Poki o CrazyGames.

**Criterio de aceptación**: la URL de itch.io carga el juego embebido y es jugable sin errores en consola; `index.html` está en la raíz del ZIP; la ficha tiene portada y descripción; el checklist enumera al menos 6 requisitos reales de un portal (SDK, tamaño, contenido, rendimiento, etc.) señalando cuáles cumple el juego y cuáles no.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| itch.io no ofrece "play in browser" | El proyecto no está marcado como **HTML**. Cámbialo en "Kind of project". |
| Pantalla en blanco en el embed | `index.html` no está en la raíz del ZIP o rutas absolutas. Recomprime con el HTML en la raíz y usa rutas relativas. |
| Assets 404 dentro del iframe | Rutas con `/` inicial. Usa rutas relativas (`./assets/...`). |
| El juego no cabe / hay scroll | Tamaño de embed distinto al canvas. Ajusta el viewport en Embed options. |
| Portal rechaza el build | Falta el SDK o no cumple requisitos. Integra el SDK oficial y revisa su checklist antes de enviar. |

## ❓ Preguntas frecuentes

**❓ ¿itch.io cobra por publicar?** No: publicar es gratis. Puedes poner precio, "pay what you want" o gratis. itch.io retiene una comisión configurable solo sobre las ventas, no por subir el juego.

**❓ ¿Por qué `index.html` debe ir en la raíz del ZIP?** Porque la plataforma busca ahí el punto de entrada para el iframe. Si comprimiste la carpeta contenedora, el HTML queda un nivel más abajo y no lo encuentra.

**❓ ¿Qué gano publicando en un portal frente a itch.io?** Tráfico masivo y monetización por anuncios integrada. El costo es cumplir sus requisitos, integrar su SDK y ceder parte de los ingresos (revenue share).

**❓ ¿El SDK del portal es obligatorio?** Sí, en Poki y CrazyGames. Gestiona los anuncios y ciertos eventos (inicio/fin de partida) que el portal necesita para monetizar y medir. Sin él, no aceptan el juego.

## 🔗 Referencias

- itch.io — HTML5 games: <https://itch.io/docs/creators/html5>
- itch.io — Creator docs: <https://itch.io/docs/creators/>
- Poki for Developers: <https://developers.poki.com>
- CrazyGames Developers: <https://developer.crazygames.com>

## ➡️ Siguiente clase

[Clase 226 - PWAs y juegos instalables](../226-pwas-y-juegos-instalables/README.md)
