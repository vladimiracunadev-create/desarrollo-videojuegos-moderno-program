# Parte 11 — Móvil, consolas y plataformas

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-10-ui-ux-accesibilidad-y-localizacion/README.md) · [⏭️ Parte siguiente](../parte-12-juegos-web-y-html5/README.md)

**14 clases** · rango 200–213 · Llevar tu juego a más pantallas: Android, iOS, input táctil, rendimiento móvil, monetización, consolas, certificación y Steam Deck

**Fuentes de referencia de esta parte:**

- Documentación de [exportación de Godot 4](https://docs.godotengine.org/en/stable/tutorials/export/index.html).
- Guías oficiales de [Google Play](https://developer.android.com/games) y [App Store](https://developer.apple.com/games/).
- [Steam Deck — guía para desarrolladores](https://partner.steamgames.com/doc/steamdeck).
- Documentación de programas de consola (Nintendo, PlayStation, Xbox — bajo NDA).

---

## 🎯 ¿De qué trata esta parte?

Un juego solo importa cuando llega a las manos del jugador, y hoy eso significa muchas plataformas con reglas muy distintas. Esta parte cubre el salto de "corre en mi PC" a "publicado en la tienda". Empieza por el **panorama de plataformas** y sus restricciones, y entra de lleno en **móvil**: exportar a **Android** (firma, keystore) e **iOS** (provisioning), diseñar **controles táctiles**, y optimizar **rendimiento y batería**, resoluciones, notch y safe areas.

Cubre la **monetización móvil** (anuncios, compras in-app), los **servicios** (Google Play Games, Game Center) y **publicar en las tiendas**. La segunda mitad mira a las **consolas**: cómo funcionan los devkits y los programas de desarrollador, la **certificación** (TRC/TCR), el input, los logros y el guardado en nube, y la compatibilidad con **Steam Deck**. El **capstone** exporta y pule el juego para una plataforma objetivo real.

## 🧩 Problemas que resuelve

- No saber exportar ni firmar un juego para Android/iOS ni superar la revisión de las tiendas.
- Controles pensados para teclado que son injugables en táctil.
- Juegos que consumen batería, se calientan o van a tirones en móvil.
- UI cortada por el notch o mal escalada en pantallas raras.
- Desconocer cómo se accede al desarrollo de consola y qué exige la certificación.
- Juegos que fallan la verificación de Steam Deck por controles o rendimiento.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Exportar y firmar un juego para Android e iOS.
- Diseñar controles táctiles y adaptar la UI a safe areas y aspect ratios móviles.
- Optimizar rendimiento y consumo para dispositivos móviles.
- Integrar monetización y servicios de plataforma, y publicar en las tiendas.
- Explicar el proceso de desarrollo, certificación y publicación en consola.
- Preparar y verificar un juego para Steam Deck.

## 🧱 Prerrequisitos

- Partes 0, 1 y 14 (exportación básica de la Parte 1; optimización como apoyo).
- Godot 4.x con las plantillas de exportación; para iOS se necesita un Mac; Android SDK para Android.

## 📚 Las 14 clases

| # | Clase |
|---|---|
| 200 | [Panorama de plataformas y sus restricciones](200-panorama-de-plataformas-y-sus-restricciones/README.md) |
| 201 | [Exportar a Android: setup y firma](201-exportar-a-android-setup-y-firma/README.md) |
| 202 | [Exportar a iOS: setup y provisioning](202-exportar-a-ios-setup-y-provisioning/README.md) |
| 203 | [Input táctil y controles móviles](203-input-tactil-y-controles-moviles/README.md) |
| 204 | [Rendimiento y batería en móvil](204-rendimiento-y-bateria-en-movil/README.md) |
| 205 | [Resoluciones, notch y safe areas](205-resoluciones-notch-y-safe-areas/README.md) |
| 206 | [Monetización móvil: anuncios y compras in-app](206-monetizacion-movil-anuncios-y-compras-in-app/README.md) |
| 207 | [Servicios: Google Play Games y Game Center](207-servicios-google-play-games-y-game-center/README.md) |
| 208 | [Publicar en las tiendas móviles](208-publicar-en-las-tiendas-moviles/README.md) |
| 209 | [Desarrollo para consolas: panorama y devkits](209-desarrollo-para-consolas-panorama-y-devkits/README.md) |
| 210 | [Certificación (TRC/TCR) y requisitos de consola](210-certificacion-trc-tcr-y-requisitos-de-consola/README.md) |
| 211 | [Input de consola, logros y guardado en nube](211-input-de-consola-logros-y-guardado-en-nube/README.md) |
| 212 | [Steam Deck y compatibilidad PC](212-steam-deck-y-compatibilidad-pc/README.md) |
| 213 | [Capstone Parte 11: exportar y pulir para una plataforma](213-capstone-parte-11-exportar-y-pulir-para-una-plataforma/README.md) |

---

> La [Parte 12](../parte-12-juegos-web-y-html5/README.md) cubre otra plataforma clave: el navegador, con Godot HTML5, Phaser, PixiJS y Three.js.
