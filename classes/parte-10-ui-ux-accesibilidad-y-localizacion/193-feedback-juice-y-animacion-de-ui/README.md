# Clase 193 — Feedback, juice y animación de UI

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (Tween) · Jan Willem Nijman, "The Art of Screenshake"*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Dar vida a la interfaz con **feedback** inmediato y **juice**: esas microanimaciones y respuestas que hacen que pulsar un botón se sienta satisfactorio. Un botón que crece un poco al pasar el ratón, se hunde al pulsarse y emite un "pop" al conceder una recompensa comunica interactividad y refuerza cada acción sin que el jugador tenga que pensarlo.

En Godot 4 esto se logra con `create_tween()`, que anima cualquier propiedad (escala, color, posición) de forma fluida, combinado con las señales de estado del Control (`mouse_entered`, `button_down`, `pressed`) y sonidos de UI. La clave del buen juice es **sumar sin distraer**: animaciones cortas, coherentes y que nunca estorben a la lectura. El laboratorio anima botones con hover y press, crea un "pop" de recompensa y añade sonido.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es el feedback y por qué el juice mejora la sensación de uso.
2. Animar propiedades de un Control (escala, color) con `create_tween()`.
3. Reaccionar a estados de hover y press mediante señales del Button.
4. Crear un efecto "pop" de recompensa con escala y desvanecimiento.
5. Añadir sonido de UI y ajustar la intensidad del juice para no distraer.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Feedback inmediato | Confirma que la acción tuvo efecto. |
| 2 | Estados hover/press | Comunican que un elemento es interactivo. |
| 3 | Tween de UI | Anima propiedades con suavidad. |
| 4 | Easing y transiciones | Definen el carácter del movimiento. |
| 5 | Pivote de escala | Decide desde dónde crece el widget. |
| 6 | Efecto "pop" | Celebra recompensas y logros. |
| 7 | Sonido de UI | Refuerza el feedback por otro canal. |
| 8 | Juice sin distraer | Sumar sensación sin robar atención. |

## 📖 Definiciones y características

- **Feedback**: respuesta perceptible del sistema a una acción del jugador. Clave: debe ser inmediata para sentirse conectada.
- **Juice**: capa de microdetalles (rebotes, brillos, sonidos) que hacen agradable la interacción. Clave: mucho valor percibido por poco coste.
- **Tween**: objeto que interpola una propiedad de un valor a otro en un tiempo dado. Clave: se crea con `create_tween()` y se descarta solo.
- **Transición (Trans)**: curva de la interpolación (lineal, elástica, back). Clave: da personalidad al movimiento.
- **Easing (Ease)**: cómo se aplica la curva (in, out, in_out). Clave: `EASE_OUT` arranca rápido y frena, útil en UI.
- **pivot_offset**: punto desde el que un Control rota y escala. Clave: centrarlo evita que el widget "salte" al crecer.
- **modulate**: color/opacidad multiplicador de un nodo. Clave: animar `modulate:a` hace fundidos sin tocar el material.
- **AudioStreamPlayer**: nodo que reproduce un sonido. Clave: para UI, uno por efecto o reutilizado con distintos streams.

## 🧰 Herramientas y preparación

Trabaja en **Godot 4.x** con la pantalla de botones de clases anteriores. Consigue dos sonidos cortos de UI (un "tick" para hover/click y un "pop" para recompensa); sirven `.wav` u `.ogg` libres, por ejemplo de <https://kenney.nl/assets> (packs de UI Audio). Impórtalos a `res://audio/`.

