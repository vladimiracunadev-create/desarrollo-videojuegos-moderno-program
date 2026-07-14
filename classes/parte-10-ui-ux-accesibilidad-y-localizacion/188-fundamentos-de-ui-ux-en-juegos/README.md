# Clase 188 — Fundamentos de UI/UX en juegos

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Celia Hodent, "The Gamer's Brain" · Documentación de Godot 4 (GUI)*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Comprender la diferencia entre **UI** (la interfaz que el jugador ve y toca) y **UX** (la experiencia global que resulta de esa interacción), y aprender a evaluar ambas con criterios profesionales. La UI es solo una parte de la UX: un botón puede verse perfecto y aun así generar una experiencia frustrante si aparece en el momento equivocado o compite por la atención con otros elementos.

En esta clase sentamos el vocabulario que usaremos en toda la Parte 10: principios de diseño (claridad, jerarquía, consistencia, feedback), el concepto de **carga cognitiva** y los cuatro tipos de UI (diegética, no diegética, espacial y meta). El laboratorio no es de código todavía: montarás en Godot 4 una pequeña pantalla de auditoría con una checklist interactiva para evaluar la UX de un juego real y proponer mejoras concretas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir con precisión entre UI y UX y explicar por qué una buena UI no garantiza buena UX.
2. Aplicar los cuatro principios base (claridad, jerarquía, consistencia, feedback) a un caso concreto.
3. Identificar fuentes de carga cognitiva innecesaria en una interfaz.
4. Clasificar cualquier elemento de UI como diegético, no diegético, espacial o meta.
5. Auditar la UX de un juego con una checklist y proponer mejoras priorizadas.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | UI vs UX | Evita confundir "lo bonito" con "lo usable". |
| 2 | Claridad | Si el jugador no entiende, abandona. |
| 3 | Jerarquía visual | Guía la mirada a lo importante primero. |
| 4 | Consistencia | Reduce el esfuerzo de reaprender. |
| 5 | Feedback | Confirma que las acciones tuvieron efecto. |
| 6 | Carga cognitiva | Menos esfuerzo mental = más diversión. |
| 7 | Los 4 tipos de UI | Deciden cuánto rompe la inmersión. |
| 8 | Auditoría con checklist | Convierte opiniones en criterios medibles. |

## 📖 Definiciones y características

- **UI (User Interface)**: conjunto de elementos visuales e interactivos (botones, barras, textos). Clave: es tangible y se diseña pixel a pixel.
- **UX (User Experience)**: la experiencia completa que siente el jugador al usar el sistema. Clave: incluye emoción, ritmo y frustración, no solo lo visual.
- **Claridad**: propiedad de una interfaz que comunica su función sin ambigüedad. Clave: iconos reconocibles y textos cortos ganan a la decoración.
- **Jerarquía visual**: ordenar elementos por importancia usando tamaño, color y posición. Clave: lo primario debe destacar sobre lo secundario.
- **Consistencia**: mantener patrones estables (mismos colores, misma posición del botón "atrás"). Clave: el jugador transfiere lo aprendido entre pantallas.
- **Feedback**: respuesta inmediata del sistema a una acción (sonido, animación, cambio de estado). Clave: sin feedback el jugador duda si algo pasó.
- **Carga cognitiva**: esfuerzo mental que exige la interfaz. Clave: cada dato en pantalla compite por la atención limitada del jugador.
- **UI diegética**: información que existe dentro del mundo del juego (un reloj en la muñeca del personaje). Clave: refuerza la inmersión.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** abierto y un juego cualquiera para auditar (uno tuyo, uno comercial o incluso un prototipo del curso). Ten a mano papel o una nota digital para registrar hallazgos. No hace falta arte: usaremos nodos `Control` básicos para construir la checklist.

Como lectura de apoyo, el trabajo de Celia Hodent sobre psicología cognitiva aplicada a juegos es la referencia estándar; su charla "The Gamer's Brain" resume los principios. Consulta también la introducción a GUI de Godot: <https://docs.godotengine.org/en/stable/tutorials/ui/index.html>.

## 🧪 Laboratorio guiado

Construiremos una **pantalla de auditoría UX**: una lista de criterios con casillas que suman una puntuación en vivo. La usarás para evaluar cualquier juego.

1. Crea una escena nueva. Como raíz elige un nodo **Control** y renómbralo `Auditoria`. En el viewport, arriba, pulsa el botón de anclas y elige **Full Rect** para que ocupe toda la pantalla.

2. Añade como hijo un **MarginContainer** y, en el Inspector, pon los cuatro `theme_override_constants/margin_*` en `24`. Dentro añade un **VBoxContainer** (`Lista`).

3. Dentro del `VBoxContainer` añade un **Label** (`Titulo`) con el texto "Auditoría UX" y varios **CheckBox** (uno por criterio): "¿El objetivo es claro?", "¿Hay jerarquía visual?", "¿La UI es consistente?", "¿El feedback es inmediato?", "¿La carga cognitiva es baja?".

