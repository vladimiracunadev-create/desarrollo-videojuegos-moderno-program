# Clase 211 — Input de consola, logros y guardado en nube

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Input) y guías de logros/nube de plataformas*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Trabajar los tres pilares de la experiencia en consola desde Godot 4: el **input de gamepad** (que Godot sí maneja de forma nativa mediante su sistema de joypad), la mostrar los **glifos correctos** de botones según la plataforma, y la **abstracción del guardado** para que soporte tanto disco local como **guardado en la nube** del ecosistema (trofeos/logros y saved games los expone el porteador/servicio, no el motor).

La idea clave: aunque los logros y la nube de cada consola llegan por una capa externa, **tú puedes preparar el juego para todo ello desde ahora** con código Godot puro: detectar el mando con `Input.get_connected_joypads()`, identificarlo con `Input.get_joy_name()` para elegir el set de glifos, y encapsular el guardado tras una interfaz que luego enchufa la nube. Al terminar tendrás un sistema de glifos por plataforma y un guardado abstracto listo para cloud.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Detectar mandos conectados y su nombre con la API de joypad de Godot 4.
2. Seleccionar el conjunto de glifos de botones adecuado según la plataforma/mando.
3. Usar acciones del Input Map en lugar de códigos de botón fijos.
4. Diseñar una interfaz de guardado que abstraiga disco local y nube.
5. Explicar cómo encajan trofeos/logros y el guardado en nube del ecosistema de consola.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Joypad nativo en Godot | El input de mando sí es API del motor. |
| 2 | Detección de mando | Saber si hay mando y cuál define la UI. |
| 3 | Glifos por plataforma | Un icono de botón erróneo confunde y falla certificación. |
| 4 | Input Map por acciones | Desacopla la lógica de los botones físicos. |
| 5 | Trofeos/logros del ecosistema | Capa social propia de cada consola. |
| 6 | Guardado en nube | Continuidad entre sesiones y dispositivos. |
| 7 | Abstracción de guardado | Permite cambiar el backend sin tocar el juego. |
| 8 | Suspensión/resume y estado | El guardado debe ser robusto ante interrupciones. |

## 📖 Definiciones y características

- **Joypad (gamepad)**: mando estándar; Godot lo maneja nativamente con eventos `InputEventJoypadButton`/`Motion`. Clave: no necesita plugin para leerse.
- **`Input.get_connected_joypads()`**: devuelve la lista de IDs de mandos conectados. Clave: base para detectar presencia de mando.
- **`Input.get_joy_name(id)`**: nombre del mando (p. ej. "Xbox", "PS5", "Switch Pro"). Clave: permite inferir qué familia de glifos usar.
- **Glifo de botón**: icono que representa un botón físico (A/B/X/Y, cruz/círculo…). Clave: debe coincidir con el mando de la plataforma.
- **Input Map por acciones**: mapeo nombre-de-acción → entradas físicas. Clave: la lógica usa `Input.is_action_pressed("saltar")`, no un botón concreto.
- **Trofeo/logro**: recompensa social del ecosistema de consola. Clave: la desbloquea la capa nativa vía porteador, no Godot directamente.
- **Guardado en nube**: almacenamiento del progreso ligado a la cuenta del ecosistema. Clave: se enchufa detrás de tu interfaz de guardado.
- **Interfaz de guardado**: contrato (`guardar`/`cargar`) independiente del backend. Clave: hoy escribe a disco; mañana, a la nube.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y, si es posible, un **mando físico** (Xbox, PlayStation o Switch Pro) para probar la detección real. Prepara un pequeño set de iconos de botones por familia (Xbox y PlayStation como mínimo); para el laboratorio bastan marcadores de texto ("A", "✕") si no tienes arte.

Configura primero el **Input Map** en **Project → Project Settings → Input Map** con acciones como `saltar`, `disparar`, `pausa`, y asígnales tanto teclas como botones de mando. Documentación: Input de Godot <https://docs.godotengine.org/en/stable/tutorials/inputs/index.html> y mandos <https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html>.

## 🧪 Laboratorio guiado

Detectaremos el mando, elegiremos glifos por plataforma y abstraeremos el guardado para soportar nube.

1. Crea un autoload `Glifos` que detecte la familia del mando:

```gdscript
extends Node

enum Familia { TECLADO, XBOX, PLAYSTATION, NINTENDO }
var familia_actual: Familia = Familia.TECLADO

func _ready() -> void:
	Input.joy_connection_changed.connect(func(_id, _con): _actualizar())
	_actualizar()

func _actualizar() -> void:
	var mandos := Input.get_connected_joypads()
	if mandos.is_empty():
		familia_actual = Familia.TECLADO
		return
	var nombre := Input.get_joy_name(mandos[0]).to_lower()
	if "xbox" in nombre or "xinput" in nombre:
		familia_actual = Familia.XBOX
	elif "ps" in nombre or "dualsense" in nombre or "playstation" in nombre or "dualshock" in nombre:
		familia_actual = Familia.PLAYSTATION
	elif "switch" in nombre or "nintendo" in nombre:
		familia_actual = Familia.NINTENDO
	else:
		familia_actual = Familia.XBOX  # Xbox como estilo por defecto

func glifo_confirmar() -> String:
	# El botón "confirmar" cambia de símbolo según la plataforma.
	match familia_actual:
		Familia.PLAYSTATION: return "✕"
		Familia.NINTENDO: return "A"  # Nintendo intercambia A/B respecto a Xbox
		Familia.XBOX: return "A"
		_: return "Enter"
```

