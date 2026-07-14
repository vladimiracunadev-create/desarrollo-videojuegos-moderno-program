# Clase 178 — Modelado 3D: fundamentos con Blender

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 (Modeling / Modifiers)*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Dar el salto del 2D al 3D aprendiendo a manejar Blender como herramienta de modelado para juegos. Vas a entender la interfaz (viewport, editores, modos), a manipular una malla en el nivel de **vértices, aristas y caras**, y a usar las operaciones y modificadores que forman el 90 % del trabajo real: **extrude**, **loop cut**, **bevel**, **Mirror** y **Subdivision Surface**.

El foco no es hacer algo "bonito", sino algo **limpio y exportable**: una malla con buena topología, escala correcta y orientación adecuada que un motor pueda cargar sin sorpresas. Al terminar habrás modelado un prop de baja poligonización (un barril, una caja o un arma sencilla) y lo habrás exportado a **glTF**, el formato estándar para llevar modelos a Godot, Unity o el navegador.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Navegar el viewport de Blender y alternar entre Modo Objeto y Modo Edición con fluidez.
2. Editar una malla seleccionando y transformando vértices, aristas y caras.
3. Aplicar extrude, loop cut y bevel para construir volumen de forma controlada.
4. Usar los modificadores Mirror y Subdivision Surface de forma no destructiva.
5. Exportar un prop low-poly a glTF con escala, origen y normales correctos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Interfaz y viewport | Sin orientarte en la ventana no puedes trabajar rápido. |
| 2 | Modo Objeto vs Edición | Separan mover el objeto de editar su geometría. |
| 3 | Vértices, aristas y caras | Son los tres elementos con los que se construye todo. |
| 4 | Extrude y loop cut | Añaden volumen y resolución donde hacen falta. |
| 5 | Bevel | Suaviza cantos duros para que atrapen la luz. |
| 6 | Modificadores no destructivos | Permiten simetría y suavizado editables. |
| 7 | Topología limpia (quads) | Se deforma y subdivide mejor; evita artefactos. |
| 8 | Escala, origen y exportación | Determinan que el modelo llegue bien al motor. |

## 📖 Definiciones y características

- **Malla (mesh)**: geometría formada por vértices, aristas y caras. Clave: es el "cuerpo" de todo modelo 3D.
- **Vértice / arista / cara**: punto, línea entre dos puntos y superficie cerrada por aristas. Clave: seleccionables por separado con las teclas `1`, `2`, `3` en Modo Edición.
- **Modo Objeto vs Modo Edición**: uno mueve/rota/escala el objeto entero; el otro edita su geometría interna. Clave: se alternan con `Tab`.
- **Extrude (`E`)**: extiende caras o aristas creando nueva geometría conectada. Clave: la herramienta base para "estirar" volumen.
- **Loop Cut (`Ctrl+R`)**: inserta un anillo de aristas alrededor de la malla. Clave: añade resolución para doblar o detallar.
- **Bevel (`Ctrl+B`)**: divide un canto en varias caras para redondearlo. Clave: los cantos con bisel leen mucho mejor la iluminación.
- **Modificador Mirror**: refleja la malla sobre un eje sin duplicar trabajo. Clave: modelas la mitad y obtienes simetría perfecta.
- **Subdivision Surface**: suaviza la malla subdividiéndola de forma no destructiva. Clave: da acabado orgánico partiendo de pocos polígonos.
- **Topología**: cómo se distribuyen aristas y caras. Clave: se prefieren **quads** (caras de 4 lados) por su deformación predecible.

## 🧰 Herramientas y preparación

Necesitas **Blender 4.x**, gratuito y multiplataforma, desde <https://www.blender.org/download/>. Al abrirlo verás el cubo por defecto: es tu punto de partida. Configura las unidades en **Scene Properties → Units** para trabajar en metros (1 unidad = 1 metro), lo que evita problemas de escala al exportar. Activa **Statistics** en el overlay del viewport para vigilar el conteo de vértices y caras.

