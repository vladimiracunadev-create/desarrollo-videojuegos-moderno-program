# Clase 181 — Rigging y skinning 3D

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 (Armatures / Skinning)*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un modelo estático no cobra vida hasta que le pones un **esqueleto**. En esta clase montas ese esqueleto (en Blender se llama **armature**), aprendes a organizar sus **huesos** en una jerarquía padre-hijo, y luego lo unes a la malla mediante **skinning**: el proceso que define qué vértices sigue cada hueso y con qué intensidad (**weight painting**). Sin este paso, animar sería imposible: no habría nada que mover salvo la posición del objeto entero.

También verás la diferencia entre **FK** (Forward Kinematics, donde rotas cada hueso de la cadena) e **IK** (Inverse Kinematics, donde mueves el extremo y la cadena se acomoda sola), fundamental para animar piernas y brazos con naturalidad. Al terminar habrás creado un armature simple para un personaje, pintado pesos básicos y probado una pose para verificar que la deformación es limpia, sin vértices que se queden atrás.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Crear un armature y construir una jerarquía de huesos coherente.
2. Emparentar (parent) la malla al armature con pesos automáticos.
3. Ajustar el skinning con weight painting para corregir deformaciones.
4. Diferenciar FK e IK y explicar cuándo conviene cada uno.
5. Probar poses en Pose Mode verificando una deformación limpia.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Armature y huesos | Es el esqueleto que moverá el modelo. |
| 2 | Jerarquía padre-hijo | Define cómo se propaga el movimiento. |
| 3 | Parenting malla-armature | Conecta la piel al esqueleto. |
| 4 | Weight painting | Controla qué vértices sigue cada hueso. |
| 5 | Vertex groups | Almacenan los pesos por hueso. |
| 6 | FK vs IK | Dos formas de posar cadenas de huesos. |
| 7 | Pose Mode | Donde se prueban y guardan las poses. |
| 8 | Deformación limpia | El objetivo: que la malla siga sin romperse. |

## 📖 Definiciones y características

- **Armature**: objeto especial que contiene el esqueleto. Clave: no se renderiza, solo deforma otras mallas.
- **Hueso (bone)**: elemento del armature con cabeza, cuerpo y cola. Clave: rota alrededor de su cabeza (pivote).
- **Jerarquía padre-hijo**: relación en la que el hueso hijo hereda el movimiento del padre. Clave: mover el fémur arrastra la tibia y el pie.
- **Skinning / parenting**: unir la malla al armature para que la deforme. Clave: `Ctrl+P` → **With Automatic Weights** genera pesos iniciales.
- **Weight painting**: pintar en la malla la influencia (0–1) de cada hueso. Clave: rojo = máxima influencia, azul = nula.
- **Vertex group**: grupo de vértices con sus pesos asociados a un hueso. Clave: cada hueso deformador tiene su propio grupo.
- **FK (Forward Kinematics)**: se rota cada hueso de la cadena manualmente. Clave: control preciso, ideal para brazos en el aire.
- **IK (Inverse Kinematics)**: se mueve el extremo y el resto se acomoda. Clave: natural para pies plantados y manos que agarran.

## 🧰 Herramientas y preparación

