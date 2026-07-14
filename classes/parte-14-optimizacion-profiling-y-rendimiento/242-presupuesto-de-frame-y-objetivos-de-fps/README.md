# Clase 242 — Presupuesto de frame y objetivos de FPS

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Optimization / General optimization tips) y Jason Gregory, "Game Engine Architecture"*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Convertir un objetivo abstracto ("que vaya a 60 FPS") en un **presupuesto de frame** concreto y repartible. A 60 FPS cada frame dura **16.6 ms**; a 90 FPS, **11.1 ms**; a 30 FPS, **33.3 ms**. Ese número es el total que tienen que compartir todos tus sistemas: física, IA, lógica de juego, UI y render. Pensar en presupuesto transforma la optimización en una tarea de contabilidad: sabes cuánto tienes, mides cuánto gasta cada partida, y decides dónde recortar.

En esta clase repartimos ese presupuesto entre subsistemas, medimos cuánto consume cada uno y comprobamos si "cabe" en el objetivo. También tratamos dos conceptos que condicionan el reparto: la diferencia entre **estabilidad** (frame time constante) y **pico** (el tirón ocasional que rompe la fluidez), y el papel del **vsync** y de `Engine.max_fps` para no gastar recursos de más.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Calcular el presupuesto de frame en milisegundos para 30, 60 y 90 FPS.
2. Repartir ese presupuesto entre los subsistemas de un juego y justificar el reparto.
3. Medir cuánto consume cada sistema y comprobar si cabe en el objetivo.
4. Explicar por qué la estabilidad del frame time importa más que el FPS pico.
5. Configurar `Engine.max_fps`, `Engine.physics_ticks_per_second` y el vsync según el objetivo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El presupuesto de frame en ms | Es el total finito que reparten todos los sistemas. |
| 2 | 16.6 / 11.1 / 33.3 ms | Traduce cada objetivo de FPS a milisegundos concretos. |
| 3 | Reparto por subsistema | Evita que un sistema se coma el presupuesto de otros. |
| 4 | Estabilidad vs pico | Un tirón esporádico arruina la sensación de fluidez. |
| 5 | Vsync y desgarro (tearing) | Sincroniza el frame con el refresco del monitor. |
| 6 | `Engine.max_fps` | Limita FPS para ahorrar energía y calor. |
| 7 | `Engine.physics_ticks_per_second` | Fija el ritmo fijo de la física, independiente del render. |
| 8 | Margen de seguridad | Dejar holgura evita caídas en el peor caso. |

## 📖 Definiciones y características

- **Presupuesto de frame**: milisegundos disponibles por frame según el FPS objetivo. Clave: `1000 / fps_objetivo`.
- **16.6 ms**: presupuesto a 60 FPS. Clave: es el objetivo estándar de la mayoría de juegos.
- **Frame time estable**: variación baja entre frames consecutivos. Clave: la fluidez percibida depende de esto, no del promedio.
- **Pico (spike)**: frame aislado que supera el presupuesto. Clave: causa un tirón visible aunque el promedio sea bueno.
- **Vsync**: sincroniza la presentación del frame con el refresco del monitor. Clave: elimina el desgarro a costa de latencia.
- **`Engine.max_fps`**: tope de FPS del motor. Clave: `0` significa sin límite; un valor razonable ahorra recursos.
- **`Engine.physics_ticks_per_second`**: número de pasos de física por segundo (por defecto 60). Clave: desacopla la simulación del framerate de render.
- **Margen de seguridad**: parte del presupuesto que se deja libre. Clave: absorbe los picos del peor caso sin bajar de objetivo.

## 🧰 Herramientas y preparación

Trabajaremos con **Godot 4.x** midiendo desde código con `Time.get_ticks_usec()` y leyendo `Performance.get_monitor()`, apoyándonos en los **Monitors** del Debugger para ver la estabilidad del frame time en el tiempo. La configuración de vsync está en **Project Settings → Display → Window → V-Sync Mode**, y también se puede tocar por código con `DisplayServer`.

La guía relevante es "General optimization tips": <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>. Para los ajustes del motor consulta la clase `Engine`: <https://docs.godotengine.org/en/stable/classes/class_engine.html>.

## 🧪 Laboratorio guiado

Vamos a **definir un presupuesto de frame de 16.6 ms, medir cuánto gasta cada subsistema y comprobar si cabe**. Simularemos tres sistemas con costes distintos y los contabilizaremos contra el objetivo.

1. Crea un `Node2D` raíz `Juego` y adjúntale este script, que fija el objetivo y mide tres fases:

```gdscript
extends Node2D

const FPS_OBJETIVO: float = 60.0
var presupuesto_ms: float

var _fisica_us: int = 0
var _ia_us: int = 0
var _ui_us: int = 0

func _ready() -> void:
	presupuesto_ms = 1000.0 / FPS_OBJETIVO   # 16.6 ms a 60 FPS
	Engine.max_fps = int(FPS_OBJETIVO)        # no malgastar por encima del objetivo
	print("Presupuesto de frame: %.2f ms" % presupuesto_ms)

func _process(_delta: float) -> void:
	_ia_us = _medir(_sistema_ia)
	_ui_us = _medir(_sistema_ui)

func _physics_process(_delta: float) -> void:
	_fisica_us = _medir(_sistema_fisica)

func _medir(fn: Callable) -> int:
	var t0: int = Time.get_ticks_usec()
	fn.call()
	return Time.get_ticks_usec() - t0
```

2. Añade los tres subsistemas simulados y el chequeo de presupuesto por segundo:

```gdscript
func _sistema_fisica() -> void:
	var s: float = 0.0
	for i in 40000:
		s += sqrt(float(i))

func _sistema_ia() -> void:
	var s: float = 0.0
	for i in 25000:
		s += float(i) * 0.5

func _sistema_ui() -> void:
	var s: int = 0
	for i in 3000:
		s += i

func _chequear() -> void:
	var total_ms: float = (_fisica_us + _ia_us + _ui_us) / 1000.0
	print("Física=%.2f | IA=%.2f | UI=%.2f | TOTAL=%.2f / %.2f ms  %s"
		% [_fisica_us / 1000.0, _ia_us / 1000.0, _ui_us / 1000.0,
		   total_ms, presupuesto_ms,
		   "CABE" if total_ms <= presupuesto_ms else "NO CABE"])
```

3. Conecta un `Timer` de 1 s a `_chequear()` (como en la clase 240) y ejecuta con **F5**. **ANTES** de optimizar, lee el Output: si el total supera 16.6 ms verás `NO CABE`. Anota qué sistema domina el gasto.

4. Abre **Monitors** en el Debugger y observa **Frame Time**. Comprueba si la línea es estable o tiene picos. Un promedio de 15 ms con picos de 25 ms sigue produciendo tirones: la **estabilidad** manda.

5. **Reparte y recorta.** Supón que asignaste un presupuesto de 8 ms a física, 5 ms a IA y 2 ms a UI (más 1.6 ms de margen). Si la física se pasa, reduce su bucle de `40000` a `20000` y re-ejecuta. **DESPUÉS** el total debería caer por debajo de 16.6 ms y el chequeo mostrar `CABE`.

6. Experimenta con el objetivo: cambia `FPS_OBJETIVO` a `30.0`. El presupuesto sube a 33.3 ms y ahora todo cabe con holgura; súbelo a `90.0` y el presupuesto baja a 11.1 ms, volviendo el reparto mucho más exigente. Observa cómo `Engine.max_fps` sigue el objetivo.

Observable: el mismo juego "cabe" o "no cabe" según el objetivo, y la decisión de optimizar deja de ser vaga para volverse aritmética.

## ✍️ Ejercicios

1. Calcula a mano el presupuesto de frame para 24, 48, 72 y 120 FPS y verifícalo por código.
2. Asigna un presupuesto explícito por sistema (en ms) y marca en rojo el que se pase.
3. Introduce un pico artificial cada pocos segundos y observa cómo afecta a la estabilidad del Frame Time en Monitors.
4. Cambia `Engine.physics_ticks_per_second` a 30 y luego a 120 y describe el efecto en el coste de `_physics_process`.
5. Activa y desactiva el vsync en Project Settings y compara el frame time resultante.
6. Añade un margen de seguridad del 15% al presupuesto y decide si tu juego sigue cabiendo.

## 📝 Reto verificable

Diseña el presupuesto de frame de un juego objetivo 60 FPS: reparte los 16.6 ms entre al menos tres subsistemas dejando un margen de seguridad explícito. Instrumenta cada sistema, ejecuta 30 segundos y entrega un informe que muestre por segundo el gasto de cada sistema, el total y si cabe. Si no cabe, optimiza hasta que quepa manteniendo el margen.

**Criterio de aceptación**: el informe demuestra que la suma de subsistemas se mantiene bajo 16.6 ms incluyendo el margen definido, y el monitor Frame Time no muestra picos que superen el presupuesto de forma sostenida.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| "Promedio bueno pero se siente a tirones" | Tienes picos que rompen la estabilidad. Vigila el máximo por frame, no solo el promedio. |
| El juego consume 100% de CPU/GPU sin necesidad | `Engine.max_fps = 0` sin límite. Fija un tope acorde al objetivo para ahorrar energía. |
| La física cambia de coste al variar los FPS | Confundes render y simulación. La física corre a `physics_ticks_per_second`, no al framerate de render. |
| Desgarro horizontal en pantalla | Vsync desactivado. Actívalo en Display → Window → V-Sync si la latencia lo permite. |
| Presupuesto sin margen y caídas en el peor caso | Repartiste el 100% sin holgura. Reserva un 10-15% para absorber picos. |

## ❓ Preguntas frecuentes

**❓ ¿De dónde salen los 16.6 ms?** De `1000 ms / 60 frames`. Cada objetivo de FPS tiene su presupuesto: 11.1 ms a 90 y 33.3 ms a 30.

**❓ ¿Es mejor apuntar a 30 o a 60 FPS?** Depende del género y la plataforma. 60 da respuesta más fluida; 30 duplica el presupuesto y facilita meter más contenido por frame.

**❓ ¿El vsync mejora el rendimiento?** No lo mejora; sincroniza la presentación para eliminar el desgarro y evita renderizar de más, a costa de algo de latencia de entrada.

**❓ ¿Por qué separar física y render en el presupuesto?** Porque la física corre a paso fijo (`physics_ticks_per_second`) y el render a paso variable; presupuestarlos juntos oculta cuál se pasa.

## 🔗 Referencias

- Godot Docs — General optimization tips: <https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html>
- Godot Docs — Engine (clase): <https://docs.godotengine.org/en/stable/classes/class_engine.html>
- Godot Docs — Fixing jitter, stutter and physics interpolation: <https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html>
- Jason Gregory, "Game Engine Architecture", 3.ª ed., sección sobre el bucle de juego y frame timing.

## ➡️ Siguiente clase

[Clase 243 - Optimización de CPU: lógica, scripts y llamadas](../243-optimizacion-de-cpu-logica-scripts-y-llamadas/README.md)
