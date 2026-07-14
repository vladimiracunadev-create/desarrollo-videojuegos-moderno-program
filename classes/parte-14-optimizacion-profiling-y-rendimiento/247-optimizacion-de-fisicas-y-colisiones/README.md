# Clase 247 — Optimización de físicas y colisiones

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Godot Docs — Physics introduction y Collision layers and masks*
> ⏱️ Duración estimada: **65 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La física es uno de los costes más silenciosos y crecientes de un juego. El motor debe, en cada tick, averiguar qué pares de cuerpos podrían tocarse (*broad phase*) y luego resolver los que realmente colisionan (*narrow phase*). Si tienes 200 cuerpos y todos pueden colisionar con todos, el número de comprobaciones potenciales crece de forma cuadrática. La mayoría de esos pares nunca deberían compararse: las balas del jugador no chocan entre sí, los objetos decorativos no colisionan con el fondo. Cada par innecesario que eliminas es tiempo de CPU recuperado.

En esta clase aprendes a recortar ese coste con las herramientas correctas: **capas y máscaras de colisión** para que solo se comparen los pares que importan, **formas simples** (círculos, cápsulas, cajas) en vez de mallas de colisión (`ConcavePolygonShape`/trimesh) que son carísimas en movimiento, cuerpos que **duermen** (*sleeping*) cuando están en reposo, el ajuste de `Engine.physics_ticks_per_second`, y la elección entre `Area` (detección) y cuerpo físico (simulación). Medirás el tiempo de física con `Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)` antes y después.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Configurar capas y máscaras para eliminar pares de colisión innecesarios.
2. Elegir formas de colisión simples y explicar por qué el trimesh dinámico se evita.
3. Aprovechar el *sleeping* de cuerpos en reposo para ahorrar CPU.
4. Ajustar `physics_ticks_per_second` según las necesidades del juego.
5. Decidir entre `Area` y cuerpo físico según se necesite detección o simulación.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Broad y narrow phase | Entender dónde se gasta el tiempo guía qué optimizar. |
| 2 | Capas y máscaras | Filtran pares antes de compararlos; el ahorro más grande y barato. |
| 3 | Formas simples | Círculo/cápsula/caja se resuelven en constante; el trimesh no. |
| 4 | Trimesh dinámico | Malla de colisión en movimiento: coste prohibitivo, se evita. |
| 5 | Sleeping bodies | Un cuerpo dormido no se simula hasta que algo lo despierta. |
| 6 | Physics ticks | Más ticks = más precisión y más CPU; hay que equilibrar. |
| 7 | Area vs Body | Detectar zonas no requiere simular física completa. |
| 8 | Medición del coste | `TIME_PHYSICS_PROCESS` cuantifica el impacto real. |

## 📖 Definiciones y características

- **Capa de colisión (`collision_layer`)**: conjunto de "canales" en los que un cuerpo *está presente*. Clave: define quién puede ser detectado.
- **Máscara de colisión (`collision_mask`)**: canales que un cuerpo *escanea*. Clave: define a quién detecta. Dos objetos interactúan solo si la capa de uno cae en la máscara del otro.
- **Forma primitiva**: `CircleShape2D`, `RectangleShape2D`, `CapsuleShape3D`, `BoxShape3D`, etc. Clave: colisión de coste constante.
- **Trimesh (`ConcavePolygonShape`)**: forma de colisión generada a partir de una malla arbitraria. Clave: solo para geometría estática; en movimiento es carísima e inestable.
- **Sleeping**: estado en el que un `RigidBody` en reposo deja de simularse. Clave: ahorra CPU automáticamente; se controla con `can_sleep`.
- **`Engine.physics_ticks_per_second`**: frecuencia fija de la simulación física (60 por defecto). Clave: subirla mejora precisión pero cuesta CPU.
- **`Area2D`/`Area3D`**: nodo que detecta solapamientos sin resolver colisiones físicas. Clave: ideal para triggers, zonas de daño o pickups.
- **`StaticBody`**: cuerpo que no se mueve; admite trimesh sin penalización de simulación. Clave: úsalo para el escenario.

## 🧰 Herramientas y preparación

