# Clase 237 — Rendimiento en XR

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Documentación de XR y del renderer Mobile de Godot 4, y guías de rendimiento de Meta Quest*
> ⏱️ Duración estimada: **85 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

En un juego plano, una caída de frames es una molestia; en VR, es un problema físico: por debajo del framerate objetivo del visor el cerebro detecta el desfase entre movimiento y visión y aparece el **mareo** (cybersickness). Por eso los 90 fps (o 72/120 según el visor) no son un lujo, son un requisito. Además hay que renderizar **dos veces**, una por ojo, con un presupuesto de frame diminuto. En esta clase aprenderás a presupuestar el frame en XR y a usar las herramientas del motor: **foveated rendering**, **MSAA**, el renderer **Mobile** para standalone (Quest) y la reducción de draw calls y overdraw.

En el laboratorio configurarás un proyecto VR para Quest —renderer Mobile, MSAA y foveation— medirás el framerate real y aplicarás optimizaciones hasta sostener el objetivo. El principio: medir primero, optimizar lo que de verdad cuesta.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar por qué el framerate bajo causa mareo y qué objetivo exige cada visor.
2. Calcular el presupuesto de frame en XR considerando el doble render.
3. Configurar el renderer Mobile y las opciones de VR para standalone.
4. Activar foveated rendering y MSAA y explicar su compromiso calidad/coste.
5. Medir el framerate y reducir draw calls y overdraw de forma dirigida.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El mareo y el framerate | Explica por qué 90 fps son obligatorios. |
| 2 | Presupuesto de frame en XR | Tienes ~11 ms para dos ojos a 90 fps. |
| 3 | Renderer Mobile | Necesario para standalone como Quest. |
| 4 | Foveated rendering | Ahorra píxeles fuera del centro de la vista. |
| 5 | MSAA | Antialiasing asequible y clave en VR. |
| 6 | Draw calls y batching | Cada llamada cuesta; menos es más rápido. |
| 7 | Overdraw | Pintar píxeles varias veces desperdicia GPU. |
| 8 | Medir antes de optimizar | Evita optimizar lo que no cuesta. |

## 📖 Definiciones y características

- **Cybersickness (mareo)**: malestar por desfase entre movimiento y visión. Clave: framerate bajo y latencia son las causas técnicas.
- **Framerate objetivo**: fps que el visor exige (72/90/120). Clave: fallarlo provoca reproyección y malestar.
- **Presupuesto de frame**: milisegundos por frame (1000/fps). Clave: a 90 fps son ~11 ms para renderizar **ambos** ojos.
- **Renderer Mobile**: backend de Godot optimizado para GPU móviles. Clave: obligatorio en standalone tipo Quest (export Android).
- **Foveated rendering**: renderiza a plena resolución el centro y baja la periferia. Clave: aprovecha que el ojo solo ve nítido el centro.
- **MSAA**: antialiasing por multimuestreo en los bordes. Clave: en VR es más eficiente que otras técnicas de suavizado.
- **Draw call**: orden de dibujo a la GPU. Clave: muchas llaman al cuello de botella de CPU; el batching las reduce.
- **Overdraw**: píxeles pintados varias veces por capas superpuestas. Clave: transparencias y geometría densa lo disparan.

## 🧰 Herramientas y preparación

Trabaja sobre un proyecto VR con OpenXR activado (clase 231). Para Quest necesitas los **export templates de Android** y el visor en modo desarrollador (por Link para iterar rápido, o exportando el APK). Cambia el backend de render en **Project → Project Settings → Rendering → Renderer** a **Mobile**. Ten a mano el **monitor de rendimiento** (Debug → Monitors) y la clase `Performance` para leer fps y draw calls por código.

Referencias: renderers de Godot en <https://docs.godotengine.org/en/stable/tutorials/rendering/index.html>, optimización en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html> y guías de Quest de Meta en <https://developer.oculus.com/documentation/>.

## 🧪 Laboratorio guiado

Configuraremos un proyecto VR para Quest y sostendremos el framerate objetivo.

1. En **Project Settings → Rendering → Renderer**, selecciona **Mobile**. Es el backend adecuado para la GPU del Quest y para el export Android que usa el standalone.

2. Activa el antialiasing MSAA en **Rendering → Anti Aliasing → MSAA 3D** a `2x`. En VR, MSAA suaviza bordes sin el coste de otras técnicas. Evita 4x salvo que sobre presupuesto.

3. Activa el foveated rendering de OpenXR. En el gestor XR, tras inicializar, sube el nivel de foveation para descargar la periferia:

