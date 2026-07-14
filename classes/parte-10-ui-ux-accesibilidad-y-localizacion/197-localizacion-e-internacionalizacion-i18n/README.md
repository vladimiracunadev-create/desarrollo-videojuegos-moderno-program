# Clase 197 — Localización e internacionalización (i18n)

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 — Internationalizing games*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego solo en inglés (o solo en español) deja fuera a la mayor parte del mercado global. Pero traducir no es solo pasar frases: si tienes los textos "hardcodeados" repartidos por escenas y scripts, cada idioma nuevo es una pesadilla. La solución profesional es separar **texto de código** desde el principio mediante **internacionalización (i18n)** y luego **localizar (l10n)** con archivos de traducción que un traductor puede editar sin tocar el juego.

En esta clase aprenderás la diferencia entre i18n y l10n, usarás el **TranslationServer** y la función `tr()` con **claves**, cargarás traducciones desde un **CSV**, y cambiarás el idioma **en runtime** viendo cómo toda la UI se actualiza al instante. También verás cómo manejar variables, plurales y la temida **expansión de texto** entre idiomas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diferenciar internacionalización (i18n) de localización (l10n) y sus responsabilidades.

2. Usar claves de traducción con `tr()` en lugar de texto literal.

3. Importar un CSV de traducciones y registrarlo en Project Settings > Localization.

4. Cambiar el idioma en runtime con `TranslationServer.set_locale()` y refrescar la UI.

5. Insertar variables y gestionar plurales y expansión de texto de forma segura.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | i18n vs l10n | Aclara qué se prepara en código y qué traduce cada idioma. |
| 2 | Claves vs texto como identificador | Las claves evitan romper traducciones al editar el original. |
| 3 | `tr()` y `TranslationServer` | Es el mecanismo central para resolver textos. |
| 4 | Archivos CSV y PO | Formatos que editan traductores sin abrir Godot. |
| 5 | Cambio de locale en runtime | Permite un selector de idioma en el menú. |
| 6 | Variables en cadenas | Insertan nombres, números o cantidades. |
| 7 | Plurales | "1 vida" vs "3 vidas" cambia según idioma. |
| 8 | Expansión de texto | El alemán o el ruso ocupan mucho más espacio. |

## 📖 Definiciones y características

- **Internacionalización (i18n)**: preparar el juego para admitir varios idiomas (extraer textos, usar claves). Clave: es trabajo de programación, se hace una vez.

- **Localización (l10n)**: adaptar el contenido a un idioma/cultura concretos. Clave: es trabajo de traducción, se repite por idioma.

- **Clave de traducción**: identificador estable como `MENU_JUGAR`. Clave: no cambia aunque edites el texto mostrado, así no rompes otras traducciones.

- **`tr(clave)`**: método de Object que devuelve la cadena traducida al locale activo. Clave: si no hay traducción, devuelve la clave tal cual (útil para detectar huecos).

- **CSV de traducciones**: tabla con una columna `keys` y una por idioma (`es`, `en`...). Clave: Godot lo importa como recurso de traducción automáticamente.

- **`TranslationServer.set_locale("en")`**: cambia el idioma activo del juego. Clave: los nodos que usan traducción automática se refrescan; los textos puestos por código deben re-aplicarse.

- **Plural**: forma que cambia según cantidad. Clave: usa archivos PO con reglas de plural o resuelve la forma por código.

- **Expansión de texto**: crecimiento de longitud al traducir. Clave: diseña botones y cuadros con holgura (a veces +30–40%).

## 🧰 Herramientas y preparación

Usaremos **Godot 4.x** y un editor de hojas de cálculo (LibreOffice Calc, Excel o cualquier editor de texto) para el CSV. **Importante:** guarda el CSV con codificación **UTF-8** y separador por comas, y con salto de línea al final. Godot detecta automáticamente los CSV de traducción con una columna `keys`. Registra el resultado en **Project > Project Settings > Localization**. Ten a mano la guía oficial de [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) y la de [Localization using gettext](https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_gettext.html) si prefieres PO. Como referencia de UX inclusiva, <https://gameaccessibilityguidelines.com/> también trata la claridad del idioma.

## 🧪 Laboratorio guiado

Localizaremos una pequeña UI a español e inglés y cambiaremos el idioma en vivo.

1. Crea `res://locale/textos.csv` con este contenido (columna `keys` primero, luego un código de idioma por columna):

```text
keys,es,en
MENU_JUGAR,Jugar,Play
MENU_OPCIONES,Opciones,Options
MENU_SALIR,Salir,Quit
HUD_VIDAS,Vidas: {0},Lives: {0}
```

2. Guarda el CSV. Godot lo importa y genera un recurso de traducción por idioma. Ve a **Project Settings > Localization > Translations** y comprueba que aparecen `textos.es.translation` y `textos.en.translation`; si no, pulsa **Add...** y añádelos manualmente.

3. Crea la UI: un `Control` con tres `Button` y un `Label`. En lugar de escribir "Jugar", pon como texto de cada botón la **clave**: `MENU_JUGAR`, `MENU_OPCIONES`, `MENU_SALIR`. Los nodos Control resuelven las claves automáticamente al idioma activo (traducción automática de UI).