Seguimos en **Blender 4.x** (<https://www.blender.org/download/>). Necesitas una malla de personaje sencilla: puede ser un humanoide low-poly propio, un muñeco de bloques, o incluso puedes activar el add-on integrado **Add Mesh: Extra Objects** para partir de formas básicas. Asegúrate de que la malla esté con **escala aplicada** (`Ctrl+A` → Scale) y con el origen en los pies, mirando hacia `-Y`.

Trabajaremos con los tres modos del armature: **Edit Mode** (colocar huesos), **Pose Mode** (posar) y el **Weight Paint** de la malla. Ten a mano la documentación de armatures (<https://docs.blender.org/manual/en/latest/animation/armatures/index.html>) y de skinning (<https://docs.blender.org/manual/en/latest/animation/armatures/skinning/index.html>). Activa **X-Axis Mirror** en Edit Mode del armature para construir simétricamente.

Activa además **In Front** en las opciones de visualización del armature (Object Data Properties → Viewport Display) para ver los huesos a través de la malla mientras los colocas. Sin esta opción, los huesos quedan ocultos dentro del personaje y trabajar a ciegas hace muy difícil posicionarlos bien.

## 🧪 Laboratorio guiado

Vamos a riggear un personaje simple: armature, pesos automáticos, corrección y una pose de prueba. El objetivo no es un rig de producción de cine, sino uno funcional que deforme limpiamente y sirva para animar en la clase siguiente.

1. Coloca al personaje en pose T o A (brazos algo abiertos), en el origen y mirando a `-Y`. Sitúa el cursor 3D en los pies con `Shift+C`.

2. Añade el armature. `Shift+A` → **Armature**. Aparece un solo hueso en el origen. Entra en **Edit Mode** (`Tab`) y activa **X-Axis Mirror** en las opciones de la herramienta para trabajar en simetría.

3. Construye la columna. Selecciona la cola del hueso y **extrude** (`E`) hacia arriba para crear cadera → torso → cuello → cabeza. Renombra cada hueso en el panel (Bone Properties) como `cadera`, `columna`, `cuello`, `cabeza`.

> 💡 **La cadera es la raíz**: en un bípedo, el hueso de la cadera (a veces llamado `root` o `pelvis`) es el padre de toda la jerarquía. Mover ese hueso desplaza al personaje entero; es el que usarás para el desplazamiento global y el que ancla columna y piernas.

4. Añade brazos y piernas. Desde el hueso del torso, extrude con `E` hacia el hombro, luego brazo, antebrazo y mano; repite hacia abajo para muslo, pierna y pie. Con X-Mirror activo, el lado opuesto se genera solo (sufijos `.L` / `.R`).

5. Revisa la jerarquía. En el **Outliner** confirma que la cadera es la raíz y que brazos y piernas cuelgan del torso y la cadera respectivamente. Un mal parentesco hará que las extremidades no acompañen el cuerpo.

6. Emparenta la malla al armature. En **Object Mode**, selecciona primero la malla, luego `Shift`+clic el armature (debe quedar activo) y `Ctrl+P` → **With Automatic Weights**. Blender reparte pesos iniciales.

> 💡 **El orden de selección importa**: al emparentar, el objeto que seleccionas **último** (el activo, con borde más claro) es el padre. Debe ser el armature. Si te equivocas y la malla queda de padre, el skinning no funcionará y tendrás que rehacer el parent.

7. Prueba una pose burda. Selecciona el armature, entra en **Pose Mode**, elige el hueso del brazo y rótalo con `R`. Observa cómo se dobla la manga. Aquí ya se ven los defectos de peso.

8. Corrige con weight painting. Con la malla seleccionada, pon el modo **Weight Paint**. Selecciona un hueso problemático (`Ctrl`+clic sobre él) y pinta: sube peso en rojo donde debe seguirlo, baja a azul donde no. Corrige, por ejemplo, el codo o la axila que se colapsan.

> 💡 **Lee el mapa de calor**: en Weight Paint, rojo = influencia total (1.0), azul = nula (0.0), y el arcoíris intermedio son los valores parciales. Un buen skinning tiene transiciones suaves de rojo a azul en las articulaciones, no saltos bruscos que producen pliegues feos.

9. Añade un IK simple a una pierna (opcional). En Pose Mode, selecciona el hueso de la pierna, **Bone Constraint Properties → Add → Inverse Kinematics**, define un hueso objetivo en el pie y limita la **Chain Length** a 2. Mueve el objetivo y comprueba que la pierna se dobla sola.

10. Guarda una pose de prueba. En Pose Mode, posa al personaje (un paso, saludo) y usa **Pose → Apply → Pose as Rest Pose** solo si quieres fijarla; para animar, mejor déjala como pose de test y vuelve a **Rest Position** desde Armature Properties.

**Entregable**: el `.blend` con el personaje riggeado, pesos corregidos en al menos una articulación y una pose de prueba que deforme la malla sin vértices sueltos ni colapsos evidentes.

Para autoevaluarte, exagera cada articulación al límite (flexiona el codo 120°, la rodilla al máximo) y observa dónde la malla se rompe primero: esas zonas son las que necesitan más trabajo de pesos o loops de soporte antes de animar en la clase 182.

Guarda el rig terminado como archivo aparte antes de animar; así, si una prueba de animación deforma algo raro, siempre puedes volver a un esqueleto y unos pesos que sabes que funcionan.

> 💡 **Rest pose limpia**: guarda tu personaje en una pose de reposo cómoda (T-pose o A-pose) antes de emparentar. Esa pose será la referencia a la que Blender vuelve con **Rest Position**, y una buena pose base facilita muchísimo el weight painting y la posterior animación.

## ✍️ Ejercicios

1. Renombra todos los huesos con la convención `.L` / `.R` y explica por qué el simétrico de weight/pose lo necesita.
2. Rota el hueso del hombro y localiza el peor problema de peso; corrígelo con weight paint.
3. Cambia la **Chain Length** del IK de la pierna a 1 y a 3; describe cómo afecta al plegado.
4. Usa **Normalize All** en los vertex groups y explica qué garantiza (suma de pesos = 1).
5. Añade un hueso de control (no deformador) para la cabeza y explica la diferencia con un hueso deformador.
6. Compara animar un brazo levantado con FK puro frente a IK; anota cuál te resultó más natural.

> 💡 **Convención de nombres**: usa siempre sufijos `.L` y `.R` (por ejemplo `brazo.L`, `pierna.R`). Blender aprovecha esa convención para reflejar poses y pesos automáticamente con **Copy Pose → Paste X-Flipped**, ahorrándote la mitad del trabajo de posado. Sin nombres correctos, esa magia no funciona.

## 📝 Reto verificable

Riggea tu personaje con un armature de al menos 12 huesos nombrados y simétricos, pesos que sigan al esqueleto de forma limpia y una pierna con IK funcional. Demuestra una pose donde el personaje flexione codo, rodilla y torso a la vez.

**Criterio de aceptación**: al rotar/mover los huesos en Pose Mode, la malla se deforma sin vértices que se queden atrás ni caras que se autointersequen groseramente en las articulaciones; el IK de la pierna dobla la rodilla al mover el objetivo del pie; y los huesos siguen la convención de nombres `.L`/`.R`.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "Bone Heat Weighting failed" al emparentar | Malla con geometría dupli­cada o non-manifold. Limpia con Merge by Distance y recalcula normales. |
| Un brazo arrastra vértices del torso | Pesos derramados a huesos vecinos. Reduce a azul esos vértices en Weight Paint. |
| La articulación colapsa al doblar | Falta de loops de soporte o pesos abruptos. Suaviza pesos y añade geometría en el codo/rodilla. |
| La malla se deforma "doble" o exagerada | Escala del armature/malla sin aplicar. `Ctrl+A` → Scale en ambos. |
| El IK gira hacia el lado equivocado | Falta un pole target o el plegado inicial. Añade pole target o pre-dobla la rodilla en Edit Mode. |
| Al posar, la malla no se mueve | La malla no está emparentada o le falta el modificador Armature. Reempareja con Automatic Weights. |

## ❓ Preguntas frecuentes

**❓ ¿Cuándo uso FK y cuándo IK?** FK para movimientos libres en el aire (saludar, gesticular) donde controlas cada rotación; IK cuando el extremo debe quedarse fijo o alcanzar algo (pies en el suelo, mano en un pomo).

**❓ ¿Qué hace exactamente "Automatic Weights"?** Calcula una influencia inicial de cada hueso sobre los vértices según su cercanía; es un buen punto de partida que casi siempre necesita retoques manuales.

**❓ ¿Por qué mis pesos deben sumar 1?** Para que la deformación sea estable: si un vértice tuviera influencias que sumen más o menos de 1, se estiraría o encogería de forma imprevista. **Normalize All** lo garantiza.

**❓ ¿El armature se exporta al motor?** Sí: glTF exporta la malla, el esqueleto y los pesos (skinning), de modo que el motor puede reproducir las animaciones que crees sobre ese rig.

## 🔗 Referencias

- Blender Manual — Armatures: <https://docs.blender.org/manual/en/latest/animation/armatures/index.html>
- Blender Manual — Skinning / Weight Paint: <https://docs.blender.org/manual/en/latest/animation/armatures/skinning/index.html>
- Blender Manual — Inverse Kinematics: <https://docs.blender.org/manual/en/latest/animation/armatures/posing/bone_constraints/inverse_kinematics/index.html>
- Blender Manual — Vertex Groups: <https://docs.blender.org/manual/en/latest/modeling/meshes/properties/vertex_groups/index.html>

## ➡️ Siguiente clase

[Clase 182 - Animación 3D: los 12 principios aplicados](../182-animacion-3d-los-12-principios-aplicados/README.md)
