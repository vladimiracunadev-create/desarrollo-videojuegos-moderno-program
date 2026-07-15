# Clase 067 — Capstone Parte 2: un nivel 3D explorable en tercera persona

> Parte: **2 — Desarrollo 3D: motores, escenas y transformaciones** · Fuente: *Documentación oficial de Godot 4 — Third-person camera con SpringArm3D y Navigation*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**
>
> 🧪 **Proyecto de referencia:** este capstone tiene un laboratorio ejecutable en
> [`labs/3d-tercera-persona`](../../../labs/3d-tercera-persona/README.md): abre `inicio/` para construirlo tú
> (con `TODO` guiados) o `solucion/` para ver la implementación completa y jugable.
> Ambos se verifican en CI con Godot headless.

---

## 🎯 Objetivo

Integrar todo lo aprendido en la Parte 2 en un único proyecto: un nivel 3D explorable en tercera persona. Reunirás nivel modular (GridMap/blockout), iluminación con `WorldEnvironment`, un personaje controlado con cámara `SpringArm3D` y blending de animación, colisiones y física, coleccionables con `Area3D`, un enemigo con navegación por navmesh y optimización básica. Este es un capstone: no es una lección nueva, sino la especificación y la guía para ensamblar un juego pequeño pero completo.

Al terminar tendrás un nivel jugable de principio a fin, con una checklist de integración cumplida, una definición de terminado clara y un plan de playtesting para pulirlo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Ensamblar un nivel 3D completo integrando nodos y sistemas de toda la Parte 2.
2. Configurar una cámara en tercera persona con `SpringArm3D` que evita atravesar muros.
3. Coordinar el estado del juego (puntos, vidas, victoria) con un `GameManager` central.
4. Integrar un enemigo que navega hacia el jugador usando `NavigationAgent3D`.
5. Aplicar una checklist y una "definition of done" para cerrar un proyecto de nivel.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Integración de sistemas | Un juego real es la suma coordinada de muchas piezas. |
| 2 | Cámara en 3ª persona (SpringArm3D) | Da control cómodo sin que la cámara cruce paredes. |
| 3 | WorldEnvironment e iluminación | Define atmósfera y hace legible el espacio. |
| 4 | Navegación con navmesh | Permite que el enemigo persiga por rutas válidas. |
| 5 | GameManager y estado | Centraliza puntos, vidas y condición de victoria. |
| 6 | Coleccionables y objetivos | Dan propósito y bucle de juego. |
| 7 | Playtesting y definition of done | Aseguran que el nivel esté realmente terminado. |

## 📖 Definiciones y características

- **SpringArm3D**: brazo de cámara que se acorta al chocar con geometría, evitando que la cámara atraviese muros. Clave: la `Camera3D` va como hijo suyo.
- **WorldEnvironment**: nodo que aplica un `Environment` global (cielo, niebla, tonemapping, glow). Clave: define el "look" atmosférico del nivel.
- **NavigationRegion3D**: define la zona navegable (navmesh) que los agentes usan para moverse. Clave: sin ella, el enemigo no sabe por dónde caminar.
- **NavigationAgent3D**: componente que calcula rutas dentro del navmesh hacia un destino. Clave: expone el siguiente punto del camino con `get_next_path_position()`.
- **GameManager**: nodo o autoload que guarda el estado global (puntos, vidas, victoria). Clave: evita repartir el estado por muchos scripts.
- **Blending de animación**: mezcla suave entre animaciones (idle, caminar, correr) con `AnimationTree`. Clave: hace natural el movimiento del personaje.
- **Definition of Done**: lista de condiciones que definen "terminado". Clave: convierte "casi listo" en un criterio verificable.
- **Playtesting**: probar el juego observando a un jugador real. Clave: revela problemas que el creador ya no ve.

## 🧰 Herramientas y preparación

Necesitas Godot 4.x desde <https://godotengine.org/download>. Reúne lo construido en clases previas: áreas (063), instanciado (064), GridMap/blockout (065) y optimización (066). Guías útiles: cámara en tercera persona y `SpringArm3D` en <https://docs.godotengine.org/en/stable/classes/class_springarm3d.html>, navegación 3D en <https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html>, y `WorldEnvironment` en <https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html>. Para animación revisa `AnimationTree` en <https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html>.

## 🧪 Laboratorio guiado

### Especificación del nivel

Construye un nivel con: un espacio modular (GridMap o blockout CSG), iluminación con `WorldEnvironment` + `DirectionalLight3D`, un jugador en tercera persona, al menos **6 coleccionables** (`Area3D`), **1 enemigo** que navega hacia el jugador, y optimización básica aplicada. La condición de victoria: recoger todos los coleccionables sin que el enemigo te alcance.