4. Para textos generados por código, usa `tr()` explícitamente. Añade un script al `Label` de vidas:

```gdscript
extends Label

var vidas: int = 3

func _ready() -> void:
	actualizar()

func actualizar() -> void:
	# tr() resuelve la clave; format() inserta la variable {0}.
	text = tr("HUD_VIDAS").format([vidas])
```

5. Ejecuta con el locale por defecto en `es` (defínelo en *Localization > General*). Verás "Jugar", "Opciones", "Salir" y "Vidas: 3".

6. Añade un **selector de idioma**. Un `OptionButton` `SelIdioma` con dos ítems (Español, English). Conéctalo para cambiar el locale en runtime:

```gdscript
@onready var lbl_vidas: Label = $LblVidas

func _on_sel_idioma_item_selected(indice: int) -> void:
	var locales := ["es", "en"]
	TranslationServer.set_locale(locales[indice])
	# Los Control con clave se refrescan solos; los textos por código, no:
	lbl_vidas.actualizar()
```

7. Ejecuta y cambia el selector a "English": los botones pasan a "Play/Options/Quit" al instante, y tras llamar a `actualizar()` el Label muestra "Lives: 3". Ese re-llamado es el detalle clave: la UI declarativa se traduce sola, pero lo que pones por código debes reconstruirlo.

8. Observa la **expansión de texto**: cambia una clave para que el inglés sea más largo ("Salir" → "Exit the game") y comprueba si el botón lo acomoda. Amplía el botón o usa `autowrap`/contenedores flexibles para dar holgura.

**Entregable observable**: una UI cuyos botones y un Label de vidas cambian entre español e inglés desde un selector en runtime, con una variable insertada correctamente y sin textos hardcodeados.

## ✍️ Ejercicios

1. Añade un tercer idioma (por ejemplo `pt`) al CSV y al selector, y verifica que carga.

2. Localiza un mensaje con dos variables (`{0}` y `{1}`), por ejemplo puntuación y nivel.

3. Resuelve un plural por código: muestra "1 vida" vs "N vidas" según el valor.

4. Genera un archivo POT desde el editor (*Project Settings > Localization > POT Generation*) y explica para qué sirve.

5. Detecta claves sin traducir aprovechando que `tr()` devuelve la clave literal cuando falta.

6. Reduce a la mitad el ancho de un botón y comprueba qué idioma se desborda; corrígelo con un contenedor.

## 📝 Reto verificable

Localiza una UI (menú de 3 opciones + un texto con variable) a dos idiomas mediante un CSV y `tr()`, con un selector que cambie el idioma en runtime y actualice toda la interfaz, incluidos los textos generados por código.

**Criterio de aceptación**: no existe ningún texto de UI hardcodeado; al cambiar el selector, botones y textos con variable pasan de un idioma a otro al instante y correctamente; la variable insertada muestra el valor real; y ninguna clave queda sin traducir en los idiomas soportados.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Los botones muestran la clave (`MENU_JUGAR`) | El CSV no está registrado o el locale no tiene esa clave. Revisa *Localization > Translations*. |
| Acentos y ñ salen corruptos | CSV no guardado en UTF-8. Reexporta con codificación UTF-8. |
| Un texto no cambia de idioma en runtime | Se generó por código con `tr()` una sola vez. Re-llámalo tras `set_locale`. |
| El texto se desborda del botón en otro idioma | Expansión de texto ignorada. Usa contenedores flexibles y deja holgura. |
| El plural queda mal ("1 vidas") | Se concatenó sin lógica de plural. Resuelve la forma por código o con PO. |

## ❓ Preguntas frecuentes

**❓ ¿Uso el texto en inglés o una clave como identificador?** Prefiere claves (`MENU_JUGAR`). Si usas el texto original como id, cualquier corrección de estilo rompe todas las traducciones asociadas.

**❓ ¿CSV o PO?** CSV es simple y cómodo para equipos pequeños; PO (gettext) escala mejor, soporta plurales estándar y lo prefieren muchos traductores profesionales.

**❓ ¿Por qué mi texto por código no se traduce solo?** La traducción automática aplica a propiedades de nodos Control; lo que asignas por script se evalúa una vez, así que debes recalcularlo al cambiar de idioma.

**❓ ¿Cómo preparo el juego para chino o árabe?** La i18n es la misma; el reto es la **fuente** (glifos CJK) y el sentido RTL, temas de la próxima clase.

## 🔗 Referencias

- Godot — Internationalizing games: <https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html>

- Godot — Localization using gettext (PO): <https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_gettext.html>

- Godot — Importing translations (CSV): <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html>

- Godot — Pseudolocalization: <https://docs.godotengine.org/en/stable/tutorials/i18n/pseudolocalization.html>

## ➡️ Siguiente clase

[Clase 198 - Fuentes, tipografía y texto multi-idioma](../198-fuentes-tipografia-y-texto-multiidioma/README.md)
