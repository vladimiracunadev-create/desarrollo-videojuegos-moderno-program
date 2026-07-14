# Clase 239 — Capstone Parte 13: una experiencia VR o AR mínima

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Síntesis de la Parte 13 sobre documentación de XR en Godot 4*
> ⏱️ Duración estimada: **120 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Es hora de integrar todo lo aprendido en la Parte 13 en una experiencia jugable y coherente. Elegirás **una** de dos rutas: una **experiencia VR mínima** —una sala a escala real con locomoción por teleport, agarrar objetos, una UI espacial, audio 3D y háptica, corriendo al framerate objetivo del visor— o una **experiencia AR mínima** —colocar objetos anclados sobre planos detectados con ARCore/ARKit. Ambas ponen a prueba lo esencial: presencia, interacción, rendimiento y feedback multimodal.

Trabajarás con una especificación clara, un checklist y una **definition of done** para saber cuándo la experiencia está realmente terminada, no solo "funcionando a medias". El foco es integrar bien lo existente, no añadir features nuevas: una experiencia pequeña pero pulida vale más que una grande y mareante.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Integrar locomoción, interacción, audio y háptica en una sola experiencia VR.
2. Alternativamente, construir una experiencia AR de colocación anclada estable.
3. Cumplir el presupuesto de rendimiento del visor de forma sostenida.
4. Verificar la experiencia contra un checklist y una definition of done.
5. Probar en hardware real y corregir los problemas que solo aparecen en el dispositivo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Elección de ruta VR o AR | Cada una integra un subconjunto distinto de la parte. |
| 2 | Especificación de la experiencia | Define el alcance y evita el sobrealcance. |
| 3 | Integración de sistemas | El valor está en que todo funcione junto. |
| 4 | Locomoción por teleport (VR) | Movimiento cómodo sin marear. |
| 5 | Agarre y UI espacial (VR) | Interacción natural con el entorno. |
| 6 | Colocación anclada (AR) | Objetos fijos y creíbles sobre el mundo. |
| 7 | Rendimiento sostenido | Sin framerate estable no hay confort. |
| 8 | Checklist y definition of done | Distinguen "termina" de "casi termina". |

## 📖 Definiciones y características

- **Capstone**: proyecto integrador que reúne las competencias de la parte. Clave: integrar, no inventar features nuevas.
- **Definition of done (DoD)**: criterios objetivos que marcan el fin. Clave: si falta uno, no está terminado.
- **Locomoción por teleport**: desplazamiento instantáneo a un punto apuntado. Clave: minimiza el mareo frente al movimiento continuo.
- **UI espacial**: interfaz en el mundo 3D (paneles flotantes) en vez de en pantalla plana. Clave: se pulsa con el mando o el rayo.
- **Objeto agarrable**: cuerpo que se toma con el gatillo/grip y sigue la mano. Clave: base de la interacción VR.
- **Ancla estable (AR)**: objeto fijado al mundo real que no deriva. Clave: prueba de un buen tracking.
- **Feedback multimodal**: respuesta visual + audio + háptica a una acción. Clave: refuerza la sensación de "real".
- **Checklist de verificación**: lista de comprobaciones antes de dar por hecho. Clave: evita entregar con fallos evidentes.

## 🧰 Herramientas y preparación

Reúne lo construido en las clases 231–238: el proyecto VR con OpenXR (o el proyecto AR con plugin de la clase 236), el renderer Mobile para standalone, los scripts de locomoción, agarre, audio 3D y háptica. Necesitas el hardware real: un visor VR (Quest u otro) para la ruta VR, o un móvil con ARCore/ARKit para la ruta AR. Prepara un lector de framerate en pantalla (clase 237) para verificar el rendimiento durante las pruebas.

Referencias: XR en Godot en <https://docs.godotengine.org/en/stable/tutorials/xr/index.html> y el resto del material de las clases 231–238.

## 🧪 Laboratorio guiado

Construiremos y verificaremos la experiencia. Ruta VR como guía principal; la ruta AR se resume al final.

1. **Especifica el alcance (VR)**: una sala a escala 1:1 con suelo y paredes, tres objetos agarrables sobre una mesa, un panel de UI espacial con un botón, audio ambiente 3D y háptica al agarrar. Nada más: mantén el alcance mínimo.

2. Monta el `XROrigin3D` con `XRCamera3D`, dos `XRController3D`, el `AudioListener3D` en la cabeza y el renderer en Mobile. Verifica la altura del jugador (clase 234).

3. Implementa la locomoción por teleport: apunta con un mando un arco hasta el suelo, y al soltar el gatillo mueve el `XROrigin3D` a ese punto. El teleport evita el mareo del movimiento continuo:

```gdscript
extends XRController3D  # mando de teleport

@export var origin_path: NodePath
@onready var origin: XROrigin3D = get_node(origin_path)
var destino: Vector3
var destino_valido := false

func _process(_delta: float) -> void:
	# Un raycast hijo apunta al suelo; aqui solo leemos su impacto.
	var rayo := $RayCast3D as RayCast3D
	destino_valido = rayo.is_colliding()
	if destino_valido:
		destino = rayo.get_collision_point()

func _on_boton_teleport(soltado: bool) -> void:
	if soltado and destino_valido:
		# Movemos el origin, no la camara: el mundo se recoloca alrededor.
		origin.global_position = destino
		trigger_haptic_pulse("haptic", 0.0, 0.5, 0.05, 0.0)
```

