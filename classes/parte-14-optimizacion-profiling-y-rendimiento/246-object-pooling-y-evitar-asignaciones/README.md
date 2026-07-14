# Clase 246 — Object pooling y evitar asignaciones

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Godot Docs — Optimization using Servers y buenas prácticas de rendimiento en tiempo de ejecución*
> ⏱️ Duración estimada: **65 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Cada vez que llamas a `instantiate()` sobre una `PackedScene` y más tarde a `queue_free()`, el motor reserva memoria, construye el árbol de nodos, lo conecta a la escena y, al liberarlo, agrega trabajo al recolector de basura y al gestor de nodos. Hacer esto una vez es trivial; hacerlo docenas de veces por frame —balas, casquillos, partículas de impacto, enemigos que aparecen en oleadas— genera picos de asignación de memoria que se traducen en *stuttering* (tirones) perceptibles justo cuando la acción es más intensa.

En esta clase implementas el patrón **object pooling**: en vez de crear y destruir, mantienes un conjunto fijo de nodos preinstanciados y los reciclas. Un objeto "muerto" no se libera: se oculta, se desactiva y vuelve a la reserva esperando su próximo uso. Medirás con `Performance.get_monitor()` y `Time.get_ticks_usec()` el coste real de instanciar cada disparo frente a reutilizar, y verás la diferencia en FPS y memoria de forma cuantificada, no por intuición.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar por qué `instantiate()`/`queue_free()` por frame degrada el rendimiento.
2. Implementar un pool de nodos reutilizables con un `Array` como reserva.
3. Reciclar objetos usando `visible`, `set_process()` y capas de física.
4. Precalentar (*prewarm*) el pool para evitar el coste del primer uso.
5. Medir y comparar FPS y memoria entre instanciar y reutilizar.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Coste de instanciar | Construir un árbol de nodos cada frame asigna memoria y causa tirones. |
| 2 | Coste de liberar | `queue_free()` acumula trabajo diferido y presiona la memoria. |
| 3 | El pool como `Array` | Una reserva preasignada elimina la asignación en caliente. |
| 4 | Reciclar vs destruir | Desactivar y reactivar es mucho más barato que crear y liberar. |
| 5 | Precalentado (prewarm) | Pagar el coste al cargar la escena evita picos en gameplay. |
| 6 | Desactivación completa | Un objeto en reserva no debe procesar, colisionar ni dibujarse. |
| 7 | Agotamiento del pool | Qué hacer cuando no quedan objetos libres: crecer o descartar. |
| 8 | Medición antes/después | Sin métricas no sabes si optimizaste o empeoraste. |

## 📖 Definiciones y características

- **Object pool (reserva de objetos)**: colección de nodos preinstanciados que se reutilizan en lugar de crearse y destruirse. Clave: elimina asignaciones en tiempo de juego.
- **Instanciar**: crear una copia viva de una `PackedScene` con `instantiate()`. Clave: es costoso si se hace muchas veces por frame.
- **Reciclar**: devolver un objeto usado al pool y reconfigurarlo para su próximo uso. Clave: sustituye a liberar.
- **Prewarm (precalentado)**: crear todos los objetos del pool al inicio, antes de necesitarlos. Clave: mueve el coste fuera del gameplay.
- **Objeto activo**: nodo del pool en uso, visible, procesando y colisionando. Clave: consume recursos.
- **Objeto inactivo**: nodo en reserva, oculto y sin procesar. Clave: casi no consume recursos.
- **`set_process(false)`**: detiene las llamadas a `_process()` de un nodo. Clave: un objeto inactivo no debe ejecutar lógica.
- **Agotamiento del pool**: situación en que se piden más objetos de los disponibles. Clave: hay que decidir entre crecer o reciclar el más antiguo.

## 🧰 Herramientas y preparación

