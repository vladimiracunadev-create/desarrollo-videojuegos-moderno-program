# Clase 236 — AR con ARCore y ARKit

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Documentación de ARCore (Google), ARKit (Apple) y de plugins XR para Godot 4*
> ⏱️ Duración estimada: **85 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

ARCore (Android) y ARKit (iOS) son los motores de AR de cada plataforma: detectan planos, siguen la pose del dispositivo y ofrecen **hit-test** para saber dónde apoya un rayo en el mundo real. Godot accede a ellos mediante **plugins/addons** que registran una interfaz XR y exponen los planos detectados y las anclas como nodos. En esta clase pasarás de la teoría de la clase anterior a una app funcional: tocar la pantalla, lanzar un hit-test sobre un plano y **colocar un objeto anclado** que se mantiene fijo al moverte.

Aprenderás la estructura típica del plugin, cómo iterar los planos detectados, cómo crear una ancla desde un hit-test y qué limitaciones aceptar (rendimiento, calidad del tracking, dependencia del dispositivo). El código es representativo del patrón que exponen estos plugins; el nombre exacto de algunos métodos puede variar según el addon.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Instalar y activar un plugin de ARCore/ARKit en un proyecto de Godot.
2. Inicializar la sesión AR y mostrar el passthrough con la cámara.
3. Iterar los planos detectados y visualizarlos en la escena.
4. Ejecutar un hit-test desde un toque y crear una ancla en el impacto.
5. Colocar un objeto sobre la ancla y reconocer las limitaciones de la técnica.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Plugins ARCore/ARKit en Godot | Conectan el AR nativo con el motor. |
| 2 | Inicializar la sesión AR | Sin ella no hay tracking ni passthrough. |
| 3 | Planos detectados como nodos | Dan superficies reales donde apoyar objetos. |
| 4 | Hit-test desde el toque | Traduce un tap 2D a un punto 3D real. |
| 5 | Crear anclas | Fijan el objeto al mundo con corrección de tracking. |
| 6 | Colocar y parentar objetos | El objeto sigue a la ancla al moverse. |
| 7 | Export a Android/iOS | AR solo corre en el dispositivo, no en editor. |
| 8 | Limitaciones y buenas prácticas | Marcan qué esperar y qué evitar. |

## 📖 Definiciones y características

- **Plugin AR**: addon que registra la interfaz ARCore/ARKit en `XRServer`. Clave: sin él, `find_interface` devuelve null.
- **Hit-test**: rayo desde un punto de pantalla hacia la escena real. Clave: devuelve pose de impacto sobre planos o puntos.
- **`XRAnchor3D`**: nodo cuya pose la mantiene el sistema de tracking. Clave: parenta objetos que deben quedar fijos al mundo.
- **Plano rastreado (tracked plane)**: superficie con pose, extensión y tipo (horizontal/vertical). Clave: se actualiza conforme mejora el mapa.
- **Passthrough de cámara**: el video real como fondo del render. Clave: lo activa la interfaz al inicializar la sesión.
- **Sesión AR**: ciclo de vida del tracking activo. Clave: consume batería y CPU; pausarla ahorra recursos.
- **Export template móvil**: paquete para compilar a APK/IPA. Clave: AR solo se prueba en el dispositivo real.
- **Feature point**: punto característico del entorno usado por el SLAM. Clave: pocas features implican tracking pobre.

## 🧰 Herramientas y preparación

Necesitas: un móvil Android con ARCore o un iPhone con ARKit, los **export templates** de Godot para esa plataforma, y un **plugin AR** para Godot 4 (busca addons de ARCore/ARKit en el Asset Library o repositorios de la comunidad). Instala el plugin en `res://addons/` y actívalo en **Project → Project Settings → Plugins**. Ten el SDK de Android (o Xcode en Mac) configurado para exportar. En el editor de escritorio el AR no funciona: se prueba exportando al dispositivo.

Referencias: ARCore en <https://developers.google.com/ar>, ARKit en <https://developer.apple.com/augmented-reality/> y exportación en <https://docs.godotengine.org/en/stable/tutorials/export/index.html>.

## 🧪 Laboratorio guiado

Detectaremos un plano y colocaremos un objeto anclado tocando la pantalla.

1. Activa el plugin AR y confirma que aparece en la lista de Plugins. Reutiliza el árbol de la clase 235: `XROrigin3D` → `XRCamera3D`, más el contenedor `Anclas`.

2. Inicializa la sesión AR en `_ready`. Al inicializarse, la cámara empieza a mostrar el passthrough:

```gdscript
extends Node3D

@onready var anclas: Node3D = $Anclas
@onready var objeto_a_colocar: PackedScene = preload("res://escenas/objeto_ar.tscn")

var interfaz_ar: XRInterface

func _ready() -> void:
	interfaz_ar = XRServer.find_interface("ARCore")  # "ARKit" en iOS
	if interfaz_ar and interfaz_ar.initialize():
		get_viewport().use_xr = true
		print("Sesion AR activa: mueve el dispositivo para detectar planos.")
	else:
		push_error("No se pudo iniciar AR. Revisa plugin y dispositivo.")
```

