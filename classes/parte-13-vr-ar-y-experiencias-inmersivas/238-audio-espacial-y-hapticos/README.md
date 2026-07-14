# Clase 238 — Audio espacial y hápticos

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Documentación de audio 3D y XR en Godot 4*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La presencia en VR no es solo visual: el sonido y el tacto la refuerzan enormemente. El **audio espacial** hace que el jugador localice una fuente por el oído —arriba, detrás, a la derecha— tal como en la vida real, y el **feedback háptico** en los mandos convierte un agarre o un golpe en una sensación física. En esta clase colocarás sonido 3D con `AudioStreamPlayer3D` usando la **cabeza del jugador** (la `XRCamera3D`) como listener, añadirás reverb por espacio y dispararás pulsos hápticos con `XRController3D.trigger_haptic_pulse()`.

El laboratorio integra ambos: objetos que suenan desde su posición en el mundo, atenuación con la distancia, y una vibración en el mando al agarrar o golpear con el gatillo. El resultado es una escena que se oye y se siente coherente con lo que se ve.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Colocar audio 3D con `AudioStreamPlayer3D` y explicar la atenuación por distancia.
2. Fijar el listener en la `XRCamera3D` para que el sonido siga la cabeza.
3. Aplicar reverb por espacio mediante buses y áreas.
4. Disparar pulsos hápticos con `trigger_haptic_pulse` en los mandos.
5. Sincronizar sonido y háptica con eventos de interacción (agarrar, golpear).

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Audio 3D en VR | Localizar por el oído refuerza la presencia. |
| 2 | Listener en la cabeza | El sonido debe moverse con la `XRCamera3D`. |
| 3 | Atenuación y rango | Modela cómo el sonido baja con la distancia. |
| 4 | HRTF y paneo | Da la sensación de dirección y altura. |
| 5 | Reverb por espacio | Una sala suena distinta a un exterior. |
| 6 | Hápticos en los mandos | El tacto confirma acciones físicas. |
| 7 | Intensidad y duración del pulso | Calibra el feedback sin molestar. |
| 8 | Sincronizar audio y háptica | Juntos venden el impacto de una acción. |

## 📖 Definiciones y características

- **`AudioStreamPlayer3D`**: reproductor posicionado en el espacio 3D. Clave: su volumen y paneo dependen de dónde esté respecto al listener.
- **Listener**: punto de escucha de la escena. Clave: en VR debe ser la `XRCamera3D` (la cabeza), no una cámara fija.
- **Atenuación (attenuation)**: caída del volumen con la distancia. Clave: `unit_size` y el modelo definen a qué ritmo baja.
- **HRTF**: función de transferencia relativa a la cabeza; simula cómo el oído percibe dirección/altura. Clave: mejora la localización con auriculares.
- **Reverb**: reflexiones que dan sensación de espacio. Clave: se aplica por bus de audio, distinto por sala.
- **`XRController3D`**: nodo del mando con pose y entradas. Clave: expone `trigger_haptic_pulse` para vibrar.
- **`trigger_haptic_pulse`**: dispara vibración con amplitud, frecuencia y duración. Clave: es el feedback táctil del mando.
- **Feedback multimodal**: combinar visual, audio y háptica. Clave: refuerzan juntos la sensación de un evento.

## 🧰 Herramientas y preparación

Continúa en tu proyecto VR con OpenXR y dos `XRController3D` (izquierdo y derecho) bajo el `XROrigin3D`. Necesitas auriculares para apreciar el audio espacial (el HRTF luce con cabeza/oídos). Ten algún archivo de sonido corto (un impacto, un zumbido) importado en `res://audio/`. Crea un bus de audio extra en el panel **Audio** para el reverb de la sala.

Referencias: `AudioStreamPlayer3D` en <https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html>, buses de audio en <https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html> y `XRController3D` en <https://docs.godotengine.org/en/stable/classes/class_xrcontroller3d.html>.

## 🧪 Laboratorio guiado

Añadiremos sonido 3D con el listener en la cabeza y háptica al interactuar.

1. Fija el listener en la cabeza. Añade un `AudioListener3D` como hijo de la `XRCamera3D` y actívalo, para que el sonido se calcule desde donde mira el jugador:

```gdscript
extends XRCamera3D

func _ready() -> void:
	var listener := AudioListener3D.new()
	add_child(listener)
	listener.make_current()  # el audio 3D se oye desde la cabeza
```

2. Coloca una fuente sonora en el mundo. Añade un `AudioStreamPlayer3D` a un objeto (por ejemplo una máquina que zumba), asígnale el stream y configura la atenuación:

```gdscript
extends AudioStreamPlayer3D

func _ready() -> void:
	stream = preload("res://audio/zumbido.ogg")
	unit_size = 2.0                         # metros a los que se oye a volumen base
	max_distance = 12.0                     # mas alla no se oye
	attenuation_model = ATTENUATION_INVERSE_DISTANCE
	autoplay = true
```

