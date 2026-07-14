# Clase 265 — Editores de niveles y contenido in-game

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (FileAccess, ResourceSaver, JSON, InputEvent)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

No toda herramienta vive en el editor de Godot: a veces la mejor forma de crear contenido es **dentro del propio juego**. Un editor de niveles in-game deja que diseñadores —y jugadores, si abres el modding— coloquen objetos con el ratón y guarden su creación en disco. En esta clase construimos un mini-editor funcional: clicas para colocar, y guardas/cargas el nivel a un archivo, cerrando el ciclo de **serialización** de datos de juego.

Aprenderás a capturar el clic del ratón y traducirlo a coordenadas del mundo, a mantener una lista de objetos colocados como datos, y a persistirlos con **`FileAccess`** en formato **JSON** (portable y editable a mano, ideal para modding) o con **`ResourceSaver`** (integrado, tipado y binario). Discutiremos la **UX** de la herramienta: deshacer, seleccionar tipo de objeto y evitar que un mal clic destruya el trabajo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Capturar entrada de ratón y convertirla en posiciones del mundo para colocar objetos.
2. Modelar el contenido de un nivel como datos serializables independientes de los nodos visuales.
3. Guardar y cargar un nivel con `FileAccess` + JSON y explicar cuándo usar `ResourceSaver`.
4. Comparar JSON y recursos de Godot para persistencia y elegir según el caso (modding vs interno).
5. Aplicar decisiones de UX básicas (selección de objeto, deshacer, feedback) en una herramienta in-game.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Editores in-game | Permiten crear contenido sin abrir Godot; base del modding. |
| 2 | Datos vs presentación | El nivel es una lista de datos; los nodos solo lo dibujan. |
| 3 | Ratón a mundo | Colocar objetos exige traducir píxeles a coordenadas. |
| 4 | Serialización JSON | Formato de texto portable y editable a mano. |
| 5 | `FileAccess` | API para leer/escribir archivos en `user://` o `res://`. |
| 6 | `ResourceSaver`/`ResourceLoader` | Persistencia tipada e integrada de Godot. |
| 7 | JSON vs recurso | Texto abierto para mods vs binario tipado interno. |
| 8 | UX de la herramienta | Deshacer y feedback evitan perder trabajo. |

## 📖 Definiciones y características

- **Editor in-game**: modo del juego que permite crear/editar contenido en ejecución. Clave: acerca la creación a diseñadores y a la comunidad.
- **Serialización**: convertir estructuras de memoria en un formato persistible (texto o binario). Clave: es lo que "guarda" el nivel.
- **`FileAccess`**: clase para abrir, leer y escribir archivos. Clave: usa `user://` para datos del jugador, escribible en cualquier plataforma.
- **`user://`**: carpeta de datos de usuario, separada del proyecto de solo lectura. Clave: es donde guardas niveles creados en runtime.
- **JSON**: formato de texto con objetos y arrays. Clave: portable, legible y editable a mano, perfecto para mods.
- **`JSON.stringify` / `JSON.parse_string`**: convierten entre diccionario/array y texto JSON. Clave: la puerta de entrada/salida del formato.
- **`ResourceSaver` / `ResourceLoader`**: guardan y cargan `Resource` (`.tres`/`.res`). Clave: tipado, con referencias, ideal para datos internos.
- **UX de herramienta**: decisiones de usabilidad (deshacer, selección, feedback). Clave: una herramienta frágil hace perder el trabajo del usuario.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y una escena 2D sencilla: un `Node2D` raíz que hará de lienzo, y un puñado de sprites o `PackedScene` que representen los tipos de objeto a colocar (por ejemplo, "caja", "enemigo", "moneda"). Guardaremos en `user://`, la carpeta de datos del usuario, para que funcione también en builds exportadas.

