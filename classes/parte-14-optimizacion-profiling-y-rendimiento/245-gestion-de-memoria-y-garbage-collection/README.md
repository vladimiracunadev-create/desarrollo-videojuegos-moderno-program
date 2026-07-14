# Clase 245 — Gestión de memoria y garbage collection

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Memory management / RefCounted) y Jason Gregory, "Game Engine Architecture"*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Entender cómo gestiona la memoria Godot 4 y por qué eso importa para el rendimiento. A diferencia de motores con recolector de basura tradicional (como C# o Java), GDScript usa **conteo de referencias**: los objetos que heredan de `RefCounted` se liberan automáticamente en cuanto nadie los referencia, sin pausas de "stop the world". Esto es una ventaja —no hay tirones impredecibles del GC— pero traslada al programador la responsabilidad de no crear objetos a lo loco y de no dejar **ciclos de referencia** que impidan la liberación.

En esta clase distinguimos **memoria estática vs dinámica**, vemos cómo el conteo de referencias libera un objeto al llegar a cero, aprendemos a detectar **picos de memoria** provocados por crear objetos cada frame, e identificamos **fugas** (leaks) y **ciclos** que crecen sin fin. Todo se observa con el monitor `MEMORY_STATIC` y las métricas de objetos, midiendo antes y después de corregir el patrón dañino.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar la diferencia entre memoria estática y dinámica en el contexto de Godot.
2. Describir cómo el conteo de referencias de `RefCounted` libera objetos al llegar a cero.
3. Detectar un pico de memoria causado por crear objetos cada frame con `MEMORY_STATIC`.
4. Identificar un ciclo de referencia y romperlo con referencias débiles o rediseño.
5. Reducir asignaciones por frame reutilizando objetos y usando `preload`.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Memoria estática vs dinámica | Distinguir lo persistente de lo que se asigna en runtime. |
| 2 | Conteo de referencias (`RefCounted`) | Es el mecanismo de liberación de GDScript. |
| 3 | `Object` vs `RefCounted` | Uno se libera solo; el otro exige `free()` manual. |
| 4 | Picos por asignación | Crear objetos cada frame dispara la memoria. |
| 5 | Ciclos de referencia | Dos objetos que se apuntan nunca llegan a cero. |
| 6 | Fugas de memoria | Referencias vivas que ya no deberían existir. |
| 7 | `preload` vs `load` | Cargar una vez frente a cargar repetido. |
| 8 | Reutilización de objetos | Menos asignaciones, memoria más plana. |

## 📖 Definiciones y características

- **Memoria estática**: la que reporta `MEMORY_STATIC`, usada por objetos y estructuras del motor. Clave: es la que vigilamos para detectar crecimientos.
- **Memoria dinámica**: asignada en tiempo de ejecución al crear objetos o arrays. Clave: crearla cada frame produce picos.
- **`RefCounted`**: clase base con conteo de referencias automático. Clave: se libera sola cuando el contador llega a cero.
- **`Object`**: clase base sin conteo. Clave: hay que liberarla con `free()` o queda como fuga.
- **Conteo de referencias**: número de variables que apuntan a un objeto. Clave: al llegar a cero, se destruye de inmediato.
- **Ciclo de referencia**: A referencia a B y B a A. Clave: el contador nunca baja a cero; hay que romperlo manualmente.
- **Fuga (leak)**: memoria retenida por referencias que ya no se usan. Clave: la memoria crece de forma sostenida sin bajar.
- **`preload`**: carga un recurso en tiempo de compilación de la escena. Clave: evita recargar el mismo recurso repetidamente.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**. Vigilaremos la memoria con `Performance.get_monitor(Performance.MEMORY_STATIC)` y con **Monitors → Memory** en el Debugger; el monitor **Object Count** ayuda a ver objetos vivos. Para inspeccionar fugas de nodos, activa en **Project Settings** el aviso de objetos huérfanos y usa `print_orphan_nodes()`.

Consulta "Memory management" y la referencia de `RefCounted`: <https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html> y <https://docs.godotengine.org/en/stable/classes/class_refcounted.html>. La lista de monitores de memoria está en la clase `Performance`: <https://docs.godotengine.org/en/stable/classes/class_performance.html>.

## 🧪 Laboratorio guiado

Vamos a **provocar un pico de memoria creando objetos cada frame, detectarlo con el monitor, corregirlo, y luego montar y romper un ciclo de referencia (fuga)**.

1. Crea un `Node2D` raíz `Memoria` con un `Label`. Adjunta esta **versión DERROCHADORA** que asigna un array grande y un objeto nuevo en cada frame:

```gdscript
extends Node2D

@onready var _label: Label = $Label

func _process(_delta: float) -> void:
	# ANTIPATRÓN: asignar memoria dinámica cada frame
	var basura: Array = []
	for i in 5000:
		basura.append(Vector2(randf(), randf()))
	var mem_mb: float = Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	var objs: int = Performance.get_monitor(Performance.OBJECT_COUNT)
	_label.text = "DERROCHA | mem=%.1f MB | objetos=%d" % [mem_mb, objs]
```

2. Ejecuta con **F5** y abre **Monitors → Memory**. **ANTES**: verás la memoria oscilar y presionar al recolector de referencias frame a frame; en el monitor de memoria la línea será irregular y el coste por frame, alto. Anota el promedio.

3. **Corrige reutilizando**: asigna el array una sola vez y reutilízalo, evitando crear objetos nuevos cada frame:

```gdscript
extends Node2D

@onready var _label: Label = $Label
var _buffer: Array = []            # asignado una vez

func _ready() -> void:
	_buffer.resize(5000)

func _process(_delta: float) -> void:
	for i in _buffer.size():
		_buffer[i] = Vector2(randf(), randf())   # sobrescribe, no re-asigna
	var mem_mb: float = Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	_label.text = "REUTILIZA | mem=%.1f MB" % mem_mb
```

4. Re-ejecuta. **DESPUÉS**: la memoria se aplana y el coste por frame baja, porque dejamos de pedir y devolver memoria constantemente. Observable directo en el monitor Memory.

5. Ahora una **fuga por ciclo de referencia**. Define dos clases `RefCounted` que se apuntan mutuamente y créalas repetidamente; el conteo nunca llega a cero y los objetos se acumulan:

```gdscript
class Nodo extends RefCounted:
	var otro: Nodo = null      # referencia fuerte al compañero

func _crear_ciclo() -> void:
	var a := Nodo.new()
	var b := Nodo.new()
	a.otro = b
	b.otro = a                 # CICLO: a<->b, contador nunca baja a 0
	# al salir de la función, a y b deberían liberarse... pero no lo hacen
```

6. Llama `_crear_ciclo()` muchas veces y observa **Object Count** crecer sin bajar: eso es una fuga. **Rómpela** anulando una de las referencias antes de perder el rastro, o usando `weakref()` para que un lado no cuente:

```gdscript
func _crear_sin_fuga() -> void:
	var a := Nodo.new()
	var b := Nodo.new()
	a.otro = b
	# b guarda una referencia DÉBIL: no impide liberar a 'a'
	b.set("otro", null)
	var debil = weakref(a)     # weakref no incrementa el contador
	# al terminar, a y b se liberan porque no hay ciclo fuerte
```

Tras el arreglo, `OBJECT_COUNT` vuelve a estabilizarse: la memoria deja de crecer indefinidamente.

Observable: entre la versión que asigna cada frame y la que reutiliza, la línea de memoria pasa de dientes de sierra a plana; y el contador de objetos deja de crecer al romper el ciclo.

## ✍️ Ejercicios

1. Grafica `MEMORY_STATIC` durante 30 s en la versión derrochadora y en la reutilizadora, y compara la forma de la curva.
2. Sustituye `load()` dentro de un bucle por un `preload` fuera de él y mide el efecto en asignaciones.
3. Crea 10000 `RefCounted` sin ciclos, deja que salgan de ámbito y confirma que `OBJECT_COUNT` vuelve a su base.
4. Reproduce un ciclo de referencia y demuéstralo con `OBJECT_COUNT` que no baja; luego rómpelo con `weakref`.
5. Usa `print_orphan_nodes()` tras liberar una escena para detectar nodos que quedaron huérfanos.
6. Convierte una clase de datos que usabas como `Object` a `RefCounted` y explica qué cambia en su liberación.

## 📝 Reto verificable

Toma un sistema que cree objetos con frecuencia (por ejemplo, un generador de proyectiles o de partículas por script). Detecta con `MEMORY_STATIC` y `OBJECT_COUNT` si hay picos o crecimiento sostenido. Corrige el patrón: reutiliza objetos, mueve cargas a `preload` y rompe cualquier ciclo de referencia que encuentres.

**Criterio de aceptación**: tras la corrección, el monitor de memoria muestra una línea estable (sin crecimiento sostenido) durante al menos 30 segundos de ejecución, y `OBJECT_COUNT` regresa a su valor base tras liberar objetos, demostrando que la fuga fue eliminada.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Memoria en dientes de sierra y tirones | Creas arrays u objetos cada frame. Reutiliza buffers y evita asignaciones en `_process`. |
| `OBJECT_COUNT` crece y nunca baja | Ciclo de referencia entre `RefCounted`. Anula una referencia o usa `weakref` para romperlo. |
| Aviso de nodos huérfanos al salir | Instanciaste nodos sin añadirlos al árbol ni liberarlos. Añádelos o llama `free()`/`queue_free()`. |
| `Object` que nunca se libera | `Object` no cuenta referencias. Libera con `free()` o hereda de `RefCounted`. |
| Carga repetida del mismo recurso | Usas `load()` en bucle. Cámbialo por `preload` una sola vez. |

## ❓ Preguntas frecuentes

**❓ ¿GDScript tiene garbage collector?** No en el sentido de C#/Java. Usa **conteo de referencias**: los `RefCounted` se liberan al instante cuando nadie los referencia, sin pausas globales.

**❓ ¿Por qué un ciclo de referencia no se libera solo?** Porque cada objeto mantiene vivo al otro: el contador de ambos nunca llega a cero. Hay que romper el ciclo manualmente o con `weakref`.

**❓ ¿Cuándo usar `Object` en vez de `RefCounted`?** Rara vez. `Object` exige liberación manual y es fácil filtrarlo. Para datos, prefiere `RefCounted`; para escena, `Node` con `queue_free()`.

**❓ ¿`preload` y `load` gastan lo mismo?** `preload` resuelve el recurso al cargar la escena y lo comparte; `load` en runtime puede recargar y asignar de más si se llama en bucle.

## 🔗 Referencias

- Godot Docs — When and how to avoid using nodes (RefCounted/Object): <https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html>
- Godot Docs — RefCounted (clase): <https://docs.godotengine.org/en/stable/classes/class_refcounted.html>
- Godot Docs — Performance (monitores de memoria): <https://docs.godotengine.org/en/stable/classes/class_performance.html>
- Jason Gregory, "Game Engine Architecture", 3.ª ed., capítulo sobre gestión de memoria.

## ➡️ Siguiente clase

[Clase 246 - Object pooling y evitar asignaciones](../246-object-pooling-y-evitar-asignaciones/README.md)
