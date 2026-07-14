# Clase 248 — Culling, LOD y streaming de mundo

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Godot Docs — Optimizing 3D performance y Occlusion culling*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Un mundo grande contiene muchísima más geometría de la que el jugador ve en un instante dado. Dibujar todo, incluso lo que está fuera de cámara o tapado por una pared, desperdicia *draw calls* y tiempo de GPU. La solución es no procesar lo que no aporta: **frustum culling** descarta lo que está fuera del campo de visión, **occlusion culling** descarta lo que está oculto tras otra geometría, el **LOD** (nivel de detalle) sustituye mallas lejanas por versiones más simples, y el **streaming** carga y descarga secciones del mundo según la posición del jugador.

En esta clase configuras estas técnicas con las herramientas nativas de Godot 4: `VisibleOnScreenEnabler2D/3D` para activar nodos solo cuando entran en pantalla, `visibility_range_*` de `GeometryInstance3D` para LOD automático por distancia, `OccluderInstance3D` para culling por oclusión, y `MultiMeshInstance` para dibujar miles de instancias de vegetación en una sola *draw call*. Medirás draw calls, primitivas dibujadas y FPS con `Performance.get_monitor()` antes y después de cada técnica.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir frustum culling de occlusion culling y saber cuándo aplica cada uno.
2. Activar y desactivar nodos con `VisibleOnScreenEnabler2D/3D`.
3. Configurar LOD por distancia con `visibility_range_begin/end`.
4. Reducir geometría con `OccluderInstance3D` y `MultiMeshInstance`.
5. Medir draw calls y primitivas para validar cada optimización.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Frustum culling | Descartar lo fuera de cámara es gratis y automático; hay que aprovecharlo. |
| 2 | Occlusion culling | Lo tapado por paredes no debe dibujarse; ahorra GPU en interiores. |
| 3 | VisibleOnScreenEnabler | Detiene la lógica de nodos fuera de pantalla, no solo el dibujo. |
| 4 | LOD por visibility_range | Mallas lejanas más simples reducen primitivas sin que se note. |
| 5 | MultiMeshInstance | Miles de plantas/rocas en una sola draw call. |
| 6 | Streaming de secciones | Cargar/descargar zonas mantiene la memoria acotada. |
| 7 | Draw calls como métrica | Menos llamadas de dibujo suele ser la mayor ganancia. |
| 8 | Medición con Performance | Cuantificar evita "optimizar" a ciegas. |

## 📖 Definiciones y características

- **Frustum**: pirámide de visión de la cámara. Clave: lo que queda fuera se descarta automáticamente.
- **Occlusion culling**: descartar objetos tapados por geometría más cercana. Clave: en Godot 4 se habilita con `OccluderInstance3D` y bakeando oclusores.
- **`VisibleOnScreenEnabler2D/3D`**: nodo que activa/desactiva a su padre según entre o salga de la pantalla. Clave: apaga procesamiento, física y lógica, no solo el render.
- **LOD (Level of Detail)**: uso de versiones progresivamente más simples de una malla según la distancia. Clave: en Godot 4 `visibility_range_*` cambia entre nodos por distancia.
- **`visibility_range_begin/end`**: distancias en las que un `GeometryInstance3D` aparece y desaparece. Clave: base del LOD manual y del *fade*.
- **`MultiMeshInstance3D`**: dibuja muchas copias de una misma malla en una sola llamada. Clave: ideal para vegetación, escombros y multitudes estáticas.
- **`OccluderInstance3D`**: geometría simple que marca qué tapa a qué. Clave: hay que hornear la oclusión para que surta efecto.
- **Streaming**: cargar y liberar porciones del mundo bajo demanda. Clave: mantiene memoria y draw calls acotados en mapas grandes.

## 🧰 Herramientas y preparación

Usa Godot 4.x en un proyecto 3D (las técnicas de LOD y oclusión son 3D; `VisibleOnScreenEnabler2D` cubre el caso 2D). Crea una escena amplia: un terreno con cientos de objetos (árboles, rocas, edificios) repartidos. Ten a la vista el **Depurador → Monitores** para leer draw calls y primitivas, y consulta las guías de rendimiento 3D (<https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html>) y occlusion culling (<https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html>).

Prepara un `Label` que lea las métricas de render en tiempo real. Estas son tus cifras de referencia para comparar cada técnica:

```gdscript
extends Label

func _process(_delta: float) -> void:
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	var draw := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var prims := Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	text = "FPS %d | draw calls %d | primitivas %d" % [fps, draw, prims]
```

## 🧪 Laboratorio guiado

Aplicarás las técnicas de forma incremental sobre la misma escena, midiendo tras cada una.

**Paso 1 — Línea base.** Con toda la geometría visible y sin optimizar, anota FPS, draw calls y primitivas mirando hacia la zona más poblada.

**Paso 2 — VisibleOnScreenEnabler.** Para objetos con lógica (enemigos, generadores de partículas), añade un `VisibleOnScreenEnabler3D` como hijo y desactiva el procesamiento cuando salen de pantalla:

```gdscript
extends Node3D

@onready var _enabler: VisibleOnScreenEnabler3D = $VisibleOnScreenEnabler3D

func _ready() -> void:
	_enabler.screen_entered.connect(_on_screen_entered)
	_enabler.screen_exited.connect(_on_screen_exited)
	set_process(false)   # arranca inactivo hasta ser visto

func _on_screen_entered() -> void:
	set_process(true)

func _on_screen_exited() -> void:
	set_process(false)   # deja de gastar CPU fuera de cámara
```

