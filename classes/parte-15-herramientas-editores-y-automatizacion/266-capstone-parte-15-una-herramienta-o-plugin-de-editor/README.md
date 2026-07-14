# Clase 266 — Capstone Parte 15: una herramienta o plugin de editor

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Making plugins / EditorPlugin, @tool) y GitHub Actions*
> ⏱️ Duración estimada: **90 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Cierras la Parte 15 construyendo **una herramienta útil de verdad**, no un ejercicio de juguete. Integras todo lo aprendido: scripts `@tool`, plugins con dock, validación de datos data-driven, testing con GUT y automatización con CI. El objetivo es que salgas con un artefacto que ahorre tiempo real en un proyecto —tuyo o de un equipo— y que esté documentado, testeado y verificado por integración continua.

Elegirás una de tres vías: un **plugin de editor con dock** que ofrezca una acción frecuente en un panel, un **generador `@tool`** que produzca o transforme contenido desde el propio editor, o un **pipeline de datos** que valide un catálogo (JSON/recursos) y lo blinde con tests en CI. Sea cual sea, la entrega incluye especificación, checklist y una **definition of done** clara: la herramienta funciona, tiene tests verdes y CI que la protege.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Especificar el alcance de una herramienta útil con criterios de aceptación medibles.
2. Implementar un `EditorPlugin` con dock o un generador `@tool` que resuelva una tarea concreta.
3. Cubrir la lógica de la herramienta con tests GUT ejecutables por CLI.
4. Proteger la herramienta con un workflow de CI que corra tests en cada push.
5. Documentar la herramienta y cerrarla contra una definition of done verificable.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Elegir un problema real | Una herramienta sin problema que resolver no aporta nada. |
| 2 | `EditorPlugin` y docks | Integran la herramienta en la UI del editor. |
| 3 | Generadores `@tool` | Ejecutan lógica en el editor para crear/transformar contenido. |
| 4 | Pipeline de datos con validación | Detecta datos corruptos antes de que rompan el juego. |
| 5 | Testing de la herramienta | La lógica de una herramienta también se testea con GUT. |
| 6 | CI de la herramienta | Cada cambio se verifica automáticamente. |
| 7 | Especificación y checklist | Convierten "una idea" en trabajo entregable. |
| 8 | Definition of done | Define objetivamente cuándo está terminada. |

## 📖 Definiciones y características

- **`EditorPlugin`**: clase base para extender el editor de Godot (docks, menús, inspectores). Clave: se activa desde `plugin.cfg` y `addons/`.
- **Dock**: panel acoplable del editor donde vive la UI de tu herramienta. Clave: `add_control_to_dock` lo integra en la interfaz.
- **`@tool`**: anotación que hace correr un script también en el editor, no solo en juego. Clave: permite generar/previsualizar contenido en tiempo de diseño.
- **Pipeline de datos**: flujo que carga, valida y transforma un catálogo de datos. Clave: separa datos de código y los verifica.
- **Validación**: comprobación de que los datos cumplen reglas (campos, tipos, rangos, referencias). Clave: falla temprano, no en producción.
- **Definition of done (DoD)**: lista de condiciones que definen "terminado". Clave: elimina la ambigüedad sobre si el trabajo está completo.
- **Checklist de entrega**: lista verificable de artefactos y pruebas. Clave: guía la autoevaluación antes de dar por cerrado.
- **`plugin.cfg`**: archivo que declara nombre, script y activación del plugin. Clave: sin él, el editor no reconoce el addon.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**, el addon **GUT** de la clase 264 y un repositorio con **GitHub Actions** como en la 262. Reutilizarás lo construido: el comando de tests por CLI, el workflow de CI y, si aplica, la serialización de la clase 265. Trabaja en `addons/mi_herramienta/` con su `plugin.cfg` y su script `EditorPlugin`.

Elige el problema antes de programar: revisa un proyecto real y localiza una tarea repetitiva (renombrar en lote, generar un TileSet, validar un catálogo de ítems). La guía de plugins de editor está en <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html> y la de scripts `@tool` en <https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html>.

## 🧪 Laboratorio guiado

Construiremos, como ejemplo de referencia, un **pipeline de datos con validación y un dock** que revisa un catálogo de ítems y avisa de errores; tú puedes adaptar la estructura a tu vía elegida.

1. Separa la **lógica validadora** (testeable, sin UI) de la herramienta. Crea `addons/validador_items/validador.gd`:

```gdscript
class_name ValidadorItems
extends RefCounted

# Devuelve una lista de errores; vacia significa catalogo valido
static func validar(catalogo: Array) -> Array[String]:
    var errores: Array[String] = []
    var ids_vistos := {}
    for i in catalogo.size():
        var item = catalogo[i]
        var etiqueta := "item[%d]" % i
        if not item.has("id") or String(item["id"]).is_empty():
            errores.append("%s: falta 'id'" % etiqueta)
        elif ids_vistos.has(item["id"]):
            errores.append("%s: id duplicado '%s'" % [etiqueta, item["id"]])
        else:
            ids_vistos[item["id"]] = true
        if not item.has("precio") or int(item.get("precio", -1)) < 0:
            errores.append("%s: 'precio' ausente o negativo" % etiqueta)
    return errores
```

2. Envuélvela en un `EditorPlugin` con un dock que muestre el informe. Crea `addons/validador_items/plugin.gd`:

