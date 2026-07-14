# Clase 230 — OpenXR y el estándar abierto

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Khronos Group — OpenXR Specification y Godot Docs (Setting up XR)*
> ⏱️ Duración estimada: **70 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Antes de OpenXR, cada fabricante tenía su propio SDK: escribir para Oculus no servía para SteamVR ni para Windows Mixed Reality. **OpenXR**, mantenido por Khronos, unifica todo bajo una sola API: tu juego habla con un **runtime** que traduce al hardware real. Godot 4 adopta OpenXR como su capa XR principal, con un **Action Map** que desacopla las acciones lógicas ("agarrar", "saltar") de los botones físicos de cada mando.

En esta clase entiendes qué resuelve un estándar, cómo funcionan los runtimes y el Action Map, y activas OpenXR en un proyecto Godot real. El laboratorio te lleva a habilitar OpenXR en los ajustes del proyecto, verificar por código que la interfaz existe con `XRServer.find_interface("OpenXR")` y configurar acciones básicas en el Action Map. Es la base sobre la que se montan todas las clases prácticas siguientes.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es OpenXR y qué problema de fragmentación resuelve.
2. Describir el papel de un runtime XR y cómo se selecciona.
3. Activar OpenXR en los ajustes de un proyecto Godot 4.
4. Verificar la interfaz OpenXR por código con `XRServer.find_interface`.
5. Configurar acciones y bindings en el Action Map de OpenXR.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Fragmentación pre-OpenXR | Explica por qué hacía falta un estándar. |
| 2 | Qué es OpenXR | Una sola API para todos los dispositivos XR. |
| 3 | Runtimes | El software (SteamVR, Meta) que implementa OpenXR. |
| 4 | Soporte en Godot 4 | Godot habla OpenXR de forma nativa. |
| 5 | Interface XR | `XRInterface` es el objeto que representa el sistema XR. |
| 6 | Action Map | Desacopla acciones lógicas de botones físicos. |
| 7 | Bindings por perfil | Cada mando mapea las acciones a sus botones. |
| 8 | Alternativas | WebXR y SDKs propietarios y cuándo aparecen. |

## 📖 Definiciones y características

- **OpenXR**: estándar abierto de Khronos que unifica el acceso a dispositivos VR/AR. Clave: escribes una vez y corre en cualquier runtime compatible.
- **Runtime XR**: software que implementa OpenXR para un hardware concreto (SteamVR, Meta, Monado). Clave: hay un runtime "activo" que tu app usa.
- **XRInterface**: objeto de Godot que representa el sistema XR y se inicializa antes de renderizar. Clave: sin inicializarlo, no hay salida al visor.
- **XRServer**: singleton de Godot que gestiona interfaces y trackers XR. Clave: es el punto de entrada por código (`find_interface`).
- **Action Map**: tabla que define acciones lógicas y sus perfiles de binding. Clave: cambia de mando sin tocar la lógica del juego.
- **Acción**: entrada semántica ("grab", "trigger", "aim_pose"). Clave: tu código consulta la acción, no el botón.
- **Interaction profile**: conjunto de bindings para un mando específico. Clave: permite soportar varios controladores con el mismo código.
- **`use_xr`**: propiedad del viewport que activa el render estéreo. Clave: es el interruptor que dirige la imagen al visor.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** (idealmente 4.2 o superior) y, para probar en hardware, un **runtime OpenXR** instalado: SteamVR en PC o el runtime de Meta en Quest vía Link/streaming. Sin visor, puedes activar OpenXR igualmente y verificar la lógica; el render estéreo solo se verá con un dispositivo o el simulador de XR de godot-xr-tools.

