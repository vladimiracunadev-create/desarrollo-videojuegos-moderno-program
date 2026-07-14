# Clase 241 — El profiler: CPU, GPU y frame time

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Using the profiler / Debugger panel)*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Dominar la herramienta central del diagnóstico en Godot 4: el **Debugger**, con su pestaña **Profiler**, su **Visual Profiler** y sus **Monitors**. Estas tres vistas convierten el vago "va lento" en un desglose por función y por fase con números concretos. En esta clase aprendemos a lanzar el juego bajo el perfilador, a leer qué porción del frame consume cada script y a separar la parte de **CPU** de la parte de **GPU**.

También aclaramos una confusión habitual: la diferencia entre **frame time** (milisegundos por frame, la métrica que de verdad importa) y **FPS** (una cifra derivada y no lineal). Al terminar sabrás abrir el perfilador ante un proyecto con carga, congelar la captura, ordenar por coste y señalar con el dedo la función responsable del cuello de botella, en lugar de suponerla.

El profiler es la herramienta que cierra el círculo abierto en la clase anterior: donde la instrumentación manual con `Time.get_ticks_usec()` nos daba el coste de un bloque que ya sospechábamos, el profiler recorre **todas** las funciones y las ordena por coste sin que tengamos que instrumentar nada. Es la diferencia entre buscar con una linterna y encender la luz de toda la habitación.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Abrir y configurar el Profiler y el Visual Profiler del Debugger de Godot 4.
2. Interpretar el desglose por función y ordenar las llamadas por tiempo consumido.
3. Distinguir tiempo de **CPU (process/physics)** del tiempo de **GPU** en el Visual Profiler.
4. Explicar por qué el **frame time** es mejor métrica que los FPS para tomar decisiones.
5. Leer los **Monitors** (FPS, draw calls, memoria) y correlacionarlos con el desglose del profiler.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El panel Debugger | Es el centro de mando del diagnóstico en vivo. |
| 2 | Profiler (lista por función) | Muestra qué script consume cada milisegundo. |
| 3 | Visual Profiler | Descompone el frame en franjas de color por fase. |
| 4 | Monitors | Grafican FPS, draw calls y memoria en el tiempo. |
| 5 | Frame time vs FPS | El frame time es lineal; los FPS engañan. |
| 6 | Self time vs total time | Separa el coste propio del de las llamadas hijas. |
| 7 | Separar CPU y GPU | Indica en qué mitad del motor optimizar. |
| 8 | Congelar y leer la captura | Sin pausar, los números se mueven demasiado. |

## 📖 Definiciones y características

- **Debugger**: panel inferior del editor con pestañas de errores, profiler y monitores, activo mientras el juego corre. Clave: solo captura si el juego se lanzó desde el editor.
- **Profiler**: lista de funciones con su tiempo por frame; se activa con **Start**. Clave: ordénala por tiempo para ver el punto caliente.
- **Visual Profiler**: gráfico por frame que separa CPU y GPU en franjas. Clave: hace visible si el cuello es de proceso o de render.
- **Monitors**: gráficas temporales de métricas del motor (FPS, draw calls, memoria). Clave: dan tendencia, no desglose por función.
- **Frame time**: milisegundos que tarda un frame en producirse. Clave: es aditivo, por eso se reparte en presupuesto.
- **FPS**: frames por segundo; inverso del frame time. Clave: no es lineal, 60→30 duele mucho más que 200→100.
- **Self time**: tiempo gastado dentro de una función sin contar sus llamadas. Clave: aísla al verdadero culpable.
- **Total time**: tiempo de la función incluyendo todo lo que llama. Clave: útil para ver ramas caras completas.

## 🧰 Herramientas y preparación

Trabajaremos íntegramente dentro de **Godot 4.x**. El **Debugger** aparece automáticamente al ejecutar (**F5**); si no lo ves, ábrelo en el menú inferior **Debugger**. Necesitas un proyecto con carga suficiente para que el desglose sea legible: reutiliza el banco de pruebas de la clase anterior o cualquier escena con muchos nodos activos.

La documentación oficial del flujo está en "The Profiler" y "Overview of debugging tools": <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html> y <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html>. Ten a mano también la lista de monitores para correlacionar cifras: <https://docs.godotengine.org/en/stable/classes/class_performance.html>.

## 🧪 Laboratorio guiado

Vamos a **identificar con el profiler qué función se come el frame** en un proyecto con dos cargas distintas, una cara y otra barata, para poder leer la diferencia en pantalla.

1. Crea un `Node2D` raíz `Escena` y adjúntale este script. Genera deliberadamente dos funciones de coste muy distinto y llámalas cada frame:

```gdscript
extends Node2D

func _process(_delta: float) -> void:
	_calculo_caro()
	_calculo_barato()

func _calculo_caro() -> void:
	var acc: float = 0.0
	for i in 150000:
		acc += sin(float(i)) * cos(float(i))

func _calculo_barato() -> void:
	var acc: int = 0
	for i in 1000:
		acc += i
```

2. Ejecuta con **F5**. Abre el **Debugger** (panel inferior) y ve a la pestaña **Profiler**. Pulsa **Start** para empezar a capturar. Deja correr unos segundos y pulsa **Stop** o haz clic en una franja del gráfico para **congelar** la lectura.

