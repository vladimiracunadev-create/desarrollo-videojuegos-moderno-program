# Clase 231 — VR en Godot: setup y primera escena

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Godot Docs — Setting up XR y XR nodes*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Con OpenXR ya habilitado, toca montar la escena mínima que todo proyecto VR necesita. La jerarquía es siempre la misma: un **XROrigin3D** que representa el espacio físico de juego, un **XRCamera3D** hija que sigue la cabeza del jugador, y uno o dos **XRController3D** que siguen los mandos. Inicializas OpenXR, activas `use_xr` en el viewport y de repente estás *dentro* de la escena, con las manos moviéndose en el aire.

En esta clase construyes esa primera escena VR completa desde cero, con mallas visibles para las manos y un script que arranca OpenXR de forma robusta. Aprenderás por qué el XROrigin3D es tu "punto cero" físico, cómo la cámara hereda el tracking sin que tú muevas nada, y cómo asignar cada controller a la mano correcta con `tracker`. Al final lo verás en el visor (o en el simulador) con las dos manos siguiéndote.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Construir la jerarquía XROrigin3D → XRCamera3D + XRController3D.
2. Asignar cada XRController3D a la mano izquierda o derecha con `tracker`.
3. Inicializar OpenXR y activar `use_xr` desde un script robusto.
4. Añadir mallas visibles a los mandos para ver las manos.
5. Verificar el tracking de cabeza y manos en visor o simulador.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | XROrigin3D | Es el punto cero del espacio físico del jugador. |
| 2 | XRCamera3D | Sigue la cabeza sin código; hija del origin. |
| 3 | XRController3D | Sigue cada mando; base de toda interacción. |
| 4 | Propiedad `tracker` | Asocia un controller a `left_hand`/`right_hand`. |
| 5 | Inicialización robusta | Evitar arrancar sin runtime o sin `use_xr`. |
| 6 | Mallas de manos | Feedback visual: el jugador ve dónde están sus manos. |
| 7 | Escala de mundo | 1 unidad = 1 metro; la escala importa en VR. |
| 8 | Simulador XR | Probar sin visor durante el desarrollo. |

## 📖 Definiciones y características

- **XROrigin3D**: nodo que ancla el espacio de juego al mundo real. Clave: mover el origin mueve al jugador; la cámara se mueve sola por tracking.
- **XRCamera3D**: cámara que se posiciona según el tracking de la cabeza. Clave: no debes moverla por código; el runtime la actualiza.
- **XRController3D**: nodo que sigue un mando físico y expone sus entradas. Clave: emite señales `button_pressed`/`button_released` y lee `input_float`.
- **`tracker`**: propiedad que identifica qué mano representa el controller (`left_hand`, `right_hand`). Clave: sin asignarla, el mando no se posiciona.
- **`button_pressed(name)`**: señal del XRController3D al pulsar un botón mapeado. Clave: `name` es la acción del Action Map, no el botón físico.
- **`input_float(name)`**: valor analógico de una acción (gatillo 0.0–1.0). Clave: útil para gatillos y grips graduales.
- **Escala de mundo**: en VR 1 unidad = 1 metro. Clave: modelar a escala real evita romper la sensación de presencia.
- **Simulador XR**: herramienta para emular movimiento sin visor. Clave: acelera el desarrollo y las pruebas de lógica.

## 🧰 Herramientas y preparación

