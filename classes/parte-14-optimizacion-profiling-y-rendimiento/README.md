# Parte 14 — Optimización, profiling y rendimiento

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-13-vr-ar-y-experiencias-inmersivas/README.md) · [⏭️ Parte siguiente](../parte-15-herramientas-editores-y-automatizacion/README.md)

**15 clases** · rango 240–254 · Hacer que el juego vaya rápido: medir antes de optimizar, profiling de CPU/GPU, presupuesto de frame, memoria, pooling, física, culling, LOD y multithreading

**Fuentes de referencia de esta parte:**

- Jason Gregory, *Game Engine Architecture* — rendimiento y sistemas.
- Documentación de [optimización de Godot 4](https://docs.godotengine.org/en/stable/tutorials/performance/index.html).
- *Real-Time Rendering* (Akenine-Möller et al.) — coste de GPU.
- Documentación de [RenderDoc](https://renderdoc.org/docs/) y profilers nativos.

---

## 🎯 ¿De qué trata esta parte?

Un juego que va a tirones no es divertido, por bueno que sea todo lo demás. Optimizar es una disciplina con método, no magia: la regla de oro es **medir antes de optimizar**. Esta parte enseña esa mentalidad y las herramientas: el **profiler** (CPU, GPU, frame time), el **presupuesto de frame** (16.6 ms para 60 fps, 11.1 ms para 90 en VR) y cómo repartirlo.

Después ataca los cuellos de botella uno a uno: **CPU** (lógica, scripts, llamadas), **GPU** (draw calls, overdraw, fillrate), **memoria** y recolección de basura, **object pooling**, **física** y colisiones, **culling/LOD/streaming** de mundo, optimización de **assets**, **multithreading**, y **tiempos de carga**. Cubre la optimización específica por plataforma y las herramientas nativas (RenderDoc, etc.). El **capstone** toma un proyecto pesado y lo lleva a 60 fps estables.

## 🧩 Problemas que resuelve

- Optimizar "a ciegas" partes que no eran el problema (sin medir).
- Caídas de FPS sin saber si el cuello está en CPU o en GPU.
- Tirones periódicos por recolección de basura o creación de objetos cada frame.
- Escenas grandes que se arrastran por dibujar lo que no se ve (sin culling/LOD).
- Tiempos de carga eternos que espantan al jugador.
- Un juego que va bien en PC pero es injugable en móvil.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Adoptar una metodología de "medir → localizar → optimizar → volver a medir".
- Usar el profiler para separar cuellos de CPU y de GPU.
- Definir y respetar un presupuesto de frame por plataforma.
- Reducir draw calls, overdraw y asignaciones de memoria.
- Aplicar object pooling, culling, LOD y streaming de mundo.
- Optimizar física, assets y tiempos de carga, y usar multithreading con criterio.

## 🧱 Prerrequisitos

- Partes 0 (delta time, debugging/profiling), 2, 4 y 10 en adelante (hay que tener algo que optimizar).
- Godot 4.x; útil RenderDoc para el análisis de GPU.

## 📚 Las 15 clases

| # | Clase |
|---|---|
| 240 | [Mentalidad de rendimiento: medir antes de optimizar](240-mentalidad-de-rendimiento-medir-antes-de-optimizar/README.md) |
| 241 | [El profiler: CPU, GPU y frame time](241-el-profiler-cpu-gpu-y-frame-time/README.md) |
| 242 | [Presupuesto de frame y objetivos de FPS](242-presupuesto-de-frame-y-objetivos-de-fps/README.md) |
| 243 | [Optimización de CPU: lógica, scripts y llamadas](243-optimizacion-de-cpu-logica-scripts-y-llamadas/README.md) |
| 244 | [Optimización de GPU: draw calls, overdraw y fillrate](244-optimizacion-de-gpu-draw-calls-overdraw-y-fillrate/README.md) |
| 245 | [Gestión de memoria y garbage collection](245-gestion-de-memoria-y-garbage-collection/README.md) |
| 246 | [Object pooling y evitar asignaciones](246-object-pooling-y-evitar-asignaciones/README.md) |
| 247 | [Optimización de físicas y colisiones](247-optimizacion-de-fisicas-y-colisiones/README.md) |
| 248 | [Culling, LOD y streaming de mundo](248-culling-lod-y-streaming-de-mundo/README.md) |
| 249 | [Optimización de assets: texturas, mallas y audio](249-optimizacion-de-assets-texturas-mallas-y-audio/README.md) |
| 250 | [Multithreading y trabajos en paralelo](250-multithreading-y-trabajos-en-paralelo/README.md) |
| 251 | [Tiempos de carga y arranque](251-tiempos-de-carga-y-arranque/README.md) |
| 252 | [Optimización por plataforma](252-optimizacion-por-plataforma/README.md) |
| 253 | [Herramientas nativas de profiling (RenderDoc)](253-herramientas-nativas-de-profiling-renderdoc/README.md) |
| 254 | [Capstone Parte 14: optimizar un proyecto a 60 fps](254-capstone-parte-14-optimizar-un-proyecto-a-60-fps/README.md) |

---

> La [Parte 15](../parte-15-herramientas-editores-y-automatizacion/README.md) multiplica tu productividad: construir herramientas y automatizar el flujo de trabajo.
