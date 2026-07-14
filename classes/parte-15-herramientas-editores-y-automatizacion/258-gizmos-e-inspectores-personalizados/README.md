# Clase 258 — Gizmos e inspectores personalizados

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Node3D gizmo plugins, Inspector plugins) y clases `EditorNode3DGizmoPlugin`, `EditorInspectorPlugin`*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Editar un número en el Inspector funciona, pero **editarlo arrastrando en el viewport** es incomparablemente más rápido e intuitivo para un diseñador. Godot permite ambas mejoras: los **gizmos 3D** (`EditorNode3DGizmoPlugin`) dibujan controles manipulables en la vista 3D, y los **plugins de inspector** (`EditorInspectorPlugin` + `EditorProperty`) sustituyen o enriquecen cómo se muestra una propiedad en el panel de propiedades.

En esta clase construimos un **gizmo de radio**: un nodo con una propiedad `radio` que se visualiza como un círculo en el viewport y se edita **arrastrando un tirador** (handle), sin tocar el Inspector. Aprenderás a dibujar líneas y handles con `EditorNode3DGizmo`, a mapear el arrastre del handle de vuelta a la propiedad con `_set_handle`, y verás cómo un `EditorInspectorPlugin` puede ofrecer un editor de propiedad a medida.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Registrar un `EditorNode3DGizmoPlugin` desde un `EditorPlugin` y asociarlo a un tipo de nodo.
2. Dibujar geometría de ayuda (líneas, handles) en el viewport con `_redraw`.
3. Editar una propiedad arrastrando un handle mediante `_get_handle_value` y `_set_handle`.
4. Explicar el rol de `EditorInspectorPlugin` y `EditorProperty` para inspectores a medida.
5. Distinguir cuándo conviene un gizmo (edición espacial) frente a un inspector custom.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es un gizmo 3D | Edición visual directa en el viewport. |
| 2 | `EditorNode3DGizmoPlugin` | Punto de registro del gizmo. |
| 3 | `_redraw` y geometría de ayuda | Dibuja el círculo, líneas y handles. |
| 4 | Handles arrastrables | Convierten el arrastre en cambios de propiedad. |
| 5 | `_set_handle` / `_get_handle_value` | Traducen posición de ratón a valor. |
| 6 | `EditorInspectorPlugin` | Personaliza el panel de propiedades. |
| 7 | `EditorProperty` | Control a medida para una propiedad. |
| 8 | Gizmo vs inspector | Elegir la herramienta según la tarea. |

## 📖 Definiciones y características

- **Gizmo**: control visual dibujado en el viewport para manipular un nodo. Clave: hace espacial la edición de propiedades numéricas.
- **`EditorNode3DGizmoPlugin`**: clase que registra el gizmo y define nombre, materiales y handles. Clave: se añade con `add_node_3d_gizmo_plugin()` desde un `EditorPlugin`.
- **`_redraw(gizmo)`**: método donde limpias y vuelves a dibujar líneas y handles. Clave: se llama cuando el nodo cambia o se selecciona.
- **Handle**: punto arrastrable del gizmo. Clave: cada handle tiene un índice y un valor asociado a una propiedad.
- **`_set_handle(...)`**: recibe la posición del ratón y actualiza la propiedad del nodo. Clave: aquí ocurre la edición real por arrastre.
- **`EditorInspectorPlugin`**: plugin que interviene en cómo el Inspector muestra propiedades. Clave: usa `_can_handle` y `_parse_property`.
- **`EditorProperty`**: control base para editar una propiedad concreta en el Inspector. Clave: emite `property_changed` para persistir el valor.
- **`_has_gizmo(node)`**: decide para qué nodos aplica el gizmo. Clave: filtra por tipo o por script para no dibujar en todo.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y estar cómodo con `EditorPlugin` de la clase anterior, porque el gizmo se registra desde un plugin. Trabajaremos en 3D: crea un tipo de nodo propio (un `Node3D` con un script `@tool` que exponga `radio`).

