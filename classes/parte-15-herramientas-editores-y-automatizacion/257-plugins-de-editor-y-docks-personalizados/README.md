# Clase 257 — Plugins de editor y docks personalizados

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Making plugins) y clase `EditorPlugin`*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Un script `@tool` vive dentro de una escena; un **plugin de editor** vive dentro del propio Godot. Con `EditorPlugin` puedes añadir paneles, botones, menús y docks que forman parte de la interfaz del editor y están disponibles en **cualquier** proyecto y escena. Es el salto de "herramienta atada a un nodo" a "herramienta integrada en tu entorno de trabajo".

En esta clase construimos un **addon** completo: la carpeta `res://addons/`, su archivo de manifiesto `plugin.cfg`, y un `EditorPlugin` que registra un **dock personalizado** con un botón que ejecuta una acción útil sobre la escena abierta. Dominarás el ciclo de vida `_enter_tree()` / `_exit_tree()`, aprenderás a **limpiar** lo que añades para no dejar controles huérfanos al desactivar, y activarás el plugin desde **Project Settings → Plugins**.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Estructurar un addon en `res://addons/nombre/` con un `plugin.cfg` válido.
2. Implementar un `EditorPlugin` con `_enter_tree()` y `_exit_tree()` simétricos.
3. Añadir un dock al editor con `add_control_to_dock()` y retirarlo al salir.
4. Ejecutar una acción sobre la escena editada desde un botón del dock.
5. Activar, desactivar y depurar el plugin desde Project Settings → Plugins.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es un `EditorPlugin` | Extiende el editor, no una escena concreta. |
| 2 | La carpeta `res://addons/` | Ubicación canónica que Godot reconoce. |
| 3 | El manifiesto `plugin.cfg` | Declara nombre, script y versión del addon. |
| 4 | Ciclo de vida `_enter_tree`/`_exit_tree` | Registra y limpia lo que el plugin añade. |
| 5 | `add_control_to_dock()` | Inserta un panel en una zona del editor. |
| 6 | Construir la UI del dock | Botones y controles que disparan acciones. |
| 7 | Acceder a la escena editada | `get_editor_interface()` y `edited_scene_root`. |
| 8 | Activación en Project Settings | Dónde se enciende y apaga el plugin. |

## 📖 Definiciones y características

- **`EditorPlugin`**: clase base de un addon que extiende el editor. Clave: solo corre en el editor y debe ser `@tool`.
- **`plugin.cfg`**: archivo INI con la sección `[plugin]` (name, description, author, version, script). Clave: sin él, Godot no lista el addon.
- **`_enter_tree()`**: se llama al activar el plugin; aquí registras docks, tipos y menús. Clave: todo lo que añadas debe deshacerse en `_exit_tree()`.
- **`_exit_tree()`**: se llama al desactivar; libera controles y quita lo registrado. Clave: omitir la limpieza deja UI huérfana en el editor.
- **`add_control_to_dock(slot, control)`**: inserta un `Control` en una zona (dock) del editor. Clave: guarda la referencia para poder retirarlo.
- **`remove_control_from_docks(control)`**: quita el control añadido. Clave: se acompaña de `free()` para liberar memoria.
- **`get_editor_interface()`**: acceso a la interfaz del editor (escena editada, selección, sistema de archivos). Clave: puerta a lo que el usuario está editando.
- **`add_control_to_bottom_panel()`**: alternativa que crea una pestaña en el panel inferior. Clave: útil para paneles grandes tipo consola.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**. Godot ofrece un asistente en **Project → Project Settings → Plugins → Create New Plugin** que genera el esqueleto (`plugin.cfg` + script) automáticamente; en esta clase lo crearemos a mano para entender cada pieza, pero puedes usar el asistente después.

Sigue la referencia oficial paso a paso, que documenta el formato exacto de `plugin.cfg`: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html>. La lista completa de métodos está en la clase `EditorPlugin`: <https://docs.godotengine.org/en/stable/classes/class_editorplugin.html>.

## 🧪 Laboratorio guiado

Crearemos un addon llamado **contador_nodos** con un dock que muestra cuántos nodos tiene la escena abierta y un botón para renombrar en lote los seleccionados.

1. Crea la carpeta `res://addons/contador_nodos/` y dentro el manifiesto `plugin.cfg`. Este archivo es INI puro, no GDScript:

```ini
[plugin]
name="Contador de Nodos"
description="Cuenta nodos de la escena y renombra la selección."
author="Tu Nombre"
version="1.0.0"
script="plugin.gd"
```

2. En la misma carpeta crea `plugin.gd`. Debe ser `@tool` y extender `EditorPlugin`. Aquí construimos el dock y lo registramos en `_enter_tree()`:

```gdscript
@tool
extends EditorPlugin

var _dock: Control

func _enter_tree() -> void:
	# Construimos la UI del dock por código.
	_dock = VBoxContainer.new()
	_dock.name = "Nodos"

	var etiqueta := Label.new()
	etiqueta.name = "Etiqueta"
	etiqueta.text = "Nodos: -"
	_dock.add_child(etiqueta)

	var boton_contar := Button.new()
	boton_contar.text = "Contar nodos"
	boton_contar.pressed.connect(_on_contar)
	_dock.add_child(boton_contar)

	var boton_prefijo := Button.new()
	boton_prefijo.text = "Prefijar selección"
	boton_prefijo.pressed.connect(_on_prefijar)
	_dock.add_child(boton_prefijo)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, _dock)

func _exit_tree() -> void:
	# Simetría: quitamos y liberamos lo que añadimos.
	remove_control_from_docks(_dock)
	_dock.free()
```