La documentación clave es **Setting up XR** de Godot (<https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html>) y la especificación de **OpenXR** (<https://registry.khronos.org/OpenXR/>). En Godot, la configuración vive en **Project Settings → XR → OpenXR**, y el Action Map se edita desde esa misma pantalla con el botón de acciones OpenXR.

## 🧪 Laboratorio guiado

Activarás OpenXR en un proyecto Godot, verificarás la interfaz por código y definirás acciones en el Action Map.

1. Crea un proyecto Godot 4 nuevo con renderizador **Forward+** o **Mobile** (Mobile si tu objetivo es standalone).

2. Ve a **Project → Project Settings → XR → OpenXR** y marca **Enabled**. Godot pedirá reiniciar; acéptalo.

3. En esa misma sección, abre el editor del **Action Map** de OpenXR. Crea un *action set* llamado `godot` (o usa el que trae por defecto) y añade acciones: `grab` (tipo bool), `trigger` (tipo float) y `aim_pose` (tipo pose).

4. Añade el **interaction profile** de tu mando (por ejemplo, *Touch controllers*) y enlaza cada acción a un botón: `grab`→grip, `trigger`→trigger, `aim_pose`→aim.

5. Crea una escena con un nodo raíz `Node3D` y adjúntale este script para inicializar OpenXR y verificar la interfaz:

```gdscript
extends Node3D

@onready var xr_interface: XRInterface

func _ready() -> void:
	# Buscamos la interfaz OpenXR registrada por Godot.
	xr_interface = XRServer.find_interface("OpenXR")

	if xr_interface and xr_interface.is_initialized():
		print("OpenXR ya estaba inicializada.")
		_activar_xr()
	elif xr_interface and xr_interface.initialize():
		print("OpenXR inicializada correctamente.")
		_activar_xr()
	else:
		push_warning("No se pudo inicializar OpenXR. ¿Runtime activo? ¿OpenXR habilitado?")

func _activar_xr() -> void:
	# Dirigimos el render estéreo al visor.
	get_viewport().use_xr = true
	# En standalone conviene fijar el refresco objetivo.
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	print("Sistema XR: ", xr_interface.get_name())
```

6. Ejecuta con F5. Sin visor verás el mensaje de advertencia (esperado); con un runtime OpenXR activo verás "OpenXR inicializada correctamente" y el nombre del sistema en consola.

7. Conecta las señales del Action Map desde un `XRController3D` (lo montarás en la clase 231) para confirmar que las acciones `grab` y `trigger` llegan. Por ahora basta con verificar la inicialización.

Con esto tienes el cimiento: OpenXR activo, la interfaz verificada por código y un Action Map con acciones semánticas listas para usarse.

## ✍️ Ejercicios

1. Explica en tres frases qué problema resolvió OpenXR frente a los SDK propietarios.
2. Cambia el nombre de una acción del Action Map y verifica que sigue funcionando sin tocar el resto.
3. Modifica el script para imprimir también `xr_interface.get_view_count()`.
4. Añade una acción `menu` (bool) mapeada al botón de menú del mando.
5. Investiga qué runtime OpenXR está activo en tu sistema y cómo cambiarlo.
6. Describe la diferencia entre una acción y un interaction profile con tus palabras.

## 📝 Reto verificable

Configura un proyecto Godot con OpenXR habilitado, un Action Map con al menos tres acciones (`grab`, `trigger`, `aim_pose`) enlazadas a un interaction profile, y un script que inicialice la interfaz, active `use_xr` e imprima el nombre del sistema XR o una advertencia clara si no hay runtime.

**Criterio de aceptación**: al ejecutar, la consola muestra "OpenXR inicializada correctamente" con el nombre del sistema cuando hay runtime activo, o una advertencia comprensible si no lo hay; el Action Map contiene las tres acciones enlazadas y el proyecto no lanza errores rojos.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| `find_interface` devuelve `null` | OpenXR no habilitado en Project Settings. Márcalo y reinicia el editor. |
| `initialize()` devuelve `false` | No hay runtime OpenXR activo. Arranca SteamVR o el runtime del visor. |
| Se ve en el monitor pero no en el visor | Falta `get_viewport().use_xr = true`. Actívalo tras inicializar. |
| Botones que no responden | Acciones sin binding en el interaction profile. Enlázalas en el Action Map. |
| Imagen a tirones en standalone | VSync o refresco mal configurados. Ajusta el vsync y el refresco objetivo. |

## ❓ Preguntas frecuentes

**❓ ¿OpenXR sustituye a WebXR?** No. WebXR es el estándar para XR en navegadores; OpenXR es para apps nativas. Godot exportado a web usa WebXR, y en escritorio/standalone usa OpenXR.

**❓ ¿Puedo tener varios runtimes instalados?** Sí, pero solo uno es el "activo" a la vez. Se selecciona en la configuración del sistema o del propio runtime (por ejemplo, SteamVR puede fijarse como runtime OpenXR por defecto).

**❓ ¿Por qué separar acciones de botones?** Porque así el mismo juego soporta mandos distintos y permite remapeo por el usuario sin tocar la lógica. Es la misma idea que un mapa de teclas configurable.

**❓ ¿Necesito el addon godot-xr-tools para usar OpenXR?** No para lo básico: OpenXR es nativo en Godot 4. El addon aporta comodidades de alto nivel (locomoción, agarre) que veremos más adelante.

## 🔗 Referencias

- Godot Docs — Setting up XR: <https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html>
- Khronos — OpenXR Registry y spec: <https://registry.khronos.org/OpenXR/>
- Khronos — OpenXR Overview: <https://www.khronos.org/openxr/>
- Godot Docs — XR action map: <https://docs.godotengine.org/en/stable/tutorials/xr/xr_action_map.html>

## ➡️ Siguiente clase

[Clase 231 - VR en Godot: setup y primera escena](../231-vr-en-godot-setup-y-primera-escena/README.md)
