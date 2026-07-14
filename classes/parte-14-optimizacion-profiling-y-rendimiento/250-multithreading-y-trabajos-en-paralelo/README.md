# Clase 250 — Multithreading y trabajos en paralelo

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Godot Docs — Using multiple threads y Thread-safe APIs*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Cuando un cálculo pesado se ejecuta en el hilo principal —generar un mundo procedural, cargar recursos, procesar una malla grande— el frame se congela hasta que termina, produciendo un tirón o un cuelgue temporal. La solución es mover ese trabajo a otro hilo para que el hilo principal siga dibujando y respondiendo a la entrada. Godot 4 ofrece dos vías: `WorkerThreadPool` para lanzar tareas cortas a un pool de hilos gestionado, y la clase `Thread` para hilos de larga duración que controlas tú.

El multithreading es poderoso pero peligroso: el árbol de escena **no es seguro para hilos**. Nunca debes crear, liberar ni modificar nodos desde un hilo secundario. En esta clase aprendes qué se puede paralelizar y qué no, cómo sincronizar con `Mutex`, cómo devolver resultados al hilo principal de forma segura con `call_deferred()`, y cómo cargar recursos en segundo plano con `ResourceLoader.load_threaded_request()` y `load_threaded_get_status()`. Medirás con `Time.get_ticks_usec()` que el frame ya no se bloquea.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Decidir cuándo conviene usar hilos y cuándo no aporta nada.
2. Lanzar trabajo con `WorkerThreadPool.add_task()` y esperar su resultado.
3. Proteger datos compartidos con `Mutex` y evitar condiciones de carrera.
4. Devolver resultados al hilo principal con `call_deferred()` de forma segura.
5. Cargar recursos en segundo plano con `ResourceLoader.load_threaded_request()`.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Cuándo usar hilos | El paralelismo solo ayuda si el trabajo es pesado e independiente. |
| 2 | WorkerThreadPool | Pool gestionado ideal para tareas cortas y paralelizables. |
| 3 | Clase Thread | Control manual para trabajo continuo de larga duración. |
| 4 | Qué NO tocar | El árbol de escena no es seguro para hilos; se corrompe. |
| 5 | Mutex | Serializa el acceso a datos compartidos sin corromperlos. |
| 6 | call_deferred | Reintroduce resultados en el hilo principal de forma segura. |
| 7 | Carga en background | `load_threaded_request` evita congelar en las transiciones. |
| 8 | Medición del bloqueo | `Time.get_ticks_usec()` demuestra que el frame no se detiene. |

## 📖 Definiciones y características

- **Hilo (Thread)**: línea de ejecución paralela al hilo principal. Clave: permite trabajo pesado sin congelar el render.
- **`WorkerThreadPool`**: sistema global de hilos de Godot 4 que ejecuta tareas encoladas. Clave: no creas hilos manualmente; encolas trabajo.
- **`add_task()`**: encola una función para ejecutarse en el pool; devuelve un id. Clave: se sincroniza con `wait_for_task_completion()`.
- **Condición de carrera**: fallo por acceso simultáneo no sincronizado a datos compartidos. Clave: causa bugs intermitentes difíciles de reproducir.
- **`Mutex`**: cerrojo que garantiza que solo un hilo entre a una sección crítica. Clave: `lock()` antes y `unlock()` después del acceso.
- **`call_deferred()`**: agenda una llamada para el final del frame, en el hilo principal. Clave: única vía segura de tocar la escena desde otro hilo.
- **API insegura para hilos**: casi todo el árbol de nodos (`add_child`, `queue_free`, cambiar propiedades de nodos). Clave: hazlo siempre en el hilo principal.
- **`ResourceLoader.load_threaded_request()`**: inicia la carga de un recurso en segundo plano. Clave: se consulta con `load_threaded_get_status()`.

## 🧰 Herramientas y preparación

