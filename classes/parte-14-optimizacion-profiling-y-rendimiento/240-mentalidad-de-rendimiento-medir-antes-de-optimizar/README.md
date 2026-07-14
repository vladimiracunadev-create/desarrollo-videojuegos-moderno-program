# Clase 240 — Mentalidad de rendimiento: medir antes de optimizar

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Performance / Optimization) y Jason Gregory, "Game Engine Architecture"*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Instalar la disciplina que separa a quien optimiza de quien adivina: **medir primero, tocar código después**. En esta clase adoptamos la regla de oro del rendimiento —no se optimiza lo que no se ha medido— y aprendemos a localizar el verdadero cuello de botella de un proyecto antes de cambiar una sola línea. La intuición del programador sobre "qué va lento" acierta con sorprendente poca frecuencia; los datos, en cambio, no mienten.

Aprenderás a instrumentar un proyecto de Godot 4 con `Performance.get_monitor()` y `Time.get_ticks_usec()` para obtener números reproducibles, a distinguir la optimización útil de la **optimización prematura** que solo añade complejidad, y a aplicar el principio 80/20 para invertir tu esfuerzo donde de verdad rinde. Al final tendrás un flujo de trabajo: perfilar, identificar el punto caliente, optimizar solo eso, y volver a medir para confirmar la ganancia.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Enunciar y justificar la regla de oro "medir antes de optimizar" con un caso propio.
2. Reconocer síntomas de optimización prematura y explicar su coste real.
3. Aplicar el principio 80/20 para priorizar qué sistema optimizar primero.
4. Instrumentar bloques de código con `Time.get_ticks_usec()` para medir su coste en microsegundos.
5. Leer los monitores de rendimiento con `Performance.get_monitor()` y localizar el cuello de botella antes de modificar nada.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | La regla de oro: medir primero | Evita horas perdidas optimizando lo que no era el problema. |
| 2 | Optimización prematura | Añade complejidad y bugs sin ganancia demostrada. |
| 3 | El principio 80/20 (Pareto) | El 80% del coste suele venir del 20% del código. |
| 4 | Qué es un cuello de botella | Es el sistema que fija el techo de rendimiento del frame. |
| 5 | CPU-bound vs GPU-bound | Determina en qué mitad del motor buscar. |
| 6 | Instrumentar con `Time.get_ticks_usec()` | Da una medición local y precisa de un bloque concreto. |
| 7 | Monitores con `Performance` | Ofrecen métricas globales del motor en vivo. |
| 8 | Cuándo NO optimizar | El tiempo del desarrollador también es un recurso finito. |

## 📖 Definiciones y características

- **Optimización**: proceso de reducir el coste (tiempo, memoria) de una operación manteniendo su resultado. Clave: solo es válida si se demuestra con medición.
- **Optimización prematura**: optimizar antes de tener datos que justifiquen el esfuerzo. Clave: suele encarecer el mantenimiento sin mejorar la experiencia.
- **Cuello de botella (bottleneck)**: el recurso o función que limita el rendimiento global. Clave: optimizar cualquier otra cosa no mueve la aguja.
- **Principio 80/20**: heurística según la cual una minoría del código consume la mayoría del tiempo. Clave: enfoca el esfuerzo donde hay retorno.
- **`Time.get_ticks_usec()`**: reloj monótono en microsegundos desde el arranque del motor. Clave: mide intervalos restando dos lecturas.
- **`Performance.get_monitor(id)`**: devuelve el valor actual de un monitor interno del motor (FPS, draw calls, memoria…). Clave: métrica global, no por bloque.
- **CPU-bound**: el frame lo limita el procesador (lógica, scripts, física). Clave: bajar carga de GPU no ayudaría.
- **GPU-bound**: el frame lo limita la tarjeta gráfica (draw calls, fillrate). Clave: la CPU tiene tiempo de sobra esperando.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y un proyecto con algo de carga real: sirve cualquier escena con decenas o cientos de nodos que se muevan. Trabajaremos casi todo desde código con la clase singleton **`Performance`** y con **`Time`**, ambas disponibles sin importar nada. En clases siguientes abriremos el **Debugger → Profiler** y **Monitors**; hoy nos centramos en la instrumentación manual, que es la más portable y la que puedes dejar embebida en tu juego.

Consulta la lista completa de monitores en la documentación de la clase `Performance`: <https://docs.godotengine.org/en/stable/classes/class_performance.html>. La guía general de optimización está en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>.

## 🧪 Laboratorio guiado

Vamos a **localizar un cuello de botella sin tocar nada** de la lógica: primero medimos, y solo con datos decidiremos. Crea una escena con un nodo raíz `Node2D` llamado `Banco` y añádele este script como marco de trabajo.

1. Prepara un proyecto con algo de trabajo por frame (por ejemplo, un bucle que recorra muchos nodos). Adjunta a `Banco` el siguiente script, que instrumenta dos fases sospechosas y las promedia:

```gdscript
extends Node2D

var _acum_fase_a: int = 0        # microsegundos acumulados
var _acum_fase_b: int = 0
var _muestras: int = 0

func _process(_delta: float) -> void:
	# --- Fase A: trabajo pesado simulado (candidato a cuello de botella) ---
	var t0: int = Time.get_ticks_usec()
	_trabajo_pesado()
	var t1: int = Time.get_ticks_usec()

	# --- Fase B: trabajo ligero ---
	_trabajo_ligero()
	var t2: int = Time.get_ticks_usec()

	_acum_fase_a += t1 - t0
	_acum_fase_b += t2 - t1
	_muestras += 1

func _trabajo_pesado() -> void:
	var s: float = 0.0
	for i in 200000:
		s += sqrt(float(i))

func _trabajo_ligero() -> void:
	var s: float = 0.0
	for i in 500:
		s += float(i)
```

