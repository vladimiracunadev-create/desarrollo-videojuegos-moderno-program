# Parte 2 — Desarrollo 3D: motores, escenas y transformaciones

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-1-motores-2d-y-tu-primer-juego-jugable/README.md) · [⏭️ Parte siguiente](../parte-3-fisica-y-matematicas-de-juegos-aplicadas/README.md)

**22 clases** · rango 046–067 · El salto a las tres dimensiones con Godot 4: escenas 3D, transformaciones, cámaras, iluminación, controladores en primera y tercera persona, física, animación y navegación

> 🧪 **Laboratorio ejecutable:** esta parte tiene un proyecto Godot real — [`labs/3d-tercera-persona`](../../labs/3d-tercera-persona/README.md) — con versión `inicio/` (para completar) y `solucion/` (referencia jugable), verificado en CI.

**Fuentes de referencia de esta parte:**

- Documentación oficial de [Godot Engine 4.x — 3D](https://docs.godotengine.org/en/stable/tutorials/3d/index.html).
- Jason Gregory, *Game Engine Architecture* (3ª ed.) — rendering y escenas.
- Eric Lengyel, *Mathematics for 3D Game Programming and Computer Graphics*.
- Documentación de [Blender](https://docs.blender.org/) y del formato [glTF](https://www.khronos.org/gltf/).

---

## 🎯 ¿De qué trata esta parte?

En 2D todo vive en un plano; en 3D hay que pensar en volumen, profundidad, cámaras que se mueven por el espacio y luces que proyectan sombras. Esta parte te lleva del mundo plano de la Parte 1 al espacio tridimensional completo, usando Godot 4: cómo se estructura una escena 3D, cómo funcionan las transformaciones (posición, rotación y escala con `Transform3D`), cómo importar modelos desde Blender, y cómo iluminar y encuadrar una escena para que se vea bien.

Después construimos lo que hace jugable un mundo 3D: controladores de personaje en **primera** y **tercera persona**, colisiones y física 3D, raycasting para disparar y detectar el suelo, animación de personajes con esqueletos y `AnimationTree`, y navegación con navmesh para que los enemigos se muevan por el nivel. Cerramos con diseño de niveles modulares (blockout, GridMap), optimización básica (LOD, draw calls) y un **capstone**: un nivel 3D explorable en tercera persona.

## 🧩 Problemas que resuelve

- No entender la diferencia entre transform local y global, o por qué rotar en 3D es más complejo que en 2D.
- Modelos que se importan mal (escala, ejes, materiales rotos) desde Blender u otras herramientas.
- Cámaras en tercera persona que atraviesan paredes o marean; controladores FPS con mal tacto.
- Escenas 3D que se ven planas o feas por mala iluminación y entorno.
- Personajes que se deslizan sin animar o cuyas animaciones no mezclan bien al correr/saltar.
- Enemigos que no saben moverse por un nivel 3D (falta de navegación).

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Estructurar escenas 3D en Godot y manipular `Transform3D` (basis + origin) con criterio.
- Importar y configurar modelos 3D (glTF/Blender) con la escala y orientación correctas.
- Encuadrar e iluminar una escena con cámaras, luces, sombras y `WorldEnvironment`.
- Programar controladores en primera y tercera persona con `CharacterBody3D`.
- Usar física 3D, raycasting, áreas y capas de colisión.
- Animar personajes con esqueletos, `AnimationPlayer` y `AnimationTree` (blending de locomoción).
- Implementar navegación con navmesh y pathfinding en 3D.
- Construir un nivel modular y aplicar optimizaciones básicas de rendimiento.

## 🧱 Prerrequisitos

- Haber cubierto las Partes 0 y 1 (game loop, vectores, matrices y transformaciones, colisiones y física 2D, máquina de estados).
- Godot 4.x instalado. Recomendable [Blender](https://www.blender.org/) para importar y ajustar modelos.
- GPU con soporte Vulkan/OpenGL para el renderizado 3D.

## 📚 Las 22 clases

| # | Clase |
|---|---|
| 046 | [Del 2D al 3D: qué cambia (ejes, cámaras y mallas)](046-del-2d-al-3d-que-cambia-ejes-camaras-y-mallas/README.md) |
| 047 | [Escenas 3D en Godot: Node3D, transformaciones y gizmo](047-escenas-3d-en-godot-node3d-transformaciones-y-gizmo/README.md) |
| 048 | [Sistemas de coordenadas 3D y Transform3D (basis y origin)](048-sistemas-de-coordenadas-3d-y-transform3d-basis-y-origin/README.md) |
| 049 | [Mallas, materiales y MeshInstance3D](049-mallas-materiales-y-meshinstance3d/README.md) |
| 050 | [Importar modelos 3D: glTF, Blender y el pipeline](050-importar-modelos-3d-gltf-blender-y-el-pipeline/README.md) |
| 051 | [Cámaras 3D: perspectiva, FOV y Camera3D](051-camaras-3d-perspectiva-fov-y-camera3d/README.md) |
| 052 | [Iluminación 3D: tipos de luz y sombras](052-iluminacion-3d-tipos-de-luz-y-sombras/README.md) |
| 053 | [WorldEnvironment: cielo, niebla y tonemapping](053-worldenvironment-cielo-niebla-y-tonemapping/README.md) |
| 054 | [Movimiento 3D: CharacterBody3D y move_and_slide](054-movimiento-3d-characterbody3d-y-move-and-slide/README.md) |
| 055 | [Controlador en primera persona (FPS)](055-controlador-en-primera-persona-fps/README.md) |
| 056 | [Controlador en tercera persona con cámara orbital](056-controlador-en-tercera-persona-con-camara-orbital/README.md) |
| 057 | [Colisiones y física 3D: cuerpos, formas y capas](057-colisiones-y-fisica-3d-cuerpos-formas-y-capas/README.md) |
| 058 | [RigidBody3D, fuerzas e interacción física](058-rigidbody3d-fuerzas-e-interaccion-fisica/README.md) |
| 059 | [Raycasting 3D: selección, disparos y detección de suelo](059-raycasting-3d-seleccion-disparos-y-deteccion-de-suelo/README.md) |
| 060 | [Animación 3D: esqueletos, skinning y AnimationPlayer](060-animacion-3d-esqueletos-skinning-y-animationplayer/README.md) |
| 061 | [AnimationTree y blending de animaciones](061-animationtree-y-blending-de-animaciones/README.md) |
| 062 | [NavigationServer 3D: navmesh y pathfinding](062-navigationserver-3d-navmesh-y-pathfinding/README.md) |
| 063 | [Áreas, triggers y detección en 3D](063-areas-triggers-y-deteccion-en-3d/README.md) |
| 064 | [Instanciado y escenas 3D reutilizables](064-instanciado-y-escenas-3d-reutilizables/README.md) |
| 065 | [Nivel 3D: GridMap, kits modulares y blockout](065-nivel-3d-gridmap-kits-modulares-y-blockout/README.md) |
| 066 | [Optimización 3D básica: LOD, occlusion y draw calls](066-optimizacion-3d-basica-lod-occlusion-y-draw-calls/README.md) |
| 067 | [Capstone Parte 2: un nivel 3D explorable en tercera persona](067-capstone-parte-2-un-nivel-3d-explorable-en-tercera-persona/README.md) |

---

> Con el mundo 3D en pie, la [Parte 3](../parte-3-fisica-y-matematicas-de-juegos-aplicadas/README.md) profundiza en la física y las matemáticas que lo hacen creíble: cuaterniones, colisiones, joints, vehículos y steering.
