# Clase 210 — Certificación (TRC/TCR) y requisitos de consola

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Guías de certificación de plataformas de consola (visión general pública)*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Entender qué es la **certificación de consola**: el proceso por el que el fabricante comprueba que tu juego cumple una lista de requisitos técnicos y de comportamiento antes de permitir su publicación. Cada plataforma tiene su nombre y su lista: **TRC (Technical Requirements Checklist)** en PlayStation, **TCR (Technical Certification Requirements)** en Xbox y el equivalente de **Nintendo** (a menudo llamado "lotcheck"). Son documentos confidenciales bajo NDA, pero comparten un núcleo de requisitos comunes que sí podemos estudiar de forma general.

Como Godot llega a consola vía porteador, buena parte de la implementación de estos requisitos la resuelve el porteo; pero tú, como diseñador del juego, debes conocerlos para no crear situaciones que los incumplan. Al terminar sabrás elaborar una **checklist de certificación** con los requisitos comunes y auto-evaluar tu juego frente a ellos.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Definir qué es la certificación y qué papel juega TRC/TCR/lotcheck.
2. Enumerar los requisitos comunes: suspensión/resume, controladores, mensajes del sistema, guardado.
3. Reconocer fallos típicos que provocan el rechazo en certificación.
4. Elaborar una checklist de certificación con requisitos comunes verificables.
5. Auto-evaluar un juego propio frente a esa checklist e identificar carencias.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es la certificación | Es el filtro final antes de publicar. |
| 2 | TRC / TCR / lotcheck | Cada plataforma nombra su lista distinta. |
| 3 | Suspensión y resume | El sistema puede dormir el juego en cualquier momento. |
| 4 | Gestión de controladores | Conectar/desconectar mando debe manejarse con gracia. |
| 5 | Mensajes del sistema | Invitaciones, batería, notificaciones interrumpen el juego. |
| 6 | Guardado y su integridad | Perder una partida guardada es causa de rechazo. |
| 7 | Fallos típicos | Conocerlos ahorra iteraciones de certificación. |
| 8 | Auto-evaluación | Detectar problemas antes de enviar a certificar. |

## 📖 Definiciones y características

- **Certificación**: revisión técnica del fabricante que aprueba o rechaza el juego. Clave: es obligatoria y previa a la publicación.
- **TRC (PlayStation)**: Technical Requirements Checklist. Clave: lista de comportamientos que el juego debe cumplir en el ecosistema Sony.
- **TCR (Xbox)**: Technical Certification Requirements. Clave: equivalente de Microsoft.
- **Lotcheck (Nintendo)**: proceso de comprobación de Nintendo. Clave: verifica comportamiento y estabilidad en Switch.
- **Suspensión/resume**: el sistema duerme y reanuda el juego (botón de encendido, tapa). Clave: al reanudar, audio, red y estado deben recuperarse sin fallos.
- **Gestión de controladores**: manejar desconexión/reconexión y reasignación del mando. Clave: al desconectar el mando activo, el juego debe pausar y avisar.
- **Mensajes del sistema**: capas del SO (invitaciones, avisos de batería). Clave: el juego no debe romperse al perder el foco.
- **Integridad de guardado**: proteger la partida contra corrupción y apagones. Clave: escritura segura y verificación de datos.

## 🧰 Herramientas y preparación

No hay SDK público que consultar (los documentos TRC/TCR están bajo NDA), así que trabajaremos con los **requisitos comunes** que son de dominio general. Prepara un documento o tabla para construir tu checklist. Ten a mano tu juego de Godot para auto-evaluarlo, aunque sea en PC: muchos requisitos (pausa al perder foco, manejo de desconexión de mando, guardado seguro) se pueden **simular y probar en el editor** antes de que exista un port.

En Godot, apóyate en las señales de entrada de mando (`Input.joy_connection_changed`) y en la notificación de foco de ventana (`NOTIFICATION_APPLICATION_FOCUS_OUT`) para reproducir localmente el comportamiento que la consola exigirá.

## 🧪 Laboratorio guiado

Construiremos una checklist de certificación y auto-evaluaremos el juego. Además, implementaremos dos comportamientos que casi todas las listas exigen: **pausar al perder el foco** y **avisar al desconectar el mando**.

1. Redacta la checklist base de requisitos comunes:

```text
[ ] Al perder el foco / suspender, el juego pausa y silencia el audio
[ ] Al reanudar, el juego recupera estado sin crash ni audio desincronizado
[ ] Al desconectar el mando activo, el juego pausa y muestra aviso
[ ] Al reconectar, se reanuda con el mando correcto
[ ] El guardado se escribe de forma segura (sin corromper si se apaga)
[ ] No hay cuelgues, memory leaks graves ni caídas de framerate persistentes
[ ] Textos legibles y terminología del sistema correcta
[ ] Manejo correcto de notificaciones/invitaciones del sistema
```

2. Crea un autoload `Certificacion` que reaccione a los eventos del sistema:

