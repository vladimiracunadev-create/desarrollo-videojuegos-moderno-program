# Clase 232 — Locomoción VR y confort

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Godot Docs (XR) y guías de confort VR de Meta*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Mover al jugador por un mundo más grande que su habitación es el problema central de la VR, y también su mayor fuente de mareo. Cuando la vista se mueve pero el cuerpo no, el oído interno protesta y llega el **cybersickness**. Por eso existen técnicas de locomoción diseñadas para el confort: el **teleport** (saltas de un punto a otro sin movimiento continuo), el **movimiento continuo** (más inmersivo pero más mareante), el **snap turn** (giros discretos que evitan la rotación fluida) y la **viñeta de confort** (oscurecer los bordes al moverte para reducir el flujo periférico).

En esta clase implementas locomoción real en Godot: un teleport con arco proyectado desde el mando y una viñeta que se activa durante el movimiento. Entenderás el punto de anclaje del teleport, por qué mueves el XROrigin3D y no la cámara, y cómo combinar técnicas para que la experiencia sea cómoda para el mayor número de personas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Comparar teleport, movimiento continuo, snap turn y smooth turn por confort.
2. Implementar un teleport con arco proyectado desde el mando en Godot.
3. Mover al jugador desplazando el XROrigin3D respetando el offset de la cámara.
4. Añadir una viñeta de confort que reaccione al movimiento.
5. Elegir la combinación de locomoción adecuada según el público objetivo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Teleport | La locomoción más cómoda; casi no marea. |
| 2 | Movimiento continuo | Más inmersivo, pero exige mitigar el mareo. |
| 3 | Snap turn | Giros discretos que evitan la rotación fluida mareante. |
| 4 | Smooth turn | Giro fluido, cómodo solo para usuarios veteranos. |
| 5 | Viñeta de confort | Reduce el flujo óptico periférico durante el movimiento. |
| 6 | Punto de anclaje | Dónde aterriza el teleport y cómo se valida el destino. |
| 7 | Mover el origin | Se desplaza el XROrigin3D, no la cámara. |
| 8 | Opciones de accesibilidad | Ofrecer varias técnicas amplía el público. |

## 📖 Definiciones y características

- **Teleport**: transporte instantáneo a un punto apuntado. Clave: sin movimiento continuo de cámara, casi no genera mareo.
- **Movimiento continuo**: desplazamiento fluido con joystick. Clave: máximo realismo, máximo riesgo de cybersickness.
- **Snap turn**: rotación en incrementos fijos (p. ej. 30°). Clave: el salto discreto evita el mareo de girar suavemente.
- **Smooth turn**: rotación continua. Clave: cómoda solo para usuarios acostumbrados; ofrécela como opción, no por defecto.
- **Viñeta de confort (tunneling)**: oscurecimiento de los bordes de la vista al moverse. Clave: reduce el flujo periférico que dispara el mareo.
- **Arco de teleport**: trayectoria parabólica proyectada desde el mando para elegir destino. Clave: comunica dónde aterrizarás.
- **Offset de cámara**: la cámara está desplazada del origin por el tracking. Clave: al teletransportar hay que compensarlo para caer en el punto correcto.
- **Destino válido**: superficie donde se permite aterrizar (suelo, no paredes). Clave: se valida con el resultado del raycast.

## 🧰 Herramientas y preparación

Parte de la escena VR de la clase 231. Necesitas **Godot 4.x** y, para la viñeta, un `ColorRect` a pantalla completa o un shader; aquí usaremos un enfoque sencillo con un `MeshInstance3D` como túnel alrededor de la cámara para no depender de post-proceso complejo. El addon **godot-xr-tools** trae una función de teleport lista, pero la implementaremos a mano para entenderla.

