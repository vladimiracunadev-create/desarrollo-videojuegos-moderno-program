# Clase 179 — UV mapping y texturizado

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 (UV Editing)*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un modelo 3D sin UVs es como un regalo sin envoltorio: no hay forma de pegarle una textura de manera coherente. En esta clase aprendes qué es una **coordenada UV**, cómo "abrir" una malla en un plano 2D marcando **seams** (costuras) y haciendo **unwrap**, y cómo distribuir esas islas para aprovechar al máximo el espacio de textura (**packing**).

Además trabajarás dos ideas que separan a un artista técnico de un principiante: la **densidad de texel** (cuántos píxeles de textura por unidad de superficie, para que todo el modelo tenga un nivel de detalle uniforme) y el **texture atlas** (agrupar varios objetos en una sola textura). Al terminar habrás desplegado las UVs del prop de la clase 178 y le habrás aplicado una textura verificando que la densidad sea consistente.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué representan las coordenadas UV y por qué son necesarias para texturizar.
2. Marcar seams estratégicos y hacer unwrap de una malla completa.
3. Distribuir y empaquetar islas UV minimizando espacio desperdiciado.
4. Medir y corregir la densidad de texel para lograr detalle uniforme.
5. Aplicar una textura al prop y validar el resultado con un patrón de comprobación.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es una coordenada UV | Es el puente entre la superficie 3D y la imagen 2D. |
| 2 | Seams (costuras) | Definen por dónde se "abre" la malla sin estirar. |
| 3 | Unwrap | Genera el mapa 2D sobre el que pintar o texturizar. |
| 4 | Islas UV y packing | Aprovechar el espacio reduce desperdicio de textura. |
| 5 | Densidad de texel | Da un nivel de detalle uniforme a todo el modelo. |
| 6 | Texture atlas | Menos texturas y draw calls en el motor. |
| 7 | Distorsión y estiramiento | Un mal UV deforma visiblemente la textura. |
| 8 | Aplicar la textura | Cerrar el ciclo: ver el material sobre la malla. |

## 📖 Definiciones y características

- **UV**: par de coordenadas (U, V) que asocia cada vértice de la malla a un punto de la imagen. Clave: "U" y "V" son los ejes 2D equivalentes a X e Y de la textura.
- **Seam (costura)**: arista marcada para que el unwrap corte por ahí. Clave: colócalas donde no se noten, como bordes y zonas ocultas.
- **Unwrap (`U`)**: proceso que aplana la malla en islas 2D según las seams. Clave: sin buenas seams, el unwrap estira la textura.
- **Isla UV**: fragmento continuo de malla desplegado en el espacio 0–1. Clave: cuantas menos y mejor colocadas, más limpio el packing.
- **Packing (`Pack Islands`)**: reorganiza las islas para llenar el cuadro UV. Clave: maximiza el uso de píxeles disponibles.
- **Densidad de texel (texel density)**: píxeles de textura por unidad de superficie. Clave: mantenerla uniforme evita zonas borrosas junto a zonas nítidas.
- **Texture atlas**: una textura que agrupa varios objetos o materiales. Clave: reduce draw calls y simplifica el pipeline.
- **Distorsión / stretching**: deformación de la textura por UVs mal proporcionadas. Clave: se detecta con un patrón de cuadrícula (checker).

## 🧰 Herramientas y preparación