3. Implementa la acción de contar. Accedemos a la **escena editada** por la interfaz del editor y recorremos su árbol:

```gdscript
func _on_contar() -> void:
	var raiz := get_editor_interface().get_edited_scene_root()
	if raiz == null:
		_set_texto("Sin escena abierta")
		return
	var total := _contar_recursivo(raiz)
	_set_texto("Nodos: %d" % total)

func _contar_recursivo(nodo: Node) -> int:
	var n := 1
	for hijo in nodo.get_children():
		n += _contar_recursivo(hijo)
	return n

func _set_texto(t: String) -> void:
	_dock.get_node("Etiqueta").text = t
```

4. Implementa la acción útil sobre la selección: añadir un prefijo a los nodos seleccionados en el editor:

```gdscript
func _on_prefijar() -> void:
	var seleccion := get_editor_interface().get_selection().get_selected_nodes()
	for nodo in seleccion:
		nodo.name = "UI_" + nodo.name
```

5. Guarda todo y ve a **Project → Project Settings → Plugins**. Verás "Contador de Nodos" en la lista. Marca la casilla **Enable**. El dock "Nodos" aparece a la derecha del editor.

6. Abre cualquier escena, pulsa **Contar nodos** y verás el total. Selecciona varios nodos en el árbol y pulsa **Prefijar selección**: sus nombres reciben `UI_`. Desactiva el plugin desde Plugins y comprueba que el dock **desaparece sin dejar rastro**: esa es la prueba de que tu `_exit_tree()` limpia bien.

La lección observable: has añadido interfaz propia al editor, disponible en todo proyecto, que actúa sobre la escena real.

## ✍️ Ejercicios

1. Cambia el dock a otra zona (`DOCK_SLOT_LEFT_BR`, por ejemplo) y observa dónde aparece.
2. Añade un `LineEdit` para que el prefijo sea configurable en lugar de fijo `UI_`.
3. Muestra en la etiqueta el nombre de la escena editada además del conteo.
4. Convierte el dock en una pestaña del panel inferior con `add_control_to_bottom_panel()` y recuérdala en `_exit_tree()` con `remove_control_from_bottom_panel()`.
5. Deshabilita el botón "Prefijar" cuando la selección esté vacía usando la señal de selección.
6. Añade un segundo botón que cuente solo los nodos de un tipo dado (por ejemplo, `Sprite2D`).

## 📝 Reto verificable

Construye un addon propio en `res://addons/` con `plugin.cfg` válido y un `EditorPlugin` que registre un dock (o panel inferior) con al menos dos acciones útiles sobre la escena editada (contar, renombrar, ordenar, reportar…). El plugin debe activarse desde Project Settings → Plugins y limpiar por completo su UI al desactivarse.

**Criterio de aceptación**: el addon aparece y se activa en Project Settings → Plugins; sus botones ejecutan acciones verificables sobre la escena abierta; y al desactivarlo el dock desaparece sin dejar controles ni errores en la consola, demostrando la simetría `_enter_tree`/`_exit_tree`.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El plugin no aparece en la lista | Falta o está mal el `plugin.cfg`, o la carpeta no está en `res://addons/`. Revisa la sección `[plugin]` y el nombre del `script`. |
| Al desactivar quedan docks fantasma | `_exit_tree()` no retira ni libera el control. Llama a `remove_control_from_docks()` y `free()`. |
| Error "null instance" al pulsar el botón | No hay escena abierta. Comprueba `get_edited_scene_root() != null` antes de actuar. |
| El script del plugin no corre en el editor | Falta `@tool` al inicio de `plugin.gd`. Añádelo antes de `extends`. |
| Cambios en el plugin no se reflejan | Godot cachea el addon. Desactívalo y reactívalo, o reinicia el editor. |

## ❓ Preguntas frecuentes

**❓ ¿`plugin.cfg` puede llamarse de otra forma?** No: el nombre y la ubicación (`res://addons/<carpeta>/plugin.cfg`) son fijos. El campo `script` sí puede apuntar a cualquier `.gd` de esa carpeta.

**❓ ¿Diferencia entre un dock y el panel inferior?** El dock se ancla a los laterales junto al Inspector o el árbol; el panel inferior crea una pestaña abajo, como la consola o el depurador, ideal para paneles anchos.

**❓ ¿Puedo diseñar la UI del dock en una escena `.tscn` en vez de por código?** Sí, y suele ser más cómodo: instancias la escena con `preload(...).instantiate()` en `_enter_tree()` y la pasas a `add_control_to_dock()`.

**❓ ¿El plugin afecta al juego exportado?** No: los addons de editor no se incluyen en la exportación del juego. Solo viven dentro del editor.

## 🔗 Referencias

- Godot Docs — Making plugins: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html>
- Godot Docs — `EditorPlugin`: <https://docs.godotengine.org/en/stable/classes/class_editorplugin.html>
- Godot Docs — `EditorInterface`: <https://docs.godotengine.org/en/stable/classes/class_editorinterface.html>
- Godot Docs — `EditorSelection`: <https://docs.godotengine.org/en/stable/classes/class_editorselection.html>

## ➡️ Siguiente clase

[Clase 258 - Gizmos e inspectores personalizados](../258-gizmos-e-inspectores-personalizados/README.md)