Necesitas Godot 4.x (estable) y un proyecto 2D nuevo. Trabajarás con `PackedScene`, `Array`, el monitor de rendimiento y el temporizador de alta resolución. Ten abierta la pestaña **Depurador → Monitores** para ver FPS y memoria en tiempo real, y consulta la guía oficial de optimización en tiempo de ejecución (<https://docs.godotengine.org/en/stable/tutorials/performance/index.html>).

Crea una escena `Bullet.tscn` mínima: un `Area2D` con un `Sprite2D` y un `CollisionShape2D` (un círculo pequeño basta). El script de la bala expondrá métodos para activarse y desactivarse. La escena principal será un `Node2D` con un nodo "cañón" que dispara. Guarda la referencia a la escena de la bala con `@export var bullet_scene: PackedScene` para asignarla desde el inspector.

## 🧪 Laboratorio guiado

Vas a medir primero el enfoque ingenuo y luego el pool.

**Paso 1 — Versión ingenua (línea base).** Dispara instanciando y liberando cada bala. Mide el tiempo de la operación de disparo.

```gdscript
extends Node2D

@export var bullet_scene: PackedScene
var _spawn_accum_usec: int = 0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		var t0: int = Time.get_ticks_usec()
		var bullet := bullet_scene.instantiate()
		add_child(bullet)
		bullet.global_position = $Muzzle.global_position
		_spawn_accum_usec += Time.get_ticks_usec() - t0

func _on_report_timer_timeout() -> void:
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	var mem := Performance.get_monitor(Performance.MEMORY_STATIC)
	print("INGENUO | FPS=%d | mem=%d KB | spawn=%d us" % [fps, mem / 1024, _spawn_accum_usec])
	_spawn_accum_usec = 0
```

Anota FPS, memoria estática y microsegundos de spawn tras 10 segundos de fuego sostenido.

**Paso 2 — La bala reciclable.** El script de la bala debe poder activarse y desactivarse por completo.

```gdscript
extends Area2D

signal recycled(bullet: Area2D)

@export var speed: float = 600.0
var _velocity: Vector2 = Vector2.ZERO

func activate(pos: Vector2, dir: Vector2) -> void:
	global_position = pos
	_velocity = dir.normalized() * speed
	visible = true
	set_process(true)
	set_deferred("monitoring", true)   # reactiva colisiones de forma segura

func deactivate() -> void:
	visible = false
	set_process(false)
	set_deferred("monitoring", false)
	_velocity = Vector2.ZERO

func _process(delta: float) -> void:
	global_position += _velocity * delta
	if not get_viewport_rect().has_point(global_position):
		recycled.emit(self)

func _on_body_entered(_body: Node2D) -> void:
	recycled.emit(self)
```

**Paso 3 — El pool.** Precalienta un `Array` de balas al iniciar y sírvelas bajo demanda.

```gdscript
extends Node2D

@export var bullet_scene: PackedScene
@export var pool_size: int = 128

var _free: Array[Area2D] = []
var _spawn_accum_usec: int = 0

func _ready() -> void:
	for i in pool_size:                 # prewarm: pagamos el coste ahora
		var b: Area2D = bullet_scene.instantiate()
		b.recycled.connect(_on_bullet_recycled)
		b.deactivate()
		add_child(b)
		_free.append(b)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		var t0: int = Time.get_ticks_usec()
		_spawn_bullet()
		_spawn_accum_usec += Time.get_ticks_usec() - t0

func _spawn_bullet() -> void:
	if _free.is_empty():
		return                          # pool agotado: descartamos el disparo
	var b: Area2D = _free.pop_back()
	b.activate($Muzzle.global_position, Vector2.RIGHT)

func _on_bullet_recycled(b: Area2D) -> void:
	b.deactivate()
	_free.append(b)

func _on_report_timer_timeout() -> void:
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	var mem := Performance.get_monitor(Performance.MEMORY_STATIC)
	print("POOL | FPS=%d | mem=%d KB | spawn=%d us | libres=%d" % [fps, mem / 1024, _spawn_accum_usec, _free.size()])
	_spawn_accum_usec = 0
```

**Paso 4 — Compara.** Ejecuta ambos con la misma cadencia de fuego y duración. Verás que el tiempo de spawn del pool es una fracción del ingenuo (no instancia ni añade nodos) y que la memoria estática se mantiene plana en vez de subir en dientes de sierra. Registra ambos resultados en una tabla ANTES/DESPUÉS.

## ✍️ Ejercicios

1. Añade partículas de impacto al pool con su propio `Array` reciclable.
2. Implementa crecimiento dinámico: si el pool se agota, instancia una bala extra y añádela.
3. Sustituye `Area2D` por un enemigo con estados y recíclalo al morir.
4. Mide el coste de `queue_free()` aislado con `Time.get_ticks_usec()` y compáralo con `deactivate()`.
5. Precalienta el pool en dos fases usando `call_deferred()` para no bloquear la carga.
6. Grafica la memoria estática de ambas versiones capturando el monitor cada segundo.

## 📝 Reto verificable

Construye una escena de tipo *bullet hell* con al menos 200 balas simultáneas disparadas por múltiples cañones, gestionadas por un pool con precalentado y reciclaje. Entrega una tabla comparativa ANTES/DESPUÉS (instanciar vs pool) con FPS medio, memoria estática y microsegundos de spawn por frame, medidos con `Performance` y `Time.get_ticks_usec()`.

**Criterio de aceptación**: el pool mantiene la memoria estática estable (sin crecimiento sostenido) durante 30 segundos de fuego continuo, el tiempo medio de spawn por bala es menor que en la versión ingenua, y la tabla presenta las tres métricas para ambos enfoques.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Tirones al abrir fuego | Instancias en caliente. Precalienta el pool en `_ready()`. |
| Balas "fantasma" que colisionan invisibles | Olvidaste desactivar `monitoring`. Usa `set_deferred("monitoring", false)` al reciclar. |
| Error al cambiar colisiones en callback físico | Modificas estado dentro de una señal de colisión. Usa `set_deferred(...)`. |
| El pool crece sin límite | Reciclas mal y siempre instancias nuevas. Verifica que `recycled` se emita una sola vez. |
| Objeto reactivado con estado viejo | No reinicializas al activar. Reinicia posición, velocidad y timers en `activate()`. |

## ❓ Preguntas frecuentes

**❓ ¿No es prematuro optimizar con pools?** Para 3 balas, sí. Para cientos por segundo, el pool es la diferencia entre 60 fps estables y tirones. Mide antes de decidir.

**❓ ¿`queue_free()` es lento por sí mismo?** Una vez no. El problema es el volumen: liberar y reasignar muchos nodos por frame presiona la memoria y añade trabajo diferido.

**❓ ¿Debo quitar el nodo del árbol con `remove_child()` o basta ocultarlo?** Ocultar y `set_process(false)` suele bastar y es más simple. `remove_child()` lo saca del procesamiento por completo, útil para pools muy grandes, a coste de re-añadirlo.

**❓ ¿Qué tamaño de pool elijo?** El pico máximo esperado más un margen. Si mides agotamiento frecuente, súbelo o activa crecimiento dinámico.

## 🔗 Referencias

- Godot Docs — Performance/Optimization: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Using the Performance monitors: <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html>
- Godot Docs — PackedScene: <https://docs.godotengine.org/en/stable/classes/class_packedscene.html>
- Godot Docs — Idle and physics processing: <https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html>

## ➡️ Siguiente clase

[Clase 247 - Optimización de físicas y colisiones](../247-optimizacion-de-fisicas-y-colisiones/README.md)