4. Añade al final un **Label** llamado `Marcador`. Este mostrará la puntuación total.

5. Selecciona el nodo raíz `Auditoria`, pulsa **Attach Script** y guarda como `auditoria.gd`:

```gdscript
extends Control

# Referencia al Label que muestra el marcador.
@onready var marcador: Label = $MarginContainer/Lista/Marcador
# Reunimos todos los CheckBox de la lista.
@onready var lista: VBoxContainer = $MarginContainer/Lista

func _ready() -> void:
	# Conectamos la señal 'toggled' de cada CheckBox.
	for hijo in lista.get_children():
		if hijo is CheckBox:
			hijo.toggled.connect(_on_criterio_cambiado)
	_actualizar_marcador()

func _on_criterio_cambiado(_estado: bool) -> void:
	_actualizar_marcador()

func _actualizar_marcador() -> void:
	var cumplidos := 0
	var total := 0
	for hijo in lista.get_children():
		if hijo is CheckBox:
			total += 1
			if hijo.button_pressed:
				cumplidos += 1
	marcador.text = "UX: %d / %d criterios" % [cumplidos, total]
```

6. Ejecuta la escena con **F6**. Marca y desmarca casillas: el `Marcador` debe actualizarse al instante. Ese cambio inmediato es, en sí mismo, un ejemplo de **feedback**.

7. Ahora aplica la herramienta: elige un juego, recórrelo mentalmente y marca cada criterio que cumpla. Anota junto a cada casilla no marcada una mejora concreta ("el botón atrás cambia de sitio entre pantallas → fijarlo abajo-izquierda").

8. Clasifica tres elementos de UI de ese juego según los cuatro tipos: por ejemplo, una barra de vida fija es **no diegética**, una linterna que se atenúa es **diegética**, un cartel dentro del nivel es **espacial**, y un menú de pausa es **meta**.

Terminas con una checklist funcional y un diagnóstico UX real y accionable.

## ✍️ Ejercicios

1. Añade un sexto criterio ("¿La navegación con gamepad funciona?") y verifica que el marcador lo cuenta.
2. Cambia el `Marcador` para que muestre también un porcentaje.
3. Colorea el `Marcador` de verde si se cumplen todos los criterios usando `add_theme_color_override`.
4. Audita un segundo juego y compara las dos puntuaciones; explica la diferencia en dos frases.
5. Toma una pantalla de un juego famoso y clasifica cada elemento visible en uno de los cuatro tipos de UI.
6. Reescribe un texto de interfaz confuso que hayas encontrado para que sea claro en menos palabras.

## 📝 Reto verificable

Extiende la auditoría para que, al cerrar (tecla Esc), imprima en el Output un resumen con la puntuación final y la lista de criterios NO cumplidos, listos para copiar como tareas de mejora.

**Criterio de aceptación**: al pulsar Esc, el Output muestra "UX: X/N" y una línea por cada criterio sin marcar; si están todos marcados, muestra "Sin observaciones".

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El marcador no cambia al marcar | No se conectó la señal `toggled`; revisa el bucle en `_ready()`. |
| "Invalid get index 'Marcador'" | La ruta `$MarginContainer/Lista/Marcador` no coincide con el árbol real. |
| Los CheckBox se apilan sin margen | Faltan los `theme_override_constants/margin_*` en el MarginContainer. |
| Confundir UI bonita con buena UX | Recuerda: la UX incluye ritmo y contexto, no solo estética. |
| Clasificar mal los tipos de UI | Pregúntate si el personaje "vería" ese dato dentro del mundo. |

## ❓ Preguntas frecuentes

**❓ ¿UI y UX son lo mismo?** No. La UI es lo que ves; la UX es cómo te hace sentir usarlo. Una UI impecable puede dar una UX pobre si llega en mal momento.

**❓ ¿Qué es la carga cognitiva y por qué importa?** Es el esfuerzo mental que exige la interfaz. Cuanto menor sea, más recursos mentales quedan para disfrutar el juego.

**❓ ¿Cuándo conviene UI diegética?** Cuando la inmersión es prioritaria y el dato encaja creíblemente en el mundo, como munición mostrada en el arma.

**❓ ¿Puedo mezclar tipos de UI en un mismo juego?** Sí, y es lo normal. El menú de pausa será meta, el HUD no diegético y los carteles del nivel espaciales.

## 🔗 Referencias

- Godot Docs — GUI (índice): <https://docs.godotengine.org/en/stable/tutorials/ui/index.html>
- Godot Docs — Control: <https://docs.godotengine.org/en/stable/classes/class_control.html>
- Celia Hodent — The Gamer's Brain (sitio oficial): <https://celiahodent.com/>
- GDC Vault — UX design talks: <https://www.gdcvault.com/>

## ➡️ Siguiente clase

[Clase 189 - Sistema de UI de Godot: Control, Containers y anclas](../189-sistema-de-ui-de-godot-control-containers-y-anclas/README.md)
