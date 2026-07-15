# Parte 5 — Inteligencia artificial para juegos

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-4-graficos-shaders-y-rendering-moderno/README.md) · [⏭️ Parte siguiente](../parte-6-audio-y-musica-interactiva/README.md)

**18 clases** · rango 108–125 · IA de juegos práctica: FSM y HFSM, behavior trees, pathfinding (A*), navmesh, steering, percepción, utility AI, GOAP, IA de combate, dirección dinámica y generación procedural

> 🧪 **Laboratorio ejecutable:** esta parte tiene un proyecto Godot real — [`labs/ia-enemigo`](../../labs/ia-enemigo/README.md) — con versión `inicio/` (para completar) y `solucion/` (referencia jugable), verificado en CI: la prueba no mira si arranca, sino si el árbol decide.

**Fuentes de referencia de esta parte:**

- Ian Millington & John Funge, *Artificial Intelligence for Games* (2ª ed., CRC Press).
- Steve Rabin (ed.), *Game AI Pro* (series, CRC Press) — [artículos gratis](http://www.gameaipro.com/).
- Mat Buckland, *Programming Game AI by Example* (Wordware).
- Documentación de [navegación de Godot 4](https://docs.godotengine.org/en/stable/tutorials/navigation/index.html).

---

## 🎯 ¿De qué trata esta parte?

La "IA" de un juego rara vez busca ser inteligente de verdad: busca ser **creíble y divertida**. Un guardia que patrulla, te ve, te persigue y pierde tu rastro no necesita redes neuronales, sino buenas estructuras de decisión. Esta parte enseña las herramientas que usa la industria, de lo simple a lo avanzado: **máquinas de estado** (FSM y jerárquicas), **behavior trees** (el estándar para enemigos complejos), y cómo darles movimiento con **pathfinding A\***, navmesh y **steering behaviors**.

Después subimos de nivel: **percepción** (visión, oído y memoria del agente), toma de decisiones con **utility AI**, planificación con **GOAP**, IA de **combate** (cobertura, flanqueo, coordinación de grupo), **directores** que ajustan la dificultad, y NPCs con vida ambiental. Cerramos con generación procedural (ruido Perlin/Simplex, niveles y mazmorras), un vistazo al machine learning en juegos (ML-Agents, RL) y un **capstone**: un enemigo completo con behavior tree, percepción y pathfinding.

## 🧩 Problemas que resuelve

- Enemigos "tontos" que no reaccionan, o cuyo código es un `if` gigante inmantenible.
- IA que se atasca en paredes o no sabe rodear obstáculos (mal pathfinding).
- Agentes que "ven" a través de muros o reaccionan de forma poco natural (falta de percepción).
- Comportamientos rígidos que no escalan a decisiones complejas (aquí entran BT, utility y GOAP).
- Combate sin táctica: enemigos que se amontonan sin coordinarse.
- Niveles siempre iguales por no dominar la generación procedural.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Implementar FSM y máquinas de estado jerárquicas para IA de agentes.
- Diseñar y construir behavior trees para enemigos complejos.
- Aplicar pathfinding A*, navmesh y steering behaviors con evitación de obstáculos.
- Modelar percepción (visión/oído/memoria) y toma de decisiones (utility AI, GOAP).
- Coordinar IA de combate y ajustar la dificultad con un director.
- Generar contenido procedural con ruido y algoritmos de niveles.
- Entender el rol (y los límites) del machine learning en juegos.

## 🧱 Prerrequisitos

- Partes 0–2 (máquina de estados, vectores, escenas 2D/3D y navegación básica).
- Steering behaviors introducidos en la Parte 3 (se retoman y amplían aquí).
- Godot 4.x (los laboratorios usan su sistema de navegación y GDScript).

## 📚 Las 18 clases

| # | Clase |
|---|---|
| 108 | [Panorama de la IA de juegos: qué es y qué no](108-panorama-de-la-ia-de-juegos-que-es-y-que-no/README.md) |
| 109 | [Máquinas de estado finito (FSM) para IA](109-maquinas-de-estado-finito-fsm-para-ia/README.md) |
| 110 | [Máquinas de estado jerárquicas (HFSM)](110-maquinas-de-estado-jerarquicas-hfsm/README.md) |
| 111 | [Behavior Trees: fundamentos](111-behavior-trees-fundamentos/README.md) |
| 112 | [Behavior Trees: construir un enemigo completo](112-behavior-trees-construir-un-enemigo-completo/README.md) |
| 113 | [Pathfinding: A* explicado y aplicado](113-pathfinding-a-estrella-explicado-y-aplicado/README.md) |
| 114 | [Navmesh y navegación en Godot (2D y 3D)](114-navmesh-y-navegacion-en-godot-2d-y-3d/README.md) |
| 115 | [Steering y evitación de obstáculos (flocking)](115-steering-y-evitacion-de-obstaculos-flocking/README.md) |
| 116 | [Percepción: visión, oído y memoria del agente](116-percepcion-vision-oido-y-memoria-del-agente/README.md) |
| 117 | [Toma de decisiones: utility AI](117-toma-de-decisiones-utility-ai/README.md) |
| 118 | [GOAP: planificación orientada a objetivos](118-goap-planificacion-orientada-a-objetivos/README.md) |
| 119 | [IA de combate: cobertura, flanqueo y coordinación](119-ia-de-combate-cobertura-flanqueo-y-coordinacion/README.md) |
| 120 | [Director de IA y dificultad dinámica](120-director-de-ia-y-dificultad-dinamica/README.md) |
| 121 | [IA para NPCs y vida ambiental](121-ia-para-npcs-y-vida-ambiental/README.md) |
| 122 | [Ruido y generación procedural (Perlin y Simplex)](122-ruido-y-generacion-procedural-perlin-y-simplex/README.md) |
| 123 | [Generación procedural de niveles](123-generacion-procedural-de-niveles/README.md) |
| 124 | [Machine learning en juegos: panorama (ML-Agents y RL)](124-machine-learning-en-juegos-panorama-ml-agents-y-rl/README.md) |
| 125 | [Capstone Parte 5: enemigo con behavior tree y percepción](125-capstone-parte-5-enemigo-con-behavior-tree-y-percepcion/README.md) |

---

> Con el mundo vivo, la [Parte 6](../parte-6-audio-y-musica-interactiva/README.md) le pone banda sonora: diseño de sonido, audio posicional y música adaptativa.
