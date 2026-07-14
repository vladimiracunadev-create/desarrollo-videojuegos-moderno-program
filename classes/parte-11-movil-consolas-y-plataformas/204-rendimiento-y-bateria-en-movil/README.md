# Clase 204 — Rendimiento y batería en móvil

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Optimization, Renderers)*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un móvil no es un PC en miniatura: tiene menos GPU, menos ancho de banda de memoria, se calienta y funciona con batería. Un juego que va a 120 FPS en tu equipo puede quemar la batería, calentar el teléfono hasta el **throttling térmico** y caer a tirones. En Godot 4 la primera decisión es el **renderer** (Mobile o Compatibility), y luego vienen la **compresión de texturas** (ETC2/ASTC), los límites de draw calls, luces y sombras, y un **cap de FPS** que ahorra energía.

En esta clase configuramos un proyecto para móvil de forma responsable: elegimos renderer, ajustamos compresión de texturas por plataforma, limitamos el trabajo de GPU y fijamos un framerate razonable. Medimos con el monitor de rendimiento y verificamos que bajamos el consumo sin arruinar la experiencia.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Elegir entre los renderers Mobile y Compatibility según el hardware objetivo.
2. Configurar compresión de texturas (ETC2/ASTC) adecuada para móvil.
3. Limitar draw calls, luces y sombras dentro de un presupuesto de GPU.
4. Fijar un cap de FPS para ahorrar batería y controlar el throttling térmico.
5. Medir rendimiento con el monitor de Godot y decidir optimizaciones.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Renderer Mobile | Optimizado para GPUs de teléfono. |
| 2 | Renderer Compatibility | Máxima compatibilidad (GLES3/WebGL). |
| 3 | Compresión de texturas | ETC2/ASTC reducen memoria y ancho de banda. |
| 4 | Draw calls y batching | Menos llamadas, más FPS. |
| 5 | Luces y sombras | Costosas en móvil; hay que limitarlas. |
| 6 | Cap de FPS | Menos frames = menos batería y calor. |
| 7 | Throttling térmico | El calor baja el rendimiento sostenido. |
| 8 | Monitor de rendimiento | Medir antes de optimizar. |

## 📖 Definiciones y características

- **Renderer Mobile**: backend Vulkan simplificado para móvil. Clave: buen equilibrio calidad/rendimiento en teléfonos modernos.
- **Renderer Compatibility**: backend OpenGL/WebGL. Clave: corre en hardware antiguo y en web, con menos features avanzadas.
- **ETC2**: formato de compresión estándar en Android/OpenGL ES 3. Clave: reduce memoria de textura manteniendo compatibilidad amplia.
- **ASTC**: compresión moderna de mayor calidad/ratio. Clave: preferible en GPUs recientes (móviles actuales, iOS).
- **Draw call**: orden de dibujo a la GPU. Clave: muchas llaman por frame hunden los FPS; conviene agrupar (batch).
- **Cap de FPS**: límite de fotogramas por segundo (`Engine.max_fps`). Clave: 30-60 basta y ahorra batería.
- **Throttling térmico**: el sistema baja frecuencias al calentarse. Clave: un pico de FPS sostenido provoca caídas peores después.
- **Monitor de rendimiento**: panel Debugger → Monitors con FPS, memoria y draw calls. Clave: base para optimizar con datos.

## 🧰 Herramientas y preparación

Necesitas tu proyecto y, para medir de verdad, un dispositivo Android exportado (clase 201): el rendimiento en PC no representa al móvil. En el editor usarás **Debugger → Monitors** para ver FPS, memoria de vídeo y draw calls, y el **Project Settings → Rendering** para renderer y calidad. La compresión de texturas se ajusta por textura en el **Import dock** o globalmente en Project Settings.

Consulta la guía de optimización de Godot en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html> y la comparación de renderers en <https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html>. Para importación de texturas, revisa el Import dock en <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>.

## 🧪 Laboratorio guiado

Configuraremos el proyecto para móvil, mediremos y reduciremos el consumo.

1. Cambia el **renderer**: en **Project → Project Settings → Rendering → Renderer**, selecciona **Mobile** (o **Compatibility** si apuntas a hardware muy antiguo o a web). Godot pedirá reiniciar; hazlo.

2. Fija un **cap de FPS** para ahorrar batería. En un script autoload o `_ready` del nodo raíz:

```gdscript
extends Node

func _ready() -> void:
	# 60 en menús rápidos; 30 si quieres máximo ahorro de batería.
	Engine.max_fps = 60
	# Alternativa: activar V-Sync para no renderizar de más.
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
```

3. Configura **compresión de texturas**. En Project Settings → Rendering → Textures activa la compresión VRAM y prefiere **ETC2/ASTC** para móvil. Por textura, en el **Import dock** elige **Compress Mode: VRAM Compressed** y reimporta.

4. Añade un **monitor en pantalla** para leer FPS y draw calls en el propio dispositivo:

