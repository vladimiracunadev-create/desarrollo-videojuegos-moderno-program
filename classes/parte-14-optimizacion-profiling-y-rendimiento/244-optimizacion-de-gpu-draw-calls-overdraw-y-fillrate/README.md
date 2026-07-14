# Clase 244 — Optimización de GPU: draw calls, overdraw y fillrate

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (GPU optimization / Using MultiMesh)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Atacar el lado **GPU** del rendimiento. Cuando el juego es GPU-bound, la CPU espera y el cuello está en cuántas veces le pedimos a la tarjeta que dibuje (**draw calls**), en cuántos píxeles se repintan de más (**overdraw** por transparencias), en el coste de rellenar la pantalla (**fillrate**) y en el tamaño de las texturas. Cada objeto dibujado por separado es una orden que la CPU envía a la GPU; miles de objetos pequeños generan miles de órdenes y saturan el envío antes que la propia potencia gráfica.

La palanca estrella de esta clase es el **batching** con **`MultiMeshInstance2D` / `MultiMeshInstance3D`**: dibujar miles de copias de la misma malla en una sola llamada. También veremos el **overdraw** que provocan las transparencias apiladas, el impacto del **tamaño de textura**, y el papel del **MSAA**. Medimos todo con el monitor `RENDER_TOTAL_DRAW_CALLS_IN_FRAME` y con el FPS, antes y después.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es una draw call y por qué su número limita el rendimiento GPU.
2. Sustituir cientos de nodos por un `MultiMeshInstance` y medir la caída de draw calls.
3. Identificar overdraw causado por transparencias apiladas y reducirlo.
4. Relacionar tamaño de textura y fillrate con el coste de rellenar la pantalla.
5. Configurar MSAA y evaluar su impacto en calidad frente a coste.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Draw call | Cada una es una orden CPU→GPU con coste fijo. |
| 2 | Batching | Agrupa dibujos para reducir el número de órdenes. |
| 3 | MultiMesh | Dibuja miles de instancias en una sola llamada. |
| 4 | Overdraw | Píxeles repintados varias veces por transparencias. |
| 5 | Fillrate | Coste de escribir píxeles; escala con la resolución. |
| 6 | Tamaño de textura | Texturas grandes gastan memoria y ancho de banda. |
| 7 | Transparencias y orden | El alpha impide descartes y encarece el render. |
| 8 | MSAA | Suaviza bordes con un coste de fillrate. |

## 📖 Definiciones y características

- **Draw call**: orden de dibujo que la CPU envía a la GPU. Clave: su número, no solo los polígonos, limita el frame.
- **Batching**: fusionar varios dibujos en uno. Clave: reduce el coste fijo por llamada.
- **MultiMesh**: recurso que representa muchas instancias de una malla con transformadas propias. Clave: una sola draw call para todas.
- **`MultiMeshInstance2D/3D`**: nodo que renderiza un `MultiMesh`. Clave: sustituye a cientos de nodos individuales.
- **Overdraw**: repintar el mismo píxel varias veces en un frame. Clave: lo disparan las transparencias solapadas.
- **Fillrate**: cantidad de píxeles que la GPU puede escribir por segundo. Clave: a más resolución y overdraw, más presión.
- **Tamaño de textura**: dimensiones en píxeles de una imagen. Clave: potencias de dos y mipmaps ayudan al muestreo.
- **MSAA**: antialiasing por multimuestreo. Clave: mejora bordes a costa de fillrate; se ajusta en Project Settings.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**. Mediremos con el monitor **RENDER_TOTAL_DRAW_CALLS_IN_FRAME** vía `Performance.get_monitor()` y con **Monitors → Draw Calls** en el Debugger, además del FPS. El MSAA está en **Project Settings → Rendering → Anti Aliasing**. Para el laboratorio 2D usaremos un `QuadMesh` como malla de las instancias.

Consulta la guía "Optimizing 3D performance" y la referencia de MultiMesh: <https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html> y <https://docs.godotengine.org/en/stable/classes/class_multimesh.html>. Para 2D y renderizado en general: <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>.

## 🧪 Laboratorio guiado

Vamos a **reducir draw calls sustituyendo cientos de nodos por un `MultiMeshInstance2D`** y a medir la diferencia en el monitor de draw calls y en FPS.

1. Primero la **versión CARA**: crea un `Node2D` raíz `Escena` con un `Label` y este script que instancia 2000 `Sprite2D` independientes. Cada uno genera su propia draw call:

```gdscript
extends Node2D

@onready var _label: Label = $Label

func _ready() -> void:
	var tex: Texture2D = preload("res://icon.svg")
	for i in 2000:
		var s := Sprite2D.new()
		s.texture = tex
		s.position = Vector2(randf() * 1000.0, randf() * 600.0)
		s.scale = Vector2(0.1, 0.1)
		add_child(s)

func _process(_delta: float) -> void:
	var dc: int = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var fps: float = Performance.get_monitor(Performance.TIME_FPS)
	_label.text = "Sprites sueltos | draw calls=%d | FPS=%.0f" % [dc, fps]
```

2. Ejecuta con **F5** y anota **draw calls** y **FPS**. **ANTES**: verás un número de draw calls elevado (aunque Godot 2D hace algo de batching, la carga es notable) y el FPS afectado en hardware modesto.

