# Clase 234 — Presencia, escala y diseño para VR

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Documentación de XR en Godot 4 y Oculus/Meta VR Best Practices*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La **presencia** es la sensación de "estar realmente ahí": el cerebro acepta el mundo virtual como real. Es el objetivo último de la VR y también su punto más frágil, porque cualquier detalle incoherente —una mesa demasiado grande, una mano que atraviesa una pared, un salto de cámara— la rompe de golpe. En esta clase estudiarás qué construye y qué destruye la presencia, con foco en la **escala 1:1**: en VR el mundo se mide en metros reales y el jugador percibe de inmediato si un objeto no tiene el tamaño esperado.

Montarás una escena a escala real (una mesa, una silla, objetos de sobremesa) y la recorrerás con el visor para verificar la sensación de tamaño. Ajustarás la altura del `XROrigin3D` para que la cámara quede a la altura de ojos correcta y aprenderás a diseñar espacios que inviten a moverse sin marear ni desorientar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es la presencia y enumerar factores que la refuerzan o la rompen.
2. Modelar y colocar objetos a escala real 1:1 en metros dentro de Godot.
3. Ajustar la altura del `XROrigin3D` según el modo de referencia del suelo.
4. Diseñar un espacio VR cómodo respetando distancias personales y zonas de interacción.
5. Detectar y corregir incoherencias de escala que arruinan la inmersión.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Presencia e inmersión | Es la meta de toda experiencia VR. |
| 2 | Escala 1:1 en metros | El jugador percibe el tamaño real al instante. |
| 3 | Altura del jugador y del origin | Fija dónde quedan los ojos y las manos. |
| 4 | Play space y modos de referencia | Define el suelo y el área jugable segura. |
| 5 | Distancias y zonas de interacción | Los objetos deben quedar al alcance del brazo. |
| 6 | Rupturas de inmersión | Un solo detalle falso desactiva la presencia. |
| 7 | Interacción natural y affordances | Los objetos deben "pedir" cómo se usan. |
| 8 | Diseño de espacios cómodos | Evita chocar con paredes reales y desorientar. |

## 📖 Definiciones y características

- **Presencia**: convicción perceptiva de estar dentro del entorno virtual. Clave: se pierde con incoherencias, no se gana con gráficos.
- **Escala 1:1**: cada unidad de Godot equivale a un metro real. Clave: modela con medidas del mundo (mesa ≈ 0.75 m de alto).
- **`XROrigin3D`**: nodo raíz que representa el centro del espacio de juego; el visor se mueve **respecto a él**. Clave: moverlo mueve todo el mundo alrededor del jugador.
- **`XRCamera3D`**: hijo del origin cuya pose la controla el visor. Clave: nunca la muevas por código, la conduce el hardware.
- **Play space**: área física real donde el jugador puede moverse con seguridad. Clave: OpenXR la reporta según los límites configurados.
- **Modo de referencia (reference space)**: define dónde está el "suelo" (a nivel de pies o de la posición de arranque). Clave: determina la altura de la cámara.
- **Affordance**: pista visual de cómo se usa un objeto (un asa invita a agarrar). Clave: reduce la fricción de la interacción.
- **Ruptura de inmersión (immersion break)**: evento que recuerda que todo es virtual. Clave: escala falsa, clipping o teletransportes bruscos son causas típicas.

## 🧰 Herramientas y preparación

Continúa en el proyecto VR de la clase 231 con OpenXR activado y `get_viewport().use_xr = true`. Necesitas un visor conectado (Quest por Link o standalone) para verificar la escala; sin visor puedes validar medidas en el editor con la rejilla, pero la sensación real solo se aprecia con el casco puesto. Usa mallas simples (`BoxMesh`, `CylinderMesh`) con dimensiones reales para prototipar rápido.

Referencias de apoyo: XR en Godot en <https://docs.godotengine.org/en/stable/tutorials/xr/index.html> y las guías de confort de Meta en <https://developer.oculus.com/resources/bp-locomotion/>.

## 🧪 Laboratorio guiado

Montaremos una sala a escala real y verificaremos el tamaño con el visor.

1. Abre la escena VR base con `XROrigin3D` y su `XRCamera3D`. Añade un `StaticBody3D` como suelo con un `CollisionShape3D` (WorldBoundaryShape o un BoxShape plano) y una malla de 4 × 4 m.

2. Crea la mesa con un `MeshInstance3D` de tipo `BoxMesh`. En el Inspector fija su **Size** a `(1.2, 0.04, 0.8)` metros (tablero) y colócala a `0.73` de altura. Añade cuatro cilindros finos como patas. Estas medidas son las de una mesa real: al verla con el visor debe sentirse creíble.

