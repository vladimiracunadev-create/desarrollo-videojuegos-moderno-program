# Clase 203 — Input táctil y controles móviles

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (InputEventScreenTouch, TouchScreenButton)*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

En móvil no hay teclado ni gamepad: el dedo es el control. Godot 4 modela el toque con `InputEventScreenTouch` (presionar/soltar) e `InputEventScreenDrag` (arrastrar), soporta **multitouch** de forma nativa mediante el `index` de cada dedo, y ofrece nodos listos como `TouchScreenButton`. Con estas piezas se construyen los controles clásicos: **joystick virtual**, **botones táctiles** y **gestos**.

En esta clase implementamos un joystick virtual analógico que mueve un personaje y botones táctiles de acción, todo con código GDScript correcto. Además veremos cómo **emular toque desde el ratón** para probar en el editor sin un teléfono, y buenas prácticas de tamaño y zona para que los controles sean cómodos con el pulgar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Procesar `InputEventScreenTouch` e `InputEventScreenDrag` con su `index` para multitouch.
2. Construir un joystick virtual analógico que devuelva un `Vector2` de dirección.
3. Añadir botones táctiles con `TouchScreenButton` o `Control` y detectar sus pulsaciones.
4. Emular toque desde el ratón para probar en el editor.
5. Aplicar buenas prácticas de tamaño y ubicación de controles táctiles.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | `InputEventScreenTouch` | Detecta presionar y soltar el dedo. |
| 2 | `InputEventScreenDrag` | Detecta el arrastre para joystick/gestos. |
| 3 | Multitouch por `index` | Varios dedos a la vez (mover + disparar). |
| 4 | `TouchScreenButton` | Botón táctil listo para usar. |
| 5 | Joystick virtual | Dirección analógica con el pulgar. |
| 6 | Gestos (tap, swipe) | Interacciones naturales en móvil. |
| 7 | Emular toque desde ratón | Probar sin dispositivo físico. |
| 8 | Ergonomía del control | Tamaño y zona cómodos para el pulgar. |

## 📖 Definiciones y características

- **`InputEventScreenTouch`**: evento de dedo que baja o sube; trae `position`, `index` y `pressed`. Clave: base de todo input táctil.
- **`InputEventScreenDrag`**: evento de dedo que se mueve; trae `position` y `relative`. Clave: alimenta el joystick y los swipes.
- **`index` de toque**: identificador del dedo (0, 1, 2…). Clave: permite multitouch sin confundir dedos.
- **`TouchScreenButton`**: nodo con normal/pressed y forma de colisión que emite `pressed`/`released`. Clave: botón táctil sin código de detección.
- **Joystick virtual**: control on-screen que convierte el arrastre del dedo en un vector de dirección. Clave: reemplaza al stick del gamepad.
- **Emulate Touch From Mouse**: opción que traduce clics del ratón a toques. Clave: probar controles táctiles en el editor.
- **Emulate Mouse From Touch**: opción inversa; toques generan eventos de ratón. Clave: útil si tu UI está pensada para ratón.
- **Zona muerta (deadzone)**: radio mínimo antes de registrar dirección. Clave: evita jitter cuando el pulgar apenas se mueve.

## 🧰 Herramientas y preparación

Trabaja en tu proyecto del curso. Activa **Project → Project Settings → Input Devices → Pointing → Emulate Touch From Mouse** para probar los controles táctiles con el ratón en el editor. Prepara dos `TextureRect` o `Sprite2D` para la base y el pomo del joystick (basta con dos círculos), y un `CanvasLayer` para que los controles queden fijos sobre el juego.

Consulta `InputEventScreenTouch` y `InputEventScreenDrag` en <https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html#touch-events> y `TouchScreenButton` en <https://docs.godotengine.org/en/stable/classes/class_touchscreenbutton.html>. La guía de exportación a Android (clase 201) te permite probarlo luego en un teléfono real.

## 🧪 Laboratorio guiado

Construiremos un joystick virtual que mueve un personaje y un botón táctil de acción.

1. Crea un `CanvasLayer` llamado `HUD`. Dentro, añade un `Control` llamado `Joystick` con dos hijos: `Base` (círculo grande) y `Pomo` (círculo pequeño centrado en la base). Colócalo abajo a la izquierda.

2. Añade el script del joystick en `Joystick`. Detecta el toque dentro de su zona, sigue el arrastre y limita el pomo al radio de la base:

```gdscript
extends Control

@export var radio_max: float = 80.0
@export var deadzone: float = 0.15

var _index: int = -1            # dedo que controla el joystick (-1 = ninguno)
var _centro: Vector2
var direccion: Vector2 = Vector2.ZERO   # salida: -1..1 en cada eje

func _ready() -> void:
	_centro = $Base.position + $Base.size * 0.5
	$Pomo.position = _centro - $Pomo.size * 0.5

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _index == -1 and _dentro_de_base(event.position):
			_index = event.index          # este dedo controla el joystick
			_actualizar(event.position)
		elif not event.pressed and event.index == _index:
			_soltar()
	elif event is InputEventScreenDrag and event.index == _index:
		_actualizar(event.position)

func _dentro_de_base(pos_global: Vector2) -> bool:
	return (pos_global - global_position - _centro).length() <= radio_max * 1.5

func _actualizar(pos_global: Vector2) -> void:
	var local: Vector2 = pos_global - global_position - _centro
	var limitado: Vector2 = local.limit_length(radio_max)
	$Pomo.position = _centro + limitado - $Pomo.size * 0.5
	var d: Vector2 = limitado / radio_max
	direccion = d if d.length() > deadzone else Vector2.ZERO

func _soltar() -> void:
	_index = -1
	direccion = Vector2.ZERO
	$Pomo.position = _centro - $Pomo.size * 0.5
```