4. Implementa el agarre: al pulsar grip cerca de un objeto agarrable, lo parenta a la mano y vibra el mando; al soltar, lo libera. Añade un `AudioStreamPlayer3D` de "clic" al agarrar:

```gdscript
func agarrar(objeto: Node3D, sonido: AudioStreamPlayer3D) -> void:
	objeto.reparent(self)                                  # sigue a la mano
	sonido.play()                                          # confirmacion sonora
	trigger_haptic_pulse("haptic", 0.0, 0.7, 0.08, 0.0)   # confirmacion tactil
```

5. Añade una UI espacial: un `MeshInstance3D` con un `SubViewport` que muestre un `Control` con un botón. Detecta el rayo del mando sobre el panel y dispara la acción del botón (por ejemplo, reiniciar la escena) con feedback háptico.

6. Añade audio ambiente 3D (clase 238) y verifica el framerate con el lector en pantalla mientras te mueves e interactúas. Optimiza (clase 237) hasta sostener el objetivo del visor.

7. **Ruta AR (alternativa)**: reutiliza la app de la clase 236. La especificación mínima es detectar planos horizontales y colocar hasta tres objetos anclados por toque, estables al caminar, con un indicador visual del plano detectado. Verifica en el móvil que las anclas no derivan.

8. Pasa el checklist y la definition of done (abajo) en el hardware real. Corrige lo que falle antes de dar por terminado.

**Checklist de verificación**

- [ ] El jugador arranca de pie a su altura real (VR) o la sesión AR inicia con passthrough (AR).
- [ ] La locomoción por teleport funciona y no marea (VR).
- [ ] Se pueden agarrar y soltar los objetos, con audio y háptica (VR).
- [ ] La UI espacial responde al mando (VR).
- [ ] Los objetos AR quedan anclados y no derivan al moverse (AR).
- [ ] El audio 3D se localiza correctamente desde la cabeza.
- [ ] El framerate se mantiene estable en el objetivo del visor.
- [ ] No hay crashes en una sesión de prueba de varios minutos.

**Definition of done**: la experiencia elegida corre en el hardware real, cumple todos los ítems del checklist, sostiene el framerate objetivo sin caídas perceptibles y puede jugarse un par de minutos sin causar molestia física ni errores. Si algún ítem falla, no está terminada.

## ✍️ Ejercicios

1. Añade un segundo tipo de objeto agarrable con distinto sonido y peso háptico (VR).
2. Marca visualmente el destino válido del teleport con un anillo en el suelo (VR).
3. Añade un segundo botón a la UI espacial que cambie el color del ambiente (VR).
4. Permite borrar el último objeto colocado con un toque largo (AR).
5. Muestra el framerate en la UI espacial para monitorizarlo dentro de la experiencia.
6. Añade reverb distinto a dos zonas de la sala y verifica el cambio al cruzarlas (VR).

## 📝 Reto verificable

Entrega una de las dos experiencias completa según su especificación mínima, probada en hardware real y superando el checklist y la definition of done. Documenta qué ruta elegiste, qué sistemas integraste y el framerate medido durante la prueba.

**Criterio de aceptación**: la experiencia corre en el visor o el móvil, integra los sistemas requeridos (locomoción, agarre, UI, audio y háptica en VR; detección de planos y colocación anclada en AR), sostiene el framerate objetivo y pasa todos los ítems del checklist sin causar mareo ni errores en una sesión de prueba.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El teleport marea igual que el movimiento | Añadiste desplazamiento continuo por error. Muévete solo al soltar el gatillo, de golpe. |
| El objeto agarrado no sigue la mano | No lo reparentaste al `XRController3D`. Usa `reparent` al mando al agarrar. |
| La UI espacial no responde | El rayo del mando no impacta el panel o falta el `SubViewport`. Revisa colisión y viewport. |
| Framerate cae al integrar todo | La suma de sistemas supera el presupuesto. Optimiza (clase 237) y mide. |
| Los objetos AR derivan | Tracking pobre. Mejora luz y textura del entorno y limita el número de anclas. |

## ❓ Preguntas frecuentes

**❓ ¿VR o AR, cuál elijo?** La que tu hardware permita probar de verdad. Ambas rutas son válidas; lo importante es integrar y verificar en el dispositivo real.

**❓ ¿Puedo ampliar el alcance con más features?** El objetivo es integrar y pulir lo existente. Amplía solo si ya cumples la definition of done por completo.

**❓ ¿Qué pasa si no llego al framerate objetivo?** No está terminado. El rendimiento es parte de la DoD porque sin él la experiencia marea.

**❓ ¿Basta con que funcione en el editor?** No. XR se valida en hardware real: muchos problemas (tracking, confort, framerate) solo aparecen en el visor o el móvil.

## 🔗 Referencias

- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Godot Docs — Deploying XR / OpenXR: <https://docs.godotengine.org/en/stable/tutorials/xr/openxr_settings.html>
- Meta — Locomotion Best Practices: <https://developer.oculus.com/resources/bp-locomotion/>
- Google — ARCore anchors: <https://developers.google.com/ar/develop/anchors>

## ➡️ Siguiente clase

[Clase 240 - Mentalidad de rendimiento: medir antes de optimizar](../../parte-14-optimizacion-profiling-y-rendimiento/240-mentalidad-de-rendimiento-medir-antes-de-optimizar/README.md)