3. Configura la altura del jugador según el modo de referencia. En el `_ready` del origin, elige suelo a nivel de pies para que la cámara quede a la altura de ojos real:

```gdscript
extends XROrigin3D

@onready var interfaz_xr: XRInterface = XRServer.find_interface("OpenXR")

func _ready() -> void:
	if interfaz_xr and interfaz_xr.is_initialized():
		get_viewport().use_xr = true
		# Suelo a nivel del piso real: el jugador de 1.75 m ve a esa altura.
		XRServer.set_reference_frame()  # centra el origen en la pose actual
		print("Play space listo. Ojos a altura real del jugador.")
	else:
		push_warning("OpenXR no inicializado: revisa el visor y el plugin.")
```

4. Añade objetos de sobremesa a escala: una taza (`CylinderMesh` de 0.08 m de alto y 0.04 m de radio) y un libro (`BoxMesh` de 0.2 × 0.03 × 0.15 m). Colócalos sobre el tablero, a menos de 0.6 m del borde para que queden al alcance del brazo.

5. Ejecuta y ponte el visor. Acércate a la mesa: la taza debe caber en tu mano imaginaria y la mesa llegarte a la cadera. Si algo se siente "de juguete" o "gigante", corrige las dimensiones en metros, no la escala del nodo.

6. Comprueba la altura sentándote y levantándote físicamente: la cámara debe seguirte porque el visor controla la pose. Si arrancas flotando o hundido en el suelo, revisa el modo de referencia y la posición Y del `XROrigin3D` (debe ser 0 sobre el suelo).

7. Añade una pared a 1.5 m para probar el confort: no debe quedar tan cerca que invite a atravesarla con la mano. Ese respeto al espacio personal es parte del diseño para la presencia.

Con la escala correcta y la altura bien fijada, la sala se siente habitable. En la próxima clase saltamos a la realidad aumentada.

## ✍️ Ejercicios

1. Modela una silla a escala real (asiento a 0.45 m) y ajústala junto a la mesa.
2. Coloca un objeto deliberadamente al doble de tamaño y describe cómo rompe la presencia.
3. Cambia el modo de referencia a "posición de arranque" y compara la altura de la cámara.
4. Añade un espejo con `MeshInstance3D` y verifica si el reflejo de escala se siente correcto.
5. Diseña una zona de interacción marcando en el suelo el área alcanzable sin caminar.
6. Coloca una ventana a la altura real de los ojos y valida que se vea sin agacharse.

## 📝 Reto verificable

Construye una habitación pequeña a escala 1:1 (suelo, dos paredes, una mesa con tres objetos y una silla), con la altura del `XROrigin3D` bien configurada para que el jugador arranque de pie sobre el suelo. Todos los objetos de sobremesa deben quedar al alcance del brazo sin caminar.

**Criterio de aceptación**: al probar con el visor, el jugador está de pie a su altura real, la mesa le llega a la cadera, puede "tocar" los objetos extendiendo el brazo y ningún elemento se siente desproporcionado.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El jugador arranca flotando o hundido | Modo de referencia o Y del origin mal. Usa suelo a nivel de pies y Y = 0. |
| Todo se siente "de juguete" o gigante | Escalaste nodos en vez de modelar en metros. Fija Size real en el Inspector. |
| La cámara no sigue al agacharse | Moviste la `XRCamera3D` por código. Déjala controlada por el visor. |
| Los objetos quedan lejos del brazo | Los colocaste fuera de la zona de alcance. Acércalos a menos de 0.6 m. |
| Mareo al acercarse a paredes | Paredes demasiado próximas al play space. Amplía el espacio libre. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué no puedo simplemente escalar el nodo raíz?** Escalar rompe físicas, colisiones y la percepción de distancia. En VR se modela siempre en metros reales.

**❓ ¿Cómo sé la altura de ojos del jugador?** Con suelo a nivel de pies, el visor la reporta automáticamente; no la fijes tú, cada persona es distinta.

**❓ ¿La presencia depende de tener gráficos realistas?** No. Un entorno estilizado pero coherente en escala y física genera más presencia que uno realista con incoherencias.

**❓ ¿Qué distancia mínima dejo a las paredes?** Al menos el alcance de un brazo (≈0.7 m) para que el jugador no sienta el impulso de atravesarlas.

## 🔗 Referencias

- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Godot Docs — Setting up XR: <https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html>
- Meta — Locomotion Best Practices: <https://developer.oculus.com/resources/bp-locomotion/>
- Khronos — OpenXR reference spaces: <https://www.khronos.org/openxr/>

## ➡️ Siguiente clase

[Clase 235 - Realidad aumentada: fundamentos y tracking](../235-realidad-aumentada-fundamentos-y-tracking/README.md)