3. Ejecuta con el visor y los auriculares: acércate y aléjate del objeto y gira la cabeza. El zumbido debe crecer al acercarte y sonar a un lado u otro según hacia dónde mires, porque el listener sigue la `XRCamera3D`.

4. Añade reverb por espacio. Crea un bus `SalaReverb`, añádele un efecto **Reverb** y enruta la fuente a ese bus dentro de la sala. Distintas salas pueden usar buses con reverb distinto para "sonar" diferente.

5. Dispara háptica al golpear con el gatillo. En el mando derecho, al pulsar el `trigger`, vibra el mando para confirmar la acción:

```gdscript
extends XRController3D  # mando derecho

func _process(_delta: float) -> void:
	if get_float("trigger") > 0.7:
		# amplitud 0-1, frecuencia en Hz, duracion en segundos.
		trigger_haptic_pulse("haptic", 0.0, 0.6, 0.1, 0.0)
```

6. Sincroniza sonido y háptica en un evento de impacto. Cuando un objeto agarrado golpee algo, reproduce un `AudioStreamPlayer3D` de impacto **y** vibra el mando que lo sostiene, para que el golpe se oiga y se sienta a la vez:

```gdscript
func golpear(mando: XRController3D, sonido_impacto: AudioStreamPlayer3D) -> void:
	sonido_impacto.play()                                   # se oye desde el punto de golpe
	mando.trigger_haptic_pulse("haptic", 0.0, 0.8, 0.08, 0.0)  # se siente en la mano
```

7. Prueba el conjunto: agarra un objeto, golpéalo contra una superficie y verifica que el sonido llega desde la posición correcta y el mando vibra en el instante del impacto. Ajusta amplitud y duración para que el pulso confirme sin resultar molesto.

Con audio espacial y háptica, la escena gana cuerpo y credibilidad. En la próxima clase integramos todo en un capstone.

## ✍️ Ejercicios

1. Coloca tres fuentes en distintas direcciones y verifica que las localizas con los ojos cerrados.
2. Cambia el `attenuation_model` y compara cómo cae el volumen con la distancia.
3. Aplica reverb solo dentro de un `Area3D` y quítalo al salir de la sala.
4. Varía amplitud y duración del pulso háptico y describe cómo cambia la sensación.
5. Añade un háptico suave y continuo al mantener un objeto agarrado.
6. Reproduce un sonido de UI espacial al pulsar un botón flotante y confírmalo con háptica.

## 📝 Reto verificable

Crea una escena VR con al menos dos fuentes de audio 3D posicionadas, el listener en la `XRCamera3D`, reverb por espacio y una interacción (agarrar y golpear) que dispare sonido de impacto desde la posición del golpe y un pulso háptico en el mando que sostiene el objeto.

**Criterio de aceptación**: con auriculares y visor, el jugador localiza cada fuente por el oído según su posición y orientación de cabeza, y al golpear un objeto agarrado oye el impacto desde el punto correcto mientras siente la vibración en el mando correspondiente.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El sonido no cambia al girar la cabeza | El listener no está en la `XRCamera3D`. Añade y activa un `AudioListener3D` como su hijo. |
| Todo suena centrado, sin dirección | Usaste `AudioStreamPlayer` (2D) en vez de `AudioStreamPlayer3D`. Cambia el nodo. |
| El mando no vibra | Nombre de acción háptica erróneo o mando sin soporte. Usa `"haptic"` y verifica el `XRController3D`. |
| El sonido se corta de golpe al alejarse | `max_distance` muy bajo. Súbelo o ajusta la atenuación. |
| La háptica es molesta o constante | Amplitud/duración altas o disparada cada frame. Reduce valores y condiciona el disparo. |

## ❓ Preguntas frecuentes

**❓ ¿Necesito auriculares para el audio espacial?** Para apreciar dirección y altura (HRTF), sí. Con altavoces se pierde gran parte de la localización.

**❓ ¿Por qué el listener debe ser la cámara?** Porque el jugador oye desde donde está su cabeza. Un listener fijo daría un sonido incoherente con lo que mira.

**❓ ¿Los parámetros de `trigger_haptic_pulse` son universales?** La firma es amplitud, frecuencia y duración, pero cada mando responde distinto. Calibra en el hardware real.

**❓ ¿Cómo cambio el reverb entre salas?** Enruta cada fuente a un bus con su propio efecto Reverb y conmuta según el `Area3D` en que esté el jugador.

## 🔗 Referencias

- Godot Docs — AudioStreamPlayer3D: <https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html>
- Godot Docs — Buses de audio: <https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html>
- Godot Docs — XRController3D: <https://docs.godotengine.org/en/stable/classes/class_xrcontroller3d.html>
- Godot Docs — AudioListener3D: <https://docs.godotengine.org/en/stable/classes/class_audiolistener3d.html>

## ➡️ Siguiente clase

[Clase 239 - Capstone Parte 13: una experiencia VR o AR mínima](../239-capstone-parte-13-una-experiencia-vr-o-ar-minima/README.md)
