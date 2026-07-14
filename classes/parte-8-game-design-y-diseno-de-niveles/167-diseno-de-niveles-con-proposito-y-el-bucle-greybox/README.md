# Clase 167 — Diseño de niveles con propósito y el bucle greybox

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Síntesis original a partir de literatura de level design (blockout/greybox) y documentación de Godot 4 (CSG, GridMap)*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un nivel no es un decorado: es una secuencia de espacios que **enseñan, prueban o recompensan** una habilidad del jugador. En esta clase aprenderás a diseñar con intención partiendo de un **objetivo de diseño** explícito y a validarlo con el **bucle greybox → playtest → iterar**, la práctica que separa un nivel que "se ve bonito" de uno que "se juega bien".

Construirás un blockout jugable en Godot usando geometría primitiva (CSG o GridMap), lo probarás contra tu objetivo y lo iterarás una vez. La meta es interiorizar que la forma se decide antes que el arte, y que cada metro cuadrado del nivel debe justificar su existencia.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Formular un **objetivo de diseño** medible para un nivel y derivar de él sus espacios.
- Explicar el propósito de cada zona (enseñar, probar, recompensar, respirar).
- Ejecutar el bucle **greybox → playtest → iterar** de forma disciplinada.
- Construir un blockout jugable en Godot con **CSG** o **GridMap** sin depender de arte final.
- Instrumentar el greybox con puntos de prueba mediante un script de GDScript.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Objetivo de diseño | Es la vara con la que se mide todo lo demás |
| 2 | Propósito por espacio | Evita relleno; cada zona hace un trabajo |
| 3 | El bucle greybox | Iterar barato antes de gastar en arte |
| 4 | Guiado y legibilidad | El jugador debe saber a dónde ir sin texto |
| 5 | Ritmo y pacing espacial | Alternar tensión y respiro sostiene el interés |
| 6 | Herramientas de blockout | CSG vs GridMap: cuándo usar cada una |
| 7 | Playtest e iteración | Los datos, no la intuición, deciden el cambio |

## 📖 Definiciones y características

- **Objetivo de diseño**: frase única que declara qué debe lograr o sentir el jugador. Clave: si no cabe en una frase, el nivel no tiene foco.
- **Greybox / blockout**: maqueta del nivel con geometría gris sin texturas ni arte. Clave: mide jugabilidad, no estética.
- **Beat de nivel**: unidad mínima de experiencia (una prueba, un descubrimiento). Clave: se encadenan para formar el ritmo.
- **Guiado (leading)**: uso de luz, líneas, contraste y composición para dirigir la mirada. Clave: reduce la fricción sin tutoriales.
- **Sightline (línea de visión)**: lo que el jugador ve desde un punto dado. Clave: controla qué se anticipa y qué sorprende.
- **Pacing espacial**: distribución de esfuerzo y calma a lo largo del recorrido. Clave: evita fatiga y aburrimiento.
- **Loop de iteración**: ciclo probar-ajustar-reprobar. Clave: cada vuelta debe ser más barata que rehacer arte.
- **Métrica de bloqueo**: dimensiones estándar (altura de salto, ancho de pasillo) usadas en el blockout. Clave: garantiza que lo diseñado sea físicamente jugable.

## 🧰 Herramientas y preparación

Trabajarás en **Godot 4.x** con nodos **CSG** (`CSGBox3D`, `CSGCombiner3D`) para esculpir geometría rápida y booleana, o con **GridMap** cuando prefieras ensamblar por celdas modulares a partir de una `MeshLibrary`. Para movimiento de prueba basta un `CharacterBody3D` con el template de Godot. Antes de tocar el editor, ten a mano una hoja con tu objetivo de diseño y un croquis en papel. Referencias: CSG en Godot (<https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html>) y GridMap (<https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html>).

## 🧪 Laboratorio guiado

Greyboxearás un nivel pequeño partiendo de un objetivo y lo iterarás una vez. Entregable: proyecto Godot con el blockout jugable y una nota de iteración.

**Paso 0 — Objetivo de diseño.** Escríbelo antes de abrir Godot. Ejemplo: *"Enseñar al jugador a usar el salto para cruzar huecos, en menos de 90 s, sin texto."*

**Paso 1 — Croquis y métricas.** En papel, divide el recorrido en 3 beats: (1) enseñar salto sobre hueco pequeño, (2) probar salto sobre hueco ancho con caída visible, (3) recompensa (coleccionable). Fija métricas: pasillo 3 m, salto máximo 3.5 m.

**Paso 2 — Blockout con CSG.** Crea la geometría gris del recorrido.