3. En la lista de funciones, activa la columna de tiempo y ordénala. Verás `_calculo_caro()` cerca de la cima con varios milisegundos de **self time**, mientras `_calculo_barato()` aparece con un valor despreciable. **ANTES** de optimizar, anota el frame time total y el tiempo de `_calculo_caro`.

4. Cambia a **Visual Profiler** (selector dentro de la misma pestaña). Observa las franjas: la mayor parte del frame estará en la fila de **CPU / _process**, no en la de **GPU**. Esto confirma que el proyecto es **CPU-bound**: el cuello está en el script, no en el render.

5. Abre la sub-pestaña **Monitors** y localiza **Frame Time** y **FPS**. Fíjate en que si el frame time sube de ~16 ms a ~33 ms, los FPS caen de 60 a 30: la misma información, pero el frame time es la magnitud que puedes sumar y presupuestar.

6. **Optimiza y vuelve a medir.** Reduce el bucle de `_calculo_caro()` de `150000` a `15000` y re-ejecuta con el profiler activo. **DESPUÉS** deberías ver `_calculo_caro` desplomarse en la lista y el frame time caer, mientras `_calculo_barato` sigue exactamente igual. Acabas de confirmar, con desglose por función, dónde estaba el coste y que tu cambio lo atacó.

Observable clave: el profiler te llevó directo a la función culpable sin adivinar, y el Visual Profiler te dijo que buscaras en CPU y no en GPU.

Detalle práctico: si activas **Start** justo al lanzar, capturarás también el pico de arranque (carga de recursos, `_ready`). Para analizar el estado estable, deja correr un par de segundos antes de fijarte en la lista, o descarta los primeros frames del gráfico. Los picos de arranque son reales, pero se optimizan con otras técnicas (carga diferida) distintas de las del frame en régimen.

## ✍️ Ejercicios

1. Añade una tercera función de coste intermedio y ordena la lista del Profiler para situarla entre las otras dos.
2. Provoca carga de GPU (muchos nodos transparentes solapados) y observa cómo cambia el reparto CPU/GPU en el Visual Profiler.
3. Anota frame time y FPS en tres niveles de carga y dibuja la relación no lineal entre ambos.
4. Distingue en una función con llamadas anidadas su **self time** de su **total time** y explica la diferencia.
5. Correlaciona un pico del monitor **Frame Time** con la función responsable usando la captura congelada.
6. Deja el profiler corriendo durante un cambio de escena y describe qué picos aparecen.

## 📝 Reto verificable

Toma un proyecto con al menos cuatro funciones llamadas por frame de costes distintos. Usando solo el Profiler y el Visual Profiler (sin instrumentar el código a mano), entrega una tabla que ordene las funciones por self time, indique si el proyecto es CPU-bound o GPU-bound, y señale el frame time total. Luego optimiza la función más cara y demuestra el cambio con una segunda captura.

**Criterio de aceptación**: la tabla identifica correctamente la función más cara vía profiler, clasifica bien CPU/GPU con el Visual Profiler, y la segunda captura muestra una reducción visible del frame time atribuible a la función optimizada.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El Profiler está vacío | No pulsaste **Start**, o el juego no se lanzó desde el editor. Ejecuta con F5 y activa la captura. |
| Los números no paran de moverse | Estás leyendo en vivo. Haz clic en una franja del gráfico para congelar el frame y analizarlo. |
| "El profiler dice 0 ms pero va lento" | El coste está en GPU, no en scripts. Mira el Visual Profiler y los draw calls, no solo la lista de funciones. |
| Confundir self time con total time | Optimizas la función equivocada. Usa self time para hallar al culpable directo, total time para ramas completas. |
| Decidir por FPS en vez de frame time | Los FPS no son lineales y engañan. Razona siempre en milisegundos por frame. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué el frame time es mejor que los FPS?** Porque es aditivo y lineal: puedes repartir 16.6 ms entre sistemas. Los FPS comprimen la escala y hacen que caídas graves parezcan pequeñas.

**❓ ¿El Profiler mide también la GPU?** El Profiler clásico se centra en CPU/scripts; para separar GPU usa el **Visual Profiler**, que muestra la franja de render aparte.

**❓ ¿Perfilar ralentiza el juego?** Sí, un poco: la instrumentación tiene coste. Úsalo para comparar relativamente, no como la cifra final de la build exportada.

**❓ ¿Puedo perfilar la build exportada?** El profiler del editor requiere lanzar desde el editor. Para builds usa monitores propios con `Performance.get_monitor()` como vimos en la clase 240.

**❓ ¿Cada cuánto debería perfilar durante el desarrollo?** No al final "por si acaso", sino cada vez que añades un sistema pesado o notas una caída. Perfilar temprano y a menudo hace que el cuello de botella nunca te sorprenda al cierre del proyecto.

## 🔗 Referencias

- Godot Docs — The Profiler: <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html>
- Godot Docs — Overview of debugging tools: <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html>
- Godot Docs — Performance (monitores): <https://docs.godotengine.org/en/stable/classes/class_performance.html>
- Godot Docs — Optimization index: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>

## ➡️ Siguiente clase

[Clase 242 - Presupuesto de frame y objetivos de FPS](../242-presupuesto-de-frame-y-objetivos-de-fps/README.md)
