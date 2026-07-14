# Clase 233 — Interacción VR: manos, agarre y UI espacial

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Godot Docs (XR) y godot-xr-tools*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La magia de la VR aparece cuando extiendes la mano, agarras un objeto y lo lanzas. Esta clase construye ese vocabulario de interacción: **agarrar** con un botón detectando objetos cercanos mediante un `Area3D` en el mando, **soltar y lanzar** transfiriendo la velocidad de la mano al objeto, y manejar **UI espacial** (menús flotantes en el mundo 3D) tanto por contacto directo como con un **puntero láser**.

Aprenderás a distinguir el agarre por proximidad (Area3D) del apuntado a distancia (RayCast3D), a reparentar un objeto agarrado para que siga la mano, y a integrar un `Control` de Godot en el espacio 3D con colisión para que un puntero pueda pulsar botones reales. Al terminar, tendrás una escena donde recoges un objeto, lo sueltas, y pulsas un botón de un panel flotante con el láser del mando: los tres pilares de casi cualquier app VR.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Detectar objetos agarrables con un Area3D en el XRController3D.
2. Agarrar y soltar objetos con `button_pressed`/`button_released`.
3. Lanzar objetos transfiriendo la velocidad de la mano al soltarlos.
4. Construir un puntero láser con RayCast3D para apuntar a distancia.
5. Integrar UI espacial (Control 3D con colisión) pulsable desde VR.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Area3D en la mano | Detecta qué objetos están al alcance para agarrar. |
| 2 | Grab con botón | El gesto central de la interacción VR. |
| 3 | Reparentar el objeto | Hace que lo agarrado siga la mano sin física. |
| 4 | Throw (lanzar) | Transferir velocidad da realismo físico. |
| 5 | RayCast3D | Apuntar a distancia; base del puntero láser. |
| 6 | UI espacial | Menús flotantes que existen en el mundo 3D. |
| 7 | Control 3D con colisión | Permite que un puntero pulse un botón real. |
| 8 | Feedback háptico | Confirmar el agarre y la pulsación con vibración. |

## 📖 Definiciones y características

- **Area3D de agarre**: zona de detección en el mando que registra objetos agarrables cercanos. Clave: usa señales `body_entered`/`area_entered`.
- **Objeto agarrable**: `RigidBody3D` marcado (grupo o script) que puede recogerse. Clave: al agarrar se congela su física; al soltar se reactiva.
- **Reparent**: cambiar el padre del objeto al mando para que siga su transform. Clave: `reparent()` conserva la posición global.
- **Throw**: al soltar, se asigna al RigidBody la velocidad lineal/angular de la mano. Clave: da la sensación de lanzar de verdad.
- **RayCast3D**: rayo que detecta el primer collider en su dirección. Clave: es la base del puntero láser para apuntar a UI u objetos.
- **UI espacial (world-space)**: un `Control` renderizado sobre una superficie 3D mediante `SubViewport`. Clave: convierte menús 2D en objetos del mundo.
- **Colisión de UI**: un collider asociado al panel para que el puntero calcule dónde "toca" el Control. Clave: traduce el punto 3D a coordenadas 2D del Control.
- **Háptica de confirmación**: pulso corto al agarrar o pulsar. Clave: cierra el bucle de feedback sin depender solo de lo visual.

## 🧰 Herramientas y preparación

Parte de la escena VR con manos de la clase 231. Necesitas **Godot 4.x**. En el Action Map (clase 230) asegúrate de tener las acciones `grab` (bool) y `trigger` (bool o float). Para la UI espacial usaremos un `SubViewport` con un `Control` dentro y un `MeshInstance3D` que muestre su textura, más un `StaticBody3D` con colisión para el puntero.

El addon **godot-xr-tools** ofrece componentes `Grabbable`, `Pointer` y `Viewport2Din3D` que hacen esto de alto nivel; aquí lo montaremos con nodos nativos para entender el mecanismo. Consulta la documentación de XR de Godot y la de `Area3D`, `RayCast3D` y `SubViewport`. Ten un par de `RigidBody3D` simples (cubos) sobre una mesa como objetos agarrables.

