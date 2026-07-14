# Clase 235 — Realidad aumentada: fundamentos y tracking

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Documentación de ARCore, ARKit y de interfaces XR en Godot 4*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La realidad aumentada superpone contenido digital sobre el mundo real que ve la cámara del dispositivo. A diferencia de la VR, aquí el reto no es construir un mundo, sino **entender el mundo real** en tiempo real: dónde está el suelo, qué superficies hay, cómo se mueve el dispositivo y cómo anclar objetos para que parezcan estar físicamente presentes. En esta clase estudiarás los fundamentos: el passthrough, el tracking por **SLAM**, la detección de planos, las anclas, la oclusión y la iluminación estimada.

El laboratorio es conceptual y de preparación: describirás con precisión el flujo de una app AR —de detectar un plano a anclar un objeto sobre él— y dejarás el proyecto de Godot listo para AR, con la interfaz XR correcta y la estructura de nodos que usarás en la siguiente clase con ARCore/ARKit.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir AR de VR y ubicar el passthrough y la MR en el espectro inmersivo.
2. Explicar cómo el SLAM estima la pose del dispositivo y mapea el entorno.
3. Describir el flujo detección de plano → ancla → objeto anclado.
4. Justificar el papel de la oclusión y la iluminación estimada en el realismo.
5. Preparar un proyecto de Godot con la interfaz XR de AR y su árbol de nodos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | AR vs VR vs MR | Cada una impone retos técnicos distintos. |
| 2 | Passthrough | Muestra el mundo real como base del contenido. |
| 3 | Tracking y SLAM | Sin pose estable, todo "flota" o deriva. |
| 4 | Detección de planos | Da superficies reales donde apoyar objetos. |
| 5 | Anclas (anchors) | Fijan el contenido a un punto del mundo. |
| 6 | Oclusión | Objetos reales tapan a los virtuales y viceversa. |
| 7 | Iluminación estimada | Ilumina lo virtual acorde a la escena real. |
| 8 | Casos de uso de AR | Guían qué features priorizar. |

## 📖 Definiciones y características

- **AR (realidad aumentada)**: contenido virtual sobre la vista real. Clave: el mundo real es el escenario, no se reemplaza.
- **MR (realidad mixta)**: AR donde lo virtual interactúa con lo real (choca, se ocluye). Clave: exige comprensión geométrica del entorno.
- **Passthrough**: imagen de la cámara mostrada como fondo. Clave: en móvil es la cámara trasera; en visores, cámaras externas.
- **SLAM**: *Simultaneous Localization and Mapping*; estima la pose y construye un mapa a la vez. Clave: usa cámara e IMU para seguir el movimiento.
- **Detección de planos**: identifica superficies horizontales/verticales. Clave: entrega su posición, tamaño y orientación.
- **Ancla (anchor)**: punto del mundo real que el sistema sigue con precisión. Clave: el objeto anclado se mantiene fijo aunque te muevas.
- **Oclusión**: ocultar lo virtual tras geometría real (una mano, un mueble). Clave: sin ella, los objetos "flotan" sobre la escena.
- **Iluminación estimada (light estimation)**: intensidad y color de la luz real deducidos de la cámara. Clave: hace que lo virtual encaje con la escena.

## 🧰 Herramientas y preparación

Necesitas un móvil compatible: Android con **ARCore** o iOS con **ARKit**. Godot no trae AR móvil de serie: se integra mediante **plugins/addons** que exponen la funcionalidad como una interfaz XR. En esta clase no compilamos aún; preparamos el proyecto y el árbol de nodos. Trabajaremos con `XROrigin3D` y `XRCamera3D` (la cámara pasa a mostrar el passthrough) más nodos de ancla que en la clase 236 poblará el plugin.

Referencias: ARCore en <https://developers.google.com/ar>, ARKit en <https://developer.apple.com/augmented-reality/> y las interfaces XR de Godot en <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>.

## 🧪 Laboratorio guiado

Prepararemos el proyecto para AR y dejaremos escrito el flujo que implementaremos luego.

1. Crea un proyecto nuevo (o duplica el VR) y en **Project → Project Settings → XR** deja OpenXR desactivado: en móvil la interfaz la aporta el plugin ARCore/ARKit, no OpenXR de escritorio.

2. Monta el árbol base: un `XROrigin3D` con un `XRCamera3D` hijo. En AR, la `XRCamera3D` renderiza el video de la cámara como fondo y su pose la mueve el tracking del dispositivo.

3. Escribe el gestor de sesión AR que inicializa la interfaz y activa el modo XR. Aún sin plugin fallará al buscar la interfaz, pero deja el esqueleto correcto:

