# Clase 226 — PWAs y juegos instalables

> Parte: **12 — Juegos web y HTML5** · Fuente: *MDN Web Docs — Progressive web apps y web.dev — Learn PWA*
> ⏱️ Duración estimada: **65 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego web vive en una pestaña y desaparece cuando el usuario la cierra. Las **Progressive Web Apps (PWA)** cambian eso: con dos piezas —un `manifest.json` y un **service worker**— tu juego se puede **instalar** en el dispositivo (icono en la pantalla de inicio, ventana propia sin barra de navegador) y **funcionar offline** gracias a la caché. Para juegos casuales esto significa reengagement, arranque instantáneo en visitas siguientes y presencia como app sin pasar por tiendas.

En esta clase convertimos un juego web en PWA instalable. Escribimos el manifest que define nombre, iconos y modo de visualización; registramos un service worker que cachea los assets del juego para que cargue sin red; y comprobamos que aparece el prompt de instalación. Al terminar tendrás un juego que se instala y abre offline.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es una PWA y qué ventajas aporta a un juego.
2. Escribir un `manifest.json` válido con iconos y modo standalone.
3. Registrar un service worker desde la página del juego.
4. Cachear los assets del juego para funcionamiento offline.
5. Verificar la instalabilidad con las herramientas del navegador.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es una PWA | Web instalable con capacidades de app. |
| 2 | `manifest.json` | Define nombre, iconos y cómo se abre. |
| 3 | Modo `display: standalone` | Ventana propia sin barra del navegador. |
| 4 | Service worker | Proxy de red que habilita offline. |
| 5 | Ciclo de vida del SW | Install, activate, fetch. |
| 6 | Estrategias de caché | Qué servir de red y qué de caché. |
| 7 | Prompt de instalación | Cómo el usuario añade el juego. |
| 8 | Requisitos de instalabilidad | HTTPS, manifest y SW válidos. |

## 📖 Definiciones y características

- **PWA (Progressive Web App)**: web que usa APIs modernas para instalarse y funcionar offline. Clave: requiere HTTPS, un manifest y un service worker.
- **`manifest.json`**: archivo JSON con metadatos de instalación. Clave: nombre, iconos, `start_url` y `display` definen cómo se ve la app instalada.
- **`display: standalone`**: modo que abre la app en su propia ventana. Clave: quita la barra del navegador y da sensación de app nativa.
- **Service worker (SW)**: script que corre en segundo plano como proxy de red. Clave: intercepta `fetch` y decide servir de red o de caché.
- **Cache Storage API**: almacén de respuestas HTTP controlado por el SW. Clave: guardas ahí el "app shell" y los assets para el offline.
- **App shell**: mínimo de HTML/CSS/JS/assets para arrancar el juego. Clave: cachearlo permite abrir sin red al instante.
- **Evento `install`**: primer paso del ciclo del SW. Clave: momento típico para precachear los assets esenciales.
- **`beforeinstallprompt`**: evento que permite mostrar tu propio botón de instalar. Clave: lo capturas para controlar cuándo aparece el prompt.

## 🧰 Herramientas y preparación

Necesitas un servidor con **HTTPS** o `localhost` (los service workers no funcionan sobre `file://` ni `http://` remoto). Para desarrollo, `localhost` cuenta como contexto seguro. Usa las DevTools → Application para inspeccionar el manifest, el service worker y la Cache Storage. Prepara un par de iconos PNG (192×192 y 512×512) para el manifest.

Referencias: PWAs en MDN (<https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps>), Service Worker API (<https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API>) y el curso Learn PWA de web.dev (<https://web.dev/learn/pwa>).

## 🧪 Laboratorio guiado

Convertiremos un juego web en PWA instalable y offline.

1. Crea `manifest.json` en la raíz del juego:

```json
{
  "name": "Mi Juego Web",
  "short_name": "MiJuego",
  "start_url": "./index.html",
  "display": "standalone",
  "background_color": "#0b0b1a",
  "theme_color": "#1f6feb",
  "icons": [
    { "src": "icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

2. Enlaza el manifest en el `<head>` de `index.html`:

```html
<link rel="manifest" href="./manifest.json" />
<meta name="theme-color" content="#1f6feb" />
```

3. Crea el service worker `sw.js`. En `install`, precachea el app shell:

```javascript
const CACHE = "mijuego-v1";
const ASSETS = [
  "./index.html",
  "./juego.js",
  "./style.css",
  "./assets/sprites.png",
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});
```

4. En `activate`, limpia cachés viejas de versiones anteriores:

```javascript
self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((claves) =>
      Promise.all(claves.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});