```gdscript
extends Node3D

@onready var interfaz_xr: XRInterface = XRServer.find_interface("OpenXR")

func _ready() -> void:
	if interfaz_xr and interfaz_xr.is_initialized():
		get_viewport().use_xr = true
		# Foveation: 0 = off, valores altos = mas ahorro en periferia.
		get_viewport().vrs_mode = Viewport.VRS_XR
		print("Renderer Mobile + foveation activos.")
	else:
		push_error("OpenXR no inicializado.")
```

4. Añade un lector de framerate en pantalla para medir de verdad. Sin datos no se optimiza:

```gdscript
extends Label

func _process(_delta: float) -> void:
	var fps := Engine.get_frames_per_second()
	var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	text = "FPS: %d | Draw calls: %d" % [fps, draw_calls]
```

5. Ejecuta con el visor y lee el framerate. Si está por debajo del objetivo, no toques nada aún: identifica la causa. Mira las draw calls: si son altas, el cuello es CPU; si el framerate cae al acercarte a superficies grandes translúcidas, es overdraw.

6. Reduce draw calls: agrupa mallas estáticas que comparten material (usa instancias del mismo `Mesh`), desactiva sombras en objetos que no las necesitan y baja el número de luces dinámicas. Vuelve a medir tras **cada** cambio.

7. Reduce overdraw: elimina transparencias innecesarias, recorta partículas y evita geometría superpuesta. Sube MSAA solo si tras estabilizar el framerate sobra margen. El objetivo es un framerate estable en el número que pida tu visor, no picos altos con caídas.

Con el presupuesto controlado, la experiencia se siente fluida y cómoda. En la próxima clase añadimos audio espacial y hápticos.

## ✍️ Ejercicios

1. Mide el framerate con foveation activada y desactivada y compara la diferencia.
2. Duplica el número de objetos hasta que caiga el framerate y anota el límite.
3. Cambia MSAA de 2x a 4x y evalúa el impacto en fps.
4. Añade una superficie translúcida grande y observa el overdraw en el monitor.
5. Compara draw calls con y sin agrupar mallas del mismo material.
6. Registra el framerate mínimo durante un minuto de movimiento intenso.

## 📝 Reto verificable

Toma una escena VR que caiga por debajo del framerate objetivo y optimízala hasta sostenerlo de forma estable, usando renderer Mobile, MSAA y foveation, y reduciendo draw calls y overdraw. Documenta el framerate antes y después y qué cambio produjo cada mejora.

**Criterio de aceptación**: la escena mantiene el framerate objetivo del visor de forma estable durante movimiento, y el alumno puede señalar con datos medidos (fps y draw calls) qué optimización aportó cada ganancia.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El visor va a tirones y marea | Framerate por debajo del objetivo. Reduce carga hasta sostenerlo estable. |
| No mejora pese a optimizar | Optimizaste algo que no era el cuello. Mide antes: mira fps y draw calls. |
| Bordes muy dentados | MSAA desactivado o a 0. Súbelo a 2x en el renderer Mobile. |
| Framerate cae cerca de cristales/humo | Overdraw por transparencias. Reduce o elimina las capas translúcidas. |
| El export a Quest no arranca | Falta renderer Mobile o export templates Android. Configúralos antes de exportar. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué exactamente 90 fps y no 60?** Cada visor fija su objetivo (72/90/120). Por debajo, la reproyección y la latencia provocan mareo. Cumple el número de **tu** visor.

**❓ ¿El foveated rendering se nota?** Bien calibrado, apenas: el ojo solo ve nítido el centro. Un nivel excesivo sí deja borrosa la periferia.

**❓ ¿Uso renderer Forward+ o Mobile en Quest?** Mobile. Forward+ apunta a GPU de escritorio; el standalone necesita Mobile por el export Android.

**❓ ¿Optimizo antes de medir?** Nunca. Mide primero para saber si el cuello es CPU (draw calls) o GPU (overdraw/resolución) y ataca la causa real.

## 🔗 Referencias

- Godot Docs — Optimización: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Renderers: <https://docs.godotengine.org/en/stable/tutorials/rendering/index.html>
- Godot Docs — VRS y foveation: <https://docs.godotengine.org/en/stable/tutorials/3d/variable_rate_shading.html>
- Meta — Documentación para desarrolladores de Quest: <https://developer.oculus.com/documentation/>

## ➡️ Siguiente clase

[Clase 238 - Audio espacial y hápticos](../238-audio-espacial-y-hapticos/README.md)