```gdscript
extends Node3D

var interfaz_ar: XRInterface

func _ready() -> void:
	# En movil la interfaz la registra el plugin ARCore/ARKit.
	interfaz_ar = XRServer.find_interface("ARCore")  # o "ARKit" en iOS
	if interfaz_ar and interfaz_ar.is_initialized():
		get_viewport().use_xr = true
		print("Sesion AR iniciada: passthrough y tracking activos.")
	else:
		push_warning("Interfaz AR no disponible: falta el plugin o el dispositivo no es compatible.")
```

4. Diseña el flujo de colocación como pseudocódigo comentado, el contrato que cumpliremos en la clase 236:

```gdscript
# FLUJO AR: detectar plano -> anclar -> colocar objeto
# 1. El sistema detecta un plano (suelo/mesa) y reporta su pose.
# 2. El usuario toca la pantalla sobre ese plano.
# 3. Un hit-test lanza un rayo desde el toque hacia la escena real.
# 4. Si impacta un plano, se crea una ancla (anchor) en ese punto.
# 5. Se instancia el objeto como hijo del nodo de ancla.
# 6. El objeto queda fijo al mundo real aunque el dispositivo se mueva.
func colocar_objeto_en(_posicion_toque: Vector2) -> void:
	pass  # se implementa con el plugin en la proxima clase
```

5. Añade un `Node3D` llamado `Anclas` que será el contenedor de todos los objetos anclados, y una escena de objeto de prueba (un `MeshInstance3D` con `BoxMesh` de 0.1 m) que reutilizaremos.

6. Documenta en un comentario qué features usarás: detección de planos horizontales, hit-test por toque, una ancla por objeto y (opcional) iluminación estimada para ajustar la luz de la escena.

7. Verifica que el proyecto abre sin errores en escritorio (mostrará el aviso de interfaz no disponible, que es lo esperado). El árbol y el contrato quedan listos para conectar el plugin.

Con los fundamentos claros y el proyecto preparado, en la próxima clase colocaremos objetos reales sobre planos con ARCore/ARKit.

## ✍️ Ejercicios

1. Dibuja el flujo detección → ancla → objeto y anótalo con los datos que entrega cada paso.
2. Explica con tus palabras por qué el SLAM necesita cámara **e** IMU y no solo cámara.
3. Enumera tres casos donde la falta de oclusión arruinaría el efecto AR.
4. Compara passthrough en móvil (cámara trasera) frente a visores MR (cámaras externas).
5. Diseña el árbol de nodos para una app que ancle varios objetos a la vez.
6. Investiga qué reporta ARCore sobre un plano detectado (pose, extent, tipo) y anótalo.

## 📝 Reto verificable

Entrega el proyecto de Godot preparado para AR: sin OpenXR de escritorio, con `XROrigin3D`/`XRCamera3D`, un nodo contenedor `Anclas`, el gestor de sesión que busca la interfaz AR y falla con un aviso claro, y el flujo de colocación documentado como pseudocódigo comentado paso a paso.

**Criterio de aceptación**: el proyecto abre sin errores en escritorio, muestra el `push_warning` de interfaz no disponible, y el pseudocódigo describe correctamente los seis pasos del flujo detección → hit-test → ancla → objeto.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Activas OpenXR y AR no funciona en móvil | AR móvil no usa OpenXR de escritorio. Deja que el plugin ARCore/ARKit registre la interfaz. |
| Los objetos "derivan" o flotan | Tracking pobre por poca luz o superficie sin textura. Mejora iluminación y textura del entorno. |
| No se detectan planos | Superficie uniforme o sin rasgos. Apunta a zonas con textura y mueve el dispositivo despacio. |
| Lo virtual siempre tapa lo real | Falta oclusión. Requiere depth/oclusión del plugin, no está activa por defecto. |
| `find_interface` devuelve null | El plugin no está instalado o el dispositivo no es compatible con ARCore/ARKit. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo hacer AR con OpenXR en el móvil?** El AR móvil típico usa ARCore/ARKit vía plugin; OpenXR cubre sobre todo visores. Prepara la interfaz que corresponda al dispositivo.

**❓ ¿El SLAM funciona en cualquier entorno?** Necesita textura y luz suficientes. Paredes lisas, oscuridad o superficies reflejantes degradan el tracking.

**❓ ¿Qué diferencia hay entre una ancla y una simple posición?** La ancla la sigue y corrige el sistema conforme mejora su mapa; una posición fija no se ajusta y puede quedar desalineada.

**❓ ¿La iluminación estimada es obligatoria?** No, pero sin ella los objetos virtuales se ven "pegados" porque su luz no coincide con la de la escena real.

## 🔗 Referencias

- Google — ARCore fundamentals: <https://developers.google.com/ar/develop/fundamentals>
- Apple — Augmented Reality (ARKit): <https://developer.apple.com/augmented-reality/>
- Godot Docs — XR interfaces: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Google — Anchors en ARCore: <https://developers.google.com/ar/develop/anchors>

## ➡️ Siguiente clase

[Clase 236 - AR con ARCore y ARKit](../236-ar-con-arcore-y-arkit/README.md)
