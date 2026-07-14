# Clase 189 — Sistema de UI de Godot: Control, Containers y anclas

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (Size and anchors, Using Containers)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Dominar el sistema de layout de Godot 4: el nodo base **Control**, las **anclas** (anchor presets) y **offsets** que fijan un elemento respecto a su padre, y los **contenedores** que posicionan automáticamente a sus hijos. Con estas piezas se construye cualquier pantalla que se adapte sola cuando cambia la resolución, sin colocar nodos "a ojo".

Aprenderás cuándo usar anclas manuales y cuándo dejar que un contenedor decida, cómo funcionan las **size flags** (`SIZE_EXPAND_FILL` y compañía) para repartir el espacio, y por qué `custom_minimum_size` evita que los widgets se aplasten. El laboratorio arma una pantalla real —panel con título, lista desplazable y fila de botones— que se reacomoda al redimensionar la ventana.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar la diferencia entre posicionar con anclas/offsets y posicionar con contenedores.
2. Aplicar anchor presets como Full Rect, Center y Bottom Wide con criterio.
3. Combinar VBoxContainer, HBoxContainer y MarginContainer para estructurar una pantalla.
4. Usar `size_flags_horizontal/vertical` con `SIZE_EXPAND_FILL` para repartir espacio.
5. Construir una pantalla que se adapte correctamente al redimensionar la ventana.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Nodo Control | Es la base de todo elemento de UI. |
| 2 | Anclas (anchors) | Fijan bordes respecto al padre. |
| 3 | Offsets | Ajustan la distancia exacta a las anclas. |
| 4 | Anchor presets | Atajos para layouts comunes. |
| 5 | Contenedores | Posicionan a los hijos automáticamente. |
| 6 | Size flags | Reparten el espacio sobrante. |
| 7 | custom_minimum_size | Impide que los widgets se aplasten. |
| 8 | Adaptación responsive | La pantalla debe verse bien a cualquier tamaño. |

## 📖 Definiciones y características

- **Control**: nodo base de la UI con posición, tamaño, anclas y foco. Clave: casi todo widget hereda de él.
- **Rect (size/position)**: rectángulo que ocupa un Control. Clave: dentro de un contenedor lo gestiona el padre, no tú.
- **Ancla (anchor)**: valor 0–1 que ata un borde del Control a una fracción del rectángulo del padre. Clave: 0 es borde izquierdo/superior, 1 el opuesto.
- **Offset**: distancia en píxeles entre el borde del Control y su ancla. Clave: define el tamaño real junto con las anclas.
- **Anchor preset**: configuración predefinida de anclas (Full Rect, Center, etc.). Clave: se aplica desde el botón de anclas del viewport.
- **Contenedor**: Control que reposiciona a sus hijos según una regla (vertical, horizontal, grid). Clave: ignora la posición manual de los hijos.
- **Size flags**: reglas de cómo un hijo usa el espacio del contenedor. Clave: `SIZE_EXPAND_FILL` hace que ocupe el espacio disponible.
- **custom_minimum_size**: tamaño mínimo garantizado del Control. Clave: útil para botones y paneles que no deben encogerse.

## 🧰 Herramientas y preparación

Trabaja en **Godot 4.x** con un proyecto vacío o el del curso. Configura antes el estiramiento en **Project → Project Settings → Display → Window → Stretch**: pon **Mode** en `canvas_items` y **Aspect** en `keep` para probar bien la adaptación.

Ten a mano dos referencias de Godot: **Size and anchors** (<https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html>) y **Using Containers** (<https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html>). Casi todo el trabajo es en el editor; el script solo rellena la lista.

## 🧪 Laboratorio guiado

Montaremos una pantalla con un panel central que contiene título, una lista con scroll y una fila de botones. Todo debe reacomodarse al redimensionar.

1. Crea una escena con raíz **Control** llamada `Pantalla`. Selecciónala y aplica el anchor preset **Full Rect** (botón de anclas → Full Rect) para que llene la ventana.

2. Añade un **PanelContainer** (`Panel`). Con él seleccionado, aplica el preset **Center** y en el Inspector fija `custom_minimum_size` a `(480, 360)`. Así el panel queda centrado con un tamaño mínimo garantizado.

3. Dentro del `Panel` añade un **MarginContainer** y pon sus `theme_override_constants/margin_*` en `16`. Dentro, un **VBoxContainer** (`Contenido`) con `theme_override_constants/separation` en `12`.

4. En `Contenido` añade en orden: un **Label** (`Titulo`, texto "Inventario"), un **ScrollContainer** (`Scroll`) y un **HBoxContainer** (`Botones`).

5. Selecciona el `Scroll` y pon `size_flags_vertical` en **Fill, Expand** (equivale a `SIZE_EXPAND_FILL`): así la lista se queda con todo el espacio vertical sobrante entre el título y los botones. Dentro del `Scroll` añade un **VBoxContainer** (`Items`).

