# Clase 196 — Accesibilidad en juegos

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Game Accessibility Guidelines; documentación de accesibilidad de Godot 4*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

La accesibilidad no es una función extra "para unos pocos": según estimaciones del sector, cientos de millones de personas conviven con alguna discapacidad que afecta a cómo juegan. Un texto minúsculo, un diálogo sin subtítulos, controles sin remapear o un puzle que exige distinguir rojo de verde pueden convertir tu juego en injugable para ellas, y en incómodo para muchos más. La buena noticia: la mayoría de ajustes son baratos si los piensas desde el diseño.

En esta clase añadirás a un juego un panel de accesibilidad con **escalado de texto**, **subtítulos** y **remapeo de teclas**, y verás cómo se implementa un **filtro de daltonismo** (con mención al enfoque por shader). Te apoyarás en las **Game Accessibility Guidelines** como checklist objetivo para no diseñar "a intuición".

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Clasificar necesidades de accesibilidad: visual, auditiva, motora y cognitiva.

2. Escalar el tamaño de fuente de toda la UI mediante `Theme` en runtime.

3. Mostrar subtítulos legibles con `Label`/`RichTextLabel` para audio y diálogo.

4. Remapear acciones de entrada por código con `InputMap` y persistir la config.

5. Explicar cómo un filtro de daltonismo por shader corrige la paleta percibida.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Los cuatro ejes de accesibilidad | Ordena qué barreras existen y cómo atacarlas. |
| 2 | Contraste y legibilidad | Base de la accesibilidad visual, útil para todos. |
| 3 | Escalado de fuente vía Theme | Permite leer sin depender del zoom del sistema. |
| 4 | Subtítulos y señales visuales de audio | Único acceso a la información sonora para muchos. |
| 5 | Remapeo de input con `InputMap` | Adapta los controles a cada capacidad motora. |
| 6 | Hold-to-toggle y tiempos ajustables | Reducen la fatiga y la exigencia motora. |
| 7 | Daltonismo y paletas seguras | Evita codificar información solo por color. |
| 8 | Game Accessibility Guidelines | Convierte la accesibilidad en checklist verificable. |

## 📖 Definiciones y características

- **Contraste**: diferencia de luminancia entre texto y fondo. Clave: apunta a una relación alta (WCAG sugiere ≥4.5:1 para texto normal).

- **Escalado de fuente**: cambiar el `default_font_size` del `Theme` para agrandar todo el texto de golpe. Clave: un solo ajuste afecta a toda la UI.

- **Subtítulos**: texto sincronizado de diálogos y efectos sonoros relevantes. Clave: incluye quién habla y sonidos clave ("[puerta cruje]").

- **Remapeo**: reasignar qué tecla/botón dispara cada acción. Clave: `InputMap` permite hacerlo en runtime sin recompilar.

- **Hold-to-toggle**: opción de convertir "mantener pulsado" en "pulsar una vez para activar/desactivar". Clave: alivia acciones sostenidas difíciles.

- **Daltonismo**: dificultad para distinguir ciertos colores (protanopía, deuteranopía, tritanopía). Clave: no codifiques información solo con color; añade forma o texto.

- **Filtro de daltonismo**: shader de post-proceso que recolorea la imagen para separar tonos confundibles. Clave: se aplica sobre el viewport completo.

- **Game Accessibility Guidelines**: catálogo de recomendaciones por nivel (básico, intermedio, avanzado). Clave: sirve como lista de verificación priorizada.

## 🧰 Herramientas y preparación

Usaremos **Godot 4.x**. Crea o reutiliza un juego pequeño con algo de texto y un par de acciones de input. Necesitas un `Theme` propio para el proyecto: créalo en el sistema de archivos (**+ > New Resource > Theme**) y asígnalo en *Project Settings > GUI > Theme > Custom*. La referencia central de esta clase es <https://gameaccessibilityguidelines.com/>, que ofrece la checklist por niveles; complétala con la [documentación de accesibilidad de Godot](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html) y, para TTS, con `DisplayServer.tts_*`. Ten a mano un verificador de contraste (por ejemplo el de WebAIM).

## 🧪 Laboratorio guiado

Añadiremos un panel de accesibilidad con escalado de texto, subtítulos y remapeo.

1. Prepara el `Theme` del proyecto. En un autoload `Ajustes` guarda una referencia al tema activo. Para escalar todo el texto, cambia su `default_font_size`:

```gdscript
extends Node
# Autoload: Ajustes

var tema: Theme

func _ready() -> void:
	tema = load("res://ui/tema_juego.tres")
	ThemeDB.get_project_theme()  # existe si lo asignaste en Project Settings

func aplicar_escala_texto(escala: float) -> void:
	# Base 16 px; escala 1.0 = normal, 1.5 = grande, 2.0 = enorme.
	tema.default_font_size = int(round(16 * escala))
```

2. Crea el panel de accesibilidad (`Control` con `VBoxContainer`). Añade un `HSlider` `SldTexto` (rango 1.0–2.0, paso 0.25) etiquetado "Tamaño de texto" y conéctalo:

```gdscript
func _on_sld_texto_value_changed(valor: float) -> void:
	Ajustes.aplicar_escala_texto(valor)
	# La UI que usa el tema se reescala sola al cambiar default_font_size.
```

3. Ejecuta y mueve el slider: todo el texto que hereda del `Theme` crece y encoge. Verifica que los contenedores acompañan sin recortar.