Estudia la guía oficial de gizmos, que detalla materiales y handles: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/3d_gizmos.html>. Para inspectores a medida, la referencia es la guía de inspector plugins: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html>.

## 🧪 Laboratorio guiado

Construiremos un **gizmo de radio**: un `Node3D` con una propiedad `radio` que se dibuja como círculo y se edita arrastrando un handle en el borde.

1. Primero el nodo objetivo. Crea `zona.gd`, un `@tool` que expone `radio` y notifica al editor para redibujar su gizmo al cambiar:

```gdscript
@tool
class_name ZonaRadio
extends Node3D

@export var radio: float = 1.0:
	set(v):
		radio = max(v, 0.05)
		update_gizmos()   # Pide al editor que redibuje el gizmo.
```

2. Crea el plugin del gizmo `gizmo_radio.gd`. Extiende `EditorNode3DGizmoPlugin`, define un material de línea y filtra por el tipo `ZonaRadio`:

```gdscript
@tool
extends EditorNode3DGizmoPlugin

func _init() -> void:
	create_material("linea", Color(0.2, 0.8, 1.0))
	create_handle_material("handles")

func _get_gizmo_name() -> String:
	return "ZonaRadio"

func _has_gizmo(node: Node3D) -> bool:
	return node is ZonaRadio
```

3. Implementa `_redraw`: dibuja el círculo en el plano XZ y coloca **un handle** en el borde para poder arrastrarlo:

```gdscript
func _redraw(gizmo: EditorNode3DGizmo) -> void:
	gizmo.clear()
	var nodo := gizmo.get_node_3d() as ZonaRadio
	var r: float = nodo.radio

	var lineas := PackedVector3Array()
	var segmentos := 48
	for i in segmentos:
		var a0 := TAU * float(i) / segmentos
		var a1 := TAU * float(i + 1) / segmentos
		lineas.append(Vector3(cos(a0), 0, sin(a0)) * r)
		lineas.append(Vector3(cos(a1), 0, sin(a1)) * r)
	gizmo.add_lines(lineas, get_material("linea", gizmo))

	# Un handle en el borde (+X) para arrastrar el radio.
	var handles := PackedVector3Array([Vector3(r, 0, 0)])
	gizmo.add_handles(handles, get_material("handles", gizmo), [])
```

4. Conecta el arrastre. `_get_handle_value` devuelve el valor inicial y `_set_handle` traduce el rayo del ratón a un nuevo radio proyectando sobre el eje X local:

```gdscript
func _get_handle_value(gizmo: EditorNode3DGizmo, id: int, secondary: bool):
	return (gizmo.get_node_3d() as ZonaRadio).radio

func _set_handle(gizmo: EditorNode3DGizmo, id: int, secondary: bool,
		camera: Camera3D, screen_pos: Vector2) -> void:
	var nodo := gizmo.get_node_3d() as ZonaRadio
	var origen := camera.project_ray_origin(screen_pos)
	var dir := camera.project_ray_normal(screen_pos)
	# Interseca el rayo con el plano Y=0 del nodo, en espacio local.
	var t := nodo.global_transform.affine_inverse()
	var lo := t * origen
	var ld := t.basis * dir
	if absf(ld.y) > 0.0001:
		var k := -lo.y / ld.y
		var punto := lo + ld * k
		nodo.radio = Vector2(punto.x, punto.z).length()
```

5. Registra el gizmo desde tu `EditorPlugin` (en su `plugin.gd`). En `_enter_tree()` añade el plugin y en `_exit_tree()` retíralo:

```gdscript
@tool
extends EditorPlugin

const GizmoRadio := preload("res://addons/zona_radio/gizmo_radio.gd")
var _gizmo := GizmoRadio.new()

func _enter_tree() -> void:
	add_node_3d_gizmo_plugin(_gizmo)

func _exit_tree() -> void:
	remove_node_3d_gizmo_plugin(_gizmo)
```

