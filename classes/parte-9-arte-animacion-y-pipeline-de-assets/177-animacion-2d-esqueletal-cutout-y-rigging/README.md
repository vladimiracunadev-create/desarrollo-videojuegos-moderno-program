# Clase 177 — Animación 2D esqueletal (cutout) y rigging

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Godot (Skeleton2D, Bone2D); docs de Spine/DragonBones*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Animar frame a frame es potente pero costoso: cada cuadro se dibuja a mano. La **animación esqueletal (cutout)** ofrece otra vía: se recorta el personaje en piezas, se le monta un **esqueleto de huesos** y se anima moviendo esos huesos, reutilizando los mismos dibujos. Es el estándar en muchos juegos 2D con personajes de movimiento fluido y ligero en memoria.

Al terminar habrás **riggeado** un personaje recortado con **Skeleton2D/Bone2D en Godot** (o Spine, si lo prefieres) y animado un movimiento simple, entendiendo huesos, IK y mesh deform, y cuándo conviene cutout frente a frame-by-frame.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Contrastar animación cutout/esqueletal con frame-by-frame y elegir según el caso.

2. Preparar un personaje recortado en piezas listas para riggear.

3. Montar una jerarquía de huesos (Skeleton2D / Bone2D) en Godot.

4. Vincular piezas a huesos y animar un movimiento simple con keyframes.

5. Explicar qué aportan la cinemática inversa (IK) y el mesh deform.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Cutout vs frame-by-frame | Define costo, peso y estilo de la animación. |
| 2 | Preparar piezas recortadas | Sin piezas separadas no hay rig posible. |
| 3 | Jerarquía de huesos | Determina cómo se propaga el movimiento. |
| 4 | Skinning / vinculación | Une los dibujos al esqueleto. |
| 5 | Keyframes y curvas | Base de la animación por huesos. |
| 6 | Cinemática inversa (IK) | Facilita posar extremidades de forma natural. |
| 7 | Mesh deform | Permite doblar piezas sin verse rígidas. |
| 8 | Ventajas y límites | Saber cuándo cutout es la elección correcta. |

## 📖 Definiciones y características

- **Animación cutout/esqueletal**: mover piezas recortadas mediante un esqueleto. Clave: reutiliza dibujos, ahorra memoria y tiempo.

- **Hueso (Bone2D)**: elemento del esqueleto con posición, rotación y longitud. Clave: al rotarlo arrastra las piezas vinculadas.

- **Skeleton2D**: nodo de Godot que contiene la jerarquía de Bone2D. Clave: coordina la deformación de todo el rig.

- **Jerarquía**: relación padre-hijo entre huesos. Clave: mover el hueso padre (torso) mueve a los hijos (brazos).

- **Skinning / vinculación**: asignar cada pieza (o sus vértices) a uno o varios huesos. Clave: define qué se mueve con cada hueso.

- **Cinemática inversa (IK)**: calcular la rotación de los huesos a partir de la posición final deseada. Clave: posar una mano y que el brazo se acomode solo.

- **Mesh deform**: deformar una malla de la pieza según los huesos. Clave: logra flexiones suaves en vez de rotaciones rígidas.

- **Keyframe**: instante con valores guardados (rotación, posición). Clave: el motor interpola entre keyframes para animar.

## 🧰 Herramientas y preparación