4. Añade **subtítulos**. Crea un `Label` `Subtitulo` anclado abajo-centro con fondo semitransparente (un `StyleBox` con panel oscuro) para garantizar contraste. Muéstralos así:

```gdscript
@onready var subtitulo: Label = $Subtitulo

func mostrar_subtitulo(texto: String, segundos: float = 3.0) -> void:
	subtitulo.text = texto
	subtitulo.visible = true
	await get_tree().create_timer(segundos).timeout
	subtitulo.visible = false
```

Llama `mostrar_subtitulo("[explosión] ¡Cuidado!")` cuando suene un efecto clave.

5. Implementa **remapeo de teclas** con `InputMap`. Añade un `Button` "Reasignar saltar" y captura la siguiente tecla:

```gdscript
var esperando_tecla: bool = false

func _on_btn_remapear_pressed() -> void:
	esperando_tecla = true

func _input(event: InputEvent) -> void:
	if esperando_tecla and event is InputEventKey and event.pressed:
		# Quitamos los eventos previos de la acción y ponemos el nuevo.
		InputMap.action_erase_events("saltar")
		InputMap.action_add_event("saltar", event)
		esperando_tecla = false
		print("Saltar reasignado a ", event.as_text())
```

6. Ejecuta, pulsa "Reasignar saltar" y presiona otra tecla: a partir de ese momento la acción `saltar` responde a la nueva tecla. Guarda el mapeo en un archivo de config (`ConfigFile`) para persistirlo entre sesiones.

7. Añade una opción de **daltonismo**. Explica y prepara el enfoque por **shader**: un `ColorRect` a pantalla completa con material de post-proceso que multiplica los canales para separar rojo/verde. Aquí basta mencionar el shader; como alternativa sin shader, ofrece **paletas alternativas** y no codifiques nada solo por color (añade iconos o texto).

8. Verifica con las **Game Accessibility Guidelines**: repasa la lista de nivel básico (texto escalable, subtítulos, remapeo, no depender solo del color) y marca qué cumples. Ajusta lo que falte.

**Entregable observable**: un panel de accesibilidad donde el slider agranda todo el texto en vivo, aparecen subtítulos legibles con buen contraste, una acción se remapea a otra tecla y funciona, y una opción anuncia el modo daltonismo.

## ✍️ Ejercicios

1. Añade un tercer nivel de escala de texto ("enorme", 2.0) y comprueba que ningún menú se rompe.

2. Da a los subtítulos un fondo con contraste ≥4.5:1 y verifícalo con un comprobador de contraste.

3. Persiste el remapeo con `ConfigFile` y recárgalo en `_ready`.

4. Implementa una opción **hold-to-toggle** para una acción sostenida (correr) y describe el cambio de sensación.

5. Sustituye una señal codificada por color (enemigo rojo / aliado verde) por color + icono, y explica por qué mejora.

6. Prueba `DisplayServer.tts_speak("Menú principal", 0)` y comenta cuándo un TTS ayuda.

## 📝 Reto verificable

Añade a un juego un menú de accesibilidad con, como mínimo: escalado de texto en tres niveles, subtítulos con contraste suficiente, remapeo de al menos dos acciones persistido entre sesiones, y una opción que evite depender solo del color.

**Criterio de aceptación**: cambiar la escala agranda todo el texto sin romper la UI; los subtítulos son legibles sobre cualquier fondo; las acciones remapeadas responden a las nuevas teclas tras reiniciar el juego; y al menos una señal de juego se comunica con forma/texto además de color.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El texto no crece al mover el slider | Los nodos no usan el `Theme` del proyecto o tienen override de fuente. Quita overrides o edita `default_font_size`. |
| Los subtítulos no se leen sobre fondos claros | Sin panel de contraste. Añade un `StyleBox` oscuro semitransparente detrás del `Label`. |
| El remapeo se pierde al reiniciar | No se persiste. Guarda y carga con `ConfigFile`. |
| Información invisible para daltónicos | Todo codificado por color. Añade iconos, patrones o texto. |
| El TTS no dice nada | Motor de voz no disponible en la plataforma. Comprueba `DisplayServer.tts_get_voices()`. |

## ❓ Preguntas frecuentes

**❓ ¿La accesibilidad encarece mucho el desarrollo?** Si la piensas desde el inicio, casi no: escalar por `Theme`, subtitular y permitir remapeo son cambios pequeños. Añadirla al final sí cuesta más.

**❓ ¿Basta con dar opciones de daltonismo por color?** No solo; lo más robusto es no codificar información crítica únicamente por color. El filtro es un complemento, no la solución completa.

**❓ ¿Debo cumplir todas las Game Accessibility Guidelines?** No es todo o nada. Prioriza el nivel básico (alto impacto, bajo coste) y sube según recursos.

**❓ ¿Godot tiene lector de pantalla nativo?** Godot 4 incorpora soporte de accesibilidad y TTS vía `DisplayServer.tts_*`; su alcance depende de la plataforma. Verifica voces disponibles antes de confiar en él.

## 🔗 Referencias

- Game Accessibility Guidelines: <https://gameaccessibilityguidelines.com/>

- Godot — Using the theme editor: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html>

- Godot — InputMap y remapeo en runtime: <https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html>

- WebAIM — Contrast Checker: <https://webaim.org/resources/contrastchecker/>

## ➡️ Siguiente clase

[Clase 197 - Localización e internacionalización (i18n)](../197-localizacion-e-internacionalizacion-i18n/README.md)