**Paso 3 — LOD por visibility_range.** Crea dos versiones de un árbol: `MeshInstance3D` de alto detalle y otra de bajo. Configura los rangos para que se releven por distancia. Por código, sobre cada `GeometryInstance3D`:

```gdscript
func _configurar_lod(alto: GeometryInstance3D, bajo: GeometryInstance3D) -> void:
	# Alto detalle: visible de 0 a 40 m
	alto.visibility_range_begin = 0.0
	alto.visibility_range_end = 40.0
	alto.visibility_range_end_margin = 5.0
	# Bajo detalle: visible de 40 m en adelante
	bajo.visibility_range_begin = 40.0
	bajo.visibility_range_end = 0.0   # 0 = sin límite lejano
	bajo.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
```

Aléjate y observa cómo caen las primitivas al entrar en juego las mallas simples.

**Paso 4 — MultiMeshInstance para vegetación.** Reemplaza cientos de `MeshInstance3D` de hierba por un único `MultiMeshInstance3D`:

```gdscript
extends MultiMeshInstance3D

@export var mesh_hierba: Mesh
@export var cantidad: int = 2000
@export var area: float = 100.0

func _ready() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh_hierba
	mm.instance_count = cantidad
	for i in cantidad:
		var t := Transform3D()
		t.origin = Vector3(randf_range(-area, area), 0.0, randf_range(-area, area))
		mm.set_instance_transform(i, t)
	multimesh = mm   # 2000 matas de hierba en una sola draw call
```

Compara draw calls: 2000 nodos separados generan miles de llamadas; el multimesh, una.

**Paso 5 — Occlusion culling.** Añade un `OccluderInstance3D` cubriendo las paredes/edificios grandes y hornea la oclusión (botón "Bake Occluders" en el editor). Activa "Use Occlusion Culling" en los ajustes de renderizado. Colócate detrás de un muro y verifica que las primitivas de lo oculto desaparecen.

**Paso 6 — Compara.** Consolida en una tabla ANTES/DESPUÉS las tres métricas para: base, +enabler, +LOD, +multimesh, +oclusión. Verás qué técnica aporta más en tu escena concreta.

## ✍️ Ejercicios

1. Añade un tercer nivel de LOD (impostor) para distancias muy lejanas.
2. Usa `VisibleOnScreenEnabler2D` para pausar enemigos de un juego 2D fuera de cámara.
3. Rellena un `MultiMeshInstance3D` con rotaciones y escalas aleatorias por instancia.
4. Mide el impacto de la oclusión mirando hacia y en contra de un muro grande.
5. Ajusta `visibility_range_fade_mode` y describe la diferencia visual entre `SELF` y `DISABLED`.
6. Registra draw calls con y sin multimesh para 500, 1000 y 2000 instancias.

## 📝 Reto verificable

Construye un mundo 3D con al menos 800 objetos (vegetación, props y edificios) y optimízalo combinando `VisibleOnScreenEnabler3D`, LOD por `visibility_range`, `MultiMeshInstance3D` para vegetación y `OccluderInstance3D` horneado. Entrega una tabla ANTES/DESPUÉS con FPS, draw calls y primitivas por técnica acumulada.

**Criterio de aceptación**: la escena optimizada reduce de forma medible las draw calls y las primitivas dibujadas respecto a la base, la vegetación se dibuja mediante multimesh (verificable por la caída de draw calls), y la oclusión elimina primitivas al situar la cámara tras geometría grande. La tabla documenta las tres métricas en cada paso.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El LOD no cambia nada | No configuraste `visibility_range_end` o los rangos se solapan mal. Revisa begin/end de ambas mallas. |
| La oclusión no surte efecto | Olvidaste hornear los oclusores o activar occlusion culling en ajustes de render. |
| Multimesh invisible | No asignaste `mesh` o `instance_count` es 0. Verifica que el `MultiMesh` esté completo. |
| Nodos que "reviven" con estado corrupto | Reactivas con `VisibleOnScreenEnabler` sin reinicializar. Reinicia estado en `screen_entered`. |
| FPS peor tras "optimizar" | Añadiste overhead sin ganancia. Mide: si una técnica no mejora tu escena, quítala. |

## ❓ Preguntas frecuentes

**❓ ¿Frustum culling hay que activarlo?** No, es automático: Godot no dibuja lo que queda fuera del frustum de la cámara. Lo que configuras es lo demás (oclusión, LOD, enablers).

**❓ ¿Cuándo compensa el occlusion culling?** En interiores y ciudades densas, donde mucha geometría queda tapada. En un campo abierto sin obstáculos apenas ayuda.

**❓ ¿MultiMesh sirve para objetos que se mueven?** Puede, actualizando transformaciones por frame, pero brilla con instancias estáticas (vegetación, rocas). Para muchos móviles independientes, evalúa el coste de actualizar el buffer.

**❓ ¿El LOD con `visibility_range` necesita mallas separadas?** Sí: cada nivel es un `GeometryInstance3D` distinto con su rango. También puedes usar el *auto LOD* de importación de mallas para reducir polígonos automáticamente por distancia.

## 🔗 Referencias

- Godot Docs — Optimizing 3D performance: <https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html>
- Godot Docs — Occlusion culling: <https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html>
- Godot Docs — Using MultiMeshInstance: <https://docs.godotengine.org/en/stable/tutorials/3d/using_multi_mesh_instance.html>
- Godot Docs — VisibleOnScreenEnabler3D: <https://docs.godotengine.org/en/stable/classes/class_visibleonscreenenabler3d.html>

## ➡️ Siguiente clase

[Clase 249 - Optimización de assets: texturas, mallas y audio](../249-optimizacion-de-assets-texturas-mallas-y-audio/README.md)