Haremos el laboratorio en **Godot 4** con **Skeleton2D** y **Bone2D**, integrados y gratuitos (<https://godotengine.org/>); su documentación de cutout está en <https://docs.godotengine.org/en/stable/tutorials/animation/cutout_animation.html>. Como alternativa profesional dedicada existe **Spine** (<https://esotericsoftware.com/>, de pago) y **DragonBones** (libre). Prepara un personaje recortado en piezas (torso, cabeza, dos brazos, dos piernas) como PNG con transparencia; puedes reutilizar un asset de la clase 175.

En Godot, ten a mano el panel **Scene**, el editor de **AnimationPlayer** y el modo de edición de huesos que aparece al seleccionar un Skeleton2D. Importa las piezas a una carpeta `personaje/`.

## 🧪 Laboratorio guiado

Riggearemos un personaje recortado en Godot y animaremos un saludo.

1. Crea una escena nueva con raíz **Node2D** llamada `Personaje`. Importa las piezas PNG a `res://personaje/`.

2. Añade cada pieza como **Sprite2D** hijo, montando la jerarquía visual: `Torso` como base, y como hijos `Cabeza`, `BrazoIzq`, `BrazoDer`, `PiernaIzq`, `PiernaDer`. Coloca cada sprite en su posición anatómica.

3. Ajusta el **punto de pivote** de cada pieza: mueve el **Offset** del Sprite2D para que rote desde la articulación (el brazo debe girar desde el hombro, no desde su centro).

4. Añade un nodo **Skeleton2D** y, dentro, crea la cadena de **Bone2D**: un hueso raíz en la cadera, un hueso torso como hijo, y huesos para cada extremidad y la cabeza siguiendo la anatomía. Usa el editor de huesos para fijar longitud y posición.

5. **Vincula** cada Sprite2D a su hueso: en el Sprite2D, asigna la propiedad de deformación/skeleton apropiada para que siga al hueso correspondiente. Comprueba moviendo un hueso: la pieza debe acompañarlo.

6. Añade un **AnimationPlayer**. Crea una animación `saludar`. En el frame 0, inserta keyframes de la rotación de todos los huesos en su pose de reposo.

7. Avanza el tiempo (p. ej. 0.5 s), rota el hueso del `BrazoDer` hacia arriba e inserta keyframe; a 1.0 s vuélvelo a bajar. Añade un leve balanceo del antebrazo para dar naturalidad. Reproduce y ajusta las curvas.

8. (Opcional) Activa un **skin/mesh deform** en una pieza para que doble suavemente, y experimenta con un nodo **SkeletonModification2DTwoBoneIK** para posar el brazo con **IK**. Guarda la escena; ya tienes un personaje riggeado y animado.

**Entregable visual**: un GIF o grabación del personaje recortado saludando mediante huesos, más la escena de Godot con el Skeleton2D, los Bone2D y la animación en el AnimationPlayer.

## ✍️ Ejercicios

1. Añade una animación `idle` con un balanceo sutil del torso y la cabeza.

2. Configura IK en una pierna y anima un paso apoyando el pie en el suelo.

3. Aplica mesh deform a la capa/cabello para que se doble en vez de rotar rígido.

4. Crea una segunda animación (`agacharse`) y transiciona entre ambas.

5. Reordena la jerarquía moviendo un brazo a otro padre y observa el efecto.

6. Compara el peso en disco de tu rig cutout frente a un spritesheet frame-by-frame equivalente.

## 📝 Reto verificable

Riggea un personaje recortado en Godot con un Skeleton2D que tenga al menos 6 Bone2D en jerarquía correcta, vincula todas las piezas y crea una animación de al menos 2 segundos (un saludo, un idle o un paso) reproducible en bucle desde el AnimationPlayer.

**Criterio de aceptación**: al mover el hueso raíz se arrastra todo el cuerpo por la jerarquía, cada extremidad rota desde su articulación (pivote correcto), la animación se reproduce fluida sin piezas que se despeguen del esqueleto, y el rig reutiliza los dibujos originales sin redibujar cuadros.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El brazo rota desde el centro, no del hombro | Pivote/Offset mal ubicado. Mueve el offset del Sprite2D a la articulación. |
| Al mover un hueso la pieza no lo sigue | Pieza sin vincular al hueso. Revisa el skinning/asignación de skeleton. |
| Mover el torso no mueve los brazos | Jerarquía plana. Anida los huesos hijos bajo el hueso padre. |
| La animación salta al hacer loop | Pose final distinta de la inicial. Iguala keyframes de inicio y fin. |
| La extremidad se dobla rígida | Falta mesh deform. Usa una malla con pesos o más huesos intermedios. |

## ❓ Preguntas frecuentes

**❓ ¿Cutout siempre es mejor que frame-by-frame?** No. Cutout ahorra memoria y permite reutilizar poses, pero frame-by-frame ofrece más expresividad artística; se eligen según estilo y presupuesto.

**❓ ¿Necesito Spine si Godot ya trae Skeleton2D?** No para empezar. Spine y DragonBones añaden herramientas profesionales (mesh, IK avanzada), pero Godot cubre lo esencial gratis.

**❓ ¿Qué es exactamente la IK?** Es calcular las rotaciones de una cadena de huesos a partir de dónde quieres que quede el extremo (la mano o el pie), en vez de rotar hueso por hueso.

**❓ ¿Puedo mezclar cutout con algún frame dibujado?** Sí; es común usar cutout para el grueso y frames pintados para gestos concretos como parpadeos o efectos.

## 🔗 Referencias

- Godot Docs — Cutout animation: <https://docs.godotengine.org/en/stable/tutorials/animation/cutout_animation.html>

- Godot Docs — Skeleton2D e IK: <https://docs.godotengine.org/en/stable/tutorials/animation/2d_skeletons.html>

- Spine — Documentación oficial: <https://esotericsoftware.com/spine-user-guide>

- DragonBones (alternativa libre): <https://github.com/DragonBones>

## ➡️ Siguiente clase

[Clase 178 - Modelado 3D: fundamentos con Blender](../178-modelado-3d-fundamentos-con-blender/README.md)