2. Añade un informe cada segundo que combine tu medición local con los monitores globales del motor. Amplía el script:

```gdscript
func _ready() -> void:
	var t := Timer.new()
	t.wait_time = 1.0
	t.timeout.connect(_informe)
	add_child(t)
	t.start()

func _informe() -> void:
	if _muestras == 0:
		return
	var fps: float = Performance.get_monitor(Performance.TIME_FPS)
	var mem_mb: float = Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	print("FPS=%.0f | mem=%.1f MB | A=%d us | B=%d us"
		% [fps, mem_mb, _acum_fase_a / _muestras, _acum_fase_b / _muestras])
	_acum_fase_a = 0
	_acum_fase_b = 0
	_muestras = 0
```

3. Ejecuta con **F5** y observa el **Output**. Verás algo como `FPS=58 | mem=24.3 MB | A=1450 us | B=3 us`. **ANTES de optimizar**, anota estos números. La medición dice, sin ambigüedad, que la Fase A cuesta cientos de veces más que la Fase B: ahí está el cuello.

4. Ahora **decide con datos**: reduce el trabajo de la Fase A (baja el bucle de `200000` a `20000`, simulando una optimización de esa función). Vuelve a ejecutar. **DESPUÉS** deberías ver la Fase A caer a decenas de microsegundos y el FPS recuperarse.

5. Prueba el contraejemplo: en lugar de tocar la Fase A, "optimiza" la Fase B (que ya era baratísima). Al re-ejecutar comprobarás que el FPS **no cambia**. Acabas de vivir en carne propia por qué optimizar sin medir es tirar tiempo.

La lección observable: la ganancia real vino de atacar el 20% caro (Fase A), no de pulir lo que ya era barato.

## ✍️ Ejercicios

1. Instrumenta una tercera fase en tu propio proyecto y compárala con A y B; identifica cuál domina el frame.
2. Cambia el informe para que muestre también el **máximo** de cada fase, no solo el promedio, y razona por qué el pico importa.
3. Añade `Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)` al informe y decide si tu escena es CPU-bound o GPU-bound.
4. Escribe en un comentario tu hipótesis del cuello ANTES de medir; luego mide y anota si acertaste.
5. Crea una función `medir(callable)` reutilizable que reciba un `Callable`, lo ejecute y devuelva los microsegundos consumidos.
6. Documenta un caso donde optimizar la Fase B no mejoró nada y explica qué principio ilustra.

## 📝 Reto verificable

Toma un proyecto propio con al menos tres subsistemas por frame (por ejemplo: IA, movimiento y dibujo de UI). Instrumenta cada uno con `Time.get_ticks_usec()`, ejecuta 30 segundos y genera un informe por segundo con promedio y pico de cada subsistema más FPS y memoria. Identifica el cuello de botella con datos y aplica **una sola** optimización dirigida a él.

**Criterio de aceptación**: el informe demuestra numéricamente qué subsistema era el cuello ANTES, y tras la optimización dirigida se observa una mejora medible del FPS o del tiempo de ese subsistema, mientras los demás permanecen prácticamente iguales.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| "Optimicé mucho y el FPS no subió" | Optimizaste algo que no era el cuello. Mide primero e identifica el 20% caro antes de tocar código. |
| Mediciones que saltan enormemente entre frames | El editor y `print` añaden ruido. Promedia varias muestras y evita imprimir cada frame. |
| Usar `OS.get_ticks_msec()` para bloques cortos | La resolución en milisegundos oculta funciones que cuestan microsegundos. Usa `Time.get_ticks_usec()`. |
| El código instrumentado quedó en la build final | Los `print` por frame degradan el rendimiento real. Envuélvelos en un flag de depuración o retíralos. |
| Comparar FPS con y sin editor abierto | El editor consume recursos y falsea la cifra. Mide siempre la build exportada o con la ventana enfocada. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué no optimizar todo desde el principio?** Porque la mayoría del código no es el cuello: optimizarlo añade complejidad y bugs sin mejorar la experiencia. Optimiza cuando los datos lo pidan.

**❓ ¿`Time.get_ticks_usec()` mide en tiempo real o de juego?** Mide tiempo real monótono desde el arranque del motor, independiente de `Engine.time_scale`. Es lo que quieres para medir rendimiento.

**❓ ¿El promedio basta para decidir?** El promedio orienta, pero un pico esporádico puede causar tirones visibles. Vigila también el máximo por segundo.

**❓ ¿Optimización prematura significa "nunca pienses en rendimiento"?** No. Significa no reescribir en nombre de la velocidad sin datos. Elegir buenas estructuras desde el diseño sí es sano.

## 🔗 Referencias

- Godot Docs — Performance (clase): <https://docs.godotengine.org/en/stable/classes/class_performance.html>
- Godot Docs — Optimization index: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Time (clase): <https://docs.godotengine.org/en/stable/classes/class_time.html>
- Jason Gregory, "Game Engine Architecture", 3.ª ed., cap. sobre profiling y medición.

## ➡️ Siguiente clase

[Clase 241 - El profiler: CPU, GPU y frame time](../241-el-profiler-cpu-gpu-y-frame-time/README.md)