Referencia clave: la clase **Tween** (<https://docs.godotengine.org/en/stable/classes/class_tween.html>) y el tutorial de tweens (<https://docs.godotengine.org/en/stable/tutorials/animation/using_the_tween_class.html>). El concepto de "juice" viene de charlas clásicas de diseño de sensación de juego.

## 🧪 Laboratorio guiado

Animaremos un botón con hover y press, crearemos un "pop" de recompensa y añadiremos sonido. Todo con Tween.

1. Parte de una escena con un **Button** (`Boton`) centrado y un **Label** (`Pop`) para la recompensa, ambos hijos de un `Control` raíz. Añade dos **AudioStreamPlayer**: `SfxTick` y `SfxPop`, y asígnales tus sonidos en el Inspector (**Stream**).

2. Para que la escala no "salte", centra el pivote del botón. Con `Boton` seleccionado, añádele el script `boton_juice.gd`:

```gdscript
extends Button

@onready var sfx_tick: AudioStreamPlayer = get_node("../SfxTick")
var _escala_base := Vector2.ONE

func _ready() -> void:
	# Centramos el pivote para que escale desde su centro.
	pivot_offset = size / 2.0
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_salir)
	button_down.connect(_on_press)
	button_up.connect(_on_release)

func _animar_escala(destino: Vector2, dur: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", destino, dur) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_hover() -> void:
	_animar_escala(_escala_base * 1.08, 0.12)
	sfx_tick.play()

func _on_salir() -> void:
	_animar_escala(_escala_base, 0.12)

func _on_press() -> void:
	# Se hunde al pulsar: feedback tactil.
	_animar_escala(_escala_base * 0.92, 0.06)

func _on_release() -> void:
	_animar_escala(_escala_base * 1.08, 0.10)
```

3. Ejecuta con **F6**. Pasa el ratón por el botón: crece suavemente con un ligero rebote (TRANS_BACK) y suena el tick. Al pulsar se hunde; al soltar rebota. Ese ciclo hover → press → release es feedback puro.

4. Ahora el **"pop" de recompensa**. Selecciona el `Control` raíz y añade `pop_recompensa.gd`:

```gdscript
extends Control

@onready var pop: Label = $Pop
@onready var sfx_pop: AudioStreamPlayer = $SfxPop

func _ready() -> void:
	pop.pivot_offset = pop.size / 2.0
	pop.modulate.a = 0.0

func mostrar_pop(texto: String) -> void:
	pop.text = texto
	pop.scale = Vector2(0.3, 0.3)
	pop.modulate.a = 1.0
	sfx_pop.play()
	# Un solo Tween con varios pasos: crece, y luego se desvanece.
	var tween := create_tween()
	tween.tween_property(pop, "scale", Vector2(1.2, 1.2), 0.18) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "scale", Vector2.ONE, 0.10)
	tween.tween_interval(0.4)
	tween.tween_property(pop, "modulate:a", 0.0, 0.3)
```

5. Dispara el pop desde el botón: en `boton_juice.gd`, conecta `pressed` para llamar al pop del padre. Añade en su `_ready()`:

```gdscript
	pressed.connect(func(): get_parent().mostrar_pop("+100"))
```

6. Ejecuta de nuevo y pulsa el botón. Aparece "+100" que crece con rebote, se asienta y se desvanece, acompañado del sonido "pop". Esa celebración breve es el tipo de recompensa que engancha sin entorpecer.

7. Ahora el equilibrio **sin distraer**: exagera a propósito el hover a `* 1.5` y una duración de `0.5 s`. Ejecuta y nota cómo se siente tosco y lento. Vuelve a valores pequeños (`1.08`, `0.12 s`): el buen juice es sutil. Regla práctica: animaciones de UI entre 0.08 y 0.25 s.

8. Verifica la coherencia: todos los botones deben usar la misma animación. Reutiliza `boton_juice.gd` en cada Button para que el feedback sea uniforme en toda la interfaz.

## ✍️ Ejercicios

1. Cambia la transición del hover a `TRANS_ELASTIC` y compara la sensación con `TRANS_BACK`.
2. Añade un ligero cambio de color en hover con `modulate` además de la escala.
3. Haz que el "pop" suba unos píxeles mientras se desvanece (anima también `position:y`).
4. Reproduce un tono ligeramente distinto en el press que en el hover usando dos streams.
5. Aplica el script de juice a una fila de tres botones y confirma que se sienten idénticos.
6. Añade un `set_parallel(true)` para animar escala y color a la vez y observa la diferencia.

## 📝 Reto verificable

Crea un botón "Reclamar" con feedback completo: hover (crece + sonido), press (se hunde), release (rebota) y, al confirmar, un "pop" de recompensa "+250" que crece, se asienta y se desvanece con sonido. Todas las animaciones deben durar menos de 0.3 s y el pivote debe estar centrado para que nada salte.

**Criterio de aceptación**: el botón responde visual y sonoramente a hover, press y release; al pulsarlo aparece el pop animado con sonido; ninguna animación supera 0.3 s ni desplaza el botón de su sitio por un pivote mal puesto.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El botón "salta" al escalar | `pivot_offset` no está centrado; ponlo en `size / 2.0`. |
| La animación se corta a medias | Un Tween nuevo cada frame; crea uno por evento, no en `_process`. |
| El pop no reaparece | `modulate.a` quedó en 0; reinícialo a 1 al mostrarlo. |
| El sonido no suena | El AudioStreamPlayer no tiene `Stream` asignado o el bus está en silencio. |
| El juice marea | Duraciones o escalas demasiado grandes; baja a 0.08–0.25 s y ~1.1x. |

## ❓ Preguntas frecuentes

**❓ ¿Tween o AnimationPlayer?** Tween es ideal para animaciones cortas y creadas por código; AnimationPlayer conviene para secuencias largas y editadas a mano.

**❓ ¿Por qué centrar el pivote?** Porque por defecto los Control escalan desde la esquina superior izquierda, lo que hace que el widget se desplace al crecer.

**❓ ¿Cuánta animación es demasiada?** Si distrae de la lectura o retrasa la respuesta, es demasiada. El juice debe sentirse, no notarse conscientemente.

**❓ ¿Debo animar todos los botones igual?** Sí: la consistencia del feedback hace que la interfaz se sienta pulida y predecible.

## 🔗 Referencias

- Godot Docs — Tween: <https://docs.godotengine.org/en/stable/classes/class_tween.html>
- Godot Docs — Using the Tween class: <https://docs.godotengine.org/en/stable/tutorials/animation/using_the_tween_class.html>
- Godot Docs — AudioStreamPlayer: <https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html>
- Kenney — UI Audio (assets libres): <https://kenney.nl/assets/interface-sounds>

## ➡️ Siguiente clase

[Clase 194 - UI responsive: múltiples resoluciones y aspect ratios](../194-ui-responsive-multiples-resoluciones-y-aspect-ratios/README.md)