Trabajaremos con `_unhandled_input` para el ratón, con `FileAccess` y `JSON` para el formato de texto, y mencionaremos `ResourceSaver` como alternativa. La documentación de `FileAccess` está en <https://docs.godotengine.org/en/stable/classes/class_fileaccess.html>, la de JSON en <https://docs.godotengine.org/en/stable/classes/class_json.html> y la guía de guardado de juegos en <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>.

## 🧪 Laboratorio guiado

Vamos a construir un **mini-editor**: clic izquierdo coloca el objeto seleccionado, y unos botones guardan/cargan el nivel en JSON.

1. Modela el nivel como **datos**, no como nodos. Crea `editor_nivel.gd` en el `Node2D` raíz con una lista de objetos colocados:

```gdscript
extends Node2D

const RUTA_NIVEL := "user://nivel_01.json"

# Cada objeto colocado es un diccionario simple y serializable
var objetos: Array[Dictionary] = []
var tipo_actual: String = "caja"

# Mapa de tipo -> escena a instanciar visualmente
@onready var escenas := {
    "caja":    preload("res://objetos/caja.tscn"),
    "enemigo": preload("res://objetos/enemigo.tscn"),
    "moneda":  preload("res://objetos/moneda.tscn"),
}
```

2. Captura el clic y coloca el objeto en la posición del mundo. Usa `_unhandled_input` para no robar clics a la UI:

```gdscript
func _unhandled_input(evento: InputEvent) -> void:
    if evento is InputEventMouseButton and evento.pressed:
        if evento.button_index == MOUSE_BUTTON_LEFT:
            var pos := get_global_mouse_position()
            _colocar(tipo_actual, pos)
        elif evento.button_index == MOUSE_BUTTON_RIGHT:
            _deshacer()   # clic derecho = deshacer el ultimo

func _colocar(tipo: String, pos: Vector2) -> void:
    objetos.append({"tipo": tipo, "x": pos.x, "y": pos.y})
    _instanciar(tipo, pos)

func _instanciar(tipo: String, pos: Vector2) -> void:
    var inst := escenas[tipo].instantiate()
    inst.position = pos
    add_child(inst)

func _deshacer() -> void:
    if objetos.is_empty():
        return
    objetos.pop_back()
    get_child(get_child_count() - 1).queue_free()  # quita el ultimo visual
```

3. Guarda el nivel a JSON con `FileAccess`. Serializamos solo los datos, no los nodos:

```gdscript
func guardar() -> void:
    var f := FileAccess.open(RUTA_NIVEL, FileAccess.WRITE)
    if f == null:
        push_error("No se pudo abrir para escritura: %s" % FileAccess.get_open_error())
        return
    var datos := {"version": 1, "objetos": objetos}
    f.store_string(JSON.stringify(datos, "\t"))   # con tabulacion, legible
    f.close()
    print("Nivel guardado en %s (%d objetos)" % [RUTA_NIVEL, objetos.size()])
```

4. Carga el nivel: lee el texto, valida el parseo y reconstruye tanto los datos como lo visual:

```gdscript
func cargar() -> void:
    if not FileAccess.file_exists(RUTA_NIVEL):
        push_warning("No hay nivel guardado todavia")
        return
    var f := FileAccess.open(RUTA_NIVEL, FileAccess.READ)
    var texto := f.get_as_text()
    f.close()

    var datos = JSON.parse_string(texto)   # devuelve null si el JSON es invalido
    if datos == null or not datos.has("objetos"):
        push_error("Archivo de nivel corrupto o con formato inesperado")
        return

    _limpiar()
    for obj in datos["objetos"]:
        var pos := Vector2(obj["x"], obj["y"])
        _colocar(obj["tipo"], pos)

func _limpiar() -> void:
    objetos.clear()
    for hijo in get_children():
        hijo.queue_free()
```

5. Conecta la UX mínima: un `OptionButton` para elegir `tipo_actual` y dos botones para `guardar()` y `cargar()`. Ejecuta, coloca varias cajas y monedas, guarda, cierra el juego y vuelve a abrir: al pulsar Cargar, tu nivel reaparece intacto desde `user://nivel_01.json`. Abre ese archivo con un editor de texto y verás tus objetos en JSON legible, listos para editar a mano o compartir como mod.