```gdscript
@tool
extends EditorPlugin

var dock: Button

func _enter_tree() -> void:
    dock = Button.new()
    dock.text = "Validar catalogo de items"
    dock.pressed.connect(_on_validar)
    add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree() -> void:
    remove_control_from_docks(dock)
    dock.queue_free()

func _on_validar() -> void:
    var texto := FileAccess.get_file_as_string("res://data/items.json")
    var catalogo = JSON.parse_string(texto)
    if catalogo == null:
        push_error("items.json no es JSON valido")
        return
    var errores := ValidadorItems.validar(catalogo)
    if errores.is_empty():
        print("Catalogo valido: sin errores")
    else:
        for e in errores:
            push_warning(e)
```

3. Declara el plugin para que el editor lo reconozca. Crea `addons/validador_items/plugin.cfg`:

```ini
[plugin]
name="Validador de items"
description="Valida el catalogo de items y reporta errores en un dock"
author="Tu nombre"
version="1.0.0"
script="plugin.gd"
```

4. **Testea la lógica** con GUT (la UI no; la lógica sí). Crea `test/test_validador.gd`:

```gdscript
extends GutTest

func test_catalogo_valido_no_da_errores() -> void:
    var cat := [{"id": "espada", "precio": 100}, {"id": "escudo", "precio": 50}]
    assert_eq(ValidadorItems.validar(cat).size(), 0)

func test_detecta_id_duplicado() -> void:
    var cat := [{"id": "pocion", "precio": 10}, {"id": "pocion", "precio": 20}]
    var errores := ValidadorItems.validar(cat)
    assert_true(errores.any(func(e): return e.contains("duplicado")))

func test_detecta_precio_negativo() -> void:
    var cat := [{"id": "bomba", "precio": -5}]
    assert_eq(ValidadorItems.validar(cat).size(), 1)
```

5. **Protege con CI**. Añade el paso de tests al workflow (clases 262 y 264), de modo que un cambio que rompa el validador se marque en rojo:

```yaml
      - name: Validar y testear la herramienta
        run: |
          ./godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test -gexit
```

Activa el plugin en `Project Settings → Plugins`, pulsa el botón del dock sobre un catálogo con errores y verás los avisos; corrígelos y desaparecen. Rompe la lógica del validador y CI cae en rojo. La lección observable: la herramienta resuelve una tarea real (validar datos antes de que rompan el juego), su lógica está testeada y CI la vigila en cada push. Eso es una herramienta terminada, no un prototipo.

## ✍️ Ejercicios

1. Añade una regla de validación más (por ejemplo, que `id` solo use minúsculas y guiones bajos) con su test.
2. Convierte el botón del dock en un panel que liste los errores en un `ItemList` en vez de la consola.
3. Ofrece la vía `@tool`: un generador que cree N ítems de plantilla y los escriba a `items.json`.
4. Añade un `workflow_dispatch` que corra solo los tests del validador de forma aislada.
5. Versiona la herramienta con un `CHANGELOG` y sube su `version` en `plugin.cfg` al añadir una regla.
6. Empaqueta el addon como `.zip` con un paso de CI que lo publique como artefacto.

## 📝 Reto verificable

Construye y documenta una herramienta útil real por una de las tres vías (plugin con dock, generador `@tool`, o pipeline de datos con validación). Entrega: especificación breve, la herramienta funcionando, tests GUT de su lógica y un workflow de CI que los ejecute. Cierra contra una definition of done explícita.

**Criterio de aceptación**: la herramienta resuelve una tarea concreta y se activa/usa dentro del editor de Godot; su lógica tiene al menos tres tests GUT que pasan por CLI con código de salida `0`; existe un workflow de GitHub Actions que corre esos tests en cada push y se marca en rojo si alguno falla; y un `README` documenta qué hace, cómo instalarla y su definition of done (funciona + tests verdes + CI activo).

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El plugin no aparece en la lista de Plugins | Falta `plugin.cfg` o su `script` apunta mal. Revisa la ruta y que el script extienda `EditorPlugin`. |
| El script `@tool` crashea el editor al editar | Ejecuta en el editor código que asume nodos de runtime. Protege con comprobaciones y `Engine.is_editor_hint()`. |
| Los tests dependen de la UI del dock | Mezclaste lógica y presentación. Extrae la lógica a una clase pura y testea solo esa. |
| El dock no se limpia al desactivar | Falta `remove_control_from_docks` y `queue_free` en `_exit_tree`. Añádelos para no dejar controles huérfanos. |
| CI verde pero la herramienta rota en el editor | Solo testeas la lógica, no la integración. Complementa con una prueba manual documentada en el checklist. |

## ❓ Preguntas frecuentes

**❓ ¿Qué vía elijo si tengo poco tiempo?** El pipeline de datos con validación: es el que más valor da por menos UI, y su lógica es fácil de testear y de meter en CI.

**❓ ¿`Engine.is_editor_hint()` para qué sirve?** Distingue si un script `@tool` corre en el editor o en el juego, para no ejecutar en diseño código que solo tiene sentido en runtime.

**❓ ¿Debo testear la interfaz del dock?** Prioriza la lógica pura. La UI se valida con una prueba manual anotada en el checklist; los unit tests cubren las reglas de negocio.

**❓ ¿Cómo distribuyo la herramienta a otros?** Empaqueta `addons/mi_herramienta/` en un `.zip` (o publícalo en el AssetLib). El `plugin.cfg` y la carpeta bastan para que otro proyecto lo active.

## 🔗 Referencias

- Godot Docs — Making plugins (`EditorPlugin`): <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html>
- Godot Docs — Running code in the editor (`@tool`): <https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html>
- GUT — documentación oficial: <https://gut.readthedocs.io/>
- GitHub Docs — Workflow syntax: <https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions>

## ➡️ Siguiente clase

[Clase 267 - Producción de juegos: scope, milestones y agile](../../parte-16-produccion-publicacion-monetizacion-y-liveops/267-produccion-de-juegos-scope-milestones-y-agile/README.md)
