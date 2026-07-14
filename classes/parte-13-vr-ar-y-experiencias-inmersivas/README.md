# Parte 13 — VR, AR y experiencias inmersivas

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-12-juegos-web-y-html5/README.md) · [⏭️ Parte siguiente](../parte-14-optimizacion-profiling-y-rendimiento/README.md)

**12 clases** · rango 228–239 · Realidad extendida: OpenXR, VR en Godot, locomoción y confort, interacción con las manos, AR con ARCore/ARKit, rendimiento XR y audio espacial

**Fuentes de referencia de esta parte:**

- [Especificación OpenXR (Khronos)](https://www.khronos.org/openxr/).
- Documentación de [XR en Godot 4](https://docs.godotengine.org/en/stable/tutorials/xr/index.html).
- Oculus/Meta *VR Best Practices* y guías de confort.
- Documentación de [ARCore](https://developers.google.com/ar) y [ARKit](https://developer.apple.com/augmented-reality/).

---

## 🎯 ¿De qué trata esta parte?

La realidad virtual y aumentada cambian las reglas: el jugador ya no mira una pantalla, está **dentro** de la experiencia o la superpone al mundo real. Esto introduce retos únicos de diseño, interacción y rendimiento. Esta parte da una base práctica de **XR** (VR, AR y MR): el hardware (visores, tracking, controles), el estándar abierto **OpenXR**, y cómo montar VR en Godot 4 desde la primera escena.

El foco está en lo que hace o rompe una experiencia inmersiva: la **locomoción y el confort** (evitar el mareo, el mayor enemigo de la VR), la **interacción** con manos, agarre y UI espacial, y el diseño para la **presencia** y la escala. En AR cubre los fundamentos, el tracking y los frameworks (ARCore/ARKit). Cierra con lo no negociable en XR —el **rendimiento** (los 90 fps obligatorios)—, el **audio espacial** y los hápticos, y un **capstone**: una experiencia VR o AR mínima.

## 🧩 Problemas que resuelve

- No saber por dónde empezar en VR/AR ni qué hardware/estándar usar.
- Experiencias que marean por mala locomoción o baja tasa de frames.
- Interacciones torpes: agarrar, pulsar botones o navegar menús en el espacio.
- Diseñar para VR como si fuera una pantalla plana (escala y presencia mal resueltas).
- AR que no ancla bien los objetos al mundo real (tracking deficiente).
- Caídas de rendimiento que en XR son inaceptables (provocan malestar físico).

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Explicar el panorama XR, el hardware y el estándar OpenXR.
- Montar una escena VR en Godot y desplegarla en un visor.
- Diseñar locomoción y confort para minimizar el mareo.
- Implementar interacción con manos, agarre y UI espacial.
- Crear una experiencia de AR básica con tracking (ARCore/ARKit).
- Cumplir el presupuesto de rendimiento de XR y añadir audio espacial y hápticos.

## 🧱 Prerrequisitos

- Partes 2 y 14 (3D sólido y optimización; XR exige ambos).
- Godot 4.x con soporte OpenXR; idealmente un visor VR (Quest, etc.) o un móvil con ARCore/ARKit.

## 📚 Las 12 clases

| # | Clase |
|---|---|
| 228 | [Panorama de XR: VR, AR y MR](228-panorama-de-xr-vr-ar-y-mr/README.md) |
| 229 | [Hardware XR: visores, tracking y controles](229-hardware-xr-visores-tracking-y-controles/README.md) |
| 230 | [OpenXR y el estándar abierto](230-openxr-y-el-estandar-abierto/README.md) |
| 231 | [VR en Godot: setup y primera escena](231-vr-en-godot-setup-y-primera-escena/README.md) |
| 232 | [Locomoción VR y confort](232-locomocion-vr-y-confort/README.md) |
| 233 | [Interacción VR: manos, agarre y UI espacial](233-interaccion-vr-manos-agarre-y-ui-espacial/README.md) |
| 234 | [Presencia, escala y diseño para VR](234-presencia-escala-y-diseno-para-vr/README.md) |
| 235 | [Realidad aumentada: fundamentos y tracking](235-realidad-aumentada-fundamentos-y-tracking/README.md) |
| 236 | [AR con ARCore y ARKit](236-ar-con-arcore-y-arkit/README.md) |
| 237 | [Rendimiento en XR](237-rendimiento-en-xr/README.md) |
| 238 | [Audio espacial y hápticos](238-audio-espacial-y-hapticos/README.md) |
| 239 | [Capstone Parte 13: una experiencia VR o AR mínima](239-capstone-parte-13-una-experiencia-vr-o-ar-minima/README.md) |

---

> La [Parte 14](../parte-14-optimizacion-profiling-y-rendimiento/README.md) profundiza en el rendimiento, esencial para XR y para todo lo demás.