Seguimos en **Blender 4.x** (<https://www.blender.org/download/>). Cambia el layout superior a la pestaña **UV Editing**, que divide la pantalla en el editor UV (izquierda) y el viewport 3D (derecha). Necesitarás el prop modelado en la clase 178; si no lo tienes, un cubo o cilindro sirven para practicar.

Para verificar densidad y distorsión usaremos una **textura de comprobación** (checker) generada dentro de Blender, sin descargas. Ten a mano la documentación de UV mapping: <https://docs.blender.org/manual/en/latest/modeling/meshes/uv/index.html>. Opcional pero útil: el add-on **Magic UV** o el propio **UVPackmaster** para packing avanzado, aunque el packing nativo basta para este laboratorio.

Antes de empezar, activa en el editor UV el overlay **Display Stretching** (menú de overlays), que colorea las caras según cuánto se deforman: azul es sano, rojo es estiramiento severo. Es el termómetro visual que usarás para decidir dónde reforzar seams o rehacer el unwrap.

## 🧪 Laboratorio guiado

Vamos a desplegar las UVs del barril de la clase 178 y aplicarle una textura verificando la densidad. El objetivo mental durante todo el proceso es simple: que la textura se "pegue" al modelo como una etiqueta bien puesta, sin arrugas ni estiramientos.

1. Abre tu `barril.blend` (o importa el `.glb`) y ve a la pestaña **UV Editing**. Selecciona el barril y entra en **Modo Edición** con `Tab`, modo Arista (`2`).

2. Marca las seams. Selecciona el loop de aristas del borde superior de la panza (`Alt+clic`) y las verticales que unen las tapas con el cuerpo. Con ellas seleccionadas: **Edge → Mark Seam** (o `Ctrl+E` → Mark Seam). Las seams aparecen en rojo.

3. Haz el unwrap. Selecciona toda la malla con `A`, pulsa `U` → **Unwrap**. En el editor UV de la izquierda aparecerán las islas: el cilindro del cuerpo abierto como un rectángulo y las dos tapas como círculos.

> 💡 **Regla de seams**: piensa como un sastre. Corta por donde una costura real iría en el objeto físico y por donde el ojo del jugador no la buscará. Un barril se abre por una vertical del cuerpo y por el borde de cada tapa.

4. Crea el patrón de comprobación. En el editor UV, arriba, abre **Image → New**, nómbralo `checker`, activa **Generated Type → UV Grid** y crea una imagen de `1024x1024`. Sirve para ver estiramientos.

5. Aplica el checker a la vista. En el viewport 3D pon el **Viewport Shading** en **Material Preview**. En **Material Properties**, crea un material y conecta la imagen `checker` como **Base Color** (o usa el editor de nodos con un **Image Texture**). Los cuadros deben verse cuadrados y del mismo tamaño por todo el barril.

6. Corrige distorsión. Si algún cuadro se ve rectangular o estirado, vuelve al editor UV, selecciona la isla afectada y usa `U` → **Unwrap** de nuevo, o ajusta seams. Escala islas para igualar el tamaño de los cuadros entre piezas: así igualas la densidad de texel.

> 💡 **Densidad de texel en la práctica**: la regla es que un cuadro del UV Grid mida lo mismo en cualquier parte del modelo. Si el cuerpo del barril muestra cuadros grandes y las tapas cuadros pequeños, las tapas tendrán menos resolución. Escala sus islas para nivelarlas.

7. Empaqueta las islas. En el editor UV, `A` para seleccionar todo y **UV → Pack Islands**. Ajusta el margen (`0.01`–`0.02`) para dejar espacio entre islas y evitar sangrado de color entre ellas.

8. Reserva espacio proporcional. Si una tapa apenas se ve en el juego, escálala un poco más pequeña en el espacio UV para dar más resolución al cuerpo, que es lo prominente. Este es el compromiso real de densidad.

9. Activa **Display Stretching** en el editor UV y recorre las islas: cualquier zona roja indica que debes ajustar seams o relajar la isla con `U` → **Unwrap** o el operador **Minimize Stretch**.

10. Guarda el resultado. En el editor UV, **UV → Export UV Layout** para obtener un PNG del despliegue (útil para pintar la textura fuera). Guarda el `.blend` para conservar las UVs.

> 💡 **Consejo**: nombra el material y la textura desde ya con una convención clara (`barril_checker`, luego `barril_albedo`). Esa disciplina de nomenclatura te ahorrará confusiones cuando en la clase 180 manejes cinco mapas del mismo prop.

**Entregable**: el prop con UVs desplegadas sin estiramientos visibles bajo el checker, islas empaquetadas con margen, más el PNG del layout UV exportado.

Como autoevaluación, gira el modelo con el checker aplicado: si los cuadros se mantienen cuadrados y del mismo tamaño en el cuerpo y en las tapas, tu densidad de texel es uniforme y el prop está listo para recibir texturas reales.

Guarda dos versiones del layout, una a `1024` y otra a `2048`, para tener referencia de cuánta resolución gana el prop al subir el tamaño de textura sin cambiar las UVs. Recuerda que las UVs viven en el rango 0–1 y son independientes de la resolución: la misma UV sirve para cualquier tamaño de imagen.

> 💡 **Atajo mental**: si dudas de dónde poner una seam, imagina que debes recortar el objeto en cartulina y volver a montarlo. Los cortes que harías con tijeras son, casi siempre, las seams correctas para tu unwrap.

## ✍️ Ejercicios

1. Remarca las seams del barril poniéndolas en zonas más visibles y observa cómo empeora la distorsión.
2. Usa `U` → **Smart UV Project** en el prop y compara el resultado con tu unwrap manual.
3. Escala una isla al doble en el espacio UV y describe qué le pasa a la densidad de texel de esa zona.
4. Crea un **atlas** colocando las UVs de dos props distintos dentro del mismo cuadro 0–1.
5. Exporta el UV layout a `2048x2048` y compara la nitidez del checker frente a `512x512`.
6. Aplica **UV → Pack Islands** con margen `0` y luego con `0.03`; explica el problema del sangrado.

> 💡 **Consejo de margen**: deja siempre un pequeño margen entre islas y respecto al borde del cuadro 0–1. Al generar mipmaps, el motor mezcla píxeles vecinos; sin margen, el color de una isla "sangra" sobre otra y aparecen líneas de contorno erróneas a distancia.

## 📝 Reto verificable

Despliega por completo tu prop de la clase 178 con seams bien escondidas, iguala la densidad de texel entre todas las islas usando el UV Grid como referencia y empaqueta las islas dentro del cuadro 0–1 con margen adecuado. Exporta el layout UV como PNG.

**Criterio de aceptación**: bajo el checker UV Grid, los cuadros se ven aproximadamente cuadrados y del mismo tamaño en todas las partes del modelo (densidad uniforme), no hay islas saliéndose del cuadro 0–1 ni solapadas, y el PNG del layout muestra las islas empaquetadas con margen.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| La textura se ve estirada en una zona | UVs desproporcionadas o faltan seams. Rehaz el unwrap y añade costuras. |
| Cuadros del checker de distinto tamaño | Densidad de texel desigual. Escala las islas para igualar el tamaño de los cuadros. |
| Colores que "sangran" entre piezas | Islas demasiado juntas. Aumenta el margen en Pack Islands. |
| El unwrap sale como una maraña | Sin seams o mal marcadas. Marca costuras lógicas antes de `U` → Unwrap. |
| Islas superpuestas en el cuadro UV | Se solapan y comparten píxeles. Sepáralas o usa Pack Islands. |
| La textura no aparece en el viewport | Falta el modo Material Preview o el nodo Image Texture sin conectar. |

## ❓ Preguntas frecuentes

**❓ ¿Qué significan realmente U y V?** Son simplemente los nombres de los ejes 2D de la textura (equivalentes a X e Y); se usan U y V para no confundir con las coordenadas 3D X, Y, Z del modelo.

**❓ ¿Dónde conviene poner las seams?** En bordes duros, zonas ocultas o poco visibles y donde un corte no rompa un patrón continuo, como el borde superior de un barril o la costura interior de una manga.

**❓ ¿Por qué importa la densidad de texel?** Porque garantiza que todo el modelo tenga un nivel de detalle coherente; sin ella, unas zonas se ven nítidas y otras borrosas aunque uses la misma textura.

**❓ ¿Cuándo uso un texture atlas?** Cuando varios objetos comparten estilo y quieres reducir el número de texturas y draw calls, típico en props de escenario y en assets móviles.

## 🔗 Referencias

- Blender Manual — UV Mapping: <https://docs.blender.org/manual/en/latest/modeling/meshes/uv/index.html>
- Blender Manual — Unwrapping: <https://docs.blender.org/manual/en/latest/modeling/meshes/uv/unwrapping/index.html>
- Blender Manual — Packing Islands: <https://docs.blender.org/manual/en/latest/modeling/meshes/uv/editing.html>
- glTF texture coordinates (spec): <https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html>

## ➡️ Siguiente clase

[Clase 180 - Materiales PBR y texturas](../180-materiales-pbr-y-texturas/README.md)