2. En tu UI de ayuda, pide el glifo dinámicamente en lugar de fijarlo:

```gdscript
func _process(_delta: float) -> void:
	$UI/Ayuda.text = "Pulsa %s para saltar" % Glifos.glifo_confirmar()
```

3. Usa siempre **acciones** del Input Map en la lógica, no botones concretos:

```gdscript
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("saltar"):
		_saltar()
```

4. Define una **interfaz de guardado** abstracta. Crea `res://guardado/almacen.gd`:

```gdscript
class_name Almacen
extends RefCounted

# Contrato de guardado. Las implementaciones concretas (disco, nube)
# heredan de aquí; el juego solo conoce esta interfaz.
func guardar(_datos: Dictionary) -> bool:
	push_error("guardar() no implementado")
	return false

func cargar() -> Dictionary:
	push_error("cargar() no implementado")
	return {}
```

5. Implementa el backend local `res://guardado/almacen_disco.gd`:

```gdscript
class_name AlmacenDisco
extends Almacen

const RUTA := "user://partida.save"

func guardar(datos: Dictionary) -> bool:
	# Escritura segura: temporal + renombrado para no corromper la partida.
	var tmp := RUTA + ".tmp"
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(datos))
	f.close()
	DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp),
		ProjectSettings.globalize_path(RUTA))
	return true

func cargar() -> Dictionary:
	if not FileAccess.file_exists(RUTA):
		return {}
	var f := FileAccess.open(RUTA, FileAccess.READ)
	var texto := f.get_as_text()
	f.close()
	var datos = JSON.parse_string(texto)
	return datos if datos is Dictionary else {}
```

6. En un autoload `Guardado`, elige el backend. Hoy es disco; el día del port, se sustituye por un `AlmacenNube` que hable con el servicio del ecosistema, **sin tocar el resto del juego**:

```gdscript
extends Node
var _almacen: Almacen = AlmacenDisco.new()

func guardar_partida(datos: Dictionary) -> void:
	_almacen.guardar(datos)

func cargar_partida() -> Dictionary:
	return _almacen.cargar()
```

7. Prueba: conecta y desconecta distintos mandos y observa cómo cambia el glifo; guarda y recarga la partida para validar el almacén.

## ✍️ Ejercicios

1. Añade glifos para más botones (saltar, cancelar, menú) por cada familia de mando.
2. Sustituye los símbolos de texto por iconos reales (`TextureRect`) según la familia.
3. Detecta en caliente el cambio de teclado a mando (y viceversa) al recibir el primer evento de cada tipo.
4. Escribe un `AlmacenNube` de mentira (mock) que herede de `Almacen` y registre las llamadas por consola.
5. Añade versionado a los datos guardados y una migración simple entre versiones.
6. Diseña la señal que emitiría el guardado en nube al detectar un conflicto entre dispositivos.

## 📝 Reto verificable

Implementa un sistema que (a) muestre el **glifo de confirmar correcto** según el mando conectado (al menos Xbox, PlayStation y teclado), usando `Input.get_connected_joypads()` y `Input.get_joy_name()`, y (b) guarde y cargue la partida a través de una **interfaz `Almacen`** con un backend de disco que use escritura segura. Deja preparado un segundo backend (mock de nube) intercambiable sin modificar el juego.

**Criterio de aceptación**: al cambiar de mando, el glifo mostrado se actualiza correctamente; guardar y volver a cargar restaura los datos; y cambiar el backend de `AlmacenDisco` a la implementación mock no requiere tocar la lógica del juego.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El juego siempre muestra glifos de Xbox | No consultas `get_joy_name()` o no reaccionas a `joy_connection_changed`. |
| El botón "confirmar" queda invertido en Nintendo | No contemplaste que Nintendo intercambia A/B respecto a Xbox. Ajusta el mapeo. |
| La lógica se rompe con otro mando | Usaste códigos de botón fijos en vez de acciones del Input Map. |
| Partida corrupta al guardar | Escribes directo sobre el archivo. Usa temporal + renombrado. |
| Migrar a nube exige reescribir el juego | El guardado no estaba abstraído. Encapsúlalo tras `Almacen`. |

## ❓ Preguntas frecuentes

**❓ ¿El input de mando necesita plugin en Godot?** No. Godot maneja gamepads de forma nativa; los eventos de joypad y las acciones del Input Map funcionan sin plugins.

**❓ ¿Cómo sé qué glifos mostrar?** Consulta `Input.get_joy_name()` del mando conectado e infiere la familia (Xbox, PlayStation, Nintendo) para elegir el set de iconos.

**❓ ¿Los logros/trofeos se programan en Godot?** La condición de desbloqueo sí la decides tú; el desbloqueo real en el ecosistema de consola lo expone la capa nativa del porteador/servicio.

**❓ ¿Por qué abstraer el guardado?** Porque la nube de cada consola es un backend distinto. Si el juego solo conoce la interfaz `Almacen`, cambiar a nube no toca la lógica.

## 🔗 Referencias

- Godot Docs — Controllers, gamepads and joysticks: <https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html>
- Godot Docs — InputEvent / Input Map: <https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html>
- Godot Docs — Saving games: <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>
- Godot Docs — FileAccess: <https://docs.godotengine.org/en/stable/classes/class_fileaccess.html>

## ➡️ Siguiente clase

[Clase 212 - Steam Deck y compatibilidad PC](../212-steam-deck-y-compatibilidad-pc/README.md)