Usa Godot 4.x. Prepara dos escenarios: (a) un cálculo pesado puro —por ejemplo, generar un `ImageTexture` de ruido grande o sumar un array enorme— y (b) la carga de una escena o recurso pesado. Consulta las guías de hilos (<https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html>) y de background loading (<https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html>).

Regla de oro que repetirás en cada laboratorio: **el resultado que produce un hilo secundario se entrega al hilo principal, y solo el hilo principal toca la escena**. Ten un `Label` con un contador o una animación simple girando en pantalla: si sigue moviéndose durante el cálculo, sabes que no bloqueaste el frame.

## 🧪 Laboratorio guiado

Compararás un cálculo bloqueante con su versión en hilo, y luego cargarás un recurso en background.

**Paso 1 — Versión bloqueante (línea base).** Ejecuta el cálculo pesado en el hilo principal y mide cuánto congela el frame:

```gdscript
extends Node

func _bloqueante() -> void:
	var t0: int = Time.get_ticks_usec()
	var suma := 0.0
	for i in 20_000_000:            # trabajo pesado en el hilo principal
		suma += sqrt(float(i))
	var ms := (Time.get_ticks_usec() - t0) / 1000.0
	print("BLOQUEANTE: %.1f ms (el frame estuvo congelado todo ese tiempo)" % ms)
```

Observa que la animación en pantalla se detiene mientras corre. Ese es el problema.

**Paso 2 — Con WorkerThreadPool.** Mueve el mismo cálculo a una tarea del pool y entrega el resultado con `call_deferred()`:

```gdscript
extends Node

var _task_id: int = -1

func lanzar_calculo() -> void:
	# add_task encola la función en el pool y no bloquea el frame.
	_task_id = WorkerThreadPool.add_task(Callable(self, "_trabajo_pesado"))

func _trabajo_pesado() -> void:
	var suma := 0.0
	for i in 20_000_000:
		suma += sqrt(float(i))
	# NO tocar la escena aquí. Devolvemos el resultado al hilo principal:
	call_deferred("_on_resultado", suma)

func _on_resultado(suma: float) -> void:
	# Esto corre en el hilo principal: aquí SÍ es seguro tocar nodos.
	WorkerThreadPool.wait_for_task_completion(_task_id)  # libera la tarea
	$Label.text = "Resultado: %f" % suma
```

Ejecuta y confirma que la animación de pantalla NO se detiene: el frame sigue vivo mientras el pool trabaja.

**Paso 3 — Datos compartidos con Mutex.** Si varias tareas escriben en una estructura común, protégela:

```gdscript
extends Node

var _mutex := Mutex.new()
var _resultados: Array[float] = []

func _acumular(valor: float) -> void:
	_mutex.lock()          # solo un hilo entra a la vez
	_resultados.append(valor)
	_mutex.unlock()        # imprescindible: si no desbloqueas, se cuelga
```

**Paso 4 — Carga de recurso en background.** Usa `ResourceLoader` para cargar una escena pesada sin congelar la transición:

```gdscript
extends Node

const RUTA := "res://escenas/nivel_grande.tscn"
var _cargando := false

func iniciar_carga() -> void:
	ResourceLoader.load_threaded_request(RUTA)   # arranca la carga en segundo plano
	_cargando = true

func _process(_delta: float) -> void:
	if not _cargando:
		return
	var progreso: Array = []
	var estado := ResourceLoader.load_threaded_get_status(RUTA, progreso)
	match estado:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progreso[0] * 100.0   # 0.0 a 1.0
		ResourceLoader.THREAD_LOAD_LOADED:
			_cargando = false
			var packed: PackedScene = ResourceLoader.load_threaded_get(RUTA)
			add_child(packed.instantiate())           # hilo principal: seguro
		ResourceLoader.THREAD_LOAD_FAILED:
			_cargando = false
			push_error("Falló la carga de %s" % RUTA)
```