### Tabla de features

| Feature | Nodo(s) clave | Estado |
|---------|---------------|--------|
| Nivel modular | GridMap + MeshLibrary o CSG | ☐ |
| Iluminación/atmósfera | WorldEnvironment + DirectionalLight3D | ☐ |
| Personaje 3ª persona | CharacterBody3D + SpringArm3D + Camera3D | ☐ |
| Animación | AnimationTree (idle/walk blending) | ☐ |
| Coleccionables | Area3D + señal `recogido` | ☐ |
| Enemigo con navmesh | NavigationRegion3D + NavigationAgent3D | ☐ |
| Estado del juego | GameManager | ☐ |
| Optimización | MultiMeshInstance3D / visibility_range | ☐ |

### Pasos de ensamblaje

1. **Nivel.** Parte del GridMap de la clase 065 o de un blockout CSG. Asegura suelo con colisión y muros que encierren el espacio.

2. **Atmósfera.** Añade un `WorldEnvironment` con un `Environment` (cielo procedimental, un poco de niebla) y una `DirectionalLight3D` con sombras. El nivel debe leerse con claridad.

3. **Cámara en 3ª persona.** En tu `CharacterBody3D`, añade la jerarquía `SpringArm3D → Camera3D`. El `SpringArm3D` se acorta solo al chocar con muros. Controla el giro con el ratón:

```gdscript
extends CharacterBody3D

@export var velocidad: float = 5.0
@export var sensibilidad: float = 0.005
@onready var brazo: SpringArm3D = $SpringArm3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(evento: InputEvent) -> void:
	if evento is InputEventMouseMotion:
		rotate_y(-evento.relative.x * sensibilidad)
		brazo.rotation.x = clampf(
			brazo.rotation.x - evento.relative.y * sensibilidad, -1.2, 0.4)

func _physics_process(_delta: float) -> void:
	var entrada := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direccion := (transform.basis * Vector3(entrada.x, 0, entrada.y)).normalized()
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad
	move_and_slide()
```

4. **GameManager.** Crea un `Node` autoload (Proyecto → Ajustes → Autoload) llamado `GameManager` que centraliza el estado:

```gdscript
extends Node

signal puntos_cambiados(total: int)
signal partida_ganada

var puntos: int = 0
var total_coleccionables: int = 0

func registrar_coleccionable() -> void:
	total_coleccionables += 1

func sumar_punto(valor: int) -> void:
	puntos += valor
	puntos_cambiados.emit(puntos)
	if puntos >= total_coleccionables * valor:
		partida_ganada.emit()

func reiniciar() -> void:
	puntos = 0
	total_coleccionables = 0
```

5. **Coleccionables.** Reutiliza el prefab `Area3D` de la clase 064. Al instanciar cada uno, llama a `GameManager.registrar_coleccionable()`; al recogerse, `GameManager.sumar_punto(valor)`.

6. **Enemigo con navmesh.** Añade un `NavigationRegion3D` que cubra el suelo y hornea su navmesh (botón *Bake NavMesh*). El enemigo es un `CharacterBody3D` con un `NavigationAgent3D` que persigue al jugador:

```gdscript
extends CharacterBody3D

@export var velocidad: float = 3.0
@onready var agente: NavigationAgent3D = $NavigationAgent3D
var objetivo: Node3D

func _ready() -> void:
	objetivo = get_tree().get_first_node_in_group("jugador")

func _physics_process(_delta: float) -> void:
	if objetivo == null:
		return
	agente.target_position = objetivo.global_position
	var siguiente := agente.get_next_path_position()
	var direccion := (siguiente - global_position).normalized()
	velocity = direccion * velocidad
	move_and_slide()
```

7. **Optimización.** Si adornas el nivel con muchos props iguales (rocas, plantas), siémbralos con `MultiMeshInstance3D` (clase 066). Aplica `visibility_range` a la geometría lejana. Verifica en el monitor que las draw calls se mantienen razonables.

8. **Interfaz y victoria.** Conecta `GameManager.puntos_cambiados` a un `Label` y `GameManager.partida_ganada` a una pantalla de victoria. Al ejecutar, recoger todo debe disparar la victoria; ser alcanzado por el enemigo, la derrota.

### Definition of Done

- [ ] El jugador se mueve en 3ª persona y la cámara no atraviesa muros.
- [ ] Hay iluminación y atmósfera legibles (WorldEnvironment activo).
- [ ] Todos los coleccionables se recogen y actualizan el marcador vía señal.
- [ ] El enemigo persigue al jugador por rutas válidas del navmesh.
- [ ] Existe condición de victoria y de derrota funcionales.
- [ ] El nivel corre con FPS estable (comprobado en el monitor).
- [ ] No hay errores en consola al jugar de principio a fin.

