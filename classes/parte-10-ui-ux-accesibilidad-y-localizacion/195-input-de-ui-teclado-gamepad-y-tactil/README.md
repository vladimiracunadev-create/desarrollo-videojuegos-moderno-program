# Clase 195 — Input de UI: teclado, gamepad y táctil

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 — GUI navigation e InputEvent*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un menú que solo funciona con ratón excluye a una gran parte de tus jugadores: quien juega con mando en el sofá, quien navega por teclado por accesibilidad y quien toca la pantalla en móvil. Godot 4 trae un sistema de **navegación por foco** con las acciones `ui_*` que resuelve teclado y gamepad casi gratis, pero hay que ordenarlo bien y complementarlo con controles táctiles pensados para dedos, no para punteros.

En esta clase construirás un menú completamente navegable con **gamepad y teclado** mediante el foco, definirás un **orden de foco** coherente, y añadirás **soporte táctil** con `TouchScreenButton` y eventos `InputEventScreenTouch`. El objetivo es que los tres esquemas de entrada funcionen a la vez, sin que uno rompa a los otros.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Usar las acciones `ui_up/down/left/right/accept` para navegar UI con teclado y gamepad.

2. Definir un orden de foco explícito con `focus_neighbor_*` y `focus_next`.

3. Garantizar que siempre haya un control enfocado con `grab_focus()`.

4. Añadir controles táctiles con `TouchScreenButton` y targets de tamaño adecuado.

5. Procesar eventos `InputEventScreenTouch`/`InputEventScreenDrag` para gestos básicos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Sistema de foco de Control | Es la base de la navegación sin ratón. |
| 2 | Acciones `ui_*` predefinidas | Mapean teclado y gamepad a la UI automáticamente. |
| 3 | `focus_mode` y `grab_focus()` | Deciden qué puede enfocarse y qué está activo. |
| 4 | Orden de foco (`focus_neighbor`) | Evita saltos ilógicos entre botones. |
| 5 | Indicador visual de foco | Sin él, el jugador no sabe dónde está. |
| 6 | `TouchScreenButton` y targets | Botones pensados para dedos, no punteros. |
| 7 | `InputEventScreenTouch/Drag` | Permiten gestos y arrastres personalizados. |
| 8 | Convivencia de los tres inputs | Un mismo menú debe servir para todos. |

## 📖 Definiciones y características

- **Foco (focus)**: estado de "elemento activo" que recibe la entrada del teclado/gamepad. Clave: solo un Control tiene foco a la vez.

- **Acción `ui_accept`**: acción integrada mapeada a Enter/Espacio y al botón A del mando. Clave: dispara el botón enfocado sin código extra.

- **`focus_mode`**: propiedad que define si un Control es enfocable (`All`, `Click`, `None`). Clave: los `Button` son `All` por defecto; los `Label` no.

- **`grab_focus()`**: fuerza el foco a un control concreto. Clave: llámalo en `_ready` para que el menú arranque con algo seleccionado.

- **`focus_neighbor_*`**: define manualmente qué control recibe el foco al pulsar cada dirección. Clave: sobreescribe la deducción automática cuando el layout es irregular.

- **`TouchScreenButton`**: nodo específico para pantallas táctiles con textura normal y presionada. Clave: no depende del sistema de foco, responde al toque directo.

- **Target táctil**: área mínima recomendada para pulsar con el dedo (≈48×48 dp). Clave: por debajo, los toques fallan y frustran.

- **`InputEventScreenTouch`**: evento con `position`, `index` (dedo) y `pressed`. Clave: base para detectar toques y multitáctil.

## 🧰 Herramientas y preparación

Usaremos **Godot 4.x**. Las acciones `ui_*` ya vienen definidas en cada proyecto (puedes verlas en **Project Settings > Input Map** activando *Show Built-in Actions*). Conecta un mando por USB o Bluetooth si quieres probar el gamepad; si no, el teclado ejercita el mismo sistema de foco. Para probar el táctil sin dispositivo, activa en *Project Settings > Input Devices > Pointing* la opción **Emulate Touch From Mouse**, que convierte clics del ratón en eventos de toque. Ten a mano la guía de [GUI navigation](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html) y las pautas de tamaño de objetivo táctil de <https://gameaccessibilityguidelines.com/>.

## 🧪 Laboratorio guiado

Haremos un menú navegable con foco (teclado/gamepad) y le añadiremos un botón táctil.

1. Crea una escena con raíz `Control` (`Menu`), y dentro un `VBoxContainer` centrado con el preset **Center**. Añade tres `Button`: `BtnJugar`, `BtnOpciones`, `BtnSalir`, con sus textos.

2. Como los botones están en un `VBoxContainer`, el foco vertical ya funciona. Añade un script a `Menu` para dar foco inicial y reaccionar:

```gdscript
extends Control

@onready var boton_jugar: Button = $VBoxContainer/BtnJugar

func _ready() -> void:
	# Siempre debe haber algo enfocado al abrir el menú.
	boton_jugar.grab_focus()
	# Conectamos las señales de cada botón.
	$VBoxContainer/BtnJugar.pressed.connect(func(): print("Jugar"))
	$VBoxContainer/BtnOpciones.pressed.connect(func(): print("Opciones"))
	$VBoxContainer/BtnSalir.pressed.connect(func(): get_tree().quit())
```