**Paso 5 — Compara.** Mide con `Time.get_ticks_usec()` el tiempo del frame durante el cálculo bloqueante frente al que usa el pool. En la versión con hilo, el tiempo del hilo principal por frame se mantiene bajo (el frame sigue fluido) aunque el trabajo total tarde lo mismo. Documenta ANTES/DESPUÉS: milisegundos de congelación del frame y fluidez de la animación.

## ✍️ Ejercicios

1. Paraleliza el cálculo en 4 tareas del pool y combina los resultados con un `Mutex`.
2. Sustituye `WorkerThreadPool` por la clase `Thread` y compara el código.
3. Añade una barra de progreso real a la carga en background del Paso 4.
4. Provoca deliberadamente una condición de carrera sin `Mutex` y observa el fallo.
5. Intenta (y explica por qué falla) llamar a `add_child()` desde el hilo secundario.
6. Mide el tiempo del hilo principal por frame con y sin el cálculo movido a hilo.

## 📝 Reto verificable

Toma una operación que congela el frame (generación procedural pesada o carga de un nivel grande) y muévela a segundo plano usando `WorkerThreadPool.add_task()` o `ResourceLoader.load_threaded_request()`, entregando el resultado al hilo principal con `call_deferred()` y protegiendo cualquier dato compartido con `Mutex`. Entrega una comparativa ANTES/DESPUÉS del tiempo de congelación del frame medido con `Time.get_ticks_usec()`.

**Criterio de aceptación**: durante la operación pesada, una animación en pantalla sigue reproduciéndose sin detenerse; el resultado se aplica a la escena únicamente desde el hilo principal (vía `call_deferred` o consulta de estado en `_process`); y la tabla muestra que el tiempo del hilo principal por frame es mucho menor que en la versión bloqueante.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Cuelgue o crash aleatorio al terminar el hilo | Tocaste la escena desde el hilo secundario. Usa `call_deferred()` para volver al principal. |
| El juego se congela indefinidamente | Un `Mutex.lock()` sin su `unlock()`. Asegura siempre el desbloqueo. |
| Resultados corruptos e intermitentes | Condición de carrera sobre datos compartidos. Protégelos con `Mutex`. |
| El frame sigue congelándose | El "hilo" en realidad corre en el principal, o esperas su fin con `wait_*` demasiado pronto. Encola y consulta el estado. |
| La carga en background nunca termina | No consultas `load_threaded_get_status()` cada frame. Hazlo en `_process()`. |

## ❓ Preguntas frecuentes

**❓ ¿Cuándo NO debo usar hilos?** Para tareas cortas o que dependen de la escena: el coste de sincronizar supera el beneficio. Los hilos brillan con trabajo pesado, largo e independiente del árbol de nodos.

**❓ ¿Por qué no puedo tocar nodos desde otro hilo?** El árbol de escena no está diseñado para acceso concurrente; modificarlo desde dos hilos corrompe su estado interno. Todo cambio de nodos debe pasar por el hilo principal, normalmente con `call_deferred()`.

**❓ ¿`WorkerThreadPool` o `Thread`?** `WorkerThreadPool` para tareas cortas y paralelizables (reutiliza hilos, menos overhead). `Thread` para un proceso continuo de larga vida que gestionas tú de principio a fin.

**❓ ¿La carga en background hace el juego más rápido?** No acelera la carga en sí; evita que congele el frame, permitiendo mostrar una pantalla de carga animada o seguir jugando mientras el recurso llega.

## 🔗 Referencias

- Godot Docs — Using multiple threads: <https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html>
- Godot Docs — Thread-safe APIs: <https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html>
- Godot Docs — Background loading: <https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html>
- Godot Docs — WorkerThreadPool: <https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html>

## ➡️ Siguiente clase

[Clase 251 - Tiempos de carga y arranque](../251-tiempos-de-carga-y-arranque/README.md)