### Guía de playtesting

Pide a alguien que juegue sin instrucciones y observa: ¿entiende el objetivo sin que se lo digas? ¿La cámara marea o se atasca? ¿El enemigo supone una amenaza real pero justa? ¿Se puede completar el nivel? Anota tres problemas concretos y corrige al menos dos antes de dar por cerrado el capstone.

## ✍️ Ejercicios

1. Añade blending de animación idle↔caminar con un `AnimationTree` según la velocidad del jugador.
2. Da al enemigo un rango de detección (`Area3D`) para que solo persiga si te acercas.
3. Añade una pantalla de derrota cuando el enemigo alcanza al jugador (usa un `Area3D` en el enemigo).
4. Incluye un checkpoint (clase 063) que reaparezca al jugador si cae del nivel.
5. Muestra un cronómetro y guarda el mejor tiempo de recolección.
6. Añade una segunda sala conectada y usa `change_scene_to_file` para pasar entre niveles.

## 📝 Reto verificable

Entrega un nivel 3D jugable de principio a fin que cumpla la tabla de features y la definition of done: personaje en tercera persona con `SpringArm3D`, iluminación con `WorldEnvironment`, al menos 6 coleccionables por `Area3D` gestionados por el `GameManager`, un enemigo que navega hacia el jugador con `NavigationAgent3D`, y condición de victoria y derrota. **Criterio de aceptación**: al ejecutar, se puede completar el nivel recogiendo todos los coleccionables; la cámara nunca atraviesa muros; el enemigo persigue por rutas válidas; recoger todo dispara la victoria y ser alcanzado dispara la derrota; y el juego corre sin errores en consola con FPS estable verificado en el monitor.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| La cámara atraviesa los muros | La `Camera3D` no es hija del `SpringArm3D` o el brazo no colisiona con esa capa. Colócala como hijo y ajusta la máscara del brazo. |
| El enemigo no se mueve | Falta hornear el navmesh o el `NavigationAgent3D` no tiene destino. Bake el `NavigationRegion3D` y asigna `target_position`. |
| El marcador no sube al recoger | El coleccionable no llama al `GameManager` o el autoload no está registrado. Verifica el Autoload en Ajustes. |
| El nivel se ve negro o plano | Falta `WorldEnvironment` o luz. Añade ambos y activa sombras. |
| La victoria nunca se dispara | El total de coleccionables no se registró al instanciarlos. Llama a `registrar_coleccionable()` por cada uno. |
| FPS bajo con muchos props | Props como nodos individuales. Pásalos a `MultiMeshInstance3D` y añade `visibility_range`. |

## ❓ Preguntas frecuentes

**❓ ¿Por dónde empiezo a ensamblar tantas piezas?** Por el "esqueleto" jugable mínimo: nivel con colisión + jugador en 3ª persona que se mueve. Cuando eso funciona, añade una feature a la vez (coleccionables, luego enemigo, luego optimización), probando tras cada una.

**❓ ¿El GameManager debe ser un autoload?** Es lo más cómodo: un autoload es accesible desde cualquier escena sin pasar referencias. Alternativamente puedes usar un nodo en la escena principal y conectar señales, pero el autoload simplifica el estado global.

**❓ ¿Necesito hornear el navmesh cada vez que cambio el nivel?** Sí, si mueves geometría que afecta a las rutas. El navmesh es una foto de la zona navegable; si el nivel cambia, vuelve a hacer *Bake* para que el enemigo navegue correctamente.

**❓ ¿Cómo sé que el capstone está realmente terminado?** Cuando cumples cada punto de la definition of done y al menos una persona ajena completó el nivel sin ayuda. "Se ve bien en mi cabeza" no cuenta; el criterio es verificable y observable.

## 🔗 Referencias

- Godot Docs — Clase SpringArm3D: <https://docs.godotengine.org/en/stable/classes/class_springarm3d.html>
- Godot Docs — Navigation introduction 3D: <https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html>
- Godot Docs — Environment and post-processing: <https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html>
- Godot Docs — Using AnimationTree: <https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html>
- Godot Docs — Clase NavigationAgent3D: <https://docs.godotengine.org/en/stable/classes/class_navigationagent3d.html>

## ➡️ Siguiente clase

[Clase 068 - Repaso aplicado: vectores y transformaciones en el motor](../../parte-3-fisica-y-matematicas-de-juegos-aplicadas/068-repaso-aplicado-vectores-y-transformaciones-en-el-motor/README.md)
