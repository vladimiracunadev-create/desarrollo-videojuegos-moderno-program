# Clase 191 — HUD diegético y no diegético

> Parte: **10 — UI/UX, accesibilidad y localización** · Fuente: *Documentación de Godot 4 (CanvasLayer, Canvas layers) · Marcus Andrews, "Game UI Discoveries"*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Diferenciar los dos grandes enfoques de HUD: el **no diegético**, un overlay fijo sobre la pantalla que el personaje no percibe (barra de vida en la esquina, contador de munición), y el **diegético o espacial**, información anclada al mundo del juego (una barra de vida flotando sobre un enemigo). Cada uno tiene un coste de inmersión y de legibilidad distinto, y saber cuál usar es parte del oficio.

En Godot 4, el HUD no diegético vive en un **CanvasLayer**, que lo dibuja por encima del mundo y no se ve afectado por la cámara. La barra sobre el enemigo, en cambio, es un `Control` en el espacio del mundo cuya posición se sincroniza con un nodo 2D. El laboratorio construye ambos a la vez y muestra sus diferencias en pantalla.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar la diferencia entre HUD diegético, no diegético, espacial y meta con ejemplos.
2. Crear un HUD no diegético en un CanvasLayer con vida y munición.
3. Actualizar una TextureProgressBar desde la lógica del juego mediante señales.
4. Colocar una barra de vida diegética que siga a un enemigo en el mundo.
5. Decidir con criterio cuándo cada tipo de HUD sirve mejor a la experiencia.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | HUD no diegético | Es el overlay clásico, siempre legible. |
| 2 | HUD diegético | Refuerza la inmersión con info en el mundo. |
| 3 | CanvasLayer | Dibuja la UI por encima y fija a pantalla. |
| 4 | TextureProgressBar | Barra visual para vida, energía o carga. |
| 5 | Señales de estado | Sincronizan datos del juego con la UI. |
| 6 | Barra flotante en el mundo | Sigue a una entidad en world-space. |
| 7 | Minimalismo del HUD | Menos ruido, más foco en el juego. |
| 8 | Elección de enfoque | Depende del género y la inmersión buscada. |

## 📖 Definiciones y características

- **HUD**: capa de información persistente durante el juego. Clave: comunica estado sin interrumpir la acción.
- **No diegético**: elemento que el personaje no percibe, dibujado sobre la pantalla. Clave: máxima legibilidad, menor inmersión.
- **Diegético**: información que existe dentro de la ficción del juego. Clave: alta inmersión, puede costar legibilidad.
- **Espacial**: UI en el espacio 3D/2D del mundo pero no parte de la ficción (un contorno resaltado). Clave: punto intermedio útil.
- **CanvasLayer**: nodo que dibuja a sus hijos en una capa independiente de la cámara. Clave: ideal para overlays fijos.
- **TextureProgressBar**: barra de progreso con texturas o color, con `min_value`, `max_value` y `value`. Clave: representa vida o munición visualmente.
- **World-space UI**: Control cuya posición se calcula desde una posición del mundo. Clave: requiere sincronizar cada frame o al moverse.
- **Minimalismo**: mostrar solo lo necesario en cada momento. Clave: reduce carga cognitiva y despeja la escena.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y una escena de juego 2D sencilla (un jugador y un enemigo bastan; sirve un `Sprite2D` cada uno). No hace falta arte fino: `TextureProgressBar` funciona con un color plano si no asignas texturas, y para la barra flotante usaremos un `ProgressBar` estándar.