Parte del proyecto con OpenXR habilitado de la clase 230. Necesitas **Godot 4.x** y, para ver el resultado inmersivo, un visor con runtime OpenXR o el simulador que incluye el addon **godot-xr-tools** (<https://github.com/GodotVR/godot-xr-tools>). El addon es opcional para esta clase (montaremos todo con nodos nativos), pero su simulador es cómodo para probar sin hardware.

Consulta la referencia de nodos XR de Godot (<https://docs.godotengine.org/en/stable/classes/class_xrorigin3d.html> y los nodos relacionados). Ten preparadas dos mallas simples para las manos: sirven `BoxMesh` o `SphereMesh` pequeñas mientras no tengas modelos de manos. Trabaja siempre pensando en metros: una mesa está a ~0,75 m del suelo.

## 🧪 Laboratorio guiado

Montarás la primera escena VR completa con manos visibles e inicialización de OpenXR.

1. Crea una escena nueva con raíz `Node3D` llamada `MundoVR`. Añade un `WorldEnvironment` y una `DirectionalLight3D` para ver algo, y un `StaticBody3D` con un `MeshInstance3D` (un plano) como suelo a `y = 0`.

2. Añade como hijo un **XROrigin3D** (`XROrigin`). Dentro de él añade un **XRCamera3D** (`XRCamera`). No la muevas: el tracking la posicionará.

3. Añade dos **XRController3D** como hijos del XROrigin: `LeftHand` y `RightHand`. En el Inspector, fija la propiedad **Tracker**: `left_hand` para el primero y `right_hand` para el segundo.

4. A cada controller añádele un `MeshInstance3D` hijo con una `BoxMesh` de ~0,08 m para ver la posición de cada mano.

5. Adjunta este script a `MundoVR` para inicializar OpenXR y reaccionar a las entradas:

```gdscript
extends Node3D

@onready var izquierda: XRController3D = $XROrigin/LeftHand
@onready var derecha: XRController3D = $XROrigin/RightHand

var xr_interface: XRInterface

func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.initialize():
		get_viewport().use_xr = true
		print("VR lista. Vistas: ", xr_interface.get_view_count())
	else:
		push_warning("Sin runtime OpenXR: se verá en modo plano para depurar.")

	# Conectamos las señales de botones de ambas manos.
	derecha.button_pressed.connect(_on_boton.bind("derecha"))
	izquierda.button_pressed.connect(_on_boton.bind("izquierda"))

func _on_boton(nombre_accion: String, mano: String) -> void:
	print("Botón '%s' en mano %s" % [nombre_accion, mano])
	# Pulso háptico corto como confirmación (frecuencia, amplitud, duración, retardo).
	var controller: XRController3D = derecha if mano == "derecha" else izquierda
	controller.trigger_haptic_pulse("haptic", 0.0, 0.5, 0.1, 0.0)

func _process(_delta: float) -> void:
	# Ejemplo: leer el gatillo derecho como valor 0.0–1.0.
	var gatillo: float = derecha.get_float("trigger")
	if gatillo > 0.5:
		pass  # Aquí iría la acción de "disparo" o similar.
```

6. Asegúrate de que las acciones `trigger` y un botón (por ejemplo el gatillo o `ax_button`) existen en el Action Map (clase 230) y están enlazadas al perfil de tu mando.

7. Ejecuta con F5. Con visor y runtime activo verás la escena en estéreo, la cámara seguirá tu cabeza y las dos cajas seguirán tus manos. Pulsa un botón y observa en consola el mensaje y el pulso háptico en el mando.

8. Sin visor, la advertencia aparecerá y verás la escena en modo plano; útil para comprobar que la jerarquía y las conexiones no dan error.

Ya tienes la escena base de VR sobre la que se construyen la locomoción y la interacción de las clases siguientes.

## ✍️ Ejercicios

1. Sustituye las cajas de las manos por `SphereMesh` y ajusta su tamaño a algo natural.
2. Añade un tercer mensaje que imprima la posición global de la cámara cada segundo.
3. Cambia el suelo por una cuadrícula (GridMap o un plano con textura) para percibir mejor la escala.
4. Haz que al soltar el botón (`button_released`) se imprima otro mensaje.
5. Lee el grip con `get_float("grab")` y colorea la malla de la mano cuando supere 0,5.
6. Coloca una mesa a 0,75 m de altura y comprueba que la escala se siente realista en el visor.

## 📝 Reto verificable

Construye una escena VR con XROrigin3D, XRCamera3D y dos XRController3D correctamente asignados a `left_hand` y `right_hand`, cada uno con una malla visible, e inicializa OpenXR activando `use_xr`. Al pulsar un botón, la mano correspondiente debe emitir un pulso háptico y registrar el evento en consola.

**Criterio de aceptación**: en visor o simulador, la cámara sigue la cabeza y ambas mallas siguen las manos; al pulsar el botón mapeado, la consola imprime la mano y la acción, y el mando vibra; sin runtime, aparece la advertencia y la escena carga en modo plano sin errores.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Las manos no se ven ni se mueven | Falta asignar `tracker` (`left_hand`/`right_hand`) al XRController3D. |
| La cámara no sigue la cabeza | XRCamera3D no es hija del XROrigin3D. Corrige la jerarquía. |
| Todo se ve gigante o diminuto | Escala incorrecta. Modela en metros: 1 unidad = 1 m. |
| `button_pressed` nunca dispara | La acción no está en el Action Map o sin binding. Revísala. |
| El mando no vibra | Nombre de háptico erróneo. Usa la acción háptica definida (p. ej. `"haptic"`). |

## ❓ Preguntas frecuentes

**❓ ¿Por qué no debo mover la XRCamera3D por código?** Porque su transform lo controla el tracking de la cabeza en cada frame. Si la mueves, el runtime la sobrescribe o provocas conflicto y mareo. Para mover al jugador, mueve el XROrigin3D.

**❓ ¿Puedo tener un solo controller?** Sí, para experiencias de una mano. Basta con un XRController3D asignado a la mano que uses; deja el otro fuera.

**❓ ¿Qué diferencia hay entre `get_float` y `is_button_pressed`?** `get_float` devuelve el valor analógico de una acción (gatillo 0,0–1,0); `is_button_pressed` devuelve un booleano para acciones de tipo botón.

**❓ ¿Necesito modelos de manos realistas?** No para empezar. Cajas o esferas bastan para validar el tracking; luego puedes sustituirlas por mallas de manos o los assets de godot-xr-tools.

## 🔗 Referencias

- Godot Docs — Setting up XR: <https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html>
- Godot Docs — XROrigin3D: <https://docs.godotengine.org/en/stable/classes/class_xrorigin3d.html>
- Godot Docs — XRController3D: <https://docs.godotengine.org/en/stable/classes/class_xrcontroller3d.html>
- godot-xr-tools: <https://github.com/GodotVR/godot-xr-tools>

## ➡️ Siguiente clase

[Clase 232 - Locomoción VR y confort](../232-locomocion-vr-y-confort/README.md)
