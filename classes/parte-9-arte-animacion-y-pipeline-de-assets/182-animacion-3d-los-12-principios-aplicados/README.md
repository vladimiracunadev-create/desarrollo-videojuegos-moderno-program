# Clase 182 — Animación 3D: los 12 principios aplicados

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Richard Williams, The Animator's Survival Kit; Documentación de Blender 4 (Animation)*
> ⏱️ Duración estimada: **95 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Los **12 principios de animación** que definieron Disney (Johnston y Thomas) y sistematizó Richard Williams no son solo para dibujo tradicional: son la diferencia entre una animación 3D rígida y una que respira. En esta clase los llevas al espacio 3D de Blender —**squash & stretch, anticipación, follow-through & overlapping, arcos, timing & spacing, ease in/ease out**, entre otros— y aprendes a leerlos y ajustarlos con las herramientas reales del programa.

El vehículo será un **ciclo** (un walk cycle o un idle), que obliga a pensar en poses clave, interpolación y repetición perfecta. Manejarás el **Dope Sheet** para colocar y desplazar keyframes, el **Graph Editor** para pulir las curvas (donde viven el timing y los arcos), y cerrarás exportando el ciclo animado a **glTF** para reproducirlo en un motor.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Identificar los 12 principios y reconocerlos en una animación 3D.
2. Crear keyframes de poses clave y gestionar su timing en el Dope Sheet.
3. Editar la interpolación con el Graph Editor para lograr arcos y ease in/out.
4. Construir un ciclo (walk o idle) que repita sin saltos.
5. Exportar la animación a glTF y reproducirla en un motor.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Los 12 principios en 3D | Marco que separa lo vivo de lo mecánico. |
| 2 | Poses clave vs breakdowns | Estructuran la animación antes de pulir. |
| 3 | Timing y spacing | Definen peso y velocidad percibidos. |
| 4 | Arcos | El movimiento natural casi nunca es recto. |
| 5 | Anticipación y follow-through | Preparan y rematan cada acción. |
| 6 | Ease in / ease out | Aceleraciones creíbles, no lineales. |
| 7 | Ciclos (loop) | Reutilizables y esenciales en juegos. |
| 8 | Dope Sheet y Graph Editor | Las dos ventanas donde vive el detalle. |

## 📖 Definiciones y características

- **Keyframe**: fotograma que fija el valor de una propiedad (posición, rotación) en un instante. Clave: la animación interpola entre ellos.
- **Squash & stretch**: deformación que sugiere peso y elasticidad conservando volumen. Clave: exagerar sin "perder masa".
- **Anticipación**: pequeño movimiento contrario antes de la acción principal. Clave: prepara al ojo para lo que viene.
- **Follow-through & overlapping**: partes que siguen moviéndose tras parar el cuerpo y a distinto ritmo. Clave: da inercia y organicidad.
- **Arco**: trayectoria curva del movimiento. Clave: casi todo lo vivo se mueve en arcos, no en líneas rectas.
- **Timing & spacing**: número de fotogramas y separación entre poses. Clave: mismo recorrido, distinta sensación de peso y energía.
- **Ease in / ease out**: aceleración y desaceleración graduales. Clave: se controlan con las manijas de las curvas en el Graph Editor.
- **Ciclo (loop)**: secuencia cuyo último frame enlaza con el primero. Clave: en juegos, caminar e idle son ciclos que se repiten indefinidamente.

## 🧰 Herramientas y preparación