3. Captura el toque en pantalla y lanza el hit-test. En AR, un tap se traduce a un rayo que consulta los planos detectados por el sistema:

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_colocar_en_toque(event.position)

func _colocar_en_toque(posicion_pantalla: Vector2) -> void:
	# El plugin expone el hit-test contra los planos rastreados.
	var resultado := interfaz_ar.hit_test(posicion_pantalla)
	if resultado.is_empty():
		print("El toque no impacto ningun plano detectado.")
		return
	var pose: Transform3D = resultado[0]  # pose del impacto mas cercano
	_anclar_objeto(pose)
```

4. Crea una ancla en la pose del impacto y parenta el objeto. Al colgarlo del `XRAnchor3D`, el sistema lo mantendrá fijo al mundo real:

```gdscript
func _anclar_objeto(pose: Transform3D) -> void:
	var ancla := XRAnchor3D.new()
	anclas.add_child(ancla)
	ancla.global_transform = pose
	var objeto := objeto_a_colocar.instantiate()
	ancla.add_child(objeto)
	print("Objeto anclado en ", pose.origin)
```

5. Prepara la escena `objeto_ar.tscn`: un `MeshInstance3D` con un `BoxMesh` de 0.1 m y un material visible. Mantenlo simple para no penalizar el rendimiento en el móvil.

6. Exporta al dispositivo (APK en Android o build en Xcode para iOS). Instala, abre la app y mueve el teléfono despacio sobre una mesa con textura hasta que se detecte un plano.

7. Toca sobre el plano: debe aparecer el cubo apoyado en la superficie real. Camina alrededor: el cubo permanece en su sitio gracias a la ancla. Si "deriva", el tracking es pobre (poca luz o textura): mejora las condiciones.

Ya tienes AR funcional: detección de planos, hit-test y anclas. En la próxima clase atacamos el rendimiento, crítico en XR.

## ✍️ Ejercicios

1. Muestra un indicador visual (un anillo) sobre el plano detectado antes de colocar el objeto.
2. Limita a un máximo de objetos anclados y elimina el más antiguo al superarlo.
3. Añade escala aleatoria a cada objeto colocado para variar la escena.
4. Distingue planos horizontales de verticales y permite colocar solo en horizontales.
5. Pausa y reanuda la sesión AR con un botón para ahorrar batería.
6. Registra en pantalla cuántos planos ha detectado el sistema en total.

## 📝 Reto verificable

Construye una app AR que detecte planos horizontales y, al tocar la pantalla sobre uno, coloque un objeto anclado mediante hit-test. La app debe manejar el caso de toque sin impacto (mensaje claro, sin crash) y mantener los objetos fijos al mundo al desplazarse el dispositivo.

**Criterio de aceptación**: exportada al dispositivo, la app detecta un plano, coloca un objeto sobre él al tocar, el objeto permanece anclado al caminar alrededor, y un toque fuera de un plano no coloca nada ni provoca error.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| `find_interface` devuelve null | Plugin no activado o dispositivo incompatible. Actívalo en Plugins y verifica ARCore/ARKit. |
| Nada ocurre al probar en el editor | AR no corre en escritorio. Exporta al dispositivo real. |
| El objeto aparece en el aire | El hit-test no impactó un plano; usaste una pose de punto suelto. Filtra por planos. |
| El objeto deriva al moverse | Tracking pobre por poca luz/textura. Mejora las condiciones del entorno. |
| Crash al tocar sin planos | No comprobaste `resultado.is_empty()`. Valida antes de usar la pose. |

## ❓ Preguntas frecuentes

**❓ ¿Los nombres de los métodos del plugin son siempre estos?** Varían según el addon. `find_interface`, `initialize` y `XRAnchor3D` son estándar de Godot; el `hit_test` concreto lo define el plugin, revisa su documentación.

**❓ ¿Puedo depurar AR sin dispositivo?** No de forma realista. Puedes validar la lógica de escena en escritorio, pero el tracking y el passthrough exigen el móvil.

**❓ ¿Por qué mi objeto se ve gigante o diminuto?** El hit-test devuelve metros reales; modela el objeto a escala 1:1 como en VR.

**❓ ¿Cuántos objetos puedo anclar?** Depende del rendimiento del dispositivo. Cada ancla consume tracking; limita el número y usa mallas simples.

## 🔗 Referencias

- Google — ARCore hit-test y anchors: <https://developers.google.com/ar/develop/anchors>
- Apple — ARKit overview: <https://developer.apple.com/documentation/arkit>
- Godot Docs — XRAnchor3D: <https://docs.godotengine.org/en/stable/classes/class_xranchor3d.html>
- Godot Docs — Exportar a Android: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html>

## ➡️ Siguiente clase

[Clase 237 - Rendimiento en XR](../237-rendimiento-en-xr/README.md)
