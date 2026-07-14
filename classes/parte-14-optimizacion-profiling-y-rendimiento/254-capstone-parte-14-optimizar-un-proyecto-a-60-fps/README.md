# Clase 254 — Capstone Parte 14: optimizar un proyecto a 60 fps

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de optimización de Godot 4 y método "medir → localizar → optimizar → remedir"*
> ⏱️ Duración estimada: **120 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Este capstone integra toda la Parte 14 en un ejercicio realista: partes de un proyecto pesado que corre a **20-30 fps** (demasiados nodos, luces con sombra, física exagerada, instancias creadas cada frame) y tu misión es llevarlo a **60 fps estables** aplicando el método completo: **medir → localizar → optimizar → remedir**. No se trata de tocar ajustes al azar, sino de documentar cada mejora con su medición antes/después, para demostrar que cada cambio tuvo efecto y sobre qué recurso.

Recorrerás las técnicas de la parte en orden de impacto: primero mides con el profiler y los monitores para saber si el cuello es CPU o GPU; luego atacas lo que domine el frame con **object pooling** (dejar de instanciar cada frame), **culling y LOD** (no dibujar lo invisible), reducción de **draw calls**, ajuste de **física** (ticks y capas de colisión) y optimización de **assets**. El entregable es un proyecto a 60 fps con una tabla de mediciones que justifica cada decisión.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Aplicar el ciclo medir → localizar → optimizar → remedir de forma disciplinada.
2. Diagnosticar con `Performance.get_monitor` y `Time.get_ticks_usec` si el cuello es CPU o GPU.
3. Aplicar pooling, culling/LOD y reducción de draw calls sobre un proyecto real.
4. Ajustar la física (`physics_ticks_per_second`, capas) para bajar su coste.
5. Documentar cada optimización con su medición antes/después y cumplir una Definition of Done por métricas.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Método de optimización | Sin método optimizas a ciegas y rompes cosas. |
| 2 | Línea base de medición | Sin un antes no puedes probar el después. |
| 3 | Localizar el cuello (CPU/GPU) | Determina qué técnica aplicar primero. |
| 4 | Object pooling | Evita el coste y los tirones de instanciar cada frame. |
| 5 | Culling y LOD | No pagar por lo que no se ve o está lejos. |
| 6 | Reducción de draw calls | Menos llamadas alivian CPU y GPU. |
| 7 | Optimización de física | Ticks y capas correctas ahorran mucho CPU. |
| 8 | Definition of Done por métricas | Objetivo claro y verificable, no una sensación. |

## 📖 Definiciones y características

- **Línea base (baseline)**: medición inicial antes de tocar nada. Clave: es la referencia contra la que se compara toda mejora.
- **Cuello de botella**: el recurso que limita el frame (CPU o GPU). Clave: optimizar otra cosa no sube los FPS.
- **Object pooling**: reutilizar objetos de un depósito en vez de crearlos y destruirlos. Clave: elimina asignaciones y tirones periódicos.
- **Culling**: descartar objetos fuera de cámara antes de dibujarlos. Clave: el frustum culling de Godot es automático, pero puedes ayudar con visibilidad y oclusión.
- **LOD (Level of Detail)**: usar mallas más simples a distancia. Clave: reduce triángulos y draw calls sin pérdida visible.
- **`physics_ticks_per_second`**: frecuencia del paso fijo de física. Clave: bajarla de 60 a 30 puede ahorrar CPU si el juego lo tolera.
- **Presupuesto de frame**: 16.6 ms para 60 fps. Clave: cada sistema debe caber dentro de su porción del presupuesto.
- **Definition of Done (DoD)**: criterios objetivos que declaran el trabajo terminado. Clave: "60 fps estables" con métricas, no "va más fluido".

## 🧰 Herramientas y preparación

