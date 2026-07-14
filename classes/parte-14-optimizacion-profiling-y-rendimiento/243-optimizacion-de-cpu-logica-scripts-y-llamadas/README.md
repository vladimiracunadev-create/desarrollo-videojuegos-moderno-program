# Clase 243 — Optimización de CPU: lógica, scripts y llamadas

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (GDScript optimization / General optimization tips)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Atacar el lado **CPU** del rendimiento: la lógica, los scripts y las llamadas que se ejecutan frame a frame. La mayoría de los juegos 2D e indie 3D son CPU-bound, y buena parte del coste evitable viene de patrones sencillos de corregir: buscar nodos con `get_node()` dentro de bucles, instanciar objetos cada frame, no tipar las variables, o poner en `_process` trabajo que podría correr mucho menos a menudo.

En esta clase aplicamos las palancas más rentables de GDScript en Godot 4: **cachear referencias** con `@onready`, **evitar `get_node` en bucles**, usar **tipado estático** (que acelera el intérprete), aprovechar **grupos** para operar sobre muchos nodos sin recorrerlos a mano, reducir el trabajo en `_process` y diferir tareas con `call_deferred`. Todo se mide con el profiler antes y después, siguiendo la disciplina de las clases anteriores.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Cachear referencias a nodos con `@onready` y explicar por qué `get_node` en bucle es costoso.
2. Aplicar tipado estático a variables y funciones para acelerar la ejecución de GDScript.
3. Usar grupos (`add_to_group`, `get_nodes_in_group`) en lugar de recorrer el árbol a mano.
4. Decidir qué lógica va en `_process`, cuál en `_physics_process` y cuál puede correr por temporizador.
5. Diferir trabajo pesado con `call_deferred` para repartir el coste entre frames.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Cachear nodos con `@onready` | Evita buscar el mismo nodo miles de veces. |
| 2 | `get_node` fuera de bucles | La búsqueda por ruta tiene coste acumulable. |
| 3 | Tipado estático | Permite al intérprete saltarse comprobaciones. |
| 4 | Grupos de nodos | Operan sobre muchos nodos sin recorrer el árbol. |
| 5 | `_process` vs `_physics_process` | Cada uno corre a un ritmo distinto y con distinto coste. |
| 6 | Reducir frecuencia de trabajo | No todo necesita ejecutarse cada frame. |
| 7 | `call_deferred` | Reparte picos de trabajo y evita conflictos de estado. |
| 8 | Señales vs polling | Reaccionar es más barato que preguntar cada frame. |

## 📖 Definiciones y características

- **`@onready`**: anotación que asigna una variable justo cuando el nodo entra al árbol. Clave: cachea la referencia una sola vez.
- **`get_node()` / `$Ruta`**: busca un nodo por su ruta en el árbol. Clave: barato una vez, caro repetido en bucles.
- **Tipado estático**: declarar el tipo de variables, parámetros y retornos. Clave: GDScript genera bytecode más rápido y detecta errores antes.
- **Grupo**: etiqueta que agrupa nodos para operarlos en conjunto. Clave: `get_nodes_in_group()` evita recorridos manuales del árbol.
- **`_process(delta)`**: callback por frame de render, ritmo variable. Clave: ideal para lógica visual no crítica.
- **`_physics_process(delta)`**: callback a paso fijo. Clave: para física y lógica que necesita determinismo.
- **`call_deferred()`**: agenda una llamada para el final del frame actual. Clave: reparte carga y evita modificar el árbol en mal momento.
- **Polling**: comprobar una condición cada frame. Clave: sustitúyelo por señales cuando el evento es esporádico.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y el **Debugger → Profiler** de la clase 241 para medir el antes y el después. Trabajaremos sobre un script deliberadamente ineficiente y lo iremos corrigiendo. Ten a mano un `Label` para mostrar métricas en pantalla y muchos nodos hijos sobre los que iterar (crea, por ejemplo, 300 `Node2D` bajo un contenedor).

La referencia central es la guía de optimización de GDScript y las notas de tipado estático: <https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html> y <https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html>. También aplican las "General optimization tips": <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>.

## 🧪 Laboratorio guiado

Partimos de un script con **todos los antipatrones** y lo optimizamos paso a paso, midiendo con `Time.get_ticks_usec()` y confirmando en el Profiler.

1. Crea `Node2D` raíz `Escena` con un hijo `Contenedor` que tenga muchos `Node2D` hijos. Adjunta a `Escena` esta **versión LENTA**, que busca el nodo y no tipa nada:

```gdscript
extends Node2D

func _process(_delta):
	var t0 = Time.get_ticks_usec()
	# ANTIPATRÓN 1: get_node por ruta en cada frame
	# ANTIPATRÓN 2: sin tipado estático
	var cont = get_node("Contenedor")
	for i in cont.get_child_count():
		# ANTIPATRÓN 3: volver a buscar el hijo por índice cada vuelta
		var hijo = cont.get_child(i)
		hijo.position.x += sin(float(i)) * 0.01
	var t1 = Time.get_ticks_usec()
	$Label.text = "LENTO: %d us" % (t1 - t0)
```

2. Ejecuta con **F5**, abre el **Profiler**, captura y anota el **self time** de `_process` y los microsegundos del `Label`. Este es tu número **ANTES**.

3. Ahora escribe la **versión RÁPIDA** aplicando las palancas: cachear con `@onready`, tipar todo y guardar la lista de hijos una vez en `_ready`:

```gdscript
extends Node2D

@onready var _label: Label = $Label          # referencia cacheada
@onready var _hijos: Array = $Contenedor.get_children()  # lista cacheada

func _process(_delta: float) -> void:
	var t0: int = Time.get_ticks_usec()
	var n: int = _hijos.size()
	for i in n:
		var hijo: Node2D = _hijos[i]           # sin get_node ni get_child en bucle
		hijo.position.x += sin(float(i)) * 0.01
	var t1: int = Time.get_ticks_usec()
	_label.text = "RÁPIDO: %d us" % (t1 - t0)
```

4. Re-ejecuta y compara. **DESPUÉS** verás los microsegundos caer de forma clara: eliminaste dos búsquedas por frame y ayudaste al intérprete con los tipos. En el Profiler el self time de `_process` baja de manera visible.

5. Aplica **grupos** para lógica esporádica. Marca ciertos nodos y opéralos sin recorrer el árbol completo:

```gdscript
func _ready() -> void:
	for h in _hijos:
		h.add_to_group("moviles")

func _mover_grupo() -> void:
	# Se llama, por ejemplo, desde un Timer, NO cada frame
	for nodo in get_tree().get_nodes_in_group("moviles"):
		nodo.position.y += 1.0
```

6. Reduce la **frecuencia** del trabajo no crítico. En vez de recalcular algo caro en cada `_process`, hazlo cada 0.2 s con un `Timer`, y usa `call_deferred` para el trabajo que pueda esperar al final del frame:

```gdscript
func _ready() -> void:
	var t := Timer.new()
	t.wait_time = 0.2
	t.timeout.connect(_recalculo_caro)
	add_child(t)
	t.start()

func _recalculo_caro() -> void:
	call_deferred("_aplicar_resultado")   # difiere el efecto al final del frame
```

Observable: entre la versión lenta y la rápida hay una caída medible de microsegundos por frame; al mover trabajo a grupos y a un temporizador, el `_process` queda casi vacío y el frame time se estabiliza.

## ✍️ Ejercicios

1. Mide el coste de `get_node("Contenedor")` llamado 1000 veces en un bucle frente a cachearlo una vez.
2. Convierte un script sin tipos a totalmente tipado y compara el self time en el Profiler.
3. Sustituye un recorrido manual del árbol por `get_nodes_in_group()` y mide la diferencia.
4. Mueve lógica no crítica de `_process` a un `Timer` de 0.1 s y observa el cambio en frame time.
5. Usa `call_deferred` para instanciar 100 nodos repartidos, en lugar de todos en el mismo frame, y compara el pico.
6. Reemplaza un polling de "¿el jugador tocó la meta?" por una señal `area_entered` y razona el ahorro.

## 📝 Reto verificable

Toma un script real que corra lógica sobre muchos nodos en `_process` usando `get_node` y sin tipos. Optimízalo aplicando al menos cuatro palancas de la clase (cacheo `@onready`, tipado, grupos, reducción de frecuencia o `call_deferred`). Documenta con el Profiler el self time de `_process` antes y después.

**Criterio de aceptación**: la versión optimizada reduce de forma medible y reproducible el self time de `_process` respecto a la original (con capturas del Profiler que lo demuestren), sin cambiar el comportamiento visible del juego.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| `_process` con self time alto en el Profiler | Buscas nodos o instancias cada frame. Cachea con `@onready` y saca las búsquedas del bucle. |
| GDScript más lento de lo esperado | Variables sin tipo obligan a comprobaciones en runtime. Añade tipado estático a variables y funciones. |
| Recorrer todo el árbol para hallar unos pocos nodos | No usas grupos. Etiqueta con `add_to_group` y consulta con `get_nodes_in_group`. |
| Tirón al crear muchos nodos de golpe | Instancias todo en un frame. Reparte con `call_deferred` o a lo largo de varios frames. |
| Lógica cara ejecutada 60 veces por segundo sin necesidad | Está en `_process`. Muévela a un `Timer` con la frecuencia mínima aceptable. |

## ❓ Preguntas frecuentes

**❓ ¿El tipado estático realmente acelera GDScript?** Sí. Con tipos conocidos, el intérprete evita comprobaciones dinámicas y genera bytecode más eficiente, además de detectar errores en tiempo de edición.

**❓ ¿`_process` o `_physics_process` para mover enemigos?** Si el movimiento interactúa con física o necesita determinismo, `_physics_process`. Si es puramente visual, `_process` con `delta` sirve.

**❓ ¿`call_deferred` hace las cosas más rápidas?** No las acelera; las agenda para el final del frame. Sirve para repartir picos y para modificar el árbol de forma segura.

**❓ ¿Cachear con `@onready` es siempre mejor que `$Ruta`?** Para nodos que usas repetidamente, sí. `$Ruta` puntual está bien; el problema es repetir la búsqueda en bucles o cada frame.

## 🔗 Referencias

- Godot Docs — Static typing in GDScript: <https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html>
- Godot Docs — General optimization tips: <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>
- Godot Docs — Optimizing using Servers: <https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html>
- Godot Docs — Groups: <https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html>

## ➡️ Siguiente clase

[Clase 244 - Optimización de GPU: draw calls, overdraw y fillrate](../244-optimizacion-de-gpu-draw-calls-overdraw-y-fillrate/README.md)
