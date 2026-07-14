# Clase 199 — Capstone Parte 10: una UI completa, accesible y localizada

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (UI, i18n, accesibilidad); Game Accessibility Guidelines*
> ⏱️ Duración estimada: **110 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Es hora de juntar todo lo de la Parte 10 en un único entregable que puedas enseñar en tu portfolio. En este capstone ensamblarás una **UI completa** —menú principal, HUD de juego y pantalla de opciones— que sea **responsive** (varias resoluciones y aspect ratios), **navegable** con teclado, gamepad y táctil, con **opciones de accesibilidad** (escalado de texto, subtítulos, remapeo) y **localizada** a dos idiomas cambiables en runtime, todo unificado por un **Theme** coherente.

Este documento funciona como **especificación + checklist + definition of done**. No introduce conceptos nuevos: integra las clases 194–198 en un sistema que funciona junto. El foco está en que las piezas convivan sin romperse entre sí (por ejemplo, que agrandar el texto no descoloque la HUD anclada, o que cambiar de idioma no rompa el layout responsive).

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Integrar theming, responsive, input múltiple, accesibilidad y l10n en una sola UI.

2. Organizar la UI en escenas reutilizables (menú, HUD, opciones) con un autoload de ajustes.

3. Verificar la UI contra una checklist objetiva y una definition of done.

4. Persistir preferencias (idioma, escala de texto, remapeo) entre sesiones.

5. Detectar y resolver conflictos entre requisitos (p. ej. escala de texto vs anclas).

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Arquitectura de escenas de UI | Separar menú/HUD/opciones facilita mantener y reusar. |
| 2 | Autoload de ajustes | Centraliza idioma, escala y remapeo accesibles desde todo el juego. |
| 3 | Theme unificado | Da coherencia visual y habilita el escalado global. |
| 4 | Responsive + safe zone | La UI debe sobrevivir a cualquier pantalla. |
| 5 | Input triple simultáneo | Teclado, gamepad y táctil sin exclusión. |
| 6 | Panel de accesibilidad | Reúne texto, subtítulos y remapeo. |
| 7 | Selector de idioma en runtime | Cierra el ciclo de localización. |
| 8 | Persistencia con ConfigFile | Guarda las preferencias del jugador. |

## 📖 Definiciones y características

- **Capstone**: proyecto integrador que demuestra el dominio de toda una parte. Clave: se evalúa por su funcionamiento conjunto, no por piezas sueltas.

- **Autoload (singleton)**: nodo global accesible desde cualquier escena. Clave: ideal para el estado de ajustes (idioma, escala, mapeo).

- **Definition of Done (DoD)**: lista de condiciones que deben cumplirse para dar la tarea por terminada. Clave: elimina la ambigüedad de "ya está".

- **Escena de UI reutilizable**: `.tscn` autocontenido (p. ej. `Opciones.tscn`) instanciable desde varios lugares. Clave: reduce duplicación.

- **Persistencia**: guardar preferencias en disco con `ConfigFile`. Clave: el jugador no reconfigura cada vez que abre el juego.

- **ConfigFile**: recurso de Godot para leer/escribir archivos `.cfg` clave-valor por secciones. Clave: simple y suficiente para ajustes.

- **Checklist de aceptación**: verificación punto por punto antes de entregar. Clave: hace objetivo el "funciona".

- **Conflicto de requisitos**: cuando cumplir un requisito estropea otro. Clave: el capstone se supera resolviéndolos, no ignorándolos.

## 🧰 Herramientas y preparación