Necesitas Godot 4.x y un proyecto pesado de partida (puedes construir uno: una escena con 800-1500 `MeshInstance3D`, varias `OmniLight3D` con sombra, decenas de `RigidBody3D` colisionando y un spawner que instancia proyectiles cada frame). Trabajarás con el **profiler** (Depurar → Profiler), el panel de **Monitores** (FPS, tiempo de frame, draw calls, memoria) y, para el análisis de GPU, **RenderDoc** (<https://renderdoc.org/>) visto en la clase anterior. Ten una hoja o tabla para registrar las mediciones antes/después de cada cambio.

Documentación de apoyo: guía general de optimización en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>, uso de servidores y multithreading en <https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html> y la clase `Performance` en <https://docs.godotengine.org/en/stable/classes/class_performance.html>.

## 🧪 Laboratorio guiado

Optimizaremos el proyecto pesado paso a paso, midiendo antes y después de cada cambio.

1. **Medir (línea base).** Crea un autoload `medidor.gd` que registre FPS y tiempo de frame promedio, y contadores de render. Déjalo activo durante todo el capstone:

```gdscript
extends Node

var _acum_ms: float = 0.0
var _frames: int = 0

func _process(_delta: float) -> void:
	_acum_ms += Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	_frames += 1
	if _frames >= 60:  # promediamos cada 60 frames para una lectura estable
		var promedio := _acum_ms / _frames
		print("FPS: %d | frame CPU: %.2f ms | draw calls: %d" % [
			Engine.get_frames_per_second(),
			promedio,
			Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)])
		_acum_ms = 0.0
		_frames = 0
```

Ejecuta y anota la línea base: por ejemplo `FPS: 24 | frame CPU: 41.2 ms | draw calls: 1820`.

2. **Localizar.** Decide si el cuello es CPU o GPU. Si el tiempo de proceso (CPU) es alto, el problema está en scripts/física; si la CPU es baja pero los FPS también, el cuello es GPU. Usa una medición puntual precisa con `Time.get_ticks_usec` alrededor del sistema sospechoso:

```gdscript
func _medir_bloque(nombre: String, callable: Callable) -> void:
	var inicio := Time.get_ticks_usec()
	callable.call()
	var us := Time.get_ticks_usec() - inicio
	print("%s tardo %.3f ms" % [nombre, us / 1000.0])
```

3. **Optimizar: pooling.** Si un spawner instancia proyectiles cada frame, reemplázalo por un pool. Crea las instancias una vez y reúsalas:

```gdscript
extends Node3D

@export var escena_proyectil: PackedScene
@export var tamano_pool: int = 200

var _pool: Array[Node3D] = []
var _siguiente: int = 0

func _ready() -> void:
	# Instanciamos TODO una vez, al arrancar, no cada frame.
	for i in tamano_pool:
		var p := escena_proyectil.instantiate() as Node3D
		p.visible = false
		p.set_process(false)
		add_child(p)
		_pool.append(p)

func disparar(origen: Vector3, direccion: Vector3) -> void:
	# Reutilizamos el siguiente proyectil libre (buffer circular).
	var p := _pool[_siguiente]
	_siguiente = (_siguiente + 1) % _pool.size()
	p.global_position = origen
	p.visible = true
	p.set_process(true)
	# ... asignar velocidad segun direccion ...
```

Remide: las asignaciones por frame y los tirones deben desaparecer. Anota el nuevo FPS.

4. **Optimizar: física.** Si hay muchos `RigidBody3D`, revisa las **capas y máscaras de colisión** para que solo colisione lo que debe, y baja los ticks si el juego lo tolera:

```gdscript
func _ready() -> void:
	# 30 ticks/seg en vez de 60: la mitad de coste de fisica si el juego aguanta.
	Engine.physics_ticks_per_second = 30
```

Remide tras el cambio y comprueba que la jugabilidad no se resiente.

5. **Optimizar: draw calls y culling.** Si el cuello es GPU, agrupa mallas estáticas (usa `MultiMeshInstance3D` para miles de copias iguales) y activa `VisibleOnScreenNotifier3D` o rangos de visibilidad (LOD) para no procesar lo lejano:

```gdscript
func _configurar_lod(malla: GeometryInstance3D, distancia: float) -> void:
	# A partir de "distancia", la malla deja de renderizarse.
	malla.visibility_range_end = distancia
	malla.visibility_range_end_margin = 5.0
```

Convierte un bosque de 1000 árboles idénticos a `MultiMesh` y observa cómo las draw calls caen de cientos a una. Remide.

6. **Optimizar: sombras y luces.** Desactiva la sombra de las luces secundarias y reduce el tamaño del atlas de sombras; las sombras suelen ser lo más caro de la GPU. Remide.

7. **Remedir y documentar.** Tras cada cambio ya anotaste el antes/después. Reúnelo en una tabla como esta, que es el corazón del entregable:

| Cambio | FPS antes | FPS después | Nota |
|--------|-----------|-------------|------|
| Baseline | 24 | — | Punto de partida |
| Pooling de proyectiles | 24 | 33 | Se van los tirones |
| Física a 30 ticks + capas | 33 | 41 | CPU baja |
| MultiMesh + LOD árboles | 41 | 55 | Draw calls 1820→260 |
| Sombras solo en luz principal | 55 | 62 | GPU respira |

8. Verifica la Definition of Done: **60 fps estables** (sin caídas bajo 58) durante el peor caso jugable, con la tabla de mediciones completa. Si aún no llegas, vuelve al paso 2: mide de nuevo, localiza el nuevo cuello y repite. El método es cíclico.

## ✍️ Ejercicios

1. Añade a la tabla el tiempo de CPU en ms (no solo FPS) para cada fila, y explica qué cambios afectaron a CPU y cuáles a GPU.
2. Sustituye el pool de tamaño fijo por uno que crezca si se agota, y mide si el crecimiento provoca tirones.
3. Aplica `VisibleOnScreenNotifier3D` para desactivar el `_process` de enemigos fuera de cámara y mide el ahorro de CPU.
4. Convierte tres grupos de objetos repetidos a `MultiMeshInstance3D` y documenta la caída de draw calls con los monitores.
5. Prueba `physics_ticks_per_second` a 30 y a 60 e interpola el movimiento; compara suavidad y coste.
6. Captura un frame con RenderDoc antes y después del capstone y adjunta el conteo de draw calls de ambos.

## 📝 Reto verificable

Entrega el proyecto optimizado junto con un informe que incluya: la línea base medida, la localización del cuello en cada iteración (CPU o GPU con evidencia), cada optimización aplicada con su medición antes/después, y la tabla resumen. El proyecto debe correr a 60 fps estables en el escenario de peor caso.

**Criterio de aceptación**: en el peor caso jugable, `Engine.get_frames_per_second()` se mantiene en 60 sin bajar de 58 de forma sostenida; el tiempo de frame de CPU cabe en el presupuesto de 16.6 ms; la tabla documenta al menos cuatro optimizaciones con su antes/después medido; y las draw calls se reducen respecto a la línea base de forma verificable en los monitores.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Optimizas y los FPS no suben | Atacaste algo que no era el cuello. Vuelve a medir y localiza CPU vs. GPU antes de tocar. |
| Sube el FPS pero aparecen tirones | Sigues instanciando en momentos puntuales. Precalienta el pool en `_ready`. |
| La física se siente rara a 30 ticks | Falta interpolación visual. Activa `physics_interpolation` o interpola en `_process`. |
| MultiMesh no muestra nada | No asignaste `instance_count` ni las transformaciones de cada instancia. |
| Los objetos lejanos desaparecen de golpe | El margen de LOD es muy corto. Aumenta `visibility_range_end_margin`. |
| "Mejora" sin datos que la respalden | No mediste el antes. Sin baseline no hay optimización demostrable, solo una sensación. |

## ❓ Preguntas frecuentes

**❓ ¿Por dónde empiezo si todo va lento?** Mide primero. Localiza si el cuello es CPU o GPU y ataca solo eso. Optimizar sin medir suele empeorar la mantenibilidad sin subir los FPS.

**❓ ¿60 fps estables significa que nunca baja?** Significa que en el peor caso jugable no cae de forma perceptible (bajo ~58). Picos aislados de un frame son tolerables; caídas sostenidas no.

**❓ ¿Bajar la física a 30 ticks se nota?** Puede notarse si no interpolas el movimiento visual. Con interpolación, 30 ticks es indistinguible en muchos juegos y ahorra la mitad del coste de física.

**❓ ¿Cuándo dejo de optimizar?** Cuando cumples la Definition of Done por métricas. Optimizar más allá del objetivo gasta tiempo que rinde más en contenido o pulido.

## 🔗 Referencias

- Godot Docs — Performance (índice de optimización): <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Using servers y multithreading: <https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html>
- Godot Docs — MultiMeshInstance3D: <https://docs.godotengine.org/en/stable/classes/class_multimeshinstance3d.html>
- Godot Docs — clase Performance (monitores): <https://docs.godotengine.org/en/stable/classes/class_performance.html>

## ➡️ Siguiente clase

[Clase 255 - Por qué construir herramientas propias](../../parte-15-herramientas-editores-y-automatizacion/255-por-que-construir-herramientas-propias/README.md)