3. En tu personaje, lee la dirección del joystick cada frame de física. Suponiendo un `CharacterBody2D`:

```gdscript
extends CharacterBody2D

@export var velocidad: float = 250.0
@onready var joystick := get_node("../HUD/Joystick")

func _physics_process(_delta: float) -> void:
	velocity = joystick.direccion * velocidad
	move_and_slide()
```

4. Añade un **botón táctil** de acción. Crea un `TouchScreenButton`, asígnale una `Texture` normal y otra pressed, y una `CircleShape2D` como `shape`. Colócalo abajo a la derecha.

5. Conecta su señal `pressed` a un script para disparar o saltar:

```gdscript
extends TouchScreenButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("Botón de acción tocado")
	# aquí: disparar, saltar, etc.
```

6. Prueba en el editor: con **Emulate Touch From Mouse** activado, arrastra el ratón sobre la base del joystick para mover al personaje y haz clic en el botón para ver el mensaje. Como el joystick usa `index`, en un móvil podrás mover con un pulgar y pulsar el botón con el otro **a la vez**.

7. Exporta a Android (clase 201) y prueba multitouch real: mueve con el pulgar izquierdo mientras disparas con el derecho; ambos eventos llegan con `index` distinto y no se pisan.

Ya tienes un esquema táctil completo: joystick analógico multitouch más botón de acción, probable en editor y en dispositivo.

## ✍️ Ejercicios

1. Añade un segundo `TouchScreenButton` y haz que cada uno imprima una acción distinta.
2. Dibuja en pantalla el vector `direccion` del joystick en una `Label` para depurar.
3. Implementa un **swipe**: detecta `InputEventScreenDrag` con `relative` grande y dispara un dash.
4. Cambia la `deadzone` y observa cómo afecta la sensibilidad del control.
5. Haz que el joystick aparezca donde el jugador toca (joystick "flotante") en vez de fijo.
6. Detecta un **tap doble** midiendo el tiempo entre dos `InputEventScreenTouch` presionados.

## 📝 Reto verificable

Implementa un control táctil completo con **joystick virtual analógico** que mueva un personaje y **al menos un botón táctil** de acción, funcionando en **multitouch** (mover y actuar simultáneamente). Debe probarse en el editor con Emulate Touch From Mouse y, si tienes dispositivo, en un Android exportado.

**Criterio de aceptación**: el personaje se mueve en función del arrastre del joystick con zona muerta aplicada, el pomo se limita al radio de la base, el botón de acción emite su señal al tocarlo, y mover el joystick con un dedo mientras se pulsa el botón con otro funciona sin que un gesto anule al otro (verificado por `index` distintos).

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El joystick no responde al ratón en el editor | Falta activar Emulate Touch From Mouse en Project Settings → Input Devices → Pointing. |
| Al pulsar el botón se pierde el movimiento | No usas `index`; un dedo pisa al otro. Guarda el `index` del joystick y filtra los drags por él. |
| El pomo se sale de la base | No limitaste el vector. Usa `limit_length(radio_max)`. |
| El personaje se mueve solo (jitter) | Falta zona muerta. Anula `direccion` si su longitud < `deadzone`. |
| `TouchScreenButton` no dispara `pressed` | Le falta `shape` o la textura. Asigna una `CircleShape2D` y la textura normal. |
| Los controles se mueven con la cámara | No están en un `CanvasLayer`/HUD. Colócalos en un CanvasLayer fijo. |

## ❓ Preguntas frecuentes

**❓ ¿Cómo distingo un dedo de otro en multitouch?** Cada evento táctil trae un `index`. Asocia cada control al `index` del dedo que lo inició y filtra los `InputEventScreenDrag` por ese mismo `index`.

**❓ ¿Puedo usar mis acciones del Input Map en táctil?** Sí: `TouchScreenButton` tiene una propiedad **Action** que dispara una acción del Input Map, de modo que tu gameplay siga leyendo `Input.is_action_pressed(...)` igual que con teclado o gamepad.

**❓ ¿Necesito un móvil para desarrollar controles táctiles?** No para iterar: con Emulate Touch From Mouse pruebas gestos de un dedo en el editor. Para multitouch real sí conviene exportar a un dispositivo.

**❓ ¿`InputEventScreenDrag` reemplaza a `InputEventScreenTouch`?** No: `ScreenTouch` marca cuándo baja o sube el dedo; `ScreenDrag` marca su movimiento mientras está presionado. Se usan juntos.

## 🔗 Referencias

- Godot Docs — InputEvent, eventos táctiles: <https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html>
- Godot Docs — Clase InputEventScreenTouch: <https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html>
- Godot Docs — Clase InputEventScreenDrag: <https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html>
- Godot Docs — Clase TouchScreenButton: <https://docs.godotengine.org/en/stable/classes/class_touchscreenbutton.html>

## ➡️ Siguiente clase

[Clase 204 - Rendimiento y batería en móvil](../204-rendimiento-y-bateria-en-movil/README.md)