Ten en el Action Map (clase 230) una acción `teleport` (bool) y, si vas a probar movimiento continuo, una acción `move` (vector2) mapeada al joystick. Consulta las guías de confort de Meta (<https://developers.meta.com/horizon/resources/>) y la documentación de XR de Godot. Recuerda: mueve siempre el **XROrigin3D**, nunca la cámara.

## 🧪 Laboratorio guiado

Implementarás un teleport con arco y una viñeta de confort al moverte.

1. En la escena VR, añade a la mano derecha un hijo para dibujar el arco: un `MeshInstance3D` con una malla que actualizarás por código, o una serie de puntos. Para simplificar, usaremos un `RayCast3D` recto largo como versión inicial y luego lo curvamos.

2. Crea un nodo `Marker3D` llamado `MarcadorTeleport` en la escena para mostrar dónde aterrizarás (un disco plano visible).

3. Adjunta este script a la mano derecha (`RightHand`):

```gdscript
extends XRController3D

@export var longitud_arco: float = 8.0
@export var pasos: int = 20
@export var gravedad: float = -9.8

@onready var origin: XROrigin3D = get_parent()
@onready var camara: XRCamera3D = origin.get_node("XRCamera")
@onready var marcador: Node3D = get_tree().current_scene.get_node("MarcadorTeleport")

var apuntando: bool = false
var destino: Vector3 = Vector3.ZERO
var destino_valido: bool = false

func _ready() -> void:
	button_pressed.connect(_on_boton)
	button_released.connect(_on_soltar)
	marcador.visible = false

func _on_boton(accion: String) -> void:
	if accion == "teleport":
		apuntando = true

func _on_soltar(accion: String) -> void:
	if accion == "teleport" and apuntando:
		apuntando = false
		marcador.visible = false
		if destino_valido:
			_teletransportar_a(destino)

func _physics_process(_delta: float) -> void:
	if not apuntando:
		return
	# Proyectamos una parábola desde la posición y dirección del mando.
	var pos: Vector3 = global_transform.origin
	var vel: Vector3 = -global_transform.basis.z * longitud_arco
	destino_valido = false
	var espacio := get_world_3d().direct_space_state
	var t_paso: float = 0.08
	for i in range(pasos):
		var siguiente: Vector3 = pos + vel * t_paso
		vel.y += gravedad * t_paso
		var consulta := PhysicsRayQueryParameters3D.create(pos, siguiente)
		var hit := espacio.intersect_ray(consulta)
		if hit:
			destino = hit.position
			# Solo es válido si la superficie mira hacia arriba (suelo).
			destino_valido = hit.normal.y > 0.7
			break
		pos = siguiente
	marcador.visible = destino_valido
	if destino_valido:
		marcador.global_position = destino

func _teletransportar_a(punto: Vector3) -> void:
	# Compensamos el offset horizontal de la cámara respecto al origin.
	var offset_cam: Vector3 = camara.global_position - origin.global_position
	offset_cam.y = 0.0
	origin.global_position = punto - offset_cam
	trigger_haptic_pulse("haptic", 0.0, 0.5, 0.08, 0.0)
```

4. Ejecuta y prueba: mantén pulsado el botón `teleport`, verás el marcador solo sobre suelos válidos; al soltar, el jugador salta a ese punto sin movimiento continuo. Nota que caes exactamente donde apuntaste porque compensamos el offset de la cámara.

5. Ahora añade la **viñeta de confort**. Crea un `MeshInstance3D` como hijo de la XRCamera3D: una esfera invertida grande y semitransparente con un hueco central (o un shader de túnel). Empieza invisible.

6. Crea un script para la viñeta que la muestre cuando el origin se mueva de forma continua:

```gdscript
extends MeshInstance3D

var pos_anterior: Vector3
@onready var origin: XROrigin3D = get_parent().get_parent()

func _ready() -> void:
	pos_anterior = origin.global_position
	visible = false

func _process(delta: float) -> void:
	var velocidad: float = (origin.global_position - pos_anterior).length() / max(delta, 0.0001)
	pos_anterior = origin.global_position
	# Mostramos el túnel solo cuando hay desplazamiento notable.
	visible = velocidad > 0.5
```

7. Si además implementas movimiento continuo con el joystick (acción `move`), la viñeta aparecerá al desplazarte y desaparecerá al parar, reduciendo el mareo. Pruébalo en el visor y ajusta el umbral `0.5` a tu gusto.

Con teleport, marcador validado y viñeta de confort tienes una locomoción cómoda y publicable.

## ✍️ Ejercicios

1. Añade snap turn: al empujar el joystick a los lados, rota el XROrigin3D 30° de golpe con enfriamiento.
2. Cambia el arco para que sea más corto y comprueba cómo afecta al alcance del teleport.
3. Haz que el marcador cambie de color (verde/rojo) según `destino_valido`.
4. Implementa movimiento continuo con la acción `move` y limita la velocidad a 2 m/s.
5. Ajusta la viñeta para que su opacidad crezca con la velocidad, no solo aparezca/desaparezca.
6. Añade un ajuste en un menú para desactivar la viñeta (usuarios sin sensibilidad al mareo).

## 📝 Reto verificable

Implementa un sistema de locomoción por teleport con arco proyectado y validación de destino (solo suelos), que mueva al XROrigin3D compensando el offset de la cámara, junto con una viñeta de confort que se active durante cualquier desplazamiento del jugador.

**Criterio de aceptación**: en visor o simulador, al apuntar aparece un marcador solo sobre superficies válidas; al soltar, el jugador aterriza exactamente en el punto apuntado; y la viñeta de confort se muestra mientras hay movimiento y se oculta al detenerse, sin errores en consola.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Al teletransportar el jugador cae desplazado | No se compensó el offset horizontal de la cámara. Resta `offset_cam` como en el lab. |
| El teleport aterriza en paredes | Falta validar la normal. Exige `hit.normal.y > 0.7`. |
| Mareo con movimiento continuo | Sin viñeta o velocidad muy alta. Activa el tunneling y baja la velocidad. |
| Girar suave marea a los usuarios | Smooth turn por defecto. Usa snap turn como opción principal. |
| El marcador nunca aparece | El raycast no golpea (arco corto o sin colisión). Aumenta pasos/longitud y revisa colliders. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué muevo el XROrigin3D y no la cámara?** Porque la cámara la controla el tracking de la cabeza en cada frame. El origin es el "suelo bajo los pies" del jugador; desplazarlo mueve todo el sistema de forma consistente.

**❓ ¿El teleport rompe la inmersión?** Un poco, pero es el mejor compromiso de confort. Muchos juegos ofrecen teleport por defecto y movimiento continuo como opción para veteranos.

**❓ ¿La viñeta se nota mucho?** Bien calibrada, apenas conscientemente: reduce el flujo periférico sin tapar el centro de la vista. Su fuerza debe ser configurable.

**❓ ¿Debo elegir una sola técnica?** No. Lo ideal es ofrecer varias (teleport, continuo, snap/smooth turn, viñeta on/off) como opciones de accesibilidad para cubrir distintas sensibilidades.

## 🔗 Referencias

- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Meta — VR comfort y locomotion: <https://developers.meta.com/horizon/resources/>
- godot-xr-tools — Locomotion: <https://github.com/GodotVR/godot-xr-tools>
- Godot Docs — PhysicsDirectSpaceState3D: <https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html>

## ➡️ Siguiente clase

[Clase 233 - Interacción VR: manos, agarre y UI espacial](../233-interaccion-vr-manos-agarre-y-ui-espacial/README.md)