Trabajaremos en **Blender 4.x** (<https://www.blender.org/download/>) con el personaje riggeado de la clase 181; si no lo tienes, usa **Rigify** o un rig sencillo propio. Cambia el layout a la pestaña **Animation**, que muestra el viewport junto al **Dope Sheet**; añadirás un **Graph Editor** en un área para pulir curvas.

Configura la escena a **24 fps** (**Output Properties → Frame Rate**), el estándar de animación, y activa **Auto Keying** solo cuando lo domines (al principio conviene poner keys a mano con `I`). Como referencia conceptual, *The Animator's Survival Kit* de Richard Williams es la biblia del walk cycle. Documentación: animación en Blender (<https://docs.blender.org/manual/en/latest/animation/index.html>) y el Graph Editor (<https://docs.blender.org/manual/en/latest/editors/graph_editor/index.html>).

Ten claro el método de trabajo profesional: primero las **poses clave** (los momentos que cuentan la acción), luego los **breakdowns** (poses intermedias que definen el arco y el peso) y por último el pulido de **curvas** en el Graph Editor. Animar así, "de lo importante a lo fino", evita perderse en detalles antes de que la acción principal funcione.

## 🧪 Laboratorio guiado

Vamos a animar un **ciclo de caminar** aplicando timing, arcos y follow-through, y a exportarlo a glTF.

1. Prepara la escena. Personaje en Rest Position, escena a 24 fps y rango de frames `1`–`24` (un ciclo de un segundo). En el layout **Animation**, selecciona el armature y entra en **Pose Mode**.

2. Coloca las **poses clave (contactos)**. En el frame 1, posa el **contacto** (pierna delante talón abajo, la de atrás en punta, brazos opuestos). Selecciona todos los huesos (`A`) e inserta key con `I` → **Location & Rotation**. En el frame 13, la pose de contacto **espejada** (el otro pie delante).

> 💡 **Aprovecha la simetría**: para la pose del frame 13, copia la del frame 1 con **Copy Pose** y pégala reflejada con **Paste X-Flipped Pose**. Si nombraste bien los huesos con `.L`/`.R` en la clase 181, Blender invierte izquierda y derecha automáticamente y te ahorra rehacer la pose entera.

3. Añade los **breakdowns de peso**. En los frames intermedios (≈4 y ≈16) crea el **down** (el cuerpo baja, la rodilla de apoyo flexiona: squash sutil de peso) y en ≈8 y ≈20 el **up/passing** (el cuerpo se eleva, pierna libre pasa: stretch leve). Aplica **timing**: menos frames = paso enérgico, más = pesado.

4. Cierra el ciclo. Copia la pose del frame 1 al frame 25 (**Copy Pose / Paste Pose** desde la cabecera de Pose Mode) para que el loop enlace sin salto. Ajusta el rango final a `24` para que 25 sea el "primer frame del siguiente ciclo".

5. Trabaja los **arcos**. Abre el **Graph Editor**. Selecciona la curva de la mano o del pie y comprueba que su trayectoria describe una curva suave, no picos. Suaviza con manijas o **Key → Handle Type → Auto Clamped** para que el movimiento no sea entrecortado.

> 💡 **Visualiza los arcos**: activa **Motion Paths** (Object/Armature Properties) sobre el hueso de la mano o el pie para dibujar su trayectoria en el viewport. Verás literalmente si el recorrido es un arco limpio o una línea quebrada, que es el defecto más común del animador novato.

6. Aplica **ease in / ease out**. En el Graph Editor, en los extremos de cada acción (por ejemplo el brazo al llegar arriba), ajusta las manijas para que desacelere al final y acelere al salir. Evita curvas totalmente lineales salvo para movimientos mecánicos.

7. Añade **follow-through y overlapping**. Desfasa 1–2 frames las claves de elementos secundarios (manos respecto a antebrazos, cabeza respecto al torso) para que "arrastren". En el Dope Sheet, selecciona esos keys y deslízalos con `G`.

8. Verifica la repetición. En el Timeline activa la reproducción en loop y observa el ciclo varias vueltas. Corrige cualquier "tirón" en el punto de enlace y comprueba que los pies no patinan (deslizamiento).

> 💡 **El patinaje mata el walk cycle**: durante la fase de apoyo, el pie plantado no debe moverse ni un píxel en el suelo. Si patina, o el pie no está bloqueado, o el timing entre contacto y despegue no cuadra. Un IK con el objetivo del pie fijo resuelve el 90 % de los casos.

9. Registra la acción. En el **Dope Sheet → Action Editor**, nombra la acción `caminar` y pulsa el icono de escudo (**Fake User**) para que Blender no la borre al no tener usuarios.

10. Exporta a glTF. **File → Export → glTF 2.0**, en **Animation** marca **Animations** y, si usas varias, **Export all Actions** o el NLA. Guarda `personaje_caminar.glb` y ábrelo en un visor glTF o en Godot para ver el ciclo reproducirse.

**Entregable**: `personaje_caminar.glb` (o un idle) con un ciclo que enlaza sin saltos, arcos suaves, ease in/out y algo de follow-through, reproduciéndose en loop en un motor o visor.

Para autoevaluarte, reproduce el ciclo a la mitad de velocidad: los defectos de spacing y los tirones se hacen evidentes en cámara lenta. Un ciclo que aguanta bien la cámara lenta se verá impecable a velocidad normal en el juego.

Compara además tu ciclo con referencia real: graba a alguien caminando o busca un walk cycle de referencia y observa cómo la cadera sube y baja, cómo los brazos oscilan opuestos a las piernas y cómo la cabeza se mantiene relativamente estable. La observación es la mejor herramienta del animador.

> 💡 **El editor de curvas es tu aliado**: gran parte del "sabor" de una animación no está en las poses, sino en cómo el Graph Editor interpola entre ellas. Dedica tanto tiempo a pulir curvas como a colocar keyframes; ahí es donde nacen el peso, la fluidez y la personalidad del movimiento.

## ✍️ Ejercicios

1. Duplica la acción y **acorta el timing** a 16 frames; describe cómo cambia la sensación de peso.
2. Exagera el **squash & stretch** del cuerpo en el down/up y valora hasta dónde es creíble.
3. Añade **anticipación** a un idle: un pequeño hundimiento antes de que el personaje se yerga.
4. En el Graph Editor, convierte una curva a **lineal** y compárala con Auto Clamped en el mismo movimiento.
5. Desfasa la cabeza 2 frames respecto al torso y explica el efecto de **overlapping**.
6. Crea un segundo ciclo (**idle** de respiración) y encadénalo con el de caminar en el NLA Editor.

> 💡 **Menos es más al empezar**: un ciclo de caminar es de los ejercicios más difíciles de animación. Si te abruma, empieza por un **idle** de respiración de dos poses (pecho arriba, pecho abajo) con buen ease in/out. Dominar timing y arcos en algo simple te prepara para el walk cycle.

## 📝 Reto verificable

Anima un ciclo completo (walk o idle) de 24 frames a 24 fps que aplique de forma reconocible al menos cinco principios: timing, arcos, ease in/out, follow-through/overlapping y squash & stretch. Debe repetir sin salto y exportarse a glTF reproducible en un motor.

**Criterio de aceptación**: al reproducir en loop en Godot o en un visor glTF, el ciclo enlaza sin tirón en el punto de unión, los pies no patinan de forma evidente, las trayectorias de manos y pies describen arcos (no líneas rectas), y se aprecia desaceleración en los extremos de las acciones y arrastre de los elementos secundarios.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El ciclo "salta" al repetir | El último frame no coincide con el primero. Copia la pose inicial al frame de cierre. |
| Los pies patinan por el suelo | El contacto no está fijo en X/Z durante el apoyo. Bloquea el pie de apoyo o usa IK plantado. |
| El movimiento se ve robótico | Curvas lineales. Cambia a Auto Clamped y trabaja ease in/out en el Graph Editor. |
| Todo se mueve a la vez, sin vida | Falta follow-through/overlapping. Desfasa 1–2 frames los elementos secundarios. |
| La animación no se exporta a glTF | La acción no tenía Fake User o no marcaste Animations al exportar. Actívalos. |
| Las manos atraviesan el cuerpo | No revisaste arcos ni colisiones. Ajusta las trayectorias en el Graph Editor. |

## ❓ Preguntas frecuentes

**❓ ¿Los 12 principios aplican igual en 3D que en 2D?** Sí; cambian las herramientas (curvas y huesos en lugar de dibujos), pero la intención —peso, anticipación, arcos, timing— es idéntica y es lo que hace creíble el movimiento.

**❓ ¿Cuál es la diferencia entre timing y spacing?** El timing es cuántos frames dura una acción; el spacing es cómo se distribuye el movimiento entre esos frames. Mismo timing con distinto spacing produce aceleraciones muy distintas.

**❓ ¿Cuántos frames debe durar un walk cycle?** Un ciclo cómodo ronda 24 frames (1 s) a 24 fps para un paso normal; menos frames dan un caminar enérgico y más, uno pesado o cansado.

**❓ ¿Por qué se anima en ciclos para juegos?** Porque el personaje camina o espera durante tiempo indefinido; un ciclo que enlaza consigo mismo se reproduce en bucle sin costuras y ahorra memoria frente a animar cada segundo.

## 🔗 Referencias

- Blender Manual — Animation & Rigging: <https://docs.blender.org/manual/en/latest/animation/index.html>
- Blender Manual — Graph Editor: <https://docs.blender.org/manual/en/latest/editors/graph_editor/index.html>
- Blender Manual — Actions & NLA: <https://docs.blender.org/manual/en/latest/editors/nla/index.html>
- Richard Williams, *The Animator's Survival Kit* (referencia de walk cycles): <https://www.theanimatorssurvivalkit.com/>

## ➡️ Siguiente clase

[Clase 183 - Sculpting y retopología](../183-sculpting-y-retopologia/README.md)