6. En `Botones` añade dos **Button** ("Usar" y "Cerrar"). A cada uno ponle `size_flags_horizontal` en **Fill, Expand** para que se repartan el ancho por igual.

7. Selecciona `Pantalla`, **Attach Script**, guarda como `pantalla.gd` para llenar la lista por código:

```gdscript
extends Control

@onready var items: VBoxContainer = $Panel/MarginContainer/Contenido/Scroll/Items
@onready var boton_cerrar: Button = $Panel/MarginContainer/Contenido/Botones/Cerrar

func _ready() -> void:
	# Generamos filas de ejemplo para ver el scroll en acción.
	for i in range(20):
		var fila := Label.new()
		fila.text = "Objeto %02d" % (i + 1)
		items.add_child(fila)
	boton_cerrar.pressed.connect(_on_cerrar)

func _on_cerrar() -> void:
	print("Cerrar inventario")
```

8. Ejecuta con **F6**. Debes ver el panel centrado con 20 objetos desplazables y dos botones iguales abajo. Ahora **redimensiona la ventana**: el panel permanece centrado, la lista crece o encoge y los botones mantienen su fila. Esa es la adaptación automática que dan anclas + contenedores.

9. Comprueba la regla clave: intenta arrastrar en el editor uno de los `Label` dentro de `Items`. Verás que vuelve a su sitio, porque su padre es un contenedor. Para reordenar, cambia el orden de los hijos en el árbol; para cambiar tamaños, ajusta size flags o `custom_minimum_size`, nunca la posición a mano.

Con este patrón —raíz Full Rect, panel centrado con mínimo, contenedores anidados y size flags— tienes la base de cualquier pantalla adaptable del curso.

## ✍️ Ejercicios

1. Cambia el preset del `Panel` a **Top Wide** y observa cómo pasa a ocupar todo el ancho superior.
2. Añade un tercer botón y comprueba que los tres siguen repartiéndose el ancho por igual.
3. Sustituye el `HBoxContainer` de botones por un **GridContainer** de 2 columnas con cuatro botones.
4. Pon `size_flags_vertical` del `Scroll` en solo **Fill** (sin Expand) y explica qué cambia.
5. Reduce el `custom_minimum_size` del panel y verifica que nunca baja de ese mínimo al encoger la ventana.
6. Envuelve el `Titulo` en un **CenterContainer** para centrarlo horizontalmente sin tocar sus anclas.

## 📝 Reto verificable

Construye una pantalla de dos columnas: a la izquierda una lista con scroll (que ocupe el 40% del ancho) y a la derecha un panel de detalle. Usa un **HBoxContainer** con size flags para el reparto y `custom_minimum_size` para que ninguna columna colapse. Debe seguir viéndose bien a 1280×720 y a 640×360.

**Criterio de aceptación**: al redimensionar entre ambas resoluciones, las dos columnas mantienen su proporción, la lista conserva su scroll y ningún widget se solapa ni se aplasta por debajo de su mínimo.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Muevo un hijo y vuelve a su sitio | Está dentro de un contenedor; la posición la decide el padre, no tú. |
| Todo se apila en la esquina superior | Faltan anclas/preset o falta un contenedor que ordene. |
| Un botón ocupa todo el ancho él solo | Solo ese hijo tiene `SIZE_EXPAND_FILL`; ponlo en los demás también. |
| El scroll no aparece | El contenido no supera la altura; falta `SIZE_EXPAND_FILL` en el ScrollContainer. |
| El panel se aplasta al encoger | No definiste `custom_minimum_size`. |

## ❓ Preguntas frecuentes

**❓ ¿Anclas o contenedores?** Contenedores para estructuras que se repiten o adaptan; anclas manuales para elementos sueltos como un logo o un HUD fijo.

**❓ ¿Por qué no puedo mover un nodo dentro de un contenedor?** Porque el contenedor recalcula la posición de sus hijos cada frame. Cambia el orden o las size flags en su lugar.

**❓ ¿Qué hace exactamente `SIZE_EXPAND_FILL`?** Pide al contenedor que ese hijo reciba parte del espacio sobrante (Expand) y lo rellene (Fill).

**❓ ¿Full Rect y Center se pueden combinar con contenedores?** Sí: el nodo raíz suele ir Full Rect y dentro colocas contenedores que gestionan el resto.

## 🔗 Referencias

- Godot Docs — Size and anchors: <https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html>
- Godot Docs — Using Containers: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html>
- Godot Docs — Control (size flags): <https://docs.godotengine.org/en/stable/classes/class_control.html>
- Godot Docs — Container: <https://docs.godotengine.org/en/stable/classes/class_container.html>

## ➡️ Siguiente clase

[Clase 190 - Theming y estilos de UI escalables](../190-theming-y-estilos-de-ui-escalables/README.md)