Ten a mano la documentación oficial de modelado (<https://docs.blender.org/manual/en/latest/modeling/index.html>) y la de modificadores (<https://docs.blender.org/manual/en/latest/modeling/modifiers/index.html>). Recomendado: un ratón de tres botones; el botón central orbita, `Shift`+central hace paneo y la rueda hace zoom.

Memoriza cinco atajos que usarás sin parar: `Tab` (Objeto/Edición), `G`/`R`/`S` (mover, rotar, escalar), `E` (extrude), `Ctrl+R` (loop cut) y `Ctrl+B` (bevel). Con solo estos cinco resuelves la mayor parte del modelado low-poly de props. Activa también el panel lateral con `N` para vigilar dimensiones y transformaciones en todo momento.

## 🧪 Laboratorio guiado

Vamos a modelar un **barril low-poly** con buena topología y exportarlo a glTF. Trabajaremos de forma no destructiva siempre que se pueda, dejando los modificadores activos hasta el final para poder ajustar la resolución sin rehacer geometría.

1. Abre Blender y borra el cubo por defecto con `X` → **Delete**. Añade un cilindro con `Shift+A` → **Mesh → Cylinder**. En el panel emergente inferior izquierdo baja los **Vertices** a `12` (suficiente para un barril low-poly).

2. Escálalo a proporción de barril. En Modo Objeto pulsa `S`, luego `Z`, escribe `1.4` y `Enter` para estirarlo en vertical. Aplica la escala con `Ctrl+A` → **Scale** (fundamental para no arrastrar escalas raras al motor).

> 💡 **Por qué aplicar la escala**: si exportas con una escala distinta de 1.0, muchos motores la interpretan de forma inconsistente y el prop llega deformado o de tamaño incorrecto. Aplicarla "hornea" la escala en la geometría y deja el objeto en 1.0 limpio.

3. Entra a **Modo Edición** con `Tab`. Pulsa `3` para modo Cara. Inserta dos anillos horizontales con `Ctrl+R`, mueve el ratón hasta ver un corte horizontal, haz clic, escribe `2` para dos cortes y confirma con clic derecho para dejarlos centrados.

4. Da forma de "panza" al barril. Selecciona el anillo central de caras (`Alt+clic` sobre una arista horizontal para seleccionar el loop), pulsa `S` y escala ligeramente hacia afuera (`1.08`). Repite suave en los anillos intermedios para la curva típica.

5. Bisela los bordes superior e inferior. Selecciona los dos loops de aristas de las tapas (`Alt+clic`), pulsa `Ctrl+B`, arrastra poco y usa la rueda para `2` segmentos. Un bisel leve hace que los cantos capturen luz sin inflar polígonos.

6. Revisa la topología: activa **Statistics** y confirma que dominan los quads. Usa **Select → Select All by Trait → Faces by Sides → 4** para verificar que no quedaron n-gons problemáticos en las tapas.

7. Comprueba las normales. En el overlay, activa **Face Orientation**: todo debe verse azul (hacia afuera). Si hay rojo, selecciona todo con `A` y `Shift+N` para recalcular normales hacia el exterior.

> 💡 **Buena práctica**: mantén el modo de selección coherente con lo que haces. Vértices (`1`) para mover puntos, aristas (`2`) para loops y bevels, caras (`3`) para extrusiones. Cambiar de modo con criterio evita selecciones accidentales que rompen la topología.

8. Vuelve a Modo Objeto (`Tab`). Coloca el origen en la base con **Object → Set Origin → Origin to 3D Cursor** tras situar el cursor abajo (o **Origin to Geometry** para centrarlo). El origen definirá el pivote en el motor.

9. Aplica **Shade Smooth** con `Auto Smooth` para suavizar el cuerpo curvo manteniendo duros los cantos biselados. Clic derecho en el viewport → **Shade Auto Smooth** y ajusta el ángulo a unos 30°.

10. Exporta a glTF: **File → Export → glTF 2.0 (.glb/.gltf)**. Elige formato **glTF Binary (.glb)**, marca **Selected Objects** con el barril seleccionado y en **Transform** deja `+Y Up`. Guarda como `barril.glb`.

> 💡 **Consejo**: antes de exportar, limpia la malla con **Mesh → Clean Up → Merge by Distance** para fusionar vértices duplicados invisibles que inflarían el conteo y romperían el sombreado.

11. Verifica dimensiones reales. Abre el panel `N`, pestaña **Item**, y confirma que el barril mide algo plausible (por ejemplo 0.9 m de alto). Un prop bien escalado encaja con el resto de assets sin ajustes en el motor.

**Entregable**: el archivo `barril.glb` (o `.gltf`) del prop low-poly con topología en quads, normales correctas, escala aplicada y origen sensato.

Para autoevaluarte, abre el `.glb` en un visor externo y comprueba tres cosas: silueta reconocible, ausencia de caras negras y un conteo de triángulos acorde a un prop de fondo. Si las tres se cumplen, tu prop está listo para texturizarse en la siguiente clase.

## ✍️ Ejercicios

1. Modela una **caja de madera** partiendo de un cubo, biselando los cantos y añadiendo un loop cut central.
2. Reduce el barril a `8` vértices de base y compara el conteo de polígonos y la silueta.
3. Añade un modificador **Subdivision Surface** al barril y observa cómo cambia con y sin biseles de soporte.
4. Modela un **arma sencilla** (una espada recta) usando Mirror para que ambos filos sean simétricos.
5. Aplica **Shade Smooth** y luego un **Auto Smooth** de 30°; explica la diferencia visual respecto a **Shade Flat**.
6. Reexporta el barril con `Z Up` en lugar de `Y Up` y comprueba cómo aparece rotado en un visor glTF.

> 💡 **Consejo de flujo**: trabaja siempre de lo general a lo particular. Bloquea primero la silueta con formas grandes, valida proporciones, y solo entonces añade biseles y detalle. Detallar antes de tener la silueta correcta te obliga a rehacer trabajo.

## 📝 Reto verificable

Modela un prop low-poly propio (barril, caja o arma) por debajo de **800 triángulos**, con topología mayoritariamente en quads, escala aplicada, normales hacia afuera y origen en un punto lógico para el pivote. Expórtalo a `.glb` y ábrelo en un visor glTF externo (por ejemplo <https://gltf-viewer.donmccurdy.com/>).

**Criterio de aceptación**: el `.glb` carga en el visor sin errores, se ve con orientación y escala correctas (proporción real), sin caras negras por normales invertidas, y el conteo mostrado por Statistics queda bajo 800 triángulos.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El modelo llega gigante o diminuto al motor | No aplicaste la escala. Usa `Ctrl+A` → Scale antes de exportar. |
| Caras negras o "huecas" al iluminar | Normales invertidas. Selecciona todo y `Shift+N` para recalcular hacia afuera. |
| Subsurf deforma el modelo hacia una bola | Faltan loops de soporte cerca de los cantos. Añade loop cuts (`Ctrl+R`) junto a las aristas duras. |
| El bevel se ve raro o se auto-interseca | Escala sin aplicar o valor demasiado alto. Aplica escala y reduce el ancho del bisel. |
| El pivote queda descentrado en el motor | El origen del objeto está mal. Reubícalo con Object → Set Origin. |
| Aparecen n-gons en las tapas | Cerraste con una sola cara de muchos lados. Usa Grid Fill o triangula solo si el motor lo exige. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué se insiste tanto en usar quads?** Porque se subdividen y deforman de forma predecible; los triángulos y n-gons pueden generar artefactos de sombreado y complican el rigging posterior.

**❓ ¿glTF o FBX para juegos?** glTF es abierto, ligero y bien soportado por motores modernos y por la web; FBX sigue siendo común en pipelines de Unity, pero glTF es la apuesta segura para este curso.

**❓ ¿Cuántos polígonos debe tener un prop?** Depende del uso: un prop de fondo puede rondar cientos de triángulos y uno prominente algunos miles. La regla es "los mínimos para que la silueta convenza".

**❓ ¿Debo triangular la malla antes de exportar?** No es obligatorio; glTF triangula al exportar. Triangula manualmente solo si necesitas controlar cómo se dividen ciertas caras.

## 🔗 Referencias

- Blender Manual — Modeling: <https://docs.blender.org/manual/en/latest/modeling/index.html>
- Blender Manual — Modifiers: <https://docs.blender.org/manual/en/latest/modeling/modifiers/index.html>
- Blender Manual — glTF 2.0 export: <https://docs.blender.org/manual/en/latest/addons/import_export/scene_gltf2.html>
- Blender Manual — Normals: <https://docs.blender.org/manual/en/latest/modeling/meshes/normals.html>

## ➡️ Siguiente clase

[Clase 179 - UV mapping y texturizado](../179-uv-mapping-y-texturizado/README.md)