La lección observable: separar datos de presentación hizo trivial la persistencia —guardamos una lista de diccionarios, no la escena— y elegir JSON dejó el nivel abierto al modding. El clic derecho como "deshacer" convirtió un error de colocación en algo reversible en vez de una catástrofe.

## ✍️ Ejercicios

1. Añade una tecla para rotar el objeto antes de colocarlo y persiste el ángulo en el JSON.
2. Implementa un guardado alternativo con `ResourceSaver` usando un `Resource` personalizado y compara ambos ficheros.
3. Añade validación: rechaza cargar un JSON cuyo `version` no coincida con la esperada.
4. Permite borrar un objeto concreto haciendo clic sobre él (detección por área o distancia), no solo el último.
5. Muestra un contador en pantalla con el número de objetos y el tipo seleccionado (feedback de UX).
6. Añade "guardar como" pidiendo un nombre de archivo, para tener varios niveles en `user://`.

## 📝 Reto verificable

Construye un mini-editor in-game que coloque al menos tres tipos de objeto con el ratón, permita deshacer, y guarde/cargue el nivel a `user://` en JSON (o recurso). Al reiniciar el juego y cargar, el nivel debe reconstruirse idéntico. Incluye validación básica ante un archivo corrupto.

**Criterio de aceptación**: tras colocar varios objetos de distinto tipo y pulsar Guardar, cerrar y reabrir el juego y pulsar Cargar reproduce exactamente las mismas posiciones y tipos; editar el archivo para corromperlo hace que Cargar muestre un error controlado (sin crashear) en lugar de romper la escena.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Guardar funciona en el editor pero no en la build | Escribías en `res://`, que es de solo lectura al exportar. Usa siempre `user://` para datos creados en runtime. |
| `JSON.parse_string` devuelve `null` sin avisar | El texto no es JSON válido. Comprueba el resultado y usa `push_error` en vez de asumir éxito. |
| Los objetos cargan con posición desplazada | Confundiste posición local con global. Usa `get_global_mouse_position()` y sé coherente al reconstruir. |
| El nivel guarda nodos y el archivo pesa muchísimo | Serializaste la escena entera. Guarda solo datos (tipo y coordenadas), no los nodos. |
| Un clic en un botón también coloca un objeto | Usaste `_input` en vez de `_unhandled_input`, o no consumiste el evento. La UI debe recibir el clic primero. |

## ❓ Preguntas frecuentes

**❓ ¿JSON o recurso de Godot?** JSON si quieres que el archivo sea legible y editable por la comunidad (modding). Recurso (`ResourceSaver`) si es dato interno, tipado y no necesitas que nadie lo abra fuera del juego.

**❓ ¿Dónde queda físicamente `user://`?** En una carpeta por-plataforma dentro del sistema (AppData en Windows, `~/.local/share` en Linux). Puedes verla con `OS.get_user_data_dir()`.

**❓ ¿Es seguro cargar un JSON de un mod ajeno?** Trátalo como dato no confiable: valida claves, tipos y rangos antes de usarlos. Nunca ejecutes código desde un archivo de nivel.

**❓ ¿Cómo hago deshacer/rehacer completo?** Mantén una pila de acciones (comando ejecutado + su inverso). El clic derecho de este lab es la versión mínima; una pila permite rehacer también.

## 🔗 Referencias

- Godot Docs — `FileAccess`: <https://docs.godotengine.org/en/stable/classes/class_fileaccess.html>
- Godot Docs — `JSON`: <https://docs.godotengine.org/en/stable/classes/class_json.html>
- Godot Docs — Saving games: <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>
- Godot Docs — `ResourceSaver`: <https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html>

## ➡️ Siguiente clase

[Clase 266 - Capstone Parte 15: una herramienta o plugin de editor](../266-capstone-parte-15-una-herramienta-o-plugin-de-editor/README.md)
