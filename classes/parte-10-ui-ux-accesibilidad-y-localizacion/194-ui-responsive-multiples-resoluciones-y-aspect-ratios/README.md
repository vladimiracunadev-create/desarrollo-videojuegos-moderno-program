# Clase 194 — UI responsive: múltiples resoluciones y aspect ratios

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 — Multiple resolutions y Design a HUD*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Tu juego no se ejecuta en "una pantalla": corre en portátiles 16:9, monitores ultrapanorámicos 21:9, tablets 4:3 y móviles con muescas. Una HUD que colocaste "a ojo" en 1920×1080 se descoloca, se recorta o deja botones fuera de la zona táctil segura en cuanto cambia la resolución o el aspect ratio. Esta clase te enseña a construir interfaces **responsive** en Godot 4: que se adapten sin código frágil, usando el sistema de **stretch** del proyecto y las **anclas** de los nodos Control.

Al terminar habrás configurado el modo de escalado del proyecto y anclado una HUD para que sus cuatro esquinas se mantengan en su sitio en cualquier resolución, respetando además las **safe zones** de dispositivos con bordes recortados. Probarás redimensionando la ventana en vivo y viendo cómo la interfaz responde de forma predecible.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Configurar el modo de **stretch** (`canvas_items`) y el `aspect` adecuado en Project Settings.

2. Anclar nodos Control a esquinas, bordes y centro usando presets de anclaje.

3. Distinguir resolución base, viewport y ventana, y cómo interactúan al escalar.

4. Adaptar una HUD a aspect ratios 16:9, 21:9 y 4:3 sin recortes ni huecos.

5. Reservar **safe zones** con `DisplayServer.get_display_safe_area()` para muescas y bordes.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Resolución base del proyecto | Es el lienzo de referencia sobre el que diseñas. |
| 2 | Modos de stretch (`disabled`/`canvas_items`/`viewport`) | Deciden cómo se escala todo el contenido. |
| 3 | Aspect: `keep`, `expand`, `keep_width`, `keep_height` | Controlan barras negras vs área visible extra. |
| 4 | Anclas y offsets de Control | Fijan cada elemento a un borde o esquina real. |
| 5 | Presets de anclaje del editor | Aplican configuraciones típicas en un clic. |
| 6 | Contenedores responsive (`MarginContainer`, `VBoxContainer`) | Distribuyen espacio sin cálculos manuales. |
| 7 | Safe zones y muescas | Evitan que botones caigan bajo una cámara o borde. |
| 8 | Pruebas multi-resolución | Verifican el diseño antes de publicar. |

## 📖 Definiciones y características

- **Resolución base**: el tamaño de referencia (p. ej. 1280×720) definido en *Display > Window*. Clave: diseña siempre pensando en él, no en tu monitor.

- **Stretch mode `canvas_items`**: escala el contenido 2D como una unidad manteniendo nitidez de la UI. Clave: es el modo recomendado para la mayoría de juegos con UI.

- **Aspect `keep`**: mantiene la proporción base y añade barras negras. Clave: garantiza que nada se deforme, a costa de bordes vacíos.

- **Aspect `expand`**: mantiene la escala pero revela más área en los lados. Clave: aprovecha pantallas anchas si tu UI está bien anclada.

- **Anchor (ancla)**: valor 0–1 que ata un borde del Control a una fracción del contenedor padre. Clave: `anchor = 1` pega el borde a la derecha/abajo.

- **Offset**: distancia en píxeles entre el ancla y el borde real del nodo. Clave: con anclas iguales en ambos lados, el nodo escala con el padre.

- **Safe area**: rectángulo garantizado como visible y no obstruido por muescas o esquinas. Clave: coloca controles interactivos dentro de él.

- **Preset de anclaje**: plantilla del editor (esquina, borde, centro, "Full Rect") que ajusta anclas y offsets de golpe. Clave: acelera el 90% de los casos.

## 🧰 Herramientas y preparación

