# Clase 190 — Theming y estilos de UI escalables

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (GUI skinning and themes, StyleBoxes)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Aprender a separar el **aspecto** de la UI de su **estructura** usando el recurso **Theme** de Godot 4. En vez de estilizar cada botón a mano, defines un Theme con estilos, colores y fuentes por tipo de nodo (Button, Panel, Label) y lo aplicas una sola vez: toda la UI hereda el mismo look, y cambiar la piel del juego se vuelve trivial.

Trabajaremos con **StyleBoxFlat** (rectángulos con relleno, bordes y esquinas redondeadas), con los **overrides** puntuales (`add_theme_*_override`) para casos especiales, y con las **variaciones de tipo** (type variations) que permiten tener, por ejemplo, un botón "peligroso" rojo sin duplicar el Theme. El laboratorio construye un Theme reutilizable y lo aplica a la pantalla de la clase 189.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Crear un recurso Theme y asignarlo a la raíz de una interfaz para que herede toda la jerarquía.
2. Diseñar un StyleBoxFlat con bordes, esquinas redondeadas y relleno.
3. Definir estilos por estado (normal, hover, pressed, disabled) de un Button.
4. Usar `add_theme_color_override` y afines para excepciones puntuales por código.
5. Crear una variación de tipo (type variation) para estilos derivados sin duplicar el Theme.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Recurso Theme | Centraliza el aspecto de toda la UI. |
| 2 | Herencia de Theme | Un Theme en la raíz baja a todos los hijos. |
| 3 | StyleBoxFlat | Da fondo, borde y esquinas a paneles y botones. |
| 4 | Estados de botón | Comunican interactividad (hover, pressed). |
| 5 | Fuentes y colores | Definen legibilidad y marca. |
| 6 | Overrides por código | Excepciones sin romper el Theme global. |
| 7 | Variaciones de tipo | Estilos derivados reutilizables. |
| 8 | Escalabilidad | Cambiar la piel sin tocar cada escena. |

## 📖 Definiciones y características

- **Theme**: recurso que agrupa estilos, colores, fuentes y constantes por tipo de nodo. Clave: se asigna a un Control y sus hijos lo heredan.
- **StyleBox**: recurso que dibuja el fondo de un widget. Clave: `StyleBoxFlat` es el más usado por ser puro código sin texturas.
- **StyleBoxFlat**: caja con color de relleno, grosor de borde, color de borde y radios de esquina. Clave: escala nítida a cualquier resolución.
- **Estado de botón**: cada Button tiene estilos `normal`, `hover`, `pressed`, `disabled`, `focus`. Clave: dar los cuatro comunica el estado al jugador.
- **Type variation**: subtipo de un nodo base (p. ej. `BotonPeligro` deriva de `Button`). Clave: comparte lo común y sobreescribe lo distinto.
- **add_theme_*_override**: método que fuerza un valor en un nodo concreto. Clave: útil para una excepción, no para estilizar todo.
- **Theme item**: cada entrada del Theme (un color, una fuente, un stylebox) identificada por nombre y tipo. Clave: los nombres deben coincidir con los que espera el nodo.
- **Herencia de Theme**: un Control sin Theme propio usa el del ancestro más cercano. Clave: pon el Theme en la raíz de la UI.

## 🧰 Herramientas y preparación

Continúa con la **pantalla de la clase 189** (panel, lista, botones) en **Godot 4.x**. Trabajaremos con el **editor de Theme** que aparece en el panel inferior al editar un recurso Theme, y con el Inspector para los StyleBox.

Referencia principal: **GUI skinning and themes** (<https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html>). Para el editor visual del Theme, consulta **Using the theme editor** (<https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html>). Puedes definir el Theme por editor o por código; aquí combinamos ambos.

## 🧪 Laboratorio guiado

Crearemos un Theme del proyecto, le daremos estilo a Button, Panel y Label, y lo aplicaremos a la pantalla de la clase 189. Haremos parte por editor y demostraremos overrides y variaciones por código.

1. En el panel **FileSystem**, clic derecho → **New Resource → Theme**, guárdalo como `ui/tema_curso.tres`. Ábrelo: aparece el editor de Theme abajo.

2. En el editor de Theme pulsa el botón **+** para añadir un tipo → elige **Button**. Se listan sus items. En la sección **StyleBox**, en `normal`, crea un **StyleBoxFlat** y en el Inspector configúralo: `bg_color` un azul oscuro, `corner_radius_*` en `8`, `content_margin_*` en `10`.

3. Repite para `hover` (azul un poco más claro) y `pressed` (azul más oscuro). En el item de color `font_color` pon blanco. Ya tienes un botón con estados.

4. Añade el tipo **PanelContainer** y dale a su stylebox `panel` un StyleBoxFlat con `bg_color` gris oscuro y `corner_radius_*` en `12`. Añade el tipo **Label** y pon su `font_color` en un gris claro.

5. Aplica el Theme: abre la escena de la clase 189, selecciona el nodo raíz `Pantalla` y en el Inspector, propiedad **Theme → Theme**, arrastra `tema_curso.tres`. Ejecuta con **F6**: panel, botones y labels heredan el estilo sin tocar cada nodo.

