# Parte 4 — Gráficos, shaders y rendering moderno

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-3-fisica-y-matematicas-de-juegos-aplicadas/README.md) · [⏭️ Parte siguiente](../parte-5-inteligencia-artificial-para-juegos/README.md)

**22 clases** · rango 086–107 · El pipeline de render moderno y el lenguaje de shaders de Godot: vertex/fragment, texturas, iluminación, PBR, normal mapping, post-procesado, agua, partículas GPU, instancing y NPR

> 🧪 **Laboratorio ejecutable:** esta parte tiene un proyecto Godot real — [`labs/shaders`](../../labs/shaders/README.md) — una galería de shaders con versión `inicio/` (para completar) y `solucion/` (referencia), verificada en CI.

**Fuentes de referencia de esta parte:**

- Tomas Akenine-Möller, Eric Haines et al., *Real-Time Rendering* (4ª ed., CRC Press).
- Patricio Gonzalez Vivo & Jen Lowe, *The Book of Shaders* — [gratis online](https://thebookofshaders.com/).
- Documentación de [shaders de Godot 4](https://docs.godotengine.org/en/stable/tutorials/shaders/index.html).
- *Physically Based Rendering* (Pharr, Jakob, Humphreys) — teoría de PBR.

---

## 🎯 ¿De qué trata esta parte?

Los gráficos de un juego no salen "gratis" del motor: detrás hay un pipeline de render y un lenguaje de **shaders** que decide cómo se dibuja cada píxel. Esta parte desmonta ese proceso y te enseña a escribir shaders propios en Godot 4. Empezamos por entender el pipeline moderno (rasterización, y un vistazo al ray tracing), la estructura de un shader y sus etapas: **vertex** (deformar geometría) y **fragment** (color por píxel), con UVs y muestreo de texturas.

Luego construimos efectos reales: **iluminación** (Lambert, Phong, especular) y el modelo **PBR** (metallic/roughness) que usan los juegos modernos, **normal mapping** para detalle de superficie, shaders **2D** sobre sprites (disolución, outline), **post-procesado** a pantalla completa (bloom, vignette, aberración cromática, CRT), sombras, transparencia, **agua** animada, **partículas en GPU**, **instancing/MultiMesh** para miles de objetos, y estilos no fotorrealistas (**toon/cel shading**). Cerramos con compute shaders, optimización en GPU, las herramientas visuales (VisualShader) y un **capstone** que aplica un set de shaders y post-procesado a un nivel.

## 🧩 Problemas que resuelve

- Tratar los shaders como magia: no poder crear ni modificar un efecto visual propio.
- Materiales que se ven "de plástico" por no entender PBR ni la iluminación.
- Superficies planas y sin detalle por no usar normal maps.
- Efectos de pantalla (bloom, viñeteado, glitch) que no sabes implementar.
- Juegos que se arrastran al dibujar mucha vegetación o multitudes (sin instancing).
- Shaders que funcionan pero matan el rendimiento por no medir su coste en GPU.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Explicar el pipeline de render moderno y las etapas programables (vertex/fragment).
- Escribir shaders en el lenguaje de Godot 4, con texturas, UVs y uniforms.
- Implementar iluminación, materiales PBR y normal mapping.
- Crear efectos 2D sobre sprites y post-procesado a pantalla completa.
- Programar agua animada, partículas en GPU e instancing con MultiMesh.
- Lograr estilos artísticos con toon/cel shading (NPR).
- Medir y optimizar el coste de un shader en la GPU.

## 🧱 Prerrequisitos

- Partes 0–2 (pipeline gráfico introductorio, coordenadas, color/texturas, escenas 3D).
- Nociones de vectores y producto punto (Parte 0 / Parte 3).
- Godot 4.x con una GPU que soporte Vulkan (recomendado) para todos los efectos.

## 📚 Las 22 clases

| # | Clase |
|---|---|
| 086 | [El pipeline de render moderno en profundidad](086-el-pipeline-de-render-moderno-en-profundidad/README.md) |
| 087 | [Rasterización vs ray tracing: panorama actual](087-rasterizacion-vs-ray-tracing-panorama-actual/README.md) |
| 088 | [El lenguaje de shaders de Godot: estructura y tipos](088-el-lenguaje-de-shaders-de-godot-estructura-y-tipos/README.md) |
| 089 | [Vertex shaders: deformar geometría](089-vertex-shaders-deformar-geometria/README.md) |
| 090 | [Fragment shaders: color por píxel y UVs](090-fragment-shaders-color-por-pixel-y-uvs/README.md) |
| 091 | [Texturas en shaders: sampling, tiling y mezcla](091-texturas-en-shaders-sampling-tiling-y-mezcla/README.md) |
| 092 | [Iluminación en shaders: Lambert, Phong y especular](092-iluminacion-en-shaders-lambert-phong-y-especular/README.md) |
| 093 | [PBR: modelo físico de materiales (metallic/roughness)](093-pbr-modelo-fisico-de-materiales-metallic-roughness/README.md) |
| 094 | [Normal mapping y detalle de superficie](094-normal-mapping-y-detalle-de-superficie/README.md) |
| 095 | [Shaders 2D: efectos sobre sprites (disolución y outline)](095-shaders-2d-efectos-sobre-sprites-disolucion-y-outline/README.md) |
| 096 | [Screen-space y post-procesado](096-screen-space-y-post-procesado/README.md) |
| 097 | [Efectos: bloom, vignette, aberración cromática y CRT](097-efectos-bloom-vignette-aberracion-cromatica-y-crt/README.md) |
| 098 | [Sombras: shadow mapping y calidad](098-sombras-shadow-mapping-y-calidad/README.md) |
| 099 | [Transparencia, blending y orden de dibujado](099-transparencia-blending-y-orden-de-dibujado/README.md) |
| 100 | [Agua, olas y superficies animadas](100-agua-olas-y-superficies-animadas/README.md) |
| 101 | [Partículas en GPU y shaders de partículas](101-particulas-en-gpu-y-shaders-de-particulas/README.md) |
| 102 | [Instancing y MultiMesh: miles de objetos](102-instancing-y-multimesh-miles-de-objetos/README.md) |
| 103 | [Toon/cel shading y estilos no fotorrealistas](103-toon-cel-shading-y-estilos-no-fotorrealistas/README.md) |
| 104 | [Compute shaders: cómputo en GPU](104-compute-shaders-computo-en-gpu/README.md) |
| 105 | [Optimización de shaders y coste en GPU](105-optimizacion-de-shaders-y-coste-en-gpu/README.md) |
| 106 | [Herramientas visuales: VisualShader y Shader Graph](106-herramientas-visuales-visualshader-y-shader-graph/README.md) |
| 107 | [Capstone Parte 4: set de shaders y post-procesado](107-capstone-parte-4-set-de-shaders-y-post-procesado/README.md) |

---

> Con lo visual bajo control, la [Parte 5](../parte-5-inteligencia-artificial-para-juegos/README.md) da vida al mundo: IA de enemigos y NPCs con FSM, behavior trees, pathfinding y percepción.