Trabaja en Godot 4.x. Crea una escena con muchos `RigidBody2D` (o 3D) cayendo sobre un `StaticBody` — por ejemplo 300 cajas apiladas. Ten a mano la tabla de capas de física en **Proyecto → Ajustes del proyecto → Capas → 2D Física**, donde puedes nombrar cada capa (p. ej. "jugador", "enemigos", "balas_jugador", "escenario"). Consulta la guía de capas y máscaras (<https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html#collision-layers-and-masks>).

Añade un `Label` que muestre en pantalla el tiempo de física leído con `Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)` multiplicado por 1000 para verlo en milisegundos. Esa cifra es tu métrica principal en todo el laboratorio.

## 🧪 Laboratorio guiado

Partirás de una escena mal configurada y la optimizarás por pasos, midiendo tras cada uno.

**Paso 1 — Línea base.** Con todos los cuerpos en la misma capa y máscara (todos colisionan con todos), lee el coste:

```gdscript
extends Label

func _process(_delta: float) -> void:
	var phys_ms := Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0
	var active := Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)
	var pairs := Performance.get_monitor(Performance.PHYSICS_2D_COLLISION_PAIRS)
	text = "física: %.2f ms | activos: %d | pares: %d" % [phys_ms, active, pairs]
```

Anota `física ms` y `pares` con la escena en plena caída.

**Paso 2 — Capas y máscaras.** Asigna capas por rol y limita las máscaras. Las balas del jugador no deben verse entre sí ni tocar decorados:

```gdscript
# Constantes de capa (bit index -> valor). Usa nombres en Ajustes del proyecto.
const L_ESCENARIO := 1      # capa 1
const L_JUGADOR   := 2      # capa 2
const L_ENEMIGO   := 4      # capa 3
const L_BALA_PJ   := 8      # capa 4

func _configurar_bala(b: Area2D) -> void:
	b.collision_layer = L_BALA_PJ                 # la bala vive en su canal
	b.collision_mask = L_ESCENARIO | L_ENEMIGO    # solo detecta muro y enemigo
	# No incluye L_BALA_PJ: las balas se ignoran entre sí.
```

Vuelve a leer `pares`: debería caer de forma notable, y con él el tiempo de física.

**Paso 3 — Formas simples.** Sustituye cualquier `CollisionPolygon2D` cóncavo por un `RectangleShape2D` o `CapsuleShape2D`. Para 3D, reemplaza colisionadores trimesh en objetos móviles por `BoxShape3D` o `SphereShape3D`. Mantén el trimesh solo en el `StaticBody` del escenario.

**Paso 4 — Sleeping.** Asegúrate de que los cuerpos en reposo duerman. En un `RigidBody2D`/`RigidBody3D`:

```gdscript
func _ready() -> void:
	can_sleep = true          # permite que el motor lo duerma en reposo
	sleeping = false          # arranca despierto; el motor lo dormirá solo

# Para forzar despertar al recibir un impulso:
func aplicar_golpe(impulso: Vector2) -> void:
	sleeping = false
	apply_central_impulse(impulso)
```

Observa `activos`: cuando la pila se estabiliza, el número de cuerpos activos debe desplomarse porque duermen.

**Paso 5 — Physics ticks.** Si tu juego no necesita 60 Hz de física (por ejemplo, un puzzle lento), baja la frecuencia y mide:

```gdscript
func _ready() -> void:
	Engine.physics_ticks_per_second = 30   # la mitad de simulaciones por segundo
```

**Paso 6 — Area vs Body.** Convierte los pickups y zonas de daño de `RigidBody`/`CharacterBody` a `Area2D`/`Area3D`: no necesitan simular masa ni resolver empujes, solo detectar solapamiento. Compara el tiempo de física final con la línea base del Paso 1 en tu tabla ANTES/DESPUÉS.

## ✍️ Ejercicios

1. Diseña una tabla de capas y máscaras para un juego con jugador, enemigos, balas de ambos bandos y escenario.
2. Mide el coste de un mismo objeto con `ConvexPolygonShape2D` vs `RectangleShape2D`.
3. Fuerza a un `RigidBody` a no dormir (`can_sleep = false`) y cuantifica el sobrecoste.
4. Reduce `physics_ticks_per_second` a 30 y describe qué comportamiento se degrada.
5. Convierte una zona de daño de cuerpo a `Area2D` y verifica que la detección sigue funcionando.
6. Registra `PHYSICS_2D_COLLISION_PAIRS` antes y después de aplicar máscaras y calcula el porcentaje de reducción.

## 📝 Reto verificable

Toma una escena con al menos 300 cuerpos físicos mal configurada (una sola capa, formas complejas, sin sleeping) y optimízala aplicando capas/máscaras por rol, formas primitivas, sleeping y `Area` donde corresponda. Entrega una tabla ANTES/DESPUÉS con `TIME_PHYSICS_PROCESS` (ms), pares de colisión y objetos activos.

**Criterio de aceptación**: el tiempo de física por frame se reduce de forma medible respecto a la línea base, el número de pares de colisión disminuye tras aplicar máscaras, y los cuerpos en reposo aparecen como inactivos (dormidos) en el monitor. La tabla documenta las tres métricas en ambos estados.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Objetos que se atraviesan sin colisionar | Capa y máscara mal cruzadas. Recuerda: A detecta a B si la capa de B está en la máscara de A. |
| Física dispara al mover un trimesh | Usaste malla de colisión en un cuerpo móvil. Cámbiala por una forma primitiva. |
| CPU alta con la escena "quieta" | Los cuerpos no duermen. Activa `can_sleep` y no los despiertes sin necesidad. |
| Detección inestable en objetos rápidos | Pocos ticks de física. Sube `physics_ticks_per_second` o activa CCD si aplica. |
| Zonas de daño empujan al jugador | Usaste un cuerpo donde bastaba un `Area`. Cambia a `Area2D`/`Area3D`. |

## ❓ Preguntas frecuentes

**❓ ¿Cuál es la diferencia práctica entre capa y máscara?** La capa dice "en qué canales existo"; la máscara dice "qué canales miro". Dos objetos interactúan solo si la capa de uno intersecta la máscara del otro. No tienen por qué ser simétricas.

**❓ ¿Por qué el trimesh es tan caro en movimiento?** Una malla cóncava tiene muchos triángulos; comprobar colisiones contra cada uno mientras el objeto se mueve y rota multiplica el trabajo. Los primitivos se resuelven con fórmulas de coste constante.

**❓ ¿Bajar los physics ticks no rompe el juego?** Depende. Un juego de acción rápida necesita 60 Hz o más; un puzzle o estrategia pausada funciona bien a 30. Prueba y mide la sensación.

**❓ ¿El sleeping se activa solo?** Sí, si `can_sleep` está en `true`. El motor duerme cuerpos con velocidad casi nula y los despierta cuando reciben una colisión o impulso.

## 🔗 Referencias

- Godot Docs — Physics introduction: <https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html>
- Godot Docs — Collision layers and masks: <https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html#collision-layers-and-masks>
- Godot Docs — RigidBody2D (sleeping): <https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html>
- Godot Docs — Performance monitors: <https://docs.godotengine.org/en/stable/classes/class_performance.html>

## ➡️ Siguiente clase

[Clase 248 - Culling, LOD y streaming de mundo](../248-culling-lod-y-streaming-de-mundo/README.md)