```gdscript
extends Node

# Gestiona pausa por pérdida de foco y por desconexión de mando.
signal juego_pausado(motivo: String)

func _ready() -> void:
	# Nos avisa cuando un mando se conecta o desconecta.
	Input.joy_connection_changed.connect(_on_joy_cambio)

func _notification(que: int) -> void:
	# El SO nos quita el foco (suspensión, overlay del sistema).
	if que == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_pausar("foco_perdido")
	elif que == NOTIFICATION_APPLICATION_FOCUS_IN:
		# Al recuperar el foco no reanudamos solos: lo hace el jugador.
		pass

func _on_joy_cambio(_dispositivo: int, conectado: bool) -> void:
	if not conectado and Input.get_connected_joypads().is_empty():
		_pausar("mando_desconectado")

func _pausar(motivo: String) -> void:
	get_tree().paused = true
	juego_pausado.emit(motivo)
```

3. En tu escena de juego, conecta la señal para mostrar el aviso adecuado:

```gdscript
func _ready() -> void:
	Certificacion.juego_pausado.connect(_mostrar_aviso)

func _mostrar_aviso(motivo: String) -> void:
	match motivo:
		"mando_desconectado":
			$UI/Aviso.text = "Vuelve a conectar el mando para continuar."
		"foco_perdido":
			$UI/Aviso.text = "Juego en pausa."
	$UI/Aviso.show()
```

4. Asegura que la UI de pausa siga funcionando: pon su nodo en **Process Mode: Always** para que reciba entrada aunque el árbol esté pausado.

5. Prueba en PC: desconecta el mando USB en pleno juego y confirma que pausa y muestra el aviso; reconéctalo y comprueba que puedes reanudar.

6. Para el guardado seguro, escribe primero en un archivo temporal y renómbralo al final, de modo que un apagado a mitad no corrompa el guardado real.

7. Rellena la checklist marcando qué cumple tu juego hoy y qué te falta. Ese listado es tu plan de trabajo antes de enviar a certificación.

## ✍️ Ejercicios

1. Añade a la checklist tres requisitos más que investigues como comunes y explica por qué importan.
2. Implementa la reanudación manual: el juego solo sale de pausa cuando el jugador pulsa un botón.
3. Simula la desconexión del segundo mando en un juego local de dos jugadores y decide qué debe pasar.
4. Implementa el patrón de guardado "escribir temporal + renombrar" y prueba interrumpirlo.
5. Documenta cómo tu juego maneja una notificación del sistema que roba el foco.
6. Clasifica cada ítem de tu checklist como "resuelve el porteador" o "responsabilidad del diseño del juego".

## 📝 Reto verificable

Elabora una **checklist de certificación** de al menos 10 requisitos comunes y auto-evalúa tu juego frente a ella, marcando cumplidos y pendientes. Implementa en Godot, como mínimo, la **pausa por desconexión de mando** con aviso al jugador y la **pausa por pérdida de foco**, verificables en PC.

**Criterio de aceptación**: al desconectar el mando durante la partida, el juego pausa y muestra un aviso claro; al reconectarlo, el jugador puede reanudar; y la checklist entregada distingue con claridad los ítems cumplidos de los pendientes.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El juego sigue corriendo con el mando desconectado | No escuchas `joy_connection_changed`. Pausa y avisa al perder el mando. |
| La UI de pausa no responde al pausar | Su Process Mode no es "Always". Cámbialo para que reciba entrada. |
| Crash al reanudar tras suspender | No recuperas bien audio/red al volver el foco. Reinicializa lo necesario. |
| Partida corrupta tras un apagón | Escribías directo sobre el guardado. Usa temporal + renombrado atómico. |
| Rechazo por terminología del sistema | Usaste nombres de botones/servicios incorrectos. Sigue la nomenclatura de la plataforma. |

## ❓ Preguntas frecuentes

**❓ ¿TRC y TCR son lo mismo?** Son análogos: TRC es de PlayStation y TCR de Xbox; Nintendo usa su propio proceso ("lotcheck"). Todos comparten un núcleo de requisitos comunes.

**❓ ¿El porteador se encarga de toda la certificación?** Ayuda mucho y resuelve gran parte de la integración, pero decisiones de diseño (cómo pausas, cómo guardas) son responsabilidad del juego.

**❓ ¿Puedo ver la lista TRC/TCR completa?** No públicamente: están bajo NDA. Sí puedes estudiar y prepararte con los requisitos comunes conocidos.

**❓ ¿Por qué tanto énfasis en suspensión y mandos?** Porque son situaciones cotidianas en consola (dormir la consola, quedarse sin batería el mando) y un fallo ahí provoca rechazo directo.

## 🔗 Referencias

- Godot Docs — Handling quit/notifications: <https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html>
- Godot Docs — Controllers, gamepads and joysticks: <https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html>
- Godot Docs — Saving games: <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>
- W4 Games (soporte de consola): <https://www.w4games.com>

## ➡️ Siguiente clase

[Clase 211 - Input de consola, logros y guardado en nube](../211-input-de-consola-logros-y-guardado-en-nube/README.md)
