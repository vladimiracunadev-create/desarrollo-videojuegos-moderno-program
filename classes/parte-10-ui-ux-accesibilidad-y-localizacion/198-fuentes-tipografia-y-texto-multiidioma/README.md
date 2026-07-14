# Clase 198 — Fuentes, tipografía y texto multi-idioma

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 — Using fonts y Text rendering*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Ya localizaste tu juego, pero al probarlo en japonés aparecen cuadraditos "□□□" en lugar de kanji, y el ruso se ve pero el árabe sale al revés. El problema no es la traducción: es la **fuente**. Una tipografía cubre un conjunto limitado de glifos, y ningún archivo abarca todos los alfabetos del mundo. La solución profesional son las **fuentes con fallback**: una fuente principal que, cuando no tiene un glifo, delega en otra que sí.

En esta clase configurarás en Godot 4 un `FontFile` con **fallbacks** para varios sistemas de escritura (latino, cirílico, CJK), comprobarás que un mismo `Label` renderiza texto en distintos idiomas sin cuadraditos, y ajustarás **tamaño y contraste** para legibilidad. También verás **RTL** (derecha-a-izquierda) para árabe/hebreo y por qué las **licencias de fuentes** importan antes de publicar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar por qué una sola fuente no cubre todos los alfabetos (glifos y cobertura).

2. Configurar una fuente principal con `fallbacks` para cirílico y CJK.

3. Aplicar la fuente al proyecto vía `Theme` u `add_theme_font_override`.

4. Ajustar tamaño, interlineado y contraste para legibilidad multi-idioma.

5. Habilitar dirección RTL y reconocer las implicaciones de licencia de fuentes.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Glifos y cobertura de una fuente | Explica por qué faltan caracteres. |
| 2 | `FontFile` y `FontVariation` | Son los recursos de fuente en Godot 4. |
| 3 | Cadena de fallbacks | Rellena los glifos que faltan con otra fuente. |
| 4 | Fuentes CJK y su tamaño | Cubrir chino/japonés/coreano pesa mucho. |
| 5 | Aplicar fuente por Theme vs override | Global vs puntual. |
| 6 | Legibilidad: tamaño, interlineado, contraste | Determinan si el texto se lee cómodo. |
| 7 | Texto RTL (árabe, hebreo) | Cambia dirección y alineación. |
| 8 | Licencias de fuentes | Evitan problemas legales al publicar. |

## 📖 Definiciones y características

- **Glifo**: representación visual de un carácter en una fuente. Clave: si la fuente no incluye el glifo, no puede dibujarlo (salen □).

- **Cobertura**: conjunto de caracteres que una fuente incluye. Clave: las fuentes "latinas" no traen CJK, que suma miles de glifos.

- **`FontFile`**: recurso de Godot que envuelve un archivo `.ttf/.otf`. Clave: es donde defines tamaño, hinting y fallbacks.

- **Fallback**: lista de fuentes secundarias consultadas cuando la principal no tiene un glifo. Clave: se prueban en orden hasta encontrar el carácter.

- **`FontVariation`**: variante de una fuente base (peso, espaciado, fallbacks) reutilizable. Clave: útil para negrita "falsa" o para adjuntar fallbacks sin duplicar el archivo.

- **`add_theme_font_override`**: aplica una fuente a un nodo concreto por código. Clave: sobreescribe la fuente del tema solo en ese Control.

- **RTL (right-to-left)**: dirección de escritura de árabe y hebreo. Clave: Godot la soporta con `text_direction` y detección automática.

- **Licencia de fuente**: términos de uso (p. ej. SIL Open Font License permite uso comercial). Clave: verifica antes de incrustar la fuente en tu juego.

## 🧰 Herramientas y preparación

Usaremos **Godot 4.x** y necesitarás algunos archivos de fuente libres. Buenas opciones con licencia abierta: **Noto Sans** (latino/cirílico) y **Noto Sans CJK** para chino/japonés/coreano, ambas bajo SIL Open Font License, descargables desde <https://fonts.google.com/noto>. Coloca los `.ttf/.otf` en `res://fonts/`. Godot los importa como `FontFile`. Ten a mano la guía oficial de [Using fonts](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html) y la de [Text rendering / control de dirección](https://docs.godotengine.org/en/stable/classes/class_textserver.html). Para criterios de legibilidad accesible, apóyate en <https://gameaccessibilityguidelines.com/>.

**Aviso de peso:** las fuentes CJK completas pesan varios MB; para prototipos puedes usar una subversión regional (p. ej. solo japonés) y así reducir tamaño.

## 🧪 Laboratorio guiado

Configuraremos una fuente con fallback y comprobaremos varios alfabetos en un Label.

1. Importa las fuentes: arrastra `NotoSans-Regular.ttf` y `NotoSansJP-Regular.otf` a `res://fonts/`. Godot crea un `FontFile` por cada una.

2. Selecciona `NotoSans-Regular.ttf` en el sistema de archivos. En el inspector de importación no hace falta tocar nada; ábrelo como recurso para editar sus **Fallbacks**. Alternativa recomendada: crea un `FontVariation` que use Noto Sans como base y adjunte el fallback.