## 🧪 Laboratorio guiado

Montarás agarre con Area3D, lanzamiento y un puntero que pulsa un botón de UI 3D.

1. **Objetos agarrables**: crea dos `RigidBody3D` (cubos) sobre una mesa y añádelos al grupo `agarrable` (en el panel Node → Groups).

2. **Zona de agarre**: a la mano derecha añade un `Area3D` (`ZonaAgarre`) con una `CollisionShape3D` esférica de ~0,1 m. Activa **Monitoring**.

3. Adjunta este script a la mano derecha para agarrar, soltar y lanzar:

```gdscript
extends XRController3D

@onready var zona: Area3D = $ZonaAgarre
var objeto_agarrado: RigidBody3D = null
var pos_anterior: Vector3
var velocidad_mano: Vector3 = Vector3.ZERO

func _ready() -> void:
	button_pressed.connect(_on_boton)
	button_released.connect(_on_soltar)
	pos_anterior = global_position

func _physics_process(delta: float) -> void:
	# Estimamos la velocidad de la mano para el lanzamiento.
	velocidad_mano = (global_position - pos_anterior) / max(delta, 0.0001)
	pos_anterior = global_position

func _on_boton(accion: String) -> void:
	if accion != "grab" or objeto_agarrado:
		return
	var candidato := _agarrable_mas_cercano()
	if candidato:
		objeto_agarrado = candidato
		objeto_agarrado.freeze = true            # Desactiva la física mientras se sostiene.
		objeto_agarrado.reparent(self)           # Sigue la mano conservando posición global.
		trigger_haptic_pulse("haptic", 0.0, 0.6, 0.08, 0.0)

func _on_soltar(accion: String) -> void:
	if accion != "grab" or not objeto_agarrado:
		return
	var obj := objeto_agarrado
	objeto_agarrado = null
	obj.reparent(get_tree().current_scene)       # Vuelve al mundo.
	obj.freeze = false
	obj.linear_velocity = velocidad_mano         # Transferimos la velocidad: throw.

func _agarrable_mas_cercano() -> RigidBody3D:
	var mejor: RigidBody3D = null
	var mejor_dist: float = INF
	for cuerpo in zona.get_overlapping_bodies():
		if cuerpo.is_in_group("agarrable"):
			var d: float = global_position.distance_to(cuerpo.global_position)
			if d < mejor_dist:
				mejor_dist = d
				mejor = cuerpo
	return mejor
```

4. Ejecuta y prueba: acerca la mano a un cubo, pulsa `grab`, se pega a la mano; muévela y suelta mientras la agitas: el cubo sale lanzado con la velocidad del gesto.

5. **UI espacial**: crea un `SubViewport` (`PanelViewport`) de 400×200 con un `Control` dentro que contenga un `Button` (`BotonProbar`). Añade un `MeshInstance3D` con un `QuadMesh` de ~0,4×0,2 m cuya textura sea la del SubViewport (usa un `StandardMaterial3D` con `albedo_texture` = ViewportTexture). Añade un `StaticBody3D` con `CollisionShape3D` del mismo tamaño para que el puntero lo golpee.

6. **Puntero láser**: a la mano izquierda añade un `RayCast3D` (`Laser`) apuntando hacia `-Z`, longitud 5 m, y un `MeshInstance3D` fino como haz visible. Script:

```gdscript
extends XRController3D

@onready var laser: RayCast3D = $Laser
@export var panel_viewport: SubViewport

func _ready() -> void:
	button_pressed.connect(_on_boton)

func _physics_process(_delta: float) -> void:
	laser.force_raycast_update()

func _on_boton(accion: String) -> void:
	if accion != "trigger" or not laser.is_colliding():
		return
	# Simulamos un clic en el Control del SubViewport en el punto golpeado.
	var evento := InputEventMouseButton.new()
	evento.button_index = MOUSE_BUTTON_LEFT
	evento.pressed = true
	# Coordenada central del panel como ejemplo; en un caso real se mapea el punto 3D a 2D.
	evento.position = panel_viewport.size / 2.0
	panel_viewport.push_input(evento)
	evento.pressed = false
	panel_viewport.push_input(evento)
	trigger_haptic_pulse("haptic", 0.0, 0.4, 0.05, 0.0)
```