```gdscript
extends Label

func _process(_delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()
	var draw_calls: int = Performance.get_monitor(
		Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var vram: float = Performance.get_monitor(
		Performance.RENDER_VIDEO_MEM_USED) / (1024.0 * 1024.0)
	text = "FPS: %d  Draw calls: %d  VRAM: %.1f MB" % [fps, draw_calls, vram]
```

5. **Limita luces y sombras**: en móvil, reduce el número de luces dinámicas y desactiva sombras donde no aporten. En cada `Light2D`/`Light3D` innecesario, apaga `shadow_enabled`. Prefiere luz horneada o `CanvasModulate` para ambiente en 2D.

6. **Reduce draw calls**: agrupa sprites con el mismo `Texture`/material, usa atlas de texturas y `MultiMeshInstance` para muchos objetos iguales. Observa cómo baja el contador de draw calls en el monitor.

7. **Mide antes y después**: exporta a Android, corre una escena representativa 2-3 minutos y anota FPS medio, draw calls y si el teléfono se calienta. Aplica un cambio (por ejemplo bajar FPS a 30 o comprimir texturas) y vuelve a medir.

8. Documenta la comparación: "antes 58 FPS, 320 draw calls, teléfono caliente a los 5 min; después 30 FPS estables, 180 draw calls, temperatura estable". Esa evidencia justifica tus ajustes.

Con esto el proyecto corre dentro de un presupuesto móvil sano, con menos calor y mejor autonomía.

## ✍️ Ejercicios

1. Compara FPS y draw calls con renderer Mobile vs Compatibility en la misma escena.
2. Baja `Engine.max_fps` de 60 a 30 y describe el efecto en fluidez y (si mides) batería.
3. Convierte tres texturas a VRAM Compressed y anota la reducción de VRAM en el monitor.
4. Desactiva las sombras de una luz y mide la diferencia en draw calls/FPS.
5. Sustituye 200 sprites individuales por un `MultiMeshInstance2D` y compara draw calls.
6. Activa y desactiva V-Sync y explica su efecto en consumo y tearing.

## 📝 Reto verificable

Configura tu juego para móvil (renderer Mobile o Compatibility, compresión de texturas VRAM y un cap de FPS) y demuestra con el **monitor de rendimiento** una mejora medible: presenta cifras de FPS, draw calls y VRAM **antes y después** de tus ajustes, sobre la misma escena.

**Criterio de aceptación**: el proyecto usa un renderer apropiado para móvil, al menos las texturas principales están en VRAM Compressed (ETC2/ASTC), hay un `Engine.max_fps` fijado, y entregas una tabla o captura con métricas antes/después que muestre reducción de draw calls o VRAM y FPS estables dentro del cap. Idealmente medido en un dispositivo real.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| FPS altos pero el teléfono se calienta y luego cae | Sin cap de FPS. Fija `Engine.max_fps = 30/60` o activa V-Sync. |
| Texturas ocupan mucha VRAM | Import sin compresión. Usa VRAM Compressed (ETC2/ASTC) y reimporta. |
| Muchos draw calls y bajones | Sprites/materiales sin agrupar. Usa atlas, mismo material y MultiMesh. |
| Sombras destrozan el rendimiento | Demasiadas luces con sombra en móvil. Desactiva sombras no esenciales o hornéalas. |
| Forward+ no arranca en el móvil | Ese renderer no es para móvil. Cambia a Mobile o Compatibility. |
| El monitor marca cero draw calls | Estás midiendo una escena vacía o pausada. Mide una escena de juego real. |

## ❓ Preguntas frecuentes

**❓ ¿Mobile o Compatibility?** Mobile (Vulkan) da mejor calidad en teléfonos modernos; Compatibility (OpenGL) llega a hardware antiguo y a web, con menos efectos avanzados. Elige según tu público objetivo.

**❓ ¿ETC2 o ASTC?** ASTC ofrece mejor calidad/ratio en GPUs recientes; ETC2 es el estándar seguro y ampliamente compatible en Android. Muchos proyectos usan ASTC como preferido con ETC2 de respaldo.

**❓ ¿Por qué limitar los FPS si el móvil da más?** Renderizar de más gasta batería y genera calor, que provoca throttling y tirones. Un cap estable (30/60) da mejor experiencia sostenida.

**❓ ¿Debo optimizar antes de medir?** No: mide primero con el monitor para saber dónde está el cuello de botella (GPU, draw calls, memoria) y optimiza eso. Optimizar a ciegas suele malgastar esfuerzo.

## 🔗 Referencias

- Godot Docs — Performance and optimization: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Renderers (Forward+, Mobile, Compatibility): <https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html>
- Godot Docs — Importing images y compresión: <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>
- Godot Docs — The Performance class y monitores: <https://docs.godotengine.org/en/stable/classes/class_performance.html>

## ➡️ Siguiente clase

[Clase 205 - Resoluciones, notch y safe areas](../205-resoluciones-notch-y-safe-areas/README.md)
