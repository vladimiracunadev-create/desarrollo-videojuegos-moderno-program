# Clase 205 — Resoluciones, notch y safe areas

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Multiple resolutions, DisplayServer)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Los teléfonos no comparten pantalla: hay relaciones de aspecto de 16:9 a 20:9, densidades muy distintas y, sobre todo, **notches** e **islas** (Dynamic Island) que recortan la zona superior, además de barras de gestos abajo. Si anclas tu vida, tu botón de pausa o tu marcador a la esquina absoluta, quedarán **debajo del notch** o tapados por la barra del sistema en muchos dispositivos.

En esta clase adaptamos la UI a la **safe area**: la región garantizada libre de recortes. Godot 4 la expone con `DisplayServer.get_display_safe_area()`. Configuramos el modo de estirado del proyecto para soportar múltiples resoluciones y aplicamos márgenes dinámicos para que ningún elemento crítico caiga bajo el notch, en cualquier orientación.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Configurar el stretch mode y aspect del proyecto para múltiples resoluciones.
2. Obtener la safe area del dispositivo con `DisplayServer.get_display_safe_area()`.
3. Aplicar márgenes dinámicos para mantener la UI fuera del notch y las barras.
4. Anclar controles a la zona segura usando contenedores y anclas.
5. Gestionar cambios de orientación sin romper el layout.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Diversidad de pantallas | Muchos aspect ratios y densidades. |
| 2 | Stretch mode y aspect | Cómo escala tu juego a cada pantalla. |
| 3 | Notch / isla | Recortan la parte superior de la UI. |
| 4 | Safe area | Región garantizada sin recortes. |
| 5 | `get_display_safe_area()` | API para leer la zona segura. |
| 6 | Anclas y contenedores | Colocar UI relativa a bordes seguros. |
| 7 | Orientación | Portrait vs landscape cambian la safe area. |
| 8 | Escalado de UI | Legibilidad en densidades distintas. |

## 📖 Definiciones y características

- **Resolución base**: tamaño de referencia del proyecto (Project Settings → Window). Clave: sobre él se calcula el estirado.
- **Stretch mode**: cómo escala el contenido (`disabled`, `canvas_items`, `viewport`). Clave: `canvas_items` mantiene la UI nítida al escalar.
- **Stretch aspect**: cómo maneja aspect ratios distintos (`keep`, `expand`, etc.). Clave: `expand` muestra más área en pantallas anchas.
- **Notch / isla**: recorte físico de la pantalla (cámara). Clave: la zona bajo él no debe contener UI crítica.
- **Safe area**: `Rect2i` con la región usable sin recortes ni barras del sistema. Clave: base para posicionar la UI.
- **`DisplayServer.get_display_safe_area()`**: devuelve la safe area en píxeles físicos. Clave: fuente de verdad para los márgenes.
- **Ancla (anchor)**: punto relativo (0-1) al que se fija un `Control`. Clave: layout que se adapta al tamaño del viewport.
- **Orientación**: portrait o landscape (Project Settings → Display → Window → Handheld). Clave: cambia dónde está el notch y las barras.

## 🧰 Herramientas y preparación

Trabaja con un `CanvasLayer` de HUD y controles basados en `Control`. En **Project → Project Settings → Display → Window → Stretch** define **Mode: canvas_items** y **Aspect: expand**, y una resolución base (por ejemplo 1080×1920 portrait o 1920×1080 landscape). Para probar el notch necesitas un dispositivo con recorte o el simulador; en el editor puedes simular la safe area aplicando un margen manual mientras desarrollas.

Consulta la guía de múltiples resoluciones en <https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html> y `DisplayServer.get_display_safe_area()` en <https://docs.godotengine.org/en/stable/classes/class_displayserver.html>. La orientación se ajusta en Project Settings → Display → Window → Handheld → Orientation.

## 🧪 Laboratorio guiado

Adaptaremos la UI a la safe area para que no quede bajo el notch.

1. Configura el estirado: en **Project Settings → Display → Window → Stretch**, pon **Mode = canvas_items** y **Aspect = expand**. Fija la resolución base a tu orientación objetivo (por ejemplo 720×1280 portrait).

2. Crea un `CanvasLayer` `HUD` con un `Control` raíz llamado `SafeArea` que ocupe toda la pantalla (anclas Full Rect). Dentro coloca tu UI: `MarcadorTop` arriba, `BotonPausa` arriba a la derecha, `Vidas` arriba a la izquierda.

3. Añade a `SafeArea` un script que consulte la zona segura y aplique márgenes para que sus hijos no invadan el notch ni las barras:

```gdscript
extends Control

func _ready() -> void:
	_aplicar_safe_area()
	# Reaplica al rotar o cambiar tamaño de ventana.
	get_tree().root.size_changed.connect(_aplicar_safe_area)

func _aplicar_safe_area() -> void:
	var segura: Rect2i = DisplayServer.get_display_safe_area()
	var pantalla: Vector2i = DisplayServer.screen_get_size()

	# Márgenes en píxeles físicos (parte recortada en cada lado).
	var izq: int = segura.position.x
	var arriba: int = segura.position.y
	var der: int = pantalla.x - (segura.position.x + segura.size.x)
	var abajo: int = pantalla.y - (segura.position.y + segura.size.y)

	# Escala de físico -> unidades del viewport (por el stretch).
	var escala: Vector2 = get_viewport_rect().size / Vector2(pantalla)

	# Empuja los bordes de este Control hacia dentro de la zona segura.
	offset_left = izq * escala.x
	offset_top = arriba * escala.y
	offset_right = -der * escala.x
	offset_bottom = -abajo * escala.y
```