Trabajaremos con **Godot 4.x** (descárgalo desde <https://godotengine.org/download>). Todo ocurre en el editor y en Project Settings; no necesitas assets externos. Abre **Project > Project Settings** y activa *Advanced Settings* (interruptor arriba a la derecha) para ver todas las opciones de *Display > Window*. Ten a mano la documentación oficial de [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) y de [anclas y contenedores de UI](https://docs.godotengine.org/en/stable/tutorials/ui/index.html). Como referencia de buenas prácticas de interfaz accesible, consulta también <https://gameaccessibilityguidelines.com/>.

Crea un proyecto nuevo vacío. Necesitarás una escena principal con un nodo `Control` que hará de raíz de la HUD.

## 🧪 Laboratorio guiado

Configuraremos el stretch del proyecto y anclaremos una HUD que sobrevive a cualquier resolución.

1. En **Project Settings > Display > Window**, fija `Viewport Width = 1280` y `Viewport Height = 720` (tu resolución base).

2. En la sección **Stretch**, pon `Mode = canvas_items` y `Aspect = expand`. Esto escala la UI y aprovecha pantallas anchas. Cierra el diálogo.

3. Crea la escena de HUD: nodo raíz `Control`, renómbralo `HUD`. Con él seleccionado, en la barra de anclaje del editor elige el preset **Full Rect**. Ahora la HUD cubre todo el viewport.

4. Añade cuatro hijos `Label`: `LblVida` (esquina superior izquierda), `LblPuntos` (superior derecha), `LblMunicion` (inferior derecha) y `LblAviso` (centro). Usa los presets de anclaje **Top Left**, **Top Right**, **Bottom Right** y **Center** respectivamente.

5. Pon un `MarginContainer` como envoltorio general si quieres margen uniforme: selecciónalo y en el inspector define los cuatro `theme_override_constants/margin_*` en `24`. Mete dentro los Labels que deban respetar margen.

6. Añade un script a `HUD` para reservar la safe zone y reaccionar al redimensionado:

```gdscript
extends Control

func _ready() -> void:
	# Reacciona cuando la ventana cambia de tamaño.
	get_tree().root.size_changed.connect(_on_size_changed)
	_on_size_changed()

func _on_size_changed() -> void:
	# La safe area viene en píxeles físicos del dispositivo.
	var safe: Rect2i = DisplayServer.get_display_safe_area()
	var win_size: Vector2i = DisplayServer.window_get_size()
	# Convertimos el margen superior/lateral a unidades de la UI escalada.
	var top_margin: float = float(safe.position.y)
	var left_margin: float = float(safe.position.x)
	# Empujamos el contenedor raíz dentro de la zona segura.
	offset_top = maxf(offset_top, top_margin)
	offset_left = maxf(offset_left, left_margin)
	print("Safe area: ", safe, " | ventana: ", win_size)
```

7. Ejecuta la escena (F6). Con el juego corriendo, **arrastra el borde de la ventana** para redimensionarla: verás que cada Label permanece pegado a su esquina y `LblAviso` se mantiene centrado. La consola imprime la safe area en cada cambio.

8. Prueba distintos aspect ratios: cierra, ve a *Display > Window*, cambia temporalmente `Viewport Width` a `1680` (para simular 21:9) y vuelve a ejecutar. Repite con `960×720` (4:3). Observa que con `Aspect = expand` no aparecen barras negras y las esquinas siguen ancladas.

**Entregable observable**: una HUD con cuatro esquinas y un aviso central que, al redimensionar la ventana en tiempo real y al cambiar entre 16:9, 21:9 y 4:3, mantiene cada elemento en su posición relativa sin recortes.

## ✍️ Ejercicios

1. Cambia el `Aspect` a `keep` y compara: describe cuándo aparecen barras negras y por qué.

2. Añade un quinto elemento anclado al borde inferior que ocupe todo el ancho (barra de estado) usando el preset **Bottom Wide**.

3. Sustituye los Labels de esquina por `VBoxContainer` con dos etiquetas cada uno y verifica que siguen anclados.

4. Simula una muesca dibujando un `ColorRect` en la franja superior y comprueba que ningún control interactivo queda debajo tras aplicar la safe area.

5. Crea un botón de "pausa" que se mantenga a 24 px de la esquina superior derecha en cualquier resolución.

6. Documenta con tres capturas (16:9, 21:9, 4:3) que tu HUD no se rompe.

## 📝 Reto verificable

Construye una HUD de juego con al menos cinco elementos (vida, puntuación, minimapa, munición y aviso central) anclados correctamente, con stretch `canvas_items` + `expand`, que respete la safe zone.

**Criterio de aceptación**: al ejecutar y redimensionar la ventana en vivo, y al probar en 16:9, 21:9 y 4:3, ningún elemento se recorta, se solapa ni queda fuera de la safe area; las esquinas permanecen ancladas a sus bordes y el aviso central sigue centrado.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| La UI se ve borrosa al escalar | Stretch en `viewport` para un juego con UI nítida. Usa `canvas_items`. |
| Los botones se descolocan al cambiar de resolución | Anclas por defecto (Top Left) con offsets fijos. Aplica presets de anclaje a cada elemento. |
| Aparecen barras negras no deseadas | `Aspect = keep`. Cambia a `expand` y ancla bien los bordes. |
| Un control queda bajo la muesca del móvil | No se usó la safe area. Lee `DisplayServer.get_display_safe_area()` y aplica márgenes. |
| El texto se sale del contenedor en pantallas estrechas | Falta un contenedor. Envuelve en `MarginContainer`/`VBoxContainer` con `size_flags`. |

## ❓ Preguntas frecuentes

**❓ ¿Qué resolución base elijo?** 1280×720 o 1920×1080 son seguras para 16:9; lo importante es diseñar siempre respecto a ella, no a tu monitor.

**❓ ¿`canvas_items` o `viewport`?** `canvas_items` para juegos con UI e ilustración vectorial nítida; `viewport` para pixel art de resolución fija que quieres escalar en bloque.

**❓ ¿Las anclas reemplazan a los contenedores?** No; se complementan. Anclas para posicionar bloques grandes, contenedores para distribuir hijos dentro de cada bloque.

**❓ ¿La safe area funciona en escritorio?** Sí, aunque suele devolver toda la ventana. Su valor real aparece en móviles con muescas o bordes redondeados.

## 🔗 Referencias

- Godot — Multiple resolutions: <https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html>

- Godot — Size and anchors: <https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html>

- Godot — Design a HUD: <https://docs.godotengine.org/en/stable/getting_started/first_2d_game/06.heads_up_display.html>

- Game Accessibility Guidelines: <https://gameaccessibilityguidelines.com/>

## ➡️ Siguiente clase

[Clase 195 - Input de UI: teclado, gamepad y táctil](../195-input-de-ui-teclado-gamepad-y-tactil/README.md)