6. Activa el plugin, añade un nodo `ZonaRadio` a una escena 3D y selecciónalo. Verás el **círculo azul** y un punto en el borde. **Arrastra el punto**: el radio cambia en vivo y el Inspector refleja el nuevo valor. Acabas de editar una propiedad numérica de forma espacial.

La lección observable: mover un handle en el viewport actualiza la propiedad real, ida y vuelta, sin escribir números.

## ✍️ Ejercicios

1. Añade un segundo handle en `-X` para editar el radio simétricamente desde ambos lados.
2. Dibuja también radios (líneas del centro al borde) para hacer la zona más legible.
3. Cambia el color del material según si el radio supera un umbral (verde/rojo).
4. Implementa `_commit_handle` para que el cambio de radio sea deshacible con Ctrl+Z.
5. Crea un `EditorInspectorPlugin` que muestre el radio como un `HSlider` en lugar del `SpinBox` por defecto.
6. Filtra `_has_gizmo` para que solo aplique si el nodo tiene además un grupo concreto.

## 📝 Reto verificable

Construye un gizmo 3D propio que edite visualmente una propiedad de un nodo `@tool` a tu elección (un ángulo de cono, una altura, la longitud de una caja). Debe: registrarse y retirarse desde un `EditorPlugin`, dibujar geometría de ayuda en `_redraw`, ofrecer al menos un handle arrastrable que modifique la propiedad, y reflejar el cambio en el Inspector.

**Criterio de aceptación**: al seleccionar el nodo aparece el gizmo dibujado según la propiedad; arrastrar el handle cambia el valor en vivo y el Inspector se actualiza en consecuencia; y desactivar el plugin retira el gizmo sin errores en la consola.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El gizmo no aparece al seleccionar | `_has_gizmo` devuelve `false` para ese nodo, o el plugin no está registrado. Revisa el tipo y `add_node_3d_gizmo_plugin()`. |
| El círculo no se actualiza al cambiar `radio` | Falta `update_gizmos()` en el setter de la propiedad. Añádelo. |
| Arrastrar el handle no mueve nada | No implementaste `_set_handle` o el cálculo del rayo es incorrecto. Verifica la transformación a espacio local. |
| El handle salta a valores enormes | El rayo no interseca el plano (mirada casi paralela). Comprueba `absf(ld.y) > epsilon` antes de dividir. |
| El cambio no se puede deshacer | Falta `_commit_handle` con `UndoRedo`. Impleméntalo para registrar la acción. |

## ❓ Preguntas frecuentes

**❓ ¿Cuándo un gizmo y cuándo un inspector custom?** El gizmo brilla cuando la propiedad es espacial (posiciones, radios, ángulos) y se entiende mejor viéndola. El inspector custom conviene para tipos de dato sin representación espacial que quieres mostrar de otra forma (una curva, una paleta de color).

**❓ ¿El gizmo necesita que el nodo sea `@tool`?** El nodo debe poder notificar `update_gizmos()` desde el editor, lo que requiere `@tool`. El plugin del gizmo también es `@tool`.

**❓ ¿Puedo dibujar mallas y no solo líneas?** Sí: `add_mesh()` y `add_collision_triangles()` permiten geometría sólida y selección. Las líneas bastan para la mayoría de ayudas.

**❓ ¿`EditorProperty` reemplaza al Inspector entero?** No: reemplaza el editor de **una** propiedad concreta que tu `EditorInspectorPlugin` decida manejar en `_parse_property`; el resto del Inspector sigue igual.

## 🔗 Referencias

- Godot Docs — Node3D gizmo plugins: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/3d_gizmos.html>
- Godot Docs — Inspector plugins: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html>
- Godot Docs — `EditorNode3DGizmoPlugin`: <https://docs.godotengine.org/en/stable/classes/class_editornode3dgizmoplugin.html>
- Godot Docs — `EditorProperty`: <https://docs.godotengine.org/en/stable/classes/class_editorproperty.html>

## ➡️ Siguiente clase

[Clase 259 - Generación y validación de datos (data-driven)](../259-generacion-y-validacion-de-datos-data-driven/README.md)
