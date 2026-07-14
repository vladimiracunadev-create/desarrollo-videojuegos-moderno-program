# Clase 171 — Capstone Parte 8: diseñar y greyboxear un nivel completo

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Síntesis original de las clases 167–170 + documentación de Godot 4 (CSG, GridMap, CharacterBody3D)*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Este capstone integra toda la Parte 8 en un único entregable: partirás de un **objetivo de diseño** y unos **pilares**, diseñarás el **core loop** del nivel, su **pacing**, su **lenguaje visual** y su **narrativa ambiental**, lo **documentarás** en un one-pager y lo **greyboxearás** en Godot hasta tenerlo jugable. Cierra el círculo diseño → documentación → blockout → playtest.

No es un ejercicio de arte ni de código complejo: es la demostración de que sabes convertir una intención de diseño en un espacio que se juega y comunica sin una sola textura final. El resultado se valida con una **especificación, un checklist y una definition of done** objetivas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Derivar un nivel completo desde un objetivo de diseño y pilares.
- Diseñar el core loop, el pacing y el lenguaje visual de un nivel.
- Integrar narrativa ambiental sin cinemáticas en el recorrido.
- Documentar el nivel en un one-pager conforme a la Clase 170.
- Producir un blockout jugable en Godot y validarlo con playtest.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Objetivo y pilares | Fijan la vara de todo el nivel |
| 2 | Core loop del nivel | Define la actividad repetida que engancha |
| 3 | Pacing | Alternar tensión y respiro sostiene el ritmo |
| 4 | Lenguaje visual | Guía al jugador sin texto |
| 5 | Narrativa ambiental | El espacio cuenta la historia (Clase 168) |
| 6 | Documentación | Comunica y ancla la visión (Clase 170) |
| 7 | Greybox jugable | Valida el diseño antes del arte (Clase 167) |
| 8 | Playtest y DoD | Cierra con evidencia objetiva |

## 📖 Definiciones y características

- **Objetivo de diseño**: qué debe lograr o sentir el jugador en el nivel. Clave: guía toda decisión posterior.
- **Pilar de diseño**: principio rector al que el nivel rinde cuentas. Clave: filtro para incluir o descartar.
- **Core loop del nivel**: actividad central que el jugador repite (explorar → resolver → avanzar). Clave: define la experiencia minuto a minuto.
- **Pacing**: distribución de intensidad a lo largo del recorrido. Clave: evita fatiga y monotonía.
- **Lenguaje visual**: sistema de señales (luz, color, forma) que comunica función. Clave: legibilidad sin tutoriales.
- **Narrativa ambiental**: historia contada por el entorno. Clave: narra sin frenar el juego (Clase 168).
- **Blockout jugable**: greybox recorrible de principio a fin. Clave: prueba el diseño, no la estética.
- **Definition of Done**: lista objetiva que declara el capstone terminado. Clave: elimina la ambigüedad.

## 🧰 Herramientas y preparación

Usarás **Godot 4.x** con **CSG** (`CSGBox3D`, `CSGCombiner3D`) o **GridMap** para el blockout, un `CharacterBody3D` (template de Godot) para recorrerlo, y `Marker3D`/luces para el lenguaje visual y los checkpoints. La documentación va en **Markdown** junto al proyecto, reutilizando la plantilla de one-pager de la Clase 170. Referencias: CSG (<https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html>), GridMap (<https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html>) y CharacterBody3D (<https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_3d.html>). Ten a la mano el one-pager, la matriz de sistemas y el blockout base de las clases previas.

## 🧪 Laboratorio guiado

Producirás el **diseño documentado + un blockout jugable** en Godot. Entregable: one-pager del nivel + proyecto Godot recorrible + nota de playtest.

**Paso 1 — One-pager del nivel.** Con la plantilla de la Clase 170, declara: objetivo, 3 pilares, core loop del nivel, y el gancho. Ejemplo de core loop: *"El jugador explora → encuentra una pista ambiental → resuelve un obstáculo espacial → avanza a la siguiente zona."*

**Paso 2 — Mapa de pacing.** Divide el nivel en 4-5 beats y etiqueta la intensidad de cada uno (respiro / tensión / clímax), asegurando alternancia:

| Beat | Zona | Intensidad | Propósito | Pista narrativa |
|------|------|-----------|-----------|-----------------|
| 1 | Entrada | Respiro | Enseñar el control | Puerta forzada |
| 2 | Pasillo | Tensión baja | Primer obstáculo | Marcas de arrastre |
| 3 | Sala central | Tensión alta | Prueba principal | Barricada rota |
| 4 | Cámara | Clímax | Reto integrador | Diario abierto |
| 5 | Salida | Respiro | Recompensa y cierre | Radio encendida |

**Paso 3 — Blockout con CSG.** Construye la geometría gris de los beats con colisión activa.

```gdscript
# nivel_blockout.gd — genera el esqueleto gris del recorrido.
extends Node3D

const BEATS := [
    {"nombre": "entrada",  "pos": Vector3(0, 0, 0),  "size": Vector3(8, 0.5, 8)},
    {"nombre": "pasillo",  "pos": Vector3(0, 0, 10), "size": Vector3(3, 0.5, 8)},
    {"nombre": "sala",     "pos": Vector3(0, 0, 20), "size": Vector3(10, 0.5, 10)},
    {"nombre": "camara",   "pos": Vector3(0, 0, 32), "size": Vector3(6, 0.5, 6)},
    {"nombre": "salida",   "pos": Vector3(0, 0, 40), "size": Vector3(8, 0.5, 8)},
]

func _ready() -> void:
    for b in BEATS:
        var caja := CSGBox3D.new()
        caja.name = b["nombre"]
        caja.size = b["size"]
        caja.position = b["pos"]
        caja.use_collision = true          # imprescindible para caminarlo
        add_child(caja)
```