3. Ahora la **versión BARATA** con `MultiMeshInstance2D`: una sola malla, 2000 instancias, **una** draw call. Crea un nuevo `Node2D` raíz y adjunta:

```gdscript
extends Node2D

@onready var _label: Label = $Label

func _ready() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_2D
	var quad := QuadMesh.new()
	quad.size = Vector2(32, 32)
	mm.mesh = quad
	mm.instance_count = 2000
	for i in mm.instance_count:
		var t := Transform2D()
		t.origin = Vector2(randf() * 1000.0, randf() * 600.0)
		mm.set_instance_transform_2d(i, t)

	var mmi := MultiMeshInstance2D.new()
	mmi.multimesh = mm
	mmi.texture = preload("res://icon.svg")
	add_child(mmi)

func _process(_delta: float) -> void:
	var dc: int = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var fps: float = Performance.get_monitor(Performance.TIME_FPS)
	_label.text = "MultiMesh | draw calls=%d | FPS=%.0f" % [dc, fps]
```

4. Ejecuta y compara. **DESPUÉS**: las 2000 instancias colapsan a esencialmente **una** draw call adicional, y el FPS sube. Abre **Monitors → Draw Calls** para ver el desplome en la gráfica al cambiar de escena.

5. Demuestra el **overdraw**. Añade sobre la escena varios `ColorRect` grandes semitransparentes (alpha ~0.3) solapados y observa cómo el FPS cae aunque las draw calls sean pocas: la GPU repinta los mismos píxeles muchas veces. Reduce el solape o el alpha y verás recuperarse el fillrate.

6. Ajusta el **MSAA** en **Project Settings → Rendering → Anti Aliasing → MSAA 2D/3D**: sube a 4x y observa en el monitor cómo el frame time crece por el mayor coste de fillrate; bájalo y compara calidad de bordes frente a coste.

Observable: la misma cantidad de objetos pasa de muchas draw calls a prácticamente una con MultiMesh, y el overdraw demuestra que "pocas draw calls" no basta si repintas la pantalla varias veces.

## ✍️ Ejercicios

1. Escala el número de instancias (500, 2000, 10000) y grafica draw calls y FPS en cada caso para ambas versiones.
2. Sustituye la textura por una mucho más grande y mide el impacto en memoria y fillrate.
3. Crea una capa de partículas transparentes solapadas y cuantifica la caída por overdraw.
4. Anima las instancias del MultiMesh actualizando sus transformadas y mide el coste de la actualización.
5. Compara MSAA 2x, 4x y 8x en frame time y describe el punto de rendimientos decrecientes.
6. Convierte un tileset de cientos de sprites repetidos a un MultiMesh y reporta la reducción de draw calls.

## 📝 Reto verificable

Toma una escena con al menos 1000 objetos visuales idénticos dibujados como nodos individuales. Reescríbela usando `MultiMeshInstance2D` o `MultiMeshInstance3D`. Entrega una comparativa medida del monitor de draw calls y del FPS antes y después, más una nota sobre si detectaste overdraw y cómo lo mitigaste.

**Criterio de aceptación**: la versión con MultiMesh reduce drásticamente el número de draw calls (de cientos/miles a un puñado) manteniendo el mismo resultado visual, y la comparativa lo demuestra con lecturas de `RENDER_TOTAL_DRAW_CALLS_IN_FRAME`.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Miles de nodos idénticos y FPS bajo | Cada nodo es una draw call. Agrúpalos en un `MultiMeshInstance`. |
| FPS bajo con pocas draw calls | Overdraw por transparencias apiladas. Reduce solape, alpha o número de capas. |
| MultiMesh no muestra nada | Falta asignar `mesh`, `instance_count` o las transformadas. Verifica que cada instancia tenga transform. |
| Caída de FPS al subir la resolución | Presión de fillrate. Baja MSAA o el tamaño de las texturas de pantalla completa. |
| Memoria de vídeo desbordada | Texturas enormes o sin mipmaps. Usa tamaños razonables (potencias de dos) y comprime. |

## ❓ Preguntas frecuentes

**❓ ¿Godot 2D no hace batching solo?** Hace cierto batching automático, pero objetos con distintos materiales o texturas rompen el lote. MultiMesh garantiza una sola llamada para instancias idénticas.

**❓ ¿MultiMesh sirve para objetos que se mueven?** Sí. Puedes actualizar cada transformada con `set_instance_transform_2d/3d`; el coste está en la actualización, no en dibujarlos.

**❓ ¿El overdraw depende del número de draw calls?** No directamente. Depende de cuántas veces se repinta cada píxel; las transparencias grandes lo disparan aunque haya una sola draw call.

**❓ ¿MSAA siempre conviene?** Mejora los bordes pero cuesta fillrate. En móviles o a resoluciones altas puede no compensar; evalúa 2x frente a 4x según tu presupuesto de frame.

## 🔗 Referencias

- Godot Docs — Using MultiMesh: <https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html>
- Godot Docs — MultiMesh (clase): <https://docs.godotengine.org/en/stable/classes/class_multimesh.html>
- Godot Docs — General optimization tips: <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>
- Godot Docs — 3D rendering limitations / anti-aliasing: <https://docs.godotengine.org/en/stable/tutorials/3d/3d_antialiasing.html>

## ➡️ Siguiente clase

[Clase 245 - Gestión de memoria y garbage collection](../245-gestion-de-memoria-y-garbage-collection/README.md)