3. Ejecuta (F6). Navega con **flechas del teclado** (o la cruceta/stick del mando) entre los tres botones y pulsa **Enter/Espacio** o **A** del mando: se imprime la acción. Ya tienes teclado + gamepad.

4. Mejora el **indicador de foco**. Crea un `Theme` (o edita el existente): en el `StyleBox` `focus` del `Button` añade un borde de 2 px de color contrastado. Ahora se ve claramente qué botón está activo. Sin este paso, la navegación es invisible.

5. Define un **orden de foco explícito** por si el layout crece. Selecciona `BtnSalir` y en el inspector, sección *Focus*, pon `Focus Neighbor Bottom` apuntando a `BtnJugar` (para que bajar desde el último vuelva al primero, foco cíclico). Repite con `Focus Neighbor Top` de `BtnJugar` → `BtnSalir`.

6. Añade **soporte táctil**. Crea un `TouchScreenButton` como hijo de `Menu`, asígnale una textura normal y otra presionada (o dos `ColorRect` exportados como PNG), y colócalo en una esquina como botón de "atrás". Conéctalo:

```gdscript
func _ready_touch() -> void:
	var atras: TouchScreenButton = $TouchScreenButton
	atras.pressed.connect(func(): print("Atras (tactil)"))
```

7. Para gestos personalizados, procesa eventos de toque en `_input`:

```gdscript
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		print("Toque en ", event.position, " dedo ", event.index)
	elif event is InputEventScreenDrag:
		print("Arrastre a ", event.position)
```

8. Activa **Emulate Touch From Mouse** y ejecuta: haz clic (=toque) sobre el `TouchScreenButton` y arrastra por la pantalla; la consola muestra los eventos. Verifica que el teclado, el mando y el táctil funcionan **a la vez** sin interferir.

**Entregable observable**: un menú de tres botones navegable con teclado y gamepad (foco visible y cíclico) más un botón táctil funcional y registro de eventos de toque/arrastre en consola.

## ✍️ Ejercicios

1. Añade un cuarto botón y ajusta los `focus_neighbor` para mantener el foco cíclico.

2. Cambia el color del `StyleBox` de foco y comprueba que el contraste es suficiente para verse.

3. Impide que el foco se pierda: si el usuario cierra un submenú, devuelve el foco al botón que lo abrió con `grab_focus()`.

4. Aumenta el tamaño de los `TouchScreenButton` hasta ≥48×48 px y comenta por qué importa en móvil.

5. Detecta un gesto de "deslizar hacia la izquierda" comparando la `position` inicial y final de un `InputEventScreenDrag`.

6. Haz que `ui_cancel` (Esc / botón B) cierre el menú desde cualquier botón.

## 📝 Reto verificable

Construye un menú principal con al menos cuatro opciones que sea 100% operable con teclado, con gamepad y con toques, con foco inicial garantizado, foco visible y navegación cíclica, más un control táctil dedicado.

**Criterio de aceptación**: al iniciar hay un botón enfocado; se puede recorrer todo el menú y activarlo solo con teclado, solo con gamepad y solo con toques; el foco siempre es visible y nunca se "pierde"; el control táctil responde y sus eventos se registran.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El gamepad no mueve la selección | No hay foco inicial. Llama a `grab_focus()` en `_ready`. |
| No se ve qué botón está seleccionado | Falta estilo de foco. Añade un `StyleBox` `focus` con borde contrastado. |
| El foco salta a botones en desorden | Layout irregular sin `focus_neighbor`. Define vecinos manualmente. |
| Los botones táctiles son difíciles de acertar | Targets demasiado pequeños. Amplía a ≥48×48 px. |
| El táctil no dispara en el editor | No se emula. Activa *Emulate Touch From Mouse*. |

## ❓ Preguntas frecuentes

**❓ ¿Necesito programar la navegación con mando?** No; las acciones `ui_*` ya mapean el gamepad. Solo ordenas el foco y das feedback visual.

**❓ ¿`Button` normal o `TouchScreenButton` en móvil?** Un `Button` responde al toque igualmente; usa `TouchScreenButton` cuando necesites control fino, multitáctil o un botón siempre visible sobre el juego.

**❓ ¿Cómo evito que el ratón robe el foco al mando?** Diseña para que el foco persista; en Godot puedes reforzar el foco tras cada acción con `grab_focus()` y evitar `focus_mode = Click` innecesario.

**❓ ¿Qué tamaño mínimo debe tener un botón táctil?** Las pautas recomiendan alrededor de 48×48 dp; más grande para acciones frecuentes o públicos con dificultades motoras.

## 🔗 Referencias

- Godot — GUI navigation: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html>

- Godot — InputEvent: <https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html>

- Godot — TouchScreenButton: <https://docs.godotengine.org/en/stable/classes/class_touchscreenbutton.html>

- Game Accessibility Guidelines (tamaño de objetivos): <https://gameaccessibilityguidelines.com/>

## ➡️ Siguiente clase

[Clase 196 - Accesibilidad en juegos](../196-accesibilidad-en-juegos/README.md)
