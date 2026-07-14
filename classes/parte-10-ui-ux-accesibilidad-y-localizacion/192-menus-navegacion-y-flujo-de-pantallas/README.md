# Clase 192 — Menús, navegación y flujo de pantallas

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (GUI navigation, InputMap)*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Diseñar el **flujo de pantallas** de un juego: cómo el jugador pasa del menú principal a opciones y vuelve, cómo se apilan menús (una **pila de pantallas**) y cómo se navega con **teclado y gamepad** además del ratón. Un menú que solo funciona con clic deja fuera a mucha gente; el foco navegable es un requisito básico de calidad y accesibilidad.

En Godot 4 la navegación por foco usa las acciones `ui_up/ui_down/ui_left/ui_right/ui_accept` y las propiedades `focus_neighbor_*` de cada Control, más `grab_focus()` para dar el foco inicial. El laboratorio arma un menú principal que abre opciones, mantiene una pila de menús para el botón "atrás" y permite recorrer todo con las flechas o el stick del mando.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Modelar el flujo de pantallas de un juego como una máquina de pantallas simple.
2. Implementar una pila de menús para gestionar el botón "atrás" de forma consistente.
3. Configurar la navegación por foco con `focus_neighbor_*` y `grab_focus()`.
4. Usar las acciones `ui_*` para navegar y confirmar con teclado y gamepad.
5. Añadir transiciones básicas entre pantallas sin romper la navegación.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Máquina de pantallas | Ordena qué pantalla está activa. |
| 2 | Pila de menús | Da un "atrás" coherente y anidado. |
| 3 | Foco de UI | Permite navegar sin ratón. |
| 4 | focus_neighbor_* | Define a dónde salta el foco. |
| 5 | grab_focus | Establece el punto de entrada al abrir. |
| 6 | Acciones ui_* | Unifican teclado y gamepad. |
| 7 | Transiciones | Suavizan el cambio de pantalla. |
| 8 | Accesibilidad de menús | Todo jugador debe poder navegar. |

## 📖 Definiciones y características

- **Máquina de pantallas**: lógica que decide qué pantalla se muestra y oculta el resto. Clave: evita que dos menús estén activos a la vez.
- **Pila de menús (stack)**: estructura LIFO que recuerda el orden de apertura. Clave: el "atrás" saca el último menú apilado.
- **Foco**: Control que recibe la entrada de teclado/gamepad. Clave: solo uno tiene el foco por vez y debe verse resaltado.
- **focus_neighbor_***: propiedad que indica qué Control recibe el foco al pulsar cada dirección. Clave: se puede definir a mano o dejar que Godot lo infiera.
- **grab_focus()**: método que da el foco a un Control por código. Clave: llámalo al abrir un menú para que el mando funcione desde el primer instante.
- **ui_accept**: acción por defecto para "confirmar" (Enter, Espacio, botón A). Clave: dispara `pressed` en el botón enfocado.
- **InputMap**: mapa de acciones a teclas/botones. Clave: las acciones `ui_*` ya vienen definidas y son configurables.
- **Transición**: animación breve al cambiar de pantalla (fundido, deslizamiento). Clave: da continuidad sin marear.

## 🧰 Herramientas y preparación

Trabaja en **Godot 4.x**. Ten conectado un **gamepad** si puedes, aunque todo se prueba también con las flechas del teclado y Enter. Revisa en **Project → Project Settings → Input Map** que existan `ui_up`, `ui_down`, `ui_accept`, etc. (vienen por defecto).

Referencia principal: **GUI navigation** (<https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html>), que explica el foco y los vecinos. Para la entrada, **InputEvent / InputMap** (<https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html>).

## 🧪 Laboratorio guiado

Montaremos un menú principal con botones "Jugar", "Opciones" y "Salir", una pantalla de opciones y una pila que gestione el "atrás". Todo navegable con teclado y mando.

1. Crea una escena raíz **Control** (`MenuManager`) con preset **Full Rect**. Cuelga de ella dos hijos **Control**: `MenuPrincipal` y `Opciones`, cada uno también Full Rect.

2. En `MenuPrincipal` añade un **CenterContainer** con un **VBoxContainer** dentro y tres **Button**: `Jugar`, `Opciones`, `Salir`. En `Opciones` añade otro VBoxContainer con un **HSlider** (`Volumen`) y un **Button** `Atras`.

3. Deja visible solo `MenuPrincipal` al inicio: selecciona `Opciones` y desmarca su `visible` en el Inspector.

4. Attach script al nodo `MenuManager`, guarda como `menu_manager.gd`:

```gdscript
extends Control

@onready var menu_principal: Control = $MenuPrincipal
@onready var opciones: Control = $Opciones
@onready var boton_jugar: Button = $MenuPrincipal/CenterContainer/VBoxContainer/Jugar
@onready var boton_opciones: Button = $MenuPrincipal/CenterContainer/VBoxContainer/Opciones
@onready var boton_salir: Button = $MenuPrincipal/CenterContainer/VBoxContainer/Salir
@onready var boton_atras: Button = $Opciones/VBoxContainer/Atras

# Pila de pantallas: la cima es la pantalla activa.
var pila: Array[Control] = []

func _ready() -> void:
	boton_jugar.pressed.connect(_on_jugar)
	boton_opciones.pressed.connect(func(): _abrir(opciones))
	boton_salir.pressed.connect(_on_salir)
	boton_atras.pressed.connect(_cerrar_actual)
	_abrir(menu_principal)

func _abrir(pantalla: Control) -> void:
	if not pila.is_empty():
		pila.back().hide()
	pantalla.show()
	pila.push_back(pantalla)
	# Damos el foco al primer boton para que el gamepad funcione ya.
	_enfocar_primero(pantalla)

func _cerrar_actual() -> void:
	if pila.size() <= 1:
		return  # No cerramos el menu raiz.
	var actual := pila.pop_back()
	actual.hide()
	pila.back().show()
	_enfocar_primero(pila.back())

func _enfocar_primero(pantalla: Control) -> void:
	for boton in pantalla.find_children("*", "Button", true, false):
		boton.grab_focus()
		return

func _on_jugar() -> void:
	print("Iniciar partida")

func _on_salir() -> void:
	get_tree().quit()

func _unhandled_input(evento: InputEvent) -> void:
	# 'ui_cancel' (Esc / boton B) actua como 'atras'.
	if evento.is_action_pressed("ui_cancel"):
		_cerrar_actual()
```

5. Configura los **vecinos de foco** para el menú principal. Selecciona `Jugar` y en el Inspector, sección **Focus**, pon `focus_neighbor_bottom` apuntando a `Opciones` y en `Opciones` el `focus_neighbor_top` a `Jugar`, y así con `Salir`. Godot suele inferirlos en un VBox, pero definirlos a mano garantiza el recorrido.

6. Ejecuta con **F6**. Con solo el teclado: usa flechas arriba/abajo para mover el foco (el botón enfocado se resalta), Enter para confirmar. Entra a "Opciones" y pulsa "Atras" o Esc para volver: la pila devuelve al menú principal.

7. Prueba el gamepad: la cruceta/stick mueve el foco (`ui_up/ui_down`) y el botón A confirma (`ui_accept`). Nunca deberías necesitar el ratón.

8. Añade una **transición** simple: envuelve el `show()` con un fundido. En `_abrir`, antes de `push_back`, anima la opacidad:

```gdscript
	pantalla.modulate.a = 0.0
	pantalla.show()
	var tween := create_tween()
	tween.tween_property(pantalla, "modulate:a", 1.0, 0.2)
```

Ejecuta de nuevo: cada pantalla aparece con un fundido de 0.2 s sin perder el foco ni la navegación.

## ✍️ Ejercicios

1. Añade una tercera pantalla "Créditos" y apílala desde Opciones para probar dos niveles de "atrás".
2. Cambia el fundido por un deslizamiento horizontal usando `tween_property` sobre `position:x`.
3. Haz que el botón que tenía el foco al salir de un menú lo recupere al volver.
4. Añade sonido al mover el foco conectando la señal `focus_entered` de cada botón.
5. Configura los `focus_neighbor_*` para un menú en dos columnas (GridContainer) y verifica la navegación en cruz.
6. Impide que "Atras" cierre el menú raíz mostrando en su lugar un diálogo de "¿Salir del juego?".

## 📝 Reto verificable

Construye un flujo de tres pantallas (Principal → Opciones → Controles) con una pila que gestione el "atrás" en ambos niveles, navegación completa por teclado y gamepad (foco inicial siempre puesto con `grab_focus`), y una transición de fundido. Al llegar al menú raíz, "atrás"/Esc no debe cerrarlo.

**Criterio de aceptación**: se puede recorrer y confirmar todo sin ratón; "atrás" vuelve exactamente una pantalla cada vez; en el menú raíz Esc no hace nada; cada pantalla que se abre tiene un botón con el foco puesto.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El gamepad no mueve el foco | No se llamó a `grab_focus()` al abrir; ningún Control tiene el foco. |
| "Atrás" cierra de más | La pila se vacía; protege con `if pila.size() <= 1: return`. |
| El foco no se ve | El Theme no tiene stylebox `focus`; añádelo para resaltar. |
| Dos menús visibles a la vez | No se ocultó el anterior antes de mostrar el nuevo. |
| Esc no funciona | La acción `ui_cancel` no está mapeada o el input se consume antes. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué una pila y no variables sueltas?** La pila escala a menús anidados y da un "atrás" coherente sin lógica especial por pantalla.

**❓ ¿Debo definir todos los `focus_neighbor_*`?** En contenedores lineales Godot los infiere; en layouts complejos conviene fijarlos para evitar saltos raros.

**❓ ¿Cómo garantizo que el mando funcione al abrir un menú?** Llamando a `grab_focus()` sobre el primer control cada vez que la pantalla aparece.

**❓ ¿Las transiciones afectan al foco?** No si animas solo propiedades visuales (opacidad, posición) y mantienes el `grab_focus` tras mostrar la pantalla.

## 🔗 Referencias

- Godot Docs — GUI navigation: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html>
- Godot Docs — InputEvent: <https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html>
- Godot Docs — Control (focus): <https://docs.godotengine.org/en/stable/classes/class_control.html>
- Godot Docs — Tween: <https://docs.godotengine.org/en/stable/classes/class_tween.html>

## ➡️ Siguiente clase

[Clase 193 - Feedback, juice y animación de UI](../193-feedback-juice-y-animacion-de-ui/README.md)