7. Conecta la señal `pressed` del `BotonProbar` a un método que imprima "Botón pulsado desde VR" o cambie un color. Ejecuta: apunta con el láser al panel, pulsa `trigger` y verás la respuesta del botón con vibración de confirmación.

Con agarre, lanzamiento y UI espacial pulsable tienes el núcleo interactivo de una app VR.

## ✍️ Ejercicios

1. Añade un punto de agarre fijo (offset) para que el objeto se oriente igual al agarrarlo con cualquier mano.
2. Haz que ambos mandos puedan agarrar, evitando que dos manos cojan el mismo objeto.
3. Calcula también la velocidad angular de la mano y aplícala al soltar para un lanzamiento con giro.
4. Cambia el color del haz del láser cuando apunte a un elemento pulsable.
5. Mapea el punto 3D golpeado a coordenadas 2D reales del Control para pulsar el botón exacto bajo el láser.
6. Añade háptica creciente cuando la mano se acerca a un objeto agarrable.

## 📝 Reto verificable

Construye una escena VR donde el jugador pueda agarrar un RigidBody3D con `grab` (detectado por un Area3D), soltarlo transfiriendo la velocidad de la mano (lanzamiento), y donde un puntero láser desde el otro mando pulse un botón de un panel de UI espacial con confirmación háptica.

**Criterio de aceptación**: en visor o simulador, al pulsar `grab` cerca de un cubo este se pega a la mano; al soltar en movimiento sale lanzado con dirección coherente; y al apuntar con el láser al panel y pulsar `trigger`, el botón responde (mensaje o cambio visual) con vibración, sin errores en consola.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El objeto agarrado tiembla o explota | Se dejó la física activa. Pon `freeze = true` al agarrar y `false` al soltar. |
| Al agarrar el objeto salta de sitio | No se usó `reparent()`. Reparenta para conservar la posición global. |
| El lanzamiento no tiene fuerza | No se transfirió la velocidad. Asigna `linear_velocity` de la mano al soltar. |
| El láser no detecta el panel | Falta el StaticBody3D con colisión o el RayCast no se actualiza. Usa `force_raycast_update()`. |
| El botón 3D no reacciona al clic | El SubViewport no recibe input. Envía el evento con `push_input()`. |

## ❓ Preguntas frecuentes

**❓ ¿Area3D o RayCast3D para agarrar?** Area3D para agarre por proximidad (recoger algo que tocas); RayCast3D para apuntar y "atraer" objetos a distancia o para punteros de UI. Muchas apps combinan ambos.

**❓ ¿Por qué congelo la física al agarrar?** Para que el objeto siga la mano de forma rígida sin que el motor de física luche contra el movimiento. Al soltar se reactiva y recibe la velocidad del gesto.

**❓ ¿Cómo hago una UI 3D con muchos botones?** Usa un `SubViewport` con un `Control` completo (VBox, botones, sliders) y mapea el punto que golpea el láser a las coordenadas 2D del viewport para dirigir el input al widget correcto.

**❓ ¿godot-xr-tools no hace esto solo?** Sí, con componentes `Grabbable`, `Pointer` y `Viewport2Din3D`. Montarlo a mano una vez te permite depurar y personalizar cuando el addon no cubra tu caso.

## 🔗 Referencias

- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Godot Docs — Area3D: <https://docs.godotengine.org/en/stable/classes/class_area3d.html>
- Godot Docs — Using a SubViewport: <https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html>
- godot-xr-tools — Interactables: <https://github.com/GodotVR/godot-xr-tools>

## ➡️ Siguiente clase

[Clase 234 - Presencia, escala y diseño para VR](../234-presencia-escala-y-diseno-para-vr/README.md)