```

5. En `fetch`, sirve de caché y cae a la red (estrategia cache-first, ideal para assets de juego):

```javascript
self.addEventListener("fetch", (e) => {
  e.respondWith(
    caches.match(e.request).then((cacheada) => cacheada || fetch(e.request))
  );
});
```

6. Registra el service worker desde `juego.js` (o un script en `index.html`):

```javascript
if ("serviceWorker" in navigator) {
  window.addEventListener("load", async () => {
    try {
      await navigator.serviceWorker.register("./sw.js");
      console.log("Service worker registrado ✔");
    } catch (err) {
      console.error("Fallo al registrar SW:", err);
    }
  });
}
```

7. Sirve el juego por `localhost` y ábrelo. En DevTools → Application → Manifest verifica que no haya errores y que aparezca "Installability: installable". Deberías ver un **icono de instalar** en la barra del navegador.

8. Prueba el **offline**: en DevTools → Network activa "Offline" y recarga. El juego debe cargar igual, servido desde la caché. Instálalo con el botón del navegador y comprueba que abre en **ventana propia** sin barra de direcciones.

## ✍️ Ejercicios

1. Añade un tercer icono `maskable` y observa cómo cambia el recorte en el instalador.
2. Cambia `display` a `fullscreen` y describe la diferencia con `standalone`.
3. Sube la versión de caché a `mijuego-v2`, cambia un asset y confirma que se actualiza tras recargar.
4. Captura el evento `beforeinstallprompt` y muestra tu propio botón "Instalar".
5. Añade una página offline personalizada para peticiones que no estén en caché.
6. Enumera qué assets NO deberías cachear (por ejemplo, datos de servidor en vivo) y por qué.

## 📝 Reto verificable

Convierte un juego web propio en **PWA instalable** con `manifest.json`, iconos y un service worker que le permita **cargar completamente offline**, y demuéstralo instalándolo y abriéndolo sin conexión de red.

**Criterio de aceptación**: DevTools → Application marca el juego como instalable sin errores de manifest; el service worker se registra y aparece "activated"; con Network en "Offline" el juego carga y es jugable; instalado, abre en ventana propia (`standalone`) con su icono; la caché se versiona (cambiar la versión actualiza los assets).

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El SW no se registra | Servido por `file://` o `http` remoto sin TLS. Usa `localhost` o `https`. |
| No aparece el botón de instalar | Falta manifest, iconos o SW válido. Revisa Application → Manifest para ver el requisito incumplido. |
| Cambios en assets no se ven | La caché sirve la versión vieja. Sube la versión del cache (`v2`) para invalidarla. |
| Offline muestra error de red | El asset pedido no estaba precacheado. Añádelo a `ASSETS` o cachéalo en `fetch`. |
| `addAll` falla en `install` | Una ruta del array no existe (404). Corrige rutas relativas; `addAll` es atómico y falla todo si una falla. |

## ❓ Preguntas frecuentes

**❓ ¿Una PWA reemplaza publicar en tiendas?** Para juegos casuales puede bastar: se instala desde el navegador sin pasar por revisión. Aun así, algunas plataformas (Play Store) permiten empaquetar la PWA para llegar también a la tienda si lo deseas.

**❓ ¿Por qué el service worker exige HTTPS?** Porque puede interceptar y modificar todas las peticiones de la página; en manos maliciosas sería peligroso. Se restringe a contextos seguros (`https`) y a `localhost` para desarrollo.

**❓ ¿Cache-first o network-first para un juego?** Para assets estáticos del juego, cache-first da arranque instantáneo y offline. Para datos vivos (rankings, partidas), usa network-first o no los caches. Puedes combinar estrategias por tipo de recurso.

**❓ ¿Cómo actualizo el juego si todo está cacheado?** Cambia el nombre de versión del cache (`mijuego-v2`) y ajusta la lista de assets. El nuevo SW se instala, precachea la versión nueva y en `activate` borra la vieja.

## 🔗 Referencias

- MDN — Progressive web apps: <https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps>
- MDN — Service Worker API: <https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API>
- web.dev — Learn PWA: <https://web.dev/learn/pwa>
- MDN — Web app manifest: <https://developer.mozilla.org/en-US/docs/Web/Manifest>

## ➡️ Siguiente clase

[Clase 227 - Capstone Parte 12: un juego web publicado](../227-capstone-parte-12-un-juego-web-publicado/README.md)
