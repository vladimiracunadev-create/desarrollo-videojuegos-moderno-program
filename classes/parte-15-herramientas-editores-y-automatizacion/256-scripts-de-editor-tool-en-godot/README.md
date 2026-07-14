# Clase 256 — Scripts de editor (@tool) en Godot

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Running code in the editor) y clase `Node._get_configuration_warnings`*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Godot puede ejecutar tu GDScript **dentro del propio editor**, no solo al pulsar F5. Basta con anotar el script con `@tool`: a partir de ahí, `_ready`, `_process` y tus funciones corren mientras editas la escena, permitiéndote **previsualizar en vivo** generación procedural, colocación de objetos o cálculos geométricos sin lanzar el juego. Es la puerta de entrada a todo el tooling en Godot.

Con ese poder llega una responsabilidad concreta: un script `@tool` mal escrito puede **corromper la escena guardada** o llenar de nodos huérfanos tu proyecto. En esta clase dominamos `Engine.is_editor_hint()` para separar el comportamiento de editor del de juego, usamos `_get_configuration_warnings()` para avisar al diseñador de configuraciones inválidas directamente en el árbol de escena, y construimos un **generador de vallas** que coloca postes en vivo según un parámetro exportado.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Activar la ejecución en el editor con `@tool` y explicar qué callbacks corren y cuándo.
2. Distinguir contexto de editor y de juego con `Engine.is_editor_hint()`.
3. Regenerar contenido en vivo al cambiar un `@export` mediante `setter` o `NOTIFICATION`.
4. Emitir avisos de configuración con `_get_configuration_warnings()` y `update_configuration_warnings()`.
5. Evitar la corrupción de escena limpiando nodos generados antes de recrearlos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | La anotación `@tool` | Habilita que el script corra dentro del editor. |
| 2 | `Engine.is_editor_hint()` | Separa lógica de editor de lógica de juego. |
| 3 | Reaccionar a cambios de `@export` | Permite previsualizar al mover un slider. |
| 4 | Regenerar sin duplicar nodos | Evita acumular basura en el árbol. |
| 5 | `_get_configuration_warnings()` | Guía al diseñador sin abrir la consola. |
| 6 | Riesgo de corromper la escena | Un `@tool` descuidado daña archivos `.tscn`. |
| 7 | `owner` y nodos visibles en el árbol | Determina qué se guarda con la escena. |
| 8 | Depurar scripts de editor | El flujo de errores difiere del runtime. |

## 📖 Definiciones y características

- **`@tool`**: anotación al inicio del script que autoriza su ejecución en el editor. Clave: sin ella, el código solo corre al ejecutar el juego.
- **`Engine.is_editor_hint()`**: devuelve `true` cuando el código corre dentro del editor. Clave: envuelve lo que NO debe ocurrir mientras editas (por ejemplo, iniciar física).
- **Setter de `@export`**: función asignada con `: set(valor)` que se dispara al cambiar la propiedad. Clave: es donde regeneras la previsualización.
- **`_get_configuration_warnings()`**: método que devuelve un `PackedStringArray` de avisos mostrados como triángulo amarillo en el árbol. Clave: solo tiene efecto en nodos `@tool`.
- **`update_configuration_warnings()`**: fuerza a Godot a reevaluar los avisos. Clave: llámalo cuando cambie algo que afecte a la validez.
- **`owner`**: nodo dueño que decide si un hijo se serializa en la escena. Clave: sin `owner` correcto, los nodos generados no se guardan o se guardan mal.
- **Nodo huérfano**: nodo creado y no liberado que persiste ocupando memoria. Clave: en `@tool` se acumulan si no limpias antes de regenerar.
- **Corrupción de escena**: estado en que el `.tscn` guarda datos inconsistentes generados por un `@tool`. Clave: se previene regenerando de forma idempotente.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**. Trabajaremos con un único script `@tool` adjunto a un nodo `Node3D` (o `Node2D` si prefieres 2D). No hace falta ningún plugin: `@tool` es una anotación del lenguaje, disponible en cualquier script.

Lee la guía oficial de código en el editor antes de empezar, porque documenta los matices de ciclo de vida: <https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html>. Para los avisos, consulta `Node._get_configuration_warnings`: <https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-private-method-get-configuration-warnings>.

## 🧪 Laboratorio guiado

Construiremos un **generador de vallas**: un nodo que coloca postes equiespaciados en vivo según parámetros exportados, y que avisa si la configuración no tiene sentido.

1. Crea una escena con raíz `Node3D` llamada `Valla`, adjunta un script nuevo y anótalo con `@tool` en la **primera línea**. Declara los parámetros con setters que disparan la regeneración:

```gdscript
@tool
extends Node3D

@export var longitud: float = 10.0:
	set(v):
		longitud = max(v, 0.0)
		_regenerar()

@export var num_postes: int = 5:
	set(v):
		num_postes = max(v, 2)
		_regenerar()
		update_configuration_warnings()

@export var altura_poste: float = 1.5:
	set(v):
		altura_poste = max(v, 0.1)
		_regenerar()
```

2. Implementa la regeneración de forma **idempotente**: borra los postes anteriores y recrea. Marca los postes con un grupo para reconocerlos y no tocar otros hijos:

```gdscript
func _regenerar() -> void:
	# Elimina postes previos para no duplicar.
	for hijo in get_children():
		if hijo.is_in_group("poste_generado"):
			hijo.queue_free()

	if num_postes < 2:
		return

	var paso: float = longitud / float(num_postes - 1)
	for i in num_postes:
		var poste := MeshInstance3D.new()
		var caja := BoxMesh.new()
		caja.size = Vector3(0.1, altura_poste, 0.1)
		poste.mesh = caja
		poste.position = Vector3(paso * i, altura_poste * 0.5, 0.0)
		poste.add_to_group("poste_generado")
		add_child(poste)
		# Sin owner, el poste no se guarda en la escena.
		poste.owner = get_tree().edited_scene_root
```

3. Añade avisos de configuración para guiar al diseñador desde el propio árbol de escena, sin abrir la consola:

```gdscript
func _get_configuration_warnings() -> PackedStringArray:
	var avisos: PackedStringArray = []
	if longitud <= 0.0:
		avisos.append("La longitud debe ser mayor que 0.")
	if num_postes < 2:
		avisos.append("Se necesitan al menos 2 postes para una valla.")
	return avisos
```

4. Guarda y observa el árbol: al ajustar `num_postes` o `longitud` en el Inspector, **los postes aparecen y se reposicionan en vivo**. Pon `num_postes` en 1 y verás el triángulo de aviso amarillo junto al nodo `Valla`.

5. Protege el comportamiento de juego. Si más adelante añades física o sonido, envuélvelo para que **solo corra fuera del editor**:

```gdscript
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	# Aquí iría lógica exclusiva del juego (audio, física...).
```

6. Comprueba la persistencia: guarda la escena, ciérrala y reábrela. Los postes deben seguir ahí porque asignamos `owner`. Si los borras y cambias un parámetro, se regeneran sin duplicados. Esa **idempotencia** es lo que evita corromper la escena.

La lección observable: mueves un slider y la geometría responde en el editor, con avisos claros cuando la configuración es inválida.

## ✍️ Ejercicios

1. Añade un `@export` de separación mínima y emite un aviso si `longitud / num_postes` cae por debajo.
2. Sustituye los postes por travesaños horizontales adicionales entre cada par.
3. Agrega un `@export_enum` para elegir la forma del poste (caja o cilindro) y regénéralo.
4. Implementa un botón `@export var regenerar: bool` que al marcarse fuerce `_regenerar()` y se auto-desmarque.
5. Haz que `_ready()` llame a `_regenerar()` solo en el editor para reconstruir al abrir la escena.
6. Añade un aviso si el nodo no tiene `edited_scene_root` (por ejemplo, si es la raíz) para evitar `owner` nulo.

## 📝 Reto verificable

Crea un generador `@tool` de una estructura repetitiva a tu elección (una escalera, una fila de columnas, una cerca curva). Debe: regenerar en vivo al cambiar al menos tres `@export`, ser idempotente (no duplica nodos al reajustar), asignar `owner` para persistir, emitir al menos dos avisos de `_get_configuration_warnings()` y proteger con `Engine.is_editor_hint()` cualquier lógica de juego.

**Criterio de aceptación**: al abrir la escena guardada los nodos generados persisten sin duplicarse; ajustar los parámetros los recoloca en vivo; y forzar una configuración inválida muestra el triángulo de aviso con el mensaje correcto en el árbol de escena.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Al reajustar un parámetro se duplican los nodos | La regeneración no borra los previos. Libera con `queue_free()` los del grupo antes de recrear. |
| Los nodos generados no se guardan en la escena | Falta `owner`. Asigna `poste.owner = get_tree().edited_scene_root`. |
| El editor se congela o crashea al editar | Bucle infinito o física activa en `@tool`. Envuelve lo de runtime en `if Engine.is_editor_hint(): return`. |
| `_get_configuration_warnings()` no muestra nada | El script no tiene `@tool` o no llamaste `update_configuration_warnings()`. Añade ambos. |
| Cambios raros al reabrir el `.tscn` | Escena corrupta por escritura no idempotente. Haz la regeneración determinista y limpia. |

## ❓ Preguntas frecuentes

**❓ ¿`@tool` afecta al rendimiento del juego final?** No de forma notable: en runtime el código corre igual, y el bloque de editor lo saltas con `Engine.is_editor_hint()`. Solo cuida no dejar trabajo pesado en `_process` del editor.

**❓ ¿Por qué mi script `@tool` no corre en el editor?** La anotación debe ir en la **primera línea** del archivo, antes de `extends`. Además, tras añadirla conviene recargar la escena.

**❓ ¿Debo asignar `owner` a todos los nodos generados?** Solo a los que quieras que se guarden con la escena. Nodos puramente visuales de previsualización pueden dejarse sin `owner` si no deben persistir.

**❓ ¿`_get_configuration_warnings()` funciona en scripts normales?** No: requiere `@tool`. En un script no-tool, el editor no ejecuta el método y no aparece ningún aviso.

## 🔗 Referencias

- Godot Docs — Running code in the editor: <https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html>
- Godot Docs — `Engine.is_editor_hint`: <https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-is-editor-hint>
- Godot Docs — `Node._get_configuration_warnings`: <https://docs.godotengine.org/en/stable/classes/class_node.html>
- Godot Docs — GDScript exports: <https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html>

## ➡️ Siguiente clase

[Clase 257 - Plugins de editor y docks personalizados](../257-plugins-de-editor-y-docks-personalizados/README.md)