Referencia clave: **Canvas layers** (<https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html>) y la clase **CanvasLayer** (<https://docs.godotengine.org/en/stable/classes/class_canvaslayer.html>). El marco de los cuatro tipos de UI proviene del análisis clásico de HUDs en juegos.

## 🧪 Laboratorio guiado

Construiremos un HUD no diegético (vida + munición) en un CanvasLayer y, por separado, una barra de vida diegética que flota sobre un enemigo y lo sigue.

1. En tu escena de juego añade un **CanvasLayer** (`HUD`). Todo lo que cuelgue de él quedará fijo a la pantalla, ignorando el movimiento de la cámara.

2. Dentro del `HUD` añade un **MarginContainer** con `margin_*` en `16` anclado con preset **Top Left**. Dentro, un **VBoxContainer** con una **TextureProgressBar** (`Vida`) y un **Label** (`Municion`).

3. Selecciona `Vida`. En el Inspector pon `min_value=0`, `max_value=100`, `value=100`. Si no tienes texturas, expande **Tint → Progress** y ponle un rojo; en **Fill Mode** deja "Left to Right". Dale un `custom_minimum_size` de `(200, 20)`.

4. Añade el script del HUD al nodo `HUD`, guárdalo como `hud.gd`:

```gdscript
extends CanvasLayer

@onready var barra_vida: TextureProgressBar = $MarginContainer/VBoxContainer/Vida
@onready var etiqueta_municion: Label = $MarginContainer/VBoxContainer/Municion

func actualizar_vida(actual: int, maxima: int) -> void:
	barra_vida.max_value = maxima
	barra_vida.value = actual

func actualizar_municion(balas: int) -> void:
	etiqueta_municion.text = "Munición: %d" % balas
```

5. Desde el jugador o un script de prueba, llama a esos métodos cuando cambie el estado. Por ejemplo, en el script del jugador:

```gdscript
extends CharacterBody2D

@onready var hud := get_tree().get_first_node_in_group("hud")
var vida := 100
var municion := 12

func _ready() -> void:
	add_to_group("jugador")
	if hud:
		hud.actualizar_vida(vida, 100)
		hud.actualizar_municion(municion)

func recibir_dano(cantidad: int) -> void:
	vida = max(0, vida - cantidad)
	if hud:
		hud.actualizar_vida(vida, 100)  # Feedback inmediato en el overlay.
```

Recuerda añadir el nodo `HUD` al grupo `hud` (panel Node → Groups) para que `get_first_node_in_group` lo encuentre.

6. Ahora la barra **diegética**. Sobre el enemigo (un `Node2D` o `CharacterBody2D`) añade un **ProgressBar** como hijo, llamado `VidaFlotante`. Colócalo con un offset por encima del sprite (por ejemplo `position = (-25, -50)`) y `custom_minimum_size = (50, 6)`.

7. Añade este script al enemigo (`enemigo.gd`) para que la barra refleje su vida en el mundo:

```gdscript
extends CharacterBody2D

@onready var vida_flotante: ProgressBar = $VidaFlotante
var vida := 60
var vida_max := 60

func _ready() -> void:
	vida_flotante.max_value = vida_max
	vida_flotante.value = vida

func recibir_dano(cantidad: int) -> void:
	vida = clampi(vida - cantidad, 0, vida_max)
	vida_flotante.value = vida
	# La barra vive en el mundo: se mueve, gira y escala con el enemigo.
	if vida == 0:
		queue_free()
```

8. Ejecuta con **F6**. Verás la barra de vida y la munición fijas arriba a la izquierda (no diegético) y, sobre el enemigo, una barra pequeña que se desplaza con él por el mundo (diegético/espacial). Provoca daño (llamando `recibir_dano`) y observa cómo cada barra responde en su propio espacio. La del HUD siempre legible; la del enemigo, integrada en la escena.

## ✍️ Ejercicios

1. Añade un icono de arma junto al contador de munición usando un `TextureRect`.
2. Haz que la barra flotante del enemigo se oculte cuando esté a vida completa y aparezca al recibir daño.
3. Cambia el color de la barra de vida del HUD a amarillo por debajo del 50% y a rojo por debajo del 25%.
4. Añade un segundo enemigo con su propia barra flotante y verifica que cada una es independiente.
5. Mueve la cámara y confirma que el HUD no se mueve pero la barra del enemigo sí.
6. Convierte la barra flotante en "espacial" añadiéndole un borde resaltado al enemigo objetivo.

## 📝 Reto verificable

Crea un HUD no diegético con vida (TextureProgressBar), munición (Label) y un contador de enemigos vivos, todo en un CanvasLayer. Añade a cada enemigo una barra de vida flotante que solo se muestre cuando ha recibido daño. El contador de enemigos debe bajar al morir cada uno.

**Criterio de aceptación**: el HUD permanece fijo al mover la cámara; cada barra flotante sigue a su enemigo y aparece solo tras el primer golpe; el contador refleja siempre el número real de enemigos vivos.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El HUD se mueve con la cámara | Está fuera del CanvasLayer; cuélgalo dentro de él. |
| La barra de vida no baja | No se llama a `actualizar_vida` o `value` supera `max_value`. |
| "Attempt to call function on a null instance" | El grupo `hud` está vacío; añade el nodo HUD al grupo. |
| La barra del enemigo no lo sigue | La pusiste en el CanvasLayer; debe ser hija del enemigo. |
| El HUD tapa contenido importante | Falta minimalismo; reduce elementos o usa esquinas libres. |

## ❓ Preguntas frecuentes

**❓ ¿Cuándo uso HUD diegético?** Cuando la inmersión es prioritaria y el dato encaja en el mundo, como la salud mostrada en el traje del personaje.

**❓ ¿Por qué el CanvasLayer para el HUD?** Porque dibuja sobre el juego y no lo afecta la cámara, así el overlay queda siempre fijo y legible.

**❓ ¿La barra flotante afecta al rendimiento?** Con pocos enemigos no; con multitudes conviene ocultarla o agruparla para evitar muchos nodos Control activos.

**❓ ¿TextureProgressBar o ProgressBar?** TextureProgressBar da control visual (radial, texturas, tintes); ProgressBar es más simple y suficiente para barras pequeñas.

## 🔗 Referencias

- Godot Docs — Canvas layers: <https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html>
- Godot Docs — CanvasLayer: <https://docs.godotengine.org/en/stable/classes/class_canvaslayer.html>
- Godot Docs — TextureProgressBar: <https://docs.godotengine.org/en/stable/classes/class_textureprogressbar.html>
- Game UI Database (referencias de HUD): <https://www.gameuidatabase.com/>

## ➡️ Siguiente clase

[Clase 192 - Menús, navegación y flujo de pantallas](../192-menus-navegacion-y-flujo-de-pantallas/README.md)