3. Crea `res://fonts/fuente_ui.tres` como `FontVariation`. En `Base Font` asigna `NotoSans-Regular.ttf`. En la propiedad **Fallbacks** (array de fuentes) añade `NotoSansJP-Regular.otf`. Ahora, cuando el latino no tenga un glifo (un kanji), se usará la japonesa.

4. Aplica la fuente globalmente. En el `Theme` del proyecto, en *Default Font*, asigna `fuente_ui.tres`. Todo Control heredará esta cadena de fuente + fallback.

5. Crea una escena de prueba con un `VBoxContainer` y varios `Label`, cada uno con texto en un alfabeto distinto:

```gdscript
extends VBoxContainer

func _ready() -> void:
	var muestras := {
		"Latino": "El veloz murciélago",
		"Cirílico": "Быстрая лисица",
		"Japonés": "すばやい狐",
	}
	for nombre in muestras:
		var lbl := Label.new()
		lbl.text = "%s: %s" % [nombre, muestras[nombre]]
		add_child(lbl)
```

6. Ejecuta (F6). Los tres textos deben verse **sin cuadraditos**: el latino y el cirílico los cubre Noto Sans, y el japonés lo resuelve el fallback CJK. Si aparecen □, revisa que el fallback esté en el array y que el idioma esté cubierto.

7. Aplica una fuente puntual por código donde quieras diferenciar (p. ej. un título) sin cambiar el tema global:

```gdscript
func poner_fuente_titulo(nodo: Label, fuente: Font) -> void:
	nodo.add_theme_font_override("font", fuente)
	nodo.add_theme_font_size_override("font_size", 32)
```

8. Ajusta **legibilidad y RTL**. Sube el `font_size` base y comprueba que sigue cabiendo (recuerda la expansión de la clase anterior). Para árabe/hebreo, en un `Label`/`RichTextLabel` pon `text_direction = TextDirection.AUTO`: Godot detecta y alinea RTL. Verifica el contraste texto/fondo (≥4.5:1).

**Entregable observable**: una pantalla que muestra texto en latino, cirílico y japonés renderizado correctamente por una única fuente con fallback, con un título de mayor tamaño por override y contraste adecuado.

## ✍️ Ejercicios

1. Añade un cuarto idioma (coreano o chino) a las muestras y comprueba que el fallback lo cubre.

2. Invierte el orden de la cadena de fallback y observa si cambia el renderizado de algún glifo compartido.

3. Aplica `add_theme_font_size_override` a un subtítulo y compáralo con el tamaño del tema.

4. Muestra una frase en árabe con `text_direction = AUTO` y confirma que se alinea a la derecha.

5. Mide el peso del proyecto con y sin la fuente CJK completa y comenta el impacto.

6. Documenta la licencia de cada fuente que uses y por qué te permite publicarla.

## 📝 Reto verificable

Configura una fuente única con fallback que renderice sin cuadraditos al menos tres sistemas de escritura (latino, cirílico y uno CJK), aplícala vía Theme, e incluye un elemento con override de fuente/tamaño y una muestra RTL correctamente alineada.

**Criterio de aceptación**: en una misma pantalla, textos en tres alfabetos distintos se muestran completos sin glifos faltantes; al menos un elemento usa `add_theme_font_override`; una frase RTL aparece alineada a la derecha; y documentas la licencia de las fuentes empleadas.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Aparecen cuadraditos (□) en un idioma | La fuente no cubre esos glifos y falta fallback. Añade la fuente adecuada al array de fallbacks. |
| El proyecto pesa cientos de MB | Fuente CJK completa incrustada. Usa una subversión regional o dynamic fonts solo del idioma necesario. |
| El texto árabe sale de izquierda a derecha | `text_direction` fijo. Ponlo en `AUTO` para detección RTL. |
| El título no cambia de tamaño | Se editó el tema global en vez del nodo. Usa `add_theme_font_size_override` en ese Control. |
| La fuente se ve pixelada al escalar | Falta re-renderizado a mayor tamaño. Con `FontFile` dinámica no ocurre; evita bitmaps de tamaño fijo. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo usar una sola fuente para todos los idiomas?** Casi nunca. Ni las más completas cubren latino + CJK + árabe con calidad; la solución práctica es una principal con fallbacks.

**❓ ¿El fallback afecta al rendimiento?** El coste es mínimo: Godot solo consulta la fuente siguiente cuando falta un glifo, y cachea el resultado.

**❓ ¿Cómo reduzco el peso de las fuentes CJK?** Usa subconjuntos por idioma (solo los glifos que necesitas) o fuentes regionales (JP/KR/SC/TC) en lugar de la CJK global.

**❓ ¿Cualquier fuente sirve para un juego comercial?** No. Revisa la licencia; las fuentes bajo SIL Open Font License (como Noto) permiten uso comercial e incrustación, pero otras no.

## 🔗 Referencias

- Godot — Using fonts: <https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html>

- Godot — TextServer y dirección de texto: <https://docs.godotengine.org/en/stable/classes/class_textserver.html>

- Google Noto Fonts (cobertura multi-idioma, OFL): <https://fonts.google.com/noto>

- SIL Open Font License: <https://openfontlicense.org/>

## ➡️ Siguiente clase

[Clase 199 - Capstone Parte 10: una UI completa, accesible y localizada](../199-capstone-parte-10-una-ui-completa-accesible-y-localizada/README.md)