6. Ahora una **variación de tipo** para un botón de peligro. En el editor de Theme, añade un tipo nuevo escribiendo el nombre `BotonPeligro` y en su base indica `Button`. Dale un `normal` StyleBoxFlat rojo. En la escena, selecciona el botón "Cerrar" y en el Inspector pon **Theme Type Variation** = `BotonPeligro`. Solo ese botón se vuelve rojo.

7. Demuestra un **override puntual** por código. Añade al script de la pantalla:

```gdscript
extends Control

@onready var titulo: Label = $Panel/MarginContainer/Contenido/Titulo
@onready var usar: Button = $Panel/MarginContainer/Contenido/Botones/Usar

func _ready() -> void:
	# Excepción puntual: agrandamos y coloreamos solo este Label,
	# sin alterar el Theme global.
	titulo.add_theme_font_size_override("font_size", 28)
	titulo.add_theme_color_override("font_color", Color("ffd24a"))

	# Un stylebox por código para un realce especial del boton 'Usar'.
	var caja := StyleBoxFlat.new()
	caja.bg_color = Color("2e7d32")
	caja.set_corner_radius_all(8)
	caja.set_content_margin_all(10)
	usar.add_theme_stylebox_override("normal", caja)
```

8. Ejecuta con **F6**. El título aparece más grande y dorado, "Usar" tiene fondo verde y "Cerrar" es rojo por la variación de tipo, mientras el resto sigue el Theme. Cambia un color en `tema_curso.tres` y comprueba que toda la UI que usa ese Theme se actualiza a la vez: eso es escalabilidad.

9. Contrasta ambos enfoques mentalmente: el Theme y las variaciones de tipo son **reutilizables** entre escenas, mientras que los `add_theme_*_override` viven pegados a un nodo concreto. Como norma, todo lo que aparezca en más de una pantalla debería vivir en el Theme; deja los overrides solo para lo verdaderamente irrepetible.

Con este flujo tienes una piel de UI centralizada, coherente y fácil de reskinnear sin tocar cada escena del juego.

## ✍️ Ejercicios

1. Añade un estado `disabled` gris al Button en el Theme y desactiva "Usar" por código para verlo.
2. Crea una segunda variación `BotonPrimario` verde y aplícala a "Usar" desde el Inspector.
3. Cambia la fuente por defecto del Theme (item Font del tipo Default) por otra `.ttf` importada.
4. Aumenta el `corner_radius` del PanelContainer a 20 y observa el efecto en la pantalla.
5. Duplica `tema_curso.tres` como `tema_oscuro.tres`, cambia los colores y alterna ambos en la misma escena.
6. Reemplaza el override del título por una variación de tipo `TituloGrande` para no repetir código en otras pantallas.

## 📝 Reto verificable

Crea un Theme completo (`Button` con cuatro estados, `PanelContainer`, `Label`) más dos variaciones de tipo (`BotonPrimario`, `BotonPeligro`). Aplícalo a una pantalla con al menos tres botones distintos. Añade una tecla que, por código, intercambie entre `tema_curso.tres` y una versión clara del Theme en caliente.

**Criterio de aceptación**: al pulsar la tecla, toda la pantalla cambia de piel sin recrear nodos; los botones primario y peligro mantienen su distinción en ambos temas; ningún estilo se pierde al alternar.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El Theme no se aplica a los hijos | Se asignó a un nodo hoja, no a la raíz de la UI. Ponlo en el ancestro. |
| El botón no cambia al pasar el mouse | Falta el stylebox `hover`; añádelo en el Theme. |
| La variación de tipo no hace nada | El nombre en "Theme Type Variation" no coincide con el del Theme. |
| Un override no se revierte | `add_theme_*_override` persiste; usa `remove_theme_*_override` para quitarlo. |
| Bordes borrosos al escalar | Usa StyleBoxFlat (vectorial) en vez de texturas de bordes. |

## ❓ Preguntas frecuentes

**❓ ¿Theme o overrides?** Theme para lo global y repetido; overrides solo para excepciones puntuales de un nodo concreto.

**❓ ¿Qué gana StyleBoxFlat frente a StyleBoxTexture?** Escala nítido a cualquier resolución y no depende de assets, ideal para UI escalable.

**❓ ¿Puedo tener varios temas en un juego?** Sí. Puedes intercambiarlos en caliente o asignar temas distintos a subárboles de la UI.

**❓ ¿Las variaciones de tipo duplican el Theme?** No: heredan de un tipo base y solo redefinen lo que cambia, evitando duplicación.

## 🔗 Referencias

- Godot Docs — GUI skinning and themes: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html>
- Godot Docs — Using the theme editor: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html>
- Godot Docs — StyleBoxFlat: <https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html>
- Godot Docs — Theme: <https://docs.godotengine.org/en/stable/classes/class_theme.html>

## ➡️ Siguiente clase

[Clase 191 - HUD diegético y no diegético](../191-hud-diegetico-y-no-diegetico/README.md)