Usaremos **Godot 4.x**. Reutiliza lo construido en 194–198: la HUD responsive, el menú navegable, el panel de accesibilidad, el CSV de traducciones y la fuente con fallback. Organiza el proyecto en `res://ui/` (escenas), `res://locale/` (CSV) y `res://fonts/`. Crea un autoload `Ajustes` en *Project Settings > Autoload*. Referencias base: [UI de Godot](https://docs.godotengine.org/en/stable/tutorials/ui/index.html), [i18n](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) y la checklist de <https://gameaccessibilityguidelines.com/>. Ten definido un `Theme` de proyecto como pieza que unifica todo.

## 🧪 Laboratorio guiado

Ensamblaremos la UI completa alrededor de un autoload de ajustes persistente.

1. Crea el autoload `Ajustes` que centraliza idioma, escala de texto y remapeo, y persiste con `ConfigFile`:

```gdscript
extends Node
# Autoload: Ajustes

const RUTA := "user://ajustes.cfg"
var tema: Theme
var idioma: String = "es"
var escala_texto: float = 1.0

func _ready() -> void:
	tema = load("res://ui/tema_juego.tres")
	cargar()
	aplicar_todo()

func aplicar_todo() -> void:
	TranslationServer.set_locale(idioma)
	tema.default_font_size = int(round(16 * escala_texto))

func guardar() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("general", "idioma", idioma)
	cfg.set_value("general", "escala_texto", escala_texto)
	# Guardamos el remapeo de la accion "saltar" como texto de su evento.
	var eventos := InputMap.action_get_events("saltar")
	if eventos.size() > 0 and eventos[0] is InputEventKey:
		cfg.set_value("input", "saltar", eventos[0].physical_keycode)
	cfg.save(RUTA)

func cargar() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(RUTA) != OK:
		return
	idioma = cfg.get_value("general", "idioma", "es")
	escala_texto = cfg.get_value("general", "escala_texto", 1.0)
	var kc = cfg.get_value("input", "saltar", null)
	if kc != null:
		var ev := InputEventKey.new()
		ev.physical_keycode = kc
		InputMap.action_erase_events("saltar")
		InputMap.action_add_event("saltar", ev)
```

2. Monta la escena `Menu.tscn`: `Control` raíz con preset **Full Rect**, `VBoxContainer` centrado con botones (`MENU_JUGAR`, `MENU_OPCIONES`, `MENU_SALIR` como claves). Da foco inicial con `grab_focus()` y estilo de foco visible en el Theme. Añade un `TouchScreenButton` para "atrás" en móvil.

3. Monta `HUD.tscn` (de la clase 194): esquinas ancladas, aviso central, respeto de safe zone. Los textos con variable usan `tr("HUD_VIDAS").format([...])`.

4. Monta `Opciones.tscn` integrando el panel de accesibilidad + selector de idioma:

```gdscript
extends Control

@onready var hud: Control = get_node_or_null("/root/Juego/HUD")

func _on_sld_texto_value_changed(v: float) -> void:
	Ajustes.escala_texto = v
	Ajustes.aplicar_todo()
	Ajustes.guardar()

func _on_sel_idioma_item_selected(indice: int) -> void:
	Ajustes.idioma = ["es", "en"][indice]
	Ajustes.aplicar_todo()
	Ajustes.guardar()
	if hud: hud.refrescar_textos()  # re-aplica textos generados por codigo
```

5. Verifica la **convivencia de requisitos**: activa la escala de texto máxima (2.0) y comprueba que la HUD anclada no se recorta (usa contenedores flexibles donde el texto crece). Cambia a inglés y confirma que ningún botón se desborda (expansión de texto). Este paso es el corazón del capstone: las piezas no deben pelearse.

6. Prueba el **input triple**: recorre menú y opciones solo con teclado, luego solo con gamepad (foco visible y cíclico), luego con toques (emula táctil). El `TouchScreenButton` de "atrás" debe funcionar en paralelo.

7. Prueba **responsive**: ejecuta en 16:9, cambia a 21:9 y 4:3 y redimensiona la ventana en vivo. Nada se recorta ni se descoloca.

8. Cierra y reabre el juego: idioma, escala de texto y remapeo deben **persistir** (los cargó `Ajustes` desde `user://ajustes.cfg`).

**Entregable observable**: un proyecto con menú + HUD + opciones bajo un Theme común, que se adapta a varias resoluciones, es operable con teclado/gamepad/táctil, ofrece escalado de texto, subtítulos y remapeo, cambia entre dos idiomas en runtime y conserva las preferencias entre sesiones.

## ✍️ Ejercicios

1. Añade una pantalla de pausa que reutilice `Opciones.tscn` sin duplicar código.

2. Incluye subtítulos disparados por un evento de juego y verifica su contraste.

3. Permite remapear una segunda acción y persístela junto a la primera.

4. Añade un tercer idioma al CSV y al selector; comprueba que persiste.

5. Muestra el estado actual (idioma y escala) en la esquina de la HUD para depurar.

6. Documenta con capturas que la UI cumple en tres aspect ratios.

## 📝 Reto verificable

Entrega un proyecto Godot con una UI completa (menú + HUD + opciones), theming unificado, responsive, navegable por los tres inputs, con accesibilidad (escala de texto, subtítulos, remapeo), localizada a dos idiomas en runtime y con preferencias persistentes.

**Definition of Done / Criterio de aceptación**: (1) la UI no se rompe en 16:9, 21:9 ni 4:3, ni al redimensionar en vivo; (2) todo el flujo es operable solo con teclado, solo con gamepad y solo con táctil, con foco siempre visible; (3) el escalado de texto afecta a toda la UI sin recortes; (4) hay subtítulos legibles y al menos una acción remapeable; (5) el idioma cambia en runtime y toda la UI (incluidos textos por código) se actualiza; (6) idioma, escala y remapeo persisten tras cerrar y reabrir el juego.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Al escalar el texto, la HUD anclada recorta contenido | Contenedores rígidos. Usa `MarginContainer`/`VBox` con `size_flags` donde el texto crece. |
| El HUD no cambia de idioma pero el menú sí | El HUD usa `tr()` por código sin re-aplicar. Llama a `refrescar_textos()` tras `set_locale`. |
| Las preferencias no persisten | Falta `guardar()` o ruta incorrecta. Usa `user://` y guarda tras cada cambio. |
| El gamepad no navega opciones | Escena sin foco inicial. Llama a `grab_focus()` al abrirla. |
| El botón táctil tapa un control con foco | Solapamiento de capas. Ordena el árbol y ajusta `mouse_filter`/posición. |

## ❓ Preguntas frecuentes

**❓ ¿Debo hacerlo todo en una sola escena?** No; separa `Menu`, `HUD` y `Opciones` en escenas y comparte estado mediante el autoload `Ajustes`. Es más limpio y reutilizable.

**❓ ¿Qué pasa si un requisito choca con otro?** Es esperado; resuélvelo con contenedores flexibles y holgura. Documentar el conflicto y su solución también forma parte del capstone.

**❓ ¿`user://` o `res://` para guardar ajustes?** Siempre `user://`: `res://` es de solo lectura en el juego exportado.

**❓ ¿Cómo demuestro que cumple la DoD?** Recorre la checklist punto por punto con capturas o un vídeo corto mostrando cada condición en funcionamiento.

## 🔗 Referencias

- Godot — UI (índice general): <https://docs.godotengine.org/en/stable/tutorials/ui/index.html>

- Godot — Internationalizing games: <https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html>

- Godot — ConfigFile (persistencia): <https://docs.godotengine.org/en/stable/classes/class_configfile.html>

- Game Accessibility Guidelines: <https://gameaccessibilityguidelines.com/>

## ➡️ Siguiente clase

[Clase 200 - Panorama de plataformas y sus restricciones](../../parte-11-movil-consolas-y-plataformas/200-panorama-de-plataformas-y-sus-restricciones/README.md)
