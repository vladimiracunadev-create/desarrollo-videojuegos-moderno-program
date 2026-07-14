# Parte 15 — Herramientas, editores y automatización (tooling)

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-14-optimizacion-profiling-y-rendimiento/README.md) · [⏭️ Parte siguiente](../parte-16-produccion-publicacion-monetizacion-y-liveops/README.md)

**12 clases** · rango 255–266 · Multiplicar la productividad: scripts de editor, plugins, inspectores personalizados, diseño data-driven, automatización de builds, CI y testing de juegos

**Fuentes de referencia de esta parte:**

- Documentación de [plugins de editor de Godot 4](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/index.html).
- Bryan Bycroft & varios, charlas de GDC sobre *tools programming*.
- Documentación de [GUT (Godot Unit Test)](https://github.com/bitwes/Gut).
- Documentación de [GitHub Actions](https://docs.github.com/actions) para CI de juegos.

---

## 🎯 ¿De qué trata esta parte?

El "tooling" —construir las herramientas con las que se hace el juego— es lo que separa un hobby lento de una producción eficiente. Cada minuto invertido en una buena herramienta se devuelve multiplicado en el resto del equipo y del proyecto. Esta parte enseña a extender el propio editor de Godot y a automatizar todo lo repetitivo. Empieza por el **porqué** de las herramientas propias y los scripts de editor (`@tool`), y avanza a **plugins**, **docks personalizados**, **gizmos** e **inspectores** a medida.

Cubre el **diseño data-driven** (separar datos de código, recursos personalizados y bases de datos de juego, validación), la **automatización de builds** por línea de comandos, la **integración continua (CI)** para juegos, el **control de versiones avanzado** en equipo (Git + LFS), y el **testing automatizado** (GUT, unit tests). Cierra con editores de contenido in-game y un **capstone**: crear una herramienta o plugin de editor realmente útil.

## 🧩 Problemas que resuelve

- Tareas repetitivas hechas a mano una y otra vez (colocar objetos, ajustar datos).
- Diseñadores que dependen de programadores para cualquier cambio de balance.
- Datos de juego dispersos en el código, difíciles de editar y validar.
- Builds manuales, lentas y propensas a errores.
- Bugs que reaparecen porque no hay tests que los detecten.
- Equipos que se pisan el trabajo por un flujo de versiones deficiente.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Escribir scripts de editor (`@tool`) y plugins con docks e inspectores propios.
- Diseñar sistemas data-driven con recursos personalizados y validación.
- Automatizar builds y exportaciones por línea de comandos.
- Montar integración continua (CI) para un proyecto de juego.
- Aplicar un flujo de Git + LFS robusto para equipos.
- Escribir tests automatizados con GUT y prevenir regresiones.

## 🧱 Prerrequisitos

- Partes 0 (Git + LFS, C#/GDScript) y experiencia con Godot de las partes anteriores.
- Godot 4.x; una cuenta de GitHub para la CI.

## 📚 Las 12 clases

| # | Clase |
|---|---|
| 255 | [Por qué construir herramientas propias](255-por-que-construir-herramientas-propias/README.md) |
| 256 | [Scripts de editor (@tool) en Godot](256-scripts-de-editor-tool-en-godot/README.md) |
| 257 | [Plugins de editor y docks personalizados](257-plugins-de-editor-y-docks-personalizados/README.md) |
| 258 | [Gizmos e inspectores personalizados](258-gizmos-e-inspectores-personalizados/README.md) |
| 259 | [Generación y validación de datos (data-driven)](259-generacion-y-validacion-de-datos-data-driven/README.md) |
| 260 | [Recursos personalizados y bases de datos de juego](260-recursos-personalizados-y-bases-de-datos-de-juego/README.md) |
| 261 | [Automatización de builds y exportación por CLI](261-automatizacion-de-builds-y-exportacion-por-cli/README.md) |
| 262 | [Integración continua (CI) para juegos](262-integracion-continua-ci-para-juegos/README.md) |
| 263 | [Control de versiones avanzado para equipos](263-control-de-versiones-avanzado-para-equipos/README.md) |
| 264 | [Testing automatizado de juegos (GUT)](264-testing-automatizado-de-juegos-gut/README.md) |
| 265 | [Editores de niveles y contenido in-game](265-editores-de-niveles-y-contenido-in-game/README.md) |
| 266 | [Capstone Parte 15: una herramienta o plugin de editor](266-capstone-parte-15-una-herramienta-o-plugin-de-editor/README.md) |

---

> Con el proyecto y el equipo afinados, la [Parte 16](../parte-16-produccion-publicacion-monetizacion-y-liveops/README.md) lo convierte en producto: producción, publicación y LiveOps.
