# Parte 10 — UI/UX, accesibilidad y localización

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-9-arte-animacion-y-pipeline-de-assets/README.md) · [⏭️ Parte siguiente](../parte-11-movil-consolas-y-plataformas/README.md)

**12 clases** · rango 188–199 · Interfaces que se entienden y llegan a todos: el sistema Control de Godot, theming, HUD, menús, UI responsive, accesibilidad y localización

> 🧪 **Laboratorio ejecutable:** esta parte tiene un proyecto Godot real — [`labs/ui-accesible`](../../labs/ui-accesible/README.md) — con versión `inicio/` (para completar) y `solucion/` (referencia), verificado en CI: la UI de Godot se calcula en la CPU, así que se puede medir sin pantalla.

**Fuentes de referencia de esta parte:**

- Celia Hodent, *The Gamer's Brain: How Neuroscience and UX Can Impact Video Game Design*.
- Documentación de [UI de Godot 4](https://docs.godotengine.org/en/stable/tutorials/ui/index.html).
- [Game Accessibility Guidelines](https://gameaccessibilityguidelines.com/).
- Documentación de [internacionalización de Godot](https://docs.godotengine.org/en/stable/tutorials/i18n/index.html).

---

## 🎯 ¿De qué trata esta parte?

La interfaz es el idioma con el que el juego habla con el jugador: menús, HUD, inventarios, avisos. Una buena UI es invisible cuando funciona y frustrante cuando no. Esta parte enseña a construir interfaces sólidas con el sistema **Control** de Godot 4 (containers, anclas, theming), y a diseñarlas bien: HUD diegético vs no diegético, navegación entre pantallas, y el **juice** que hace que una UI se sienta viva.

Además aborda dos temas que separan un juego amateur de uno profesional: la **UI responsive** (que funcione en cualquier resolución y aspect ratio, con teclado, gamepad y táctil) y, sobre todo, la **accesibilidad** (visual, auditiva, motora y cognitiva) y la **localización** a varios idiomas. Cerramos con tipografía multi-idioma y un **capstone**: una UI completa, accesible y localizada.

## 🧩 Problemas que resuelve

- UIs que se rompen o descolocan al cambiar de resolución o aspect ratio.
- Menús que no se pueden navegar con gamepad o que son un caos con muchos elementos.
- HUD que satura o esconde información clave.
- Juegos inaccesibles para personas con daltonismo, baja visión o dificultades motoras.
- Textos "hardcodeados" imposibles de traducir; fuentes que no soportan otros idiomas.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Construir UIs con el sistema Control de Godot (containers, anclas, theming).
- Diseñar HUD y menús claros con buena navegación y feedback.
- Crear UIs responsive que funcionen con teclado, gamepad y táctil.
- Aplicar pautas de accesibilidad (contraste, subtítulos, remapeo, escalado).
- Localizar un juego a varios idiomas con archivos de traducción.
- Gestionar tipografía y texto en distintos idiomas y sistemas de escritura.

## 🧱 Prerrequisitos

- Partes 0 y 1 (nodos, escenas, señales; HUD básico de la Parte 1).
- Godot 4.x. Útil haber visto la Parte 8 (UX es parte del diseño).

## 📚 Las 12 clases

| # | Clase |
|---|---|
| 188 | [Fundamentos de UI/UX en juegos](188-fundamentos-de-ui-ux-en-juegos/README.md) |
| 189 | [Sistema de UI de Godot: Control, Containers y anclas](189-sistema-de-ui-de-godot-control-containers-y-anclas/README.md) |
| 190 | [Theming y estilos de UI escalables](190-theming-y-estilos-de-ui-escalables/README.md) |
| 191 | [HUD diegético y no diegético](191-hud-diegetico-y-no-diegetico/README.md) |
| 192 | [Menús, navegación y flujo de pantallas](192-menus-navegacion-y-flujo-de-pantallas/README.md) |
| 193 | [Feedback, juice y animación de UI](193-feedback-juice-y-animacion-de-ui/README.md) |
| 194 | [UI responsive: múltiples resoluciones y aspect ratios](194-ui-responsive-multiples-resoluciones-y-aspect-ratios/README.md) |
| 195 | [Input de UI: teclado, gamepad y táctil](195-input-de-ui-teclado-gamepad-y-tactil/README.md) |
| 196 | [Accesibilidad en juegos](196-accesibilidad-en-juegos/README.md) |
| 197 | [Localización e internacionalización (i18n)](197-localizacion-e-internacionalizacion-i18n/README.md) |
| 198 | [Fuentes, tipografía y texto multi-idioma](198-fuentes-tipografia-y-texto-multiidioma/README.md) |
| 199 | [Capstone Parte 10: una UI completa, accesible y localizada](199-capstone-parte-10-una-ui-completa-accesible-y-localizada/README.md) |

---

> Con la interfaz resuelta, la [Parte 11](../parte-11-movil-consolas-y-plataformas/README.md) lleva el juego a más pantallas: móvil, consolas y plataformas.