**Paso 4 — Lenguaje visual y checkpoints.** Coloca luces que guíen la mirada hacia el objetivo de cada beat y marcadores de prueba para playtestear.

```gdscript
# guiado_y_checkpoints.gd — ilumina lo importante y marca puntos de test.
extends Node3D

@export var focos: Array[Vector3] = [
    Vector3(0, 4, 20),   # ilumina la prueba principal (sala)
    Vector3(0, 4, 40),   # ilumina la recompensa (salida)
]
@export var checkpoints: Array[Vector3] = [
    Vector3(0, 1, 0), Vector3(0, 1, 20), Vector3(0, 1, 40),
]

func _ready() -> void:
    for p in focos:
        var luz := OmniLight3D.new()       # la luz es el narrador: dirige el ojo
        luz.position = p
        luz.omni_range = 12.0
        add_child(luz)
    for i in checkpoints.size():
        var m := Marker3D.new()
        m.name = "Checkpoint_%d" % i
        m.position = checkpoints[i]
        add_child(m)
        print("Checkpoint %d en %s" % [i, checkpoints[i]])
```

**Paso 5 — Playtest e iteración.** Recorre el nivel con el `CharacterBody3D`. Cronometra, anota dónde dudó o se perdió el jugador, si captó la narrativa ambiental y si el pacing se sintió. Aplica una iteración documentada.

## ✍️ Ejercicios

1. Escribe el objetivo de diseño del nivel en una frase medible.
2. Justifica cada uno de tus 3 pilares con una decisión concreta del nivel.
3. Ajusta el mapa de pacing para que no haya dos beats de tensión seguidos.
4. Añade una sightline que anticipe el clímax desde la entrada.
5. Integra dos pistas de narrativa ambiental coherentes entre sí.
6. Sustituye una sección CSG por GridMap y compara el flujo de trabajo.

## 📝 Reto verificable

Entrega el **nivel completo**: one-pager (objetivo, pilares, core loop), mapa de pacing con narrativa ambiental por beat, un **blockout jugable en Godot** recorrible de principio a fin con lenguaje visual (luces que guían) y checkpoints, y una **nota de playtest** con una iteración aplicada.

**Definition of Done**:

- El one-pager declara objetivo, 3 pilares y el core loop del nivel.
- El mapa de pacing cubre 4-5 beats con intensidad alternada y pista narrativa por beat.
- El blockout se recorre entero con `CharacterBody3D`, con colisión en toda la geometría.
- Cada beat clave está iluminado para guiar al jugador hacia su objetivo.
- Existe al menos un checkpoint/marcador por sección para playtestear.
- La nota de playtest documenta una observación real y la iteración que provocó.

**Criterio de aceptación**: se cumplen los seis puntos de la Definition of Done, verificados recorriendo el blockout de inicio a fin y contrastándolo con el one-pager y el mapa de pacing; la iteración documentada debe derivar de una observación concreta del playtest.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El blockout no cuadra con el one-pager | Diseñaste sin objetivo; deriva cada zona del propósito declarado |
| El jugador se pierde | Falta lenguaje visual; ilumina y compón hacia el objetivo |
| Dos beats de tensión seguidos | Pacing plano; intercala un respiro entre pruebas |
| No se puede caminar el nivel | Falta `use_collision`/colisión en la geometría |
| La narrativa ambiental no se lee | Pistas ambiguas o mal ubicadas; refuérzalas con guiado |
| Se pule arte antes de validar | Greybox contaminado; valida jugabilidad en gris primero |

## ❓ Preguntas frecuentes

**¿Debe estar "bonito" el blockout?** No. Debe ser legible y jugable. El arte llega después; aquí validas diseño, pacing y guiado en gris.

**¿Cuánto debe durar el nivel?** Lo que exija cumplir su objetivo; para un capstone, 2-5 minutos de recorrido bastan para demostrar core loop, pacing y narrativa.

**¿CSG o GridMap para el capstone?** El que te haga iterar más rápido. CSG para formas libres, GridMap para módulos repetidos; puedes combinarlos.

**¿Qué pasa si el playtest revela que el diseño falla?** Es exactamente para eso: itera. Un capstone honesto muestra el problema detectado y el cambio que lo resolvió.

## 🔗 Referencias

- Godot Docs — CSG tools: <https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html>
- Godot Docs — Using GridMaps: <https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html>
- Godot Docs — CharacterBody3D: <https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_3d.html>
- Level Design Book — Process: <https://book.leveldesignbook.com/process>

## ➡️ Siguiente clase

¡Has completado la Parte 8! Continúa con [Clase 172 - Fundamentos de arte para desarrolladores](../../parte-9-arte-animacion-y-pipeline-de-assets/172-fundamentos-de-arte-para-desarrolladores/README.md), donde empezarás a vestir de arte los espacios que has aprendido a diseñar.