4. Como este `SafeArea` tiene anclas Full Rect, al mover sus `offset_*` hacia dentro toda su UI hija queda automáticamente dentro de la zona segura. Ancla `Vidas` arriba-izquierda, `BotonPausa` arriba-derecha y `MarcadorTop` centrado arriba dentro de `SafeArea`.

5. Prueba en el editor simulando un notch: temporalmente fuerza `offset_top = 80` para ver cómo la UI baja y deja hueco arriba. Quita el override cuando confirmes el efecto; en dispositivo real lo hará `get_display_safe_area()`.

6. Soporta **orientación**: si tu juego admite portrait y landscape, la señal `size_changed` vuelve a llamar `_aplicar_safe_area()` al rotar, recalculando márgenes para la nueva forma del notch/barras.

7. Exporta a Android (clase 201) y prueba en un teléfono con notch: verifica que ni el marcador ni el botón de pausa quedan bajo el recorte, y que abajo respetas la barra de gestos.

Con esto tu HUD se mantiene visible y tappable en cualquier pantalla, notch incluido.

## ✍️ Ejercicios

1. Muestra en pantalla los cuatro márgenes (izq/arriba/der/abajo) que devuelve la safe area.
2. Cambia la orientación a landscape y verifica que la UI se recoloca al rotar.
3. Añade un fondo decorativo que sí cubra toda la pantalla (bajo el notch) y UI solo en la zona segura.
4. Ancla un botón inferior y comprueba que respeta la barra de gestos de Android/iOS.
5. Prueba dos resoluciones base distintas y compara la nitidez de la UI con `canvas_items`.
6. Extrae el cálculo de safe area a un autoload reutilizable por varias escenas.

## 📝 Reto verificable

Adapta el HUD de tu juego a la **safe area** usando `DisplayServer.get_display_safe_area()`, de modo que ningún elemento interactivo o de información quede bajo el notch/isla ni bajo las barras del sistema, y que el layout se recalcule al cambiar de orientación.

**Criterio de aceptación**: el proyecto usa stretch `canvas_items`/`expand`; el HUD lee la safe area y aplica márgenes dinámicos; en un dispositivo (o simulando el recorte) el marcador y los botones quedan completamente dentro de la zona segura y siguen siendo tappables; y al rotar el dispositivo la UI se reajusta sin solaparse con el notch.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El marcador queda bajo el notch | No aplicaste la safe area. Usa `get_display_safe_area()` y empuja los offsets hacia dentro. |
| La UI se ve borrosa al escalar | Stretch en `viewport` o `disabled`. Usa `canvas_items` para UI nítida. |
| Botón inferior tapado por la barra de gestos | Ignoraste el margen inferior. Resta también `abajo` de la safe area. |
| Al rotar, la UI no se reacomoda | No reconectaste `size_changed`. Reaplica la safe area en esa señal. |
| Márgenes desproporcionados | Mezclaste píxeles físicos con unidades del viewport. Aplica la escala `viewport/screen`. |
| En el editor `get_display_safe_area` da toda la pantalla | En escritorio no hay notch. Prueba en dispositivo o simula el margen a mano. |

## ❓ Preguntas frecuentes

**❓ ¿`get_display_safe_area()` funciona en el editor de escritorio?** Devuelve la ventana completa porque no hay notch. La zona segura real solo aparece en dispositivos móviles con recorte, así que valida en hardware o simula el margen mientras desarrollas.

**❓ ¿Debo meter TODO dentro de la safe area?** No: fondos y elementos decorativos pueden cubrir toda la pantalla (se ven mejor a sangre). Solo la UI crítica e interactiva debe quedar dentro de la zona segura.

**❓ ¿Qué stretch mode conviene en móvil?** `canvas_items` con aspect `expand` es lo habitual: mantiene la UI nítida y aprovecha pantallas más anchas mostrando algo más de área en lugar de barras negras.

**❓ ¿Cómo manejo portrait y landscape a la vez?** Recalcula la safe area en la señal `size_changed` y usa anclas/contenedores en vez de posiciones fijas, para que el layout se adapte a ambas formas.

## 🔗 Referencias

- Godot Docs — Multiple resolutions: <https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html>
- Godot Docs — Clase DisplayServer (get_display_safe_area): <https://docs.godotengine.org/en/stable/classes/class_displayserver.html>
- Godot Docs — Size and anchors (Control): <https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html>
- Godot Docs — Handheld / orientación: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html>

## ➡️ Siguiente clase

[Clase 206 - Monetización móvil: anuncios y compras in-app](../206-monetizacion-movil-anuncios-y-compras-in-app/README.md)