```gdscript
# Ejecutable desde un script de editor o _ready para prototipar suelos y huecos.
extends Node3D

func _ready() -> void:
    _crear_plataforma(Vector3(0, 0, 0), Vector3(6, 0.5, 6))     # inicio
    _crear_plataforma(Vector3(0, 0, 8), Vector3(6, 0.5, 4))     # tras hueco pequeño
    _crear_plataforma(Vector3(0, 0, 16), Vector3(6, 0.5, 6))    # tras hueco ancho

func _crear_plataforma(pos: Vector3, medida: Vector3) -> void:
    var caja := CSGBox3D.new()
    caja.size = medida
    caja.position = pos
    caja.use_collision = true   # imprescindible para caminar sobre el blockout
    add_child(caja)
```

**Paso 3 — Puntos de prueba.** Instrumenta el nivel con marcadores de spawn/checkpoint para playtestear rápido.

```gdscript
# spawn_puntos_prueba.gd — coloca marcadores visibles de test en el blockout.
extends Node3D

@export var puntos: Array[Vector3] = [
    Vector3(0, 1, 0),    # inicio
    Vector3(0, 1, 8),    # tras beat 1
    Vector3(0, 1, 16),   # meta / recompensa
]

func _ready() -> void:
    for i in puntos.size():
        var m := Marker3D.new()
        m.position = puntos[i]
        m.name = "Prueba_%d" % i
        add_child(m)
        var vista := CSGCylinder3D.new()   # baliza gris para ubicarlos a ojo
        vista.radius = 0.3
        vista.height = 2.0
        vista.position = puntos[i]
        add_child(vista)
        print("Punto de prueba %d en %s" % [i, puntos[i]])
```

**Paso 4 — Playtest.** Camina el nivel (o pide a un compañero). Cronometra, anota dónde dudó el jugador, dónde cayó, si entendió el salto sin ayuda.

**Paso 5 — Iterar una vez.** Aplica UN cambio basado en la observación (p. ej. estrechar el hueco ancho, o añadir una sightline al coleccionable) y vuelve a probar. Documenta el antes/después en una nota.

## ✍️ Ejercicios

1. Reescribe tu objetivo de diseño para que sea medible en tiempo o en acciones.
2. Etiqueta cada zona de tu croquis con su propósito: enseñar, probar, recompensar o respirar.
3. Añade una sightline que anticipe la recompensa desde el inicio del nivel.
4. Convierte una sección del blockout de CSG a GridMap con una `MeshLibrary` mínima.
5. Cambia el ancho de un hueco y predice el efecto antes de probar; contrasta con el resultado.
6. Diseña un "beat de respiro" (zona segura sin desafío) e integra su razón de ser.

## 📝 Reto verificable

Entrega un **blockout jugable de 3 beats** en Godot que cumpla un objetivo de diseño escrito, con puntos de prueba instrumentados y una nota de iteración que documente un cambio antes/después basado en un playtest real.

**Criterio de aceptación**: el nivel se camina de principio a fin con `CharacterBody3D`, cada uno de los 3 beats tiene un propósito declarado, existe al menos un marcador de prueba por beat, y la nota describe una observación de playtest y el cambio concreto que provocó.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El jugador no sabe a dónde ir | Falta guiado; añade luz, contraste o una sightline hacia el objetivo |
| El blockout ya tiene texturas y arte | Estás puliendo antes de validar; quítalo y mide solo jugabilidad |
| No se puede caminar sobre las CSG | Falta `use_collision = true` en las cajas |
| El nivel se siente plano o monótono | No hay pacing; alterna tensión (prueba) y respiro (zona segura) |
| Se rehace todo tras cada test | Iteración cara; cambia una sola variable por vuelta |
| El salto "no llega" en el juego | Métricas mal fijadas; ajusta distancias a la altura real de salto |

## ❓ Preguntas frecuentes

**¿CSG o GridMap para greybox?** CSG es ideal para formas orgánicas y ajustes rápidos con booleanas; GridMap brilla cuando el nivel es modular por celdas y quieres reutilizar piezas. Puedes mezclarlos.

**¿Cuántas iteraciones necesita un blockout?** Tantas como haga falta hasta que el objetivo se cumpla en playtest, pero cada vuelta debe ser barata: por eso no metes arte todavía.

**¿Puedo saltarme el greybox si tengo prisa?** Es justo cuando más lo necesitas: iterar en gris cuesta minutos; iterar sobre arte final cuesta días.

**¿Debo diseñar en papel antes de Godot?** Sí. Un croquis fuerza a decidir el propósito de cada espacio antes de invertir tiempo en el editor.

## 🔗 Referencias

- Godot Docs — CSG tools: <https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html>
- Godot Docs — Using GridMaps: <https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html>
- Godot Docs — CharacterBody3D (movimiento de prueba): <https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_3d.html>
- Level Design Book — Blockout: <https://book.leveldesignbook.com/process/blockout>

## ➡️ Siguiente clase

Continúa con [Clase 168 - Narrativa y storytelling en juegos](../168-narrativa-y-storytelling-en-juegos/README.md), donde harás que el propio nivel cuente una historia sin cinemáticas.
