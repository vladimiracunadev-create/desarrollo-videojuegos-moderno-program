# Clase 187 — Capstone Parte 9: un set de assets coherente

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 y Godot 4 (flujo de arte completo)*
> ⏱️ Duración estimada: **150 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Llega el momento de integrar todo lo aprendido en la Parte 9. Hasta ahora practicaste piezas sueltas —modelar, mapear UVs, texturizar, esculpir, animar, iluminar, optimizar— pero un juego real no necesita piezas sueltas: necesita un **set coherente**. Coherencia significa que tres props, un personaje simple y una paleta comparten la misma **dirección de arte**: escala consistente, misma lógica de materiales, densidad de textura comparable, nomenclatura unificada y un mood común. Cuando eso ocurre, la escena "se siente de un mismo mundo".

En este capstone producirás un **mini set de assets coherente** (por ejemplo 3 props + 1 personaje simple + una paleta) siguiendo una dirección de arte que tú definas, pasando por modelado, UVs, textura, una animación básica y optimización, y lo montarás en una **escena de Godot 4**. Trabajarás con una **especificación**, un **checklist** y una **definition of done** explícitos. No es una clase de teoría nueva: es la síntesis práctica que demuestra que dominas el pipeline de principio a fin.

Trátalo como una pieza de portfolio, no como un ejercicio desechable. Un reclutador o un compañero de equipo no evaluará cada asset aislado, sino si el conjunto "funciona": si transmite un mundo, si está limpio y ordenado, si podría entrar en un juego real sin retoques. Por eso las decisiones de proceso —spec, paleta, presupuestos, nomenclatura, definition of done— pesan tanto como la calidad de cada modelo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Redactar una **especificación** y una **dirección de arte** para un set de assets.
2. Producir un set (props + personaje + paleta) **coherente** en escala, estilo y materiales.
3. Aplicar el pipeline completo: modelado, UV, textura, animación básica y optimización.
4. Verificar el trabajo contra un **checklist** y una **definition of done**.
5. Montar y presentar el set en una **escena de Godot** iluminada y ordenada.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Dirección de arte | Es el pegamento que hace que assets distintos convivan. |
| 2 | Especificación del set | Define qué producir, con qué límites y estilo. |
| 3 | Paleta y materiales compartidos | Unifican color y superficie de todo el conjunto. |
| 4 | Coherencia de escala y densidad | Evita que un prop parezca de otro juego. |
| 5 | Pipeline extremo a extremo | Demuestra dominio de cada etapa encadenada. |
| 6 | Checklist de calidad | Convierte "está bien" en criterios verificables. |
| 7 | Definition of done | Cierra el trabajo: cuándo está realmente terminado. |
| 8 | Montaje y presentación en Godot | El set debe verse coherente en su destino real. |

## 📖 Definiciones y características

- **Dirección de arte**: conjunto de decisiones estéticas que guían todo el set. Clave: sin ella los assets se ven "de distintos juegos".
- **Especificación (spec)**: documento con alcance, estilo, presupuestos y entregables. Clave: acuerda el objetivo antes de producir.
- **Set coherente**: grupo de assets que comparten escala, estilo, materiales y paleta. Clave: la coherencia se ve, aunque cueste nombrarla.
- **Paleta**: conjunto acotado de colores base del mundo. Clave: pocos colores bien elegidos dan identidad y unidad.
- **Trim / material compartido**: material reutilizado por varios assets. Clave: ahorra memoria y refuerza la unidad visual.
- **Checklist**: lista de comprobaciones objetivas por asset. Clave: detecta lo que la vista pasa por alto (escala, UVs, nombres).
- **Definition of Done (DoD)**: criterio que declara un trabajo terminado. Clave: evita el "casi listo" infinito.
- **Coherencia de densidad de textura**: texels por unidad similares en todos los assets. Clave: evita que unos se vean nítidos y otros borrosos.

## 🧰 Herramientas y preparación

Usarás **Blender 4.x** (<https://www.blender.org/download/>) para modelado, UV, texturizado (o pintura de vértices), esculpido/bake si aplica y una animación básica, y **Godot 4.x** (<https://godotengine.org/download>) para el montaje final. Reúne lo aprendido en las clases 183–186: sculpting/retopología, VFX opcional, iluminación y, sobre todo, el **pipeline y la convención de nomenclatura** de la clase 186 (reutiliza esa estructura de carpetas y presupuestos). Exporta con **glTF 2.0 (.glb)**. Crea un proyecto `capstone_p9/` con su `res://assets/` ya organizado y un documento `SPEC.md` donde escribirás la dirección de arte, la paleta y la definition of done.

Reserva tiempo para la fase de **referencia** antes de modelar: reúne 3–5 imágenes que definan el estilo y el mood que buscas (un *moodboard*). No es tiempo perdido; es lo que te da un criterio contra el cual comparar y evita que el set derive hacia estilos mezclados a mitad de producción. Puedes montar el moodboard en una imagen y dejarlo junto al `SPEC.md`.

## 🧪 Laboratorio guiado

Producirás el set coherente y lo montarás en una escena de Godot.

1. **Escribe la especificación.** En `SPEC.md` define: tema (p. ej. "campamento medieval de bosque"), **paleta** de 4–6 colores, presupuestos (heredados de la clase 186), lista de entregables (3 props + 1 personaje simple) y la **definition of done**. Fija un estilo (estilizado low-poly, realista PBR, etc.).

   > Mantén la paleta **corta**: 4–6 colores obligan a decisiones y dan identidad; una paleta amplia diluye el carácter del mundo. Elige colores que funcionen juntos (dominantes, secundarios y un acento) y anótalos con su valor hex en el spec para reutilizarlos exactos en cada material.

2. **Bloquea la escala.** Crea un objeto de referencia (una figura humana de 1.8 m) y modela **todo** relativo a ella. La escala consistente es la base de la coherencia.

   > El error de escala es el más común y el más delator: un barril del tamaño de una casa o una espada de juguete rompen la ilusión al instante. Deja la figura de referencia visible en la escena de Blender durante toda la producción y compara cada asset contra ella antes de darlo por bueno.

3. **Modela los 3 props.** Modela cada prop respetando el presupuesto y el estilo. Reutiliza formas y proporciones para que "hablen el mismo idioma" (misma dureza de bordes, mismo nivel de detalle).

   > Un recurso de coherencia barato es el **lenguaje de formas** compartido: si el mundo es redondeado y amable, todos los props llevan bordes biselados suaves; si es duro y tosco, todos llevan aristas marcadas. Definir esa regla en el spec y aplicarla a los tres props hace que se vean "de la misma mano".

4. **UVs y densidad uniforme.** Haz unwrap de cada prop buscando una **densidad de texel** comparable entre todos. Usa una textura de checker para verificar que ninguno se ve más nítido que otro.

   > La densidad de texel es la coherencia invisible: aunque el jugador no sepa nombrarla, nota cuando un asset se ve borroso al lado de otro nítido. Fija un objetivo (p. ej. 512 px/m) y aplícalo a todo el set; los cuadros del checker deben verse del mismo tamaño en cualquier asset.

5. **Personaje simple.** Modela un personaje básico (bloques o low-poly), con UVs y un **rig mínimo** (o Armature simple). No busques detalle de personaje AAA: busca que encaje con los props.

6. **Textura y paleta compartida.** Texturiza aplicando la paleta del spec. Comparte materiales/atlas siempre que puedas: un material común refuerza la unidad y baja draw calls.

   > Una técnica muy usada en producción es el **atlas de paleta**: una textura pequeña con franjas de los colores del spec, donde las UVs de todos los assets apuntan a esas franjas. Un solo material, unidad cromática garantizada y un coste de memoria mínimo. Es el estándar del look estilizado low-poly.

7. **Animación básica.** Da al personaje una animación sencilla (idle o saludo) con el AnimationPlayer/Armature. Basta un clip corto que demuestre el rig funcionando.

   > No subestimes un buen **idle**: una animación de reposo sutil (respiración, ligero balanceo) da más vida que una acción compleja mal ejecutada. Exporta la animación dentro del mismo `.glb` del personaje para que Godot la reconozca automáticamente como AnimationPlayer al importar.

8. **Optimiza y exporta.** Aplica transformaciones, verifica escala 1.0, nombra según la convención (`SM_`, `SK_`, `T_`, `M_`) y exporta a `.glb`. Confirma que cada asset cumple su presupuesto.

   > Antes de exportar, pasa cada malla por una limpieza rápida: elimina vértices dobles (*Merge by Distance*), recalcula normales (*Shade Auto Smooth* / *Recalculate Outside*) y borra geometría oculta que nunca se ve. Estos descuidos no se notan en Blender pero generan sombreados raros y peso extra en el motor.

9. **Monta en Godot.** Importa el set (LODs + compresión, como en la clase 186), colócalo en una escena, ilumínala con un mood coherente (clase 185) y dispón los assets como una pequeña viñeta del mundo. **Entregable**: proyecto `capstone_p9/` con el set completo montado, `SPEC.md` con la DoD, y una captura de la escena final.

10. **Pasa el checklist final.** Recorre tu `SPEC.md` punto por punto: escala verificada contra la referencia, UVs sin solapes y densidad de texel pareja, nombres según convención, presupuestos cumplidos, animación reproduciéndose, materiales/paleta compartidos y cero errores de importación en la consola de Godot. Solo cuando **todos** los ítems están marcados, el capstone está *done*. Un asset "casi listo" no cuenta como listo.

## ✍️ Ejercicios

1. Añade un **cuarto prop** que amplíe el mundo sin romper paleta ni escala.
2. Crea una **variante de color** de un prop reusando el mismo modelo y cambiando solo el material.
3. Añade una segunda **animación** al personaje (p. ej. caminar en sitio).
4. Documenta la **densidad de texel** de cada asset y ajusta el que se desvíe.
5. Prepara una **hoja de presentación** (turntable o 3 capturas) que muestre el set con luz coherente.
6. Escribe la **retrospectiva**: qué asset costó más coherencia y por qué.

## 📝 Reto verificable

Entrega un set completo y coherente: **3 props + 1 personaje simple + una paleta documentada**, producidos con el pipeline completo (modelado, UV, textura, animación básica, optimización), nombrados según la convención, montados en una escena de Godot iluminada, acompañados de `SPEC.md` (dirección de arte + paleta + definition of done) y una captura final. Cumple tu propio checklist y DoD.

**Criterio de aceptación**: la escena de Godot muestra los cuatro assets como parte de un mismo mundo (escala, estilo, paleta y densidad de textura coherentes); todos siguen la convención de nombres, respetan los presupuestos, el personaje tiene al menos una animación funcional, y cada punto del checklist/DoD del `SPEC.md` está marcado como cumplido sin errores de importación en Godot.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Un prop "parece de otro juego" | Rompe estilo, escala o densidad. Ajústalo a la referencia y a la paleta del spec. |
| Unos assets nítidos y otros borrosos | Densidad de texel dispar. Reescala islas UV para igualar texels/unidad. |
| El personaje no encaja con los props | Nivel de detalle o dureza de bordes distintos. Alinéalos al estilo común. |
| Colores dispersos, sin identidad | No se respetó la paleta. Reduce a los 4–6 colores del spec. |
| El trabajo "nunca termina" | Falta una **definition of done** clara. Escríbela y ciérrate a ella. |
| La escena en Godot se ve incoherente | Iluminación o materiales inconsistentes. Unifica mood y comparte materiales. |

## ❓ Preguntas frecuentes

**❓ ¿Qué hace que un set sea "coherente"?** Consistencia en escala, estilo, dureza de bordes, densidad de textura y paleta. No es que los assets sean iguales, sino que comparten reglas; el ojo detecta la unidad aunque el jugador no sepa nombrarla.

**❓ ¿Cuánto detalle debe tener el personaje?** El justo para encajar con los props. Un personaje demasiado detallado junto a props simples rompe la coherencia tanto como uno demasiado tosco. Iguala el nivel de detalle al del conjunto.

**❓ ¿Por qué escribir una spec si trabajo solo?** Porque fija decisiones antes de producir y te da un criterio objetivo para saber cuándo terminaste. La spec y la DoD son las que convierten "arte a ojo" en un proceso repetible y evaluable.

**❓ ¿Puedo reutilizar assets de clases anteriores?** Sí, si los adaptas a la dirección de arte del set. El objetivo del capstone es la **coherencia**, así que integrar y unificar trabajo previo es perfectamente válido.

## 🔗 Referencias

- Blender Manual — UV editing (densidad y unwrap): <https://docs.blender.org/manual/en/latest/modeling/meshes/uv/index.html>
- Blender Manual — Animation & rigging: <https://docs.blender.org/manual/en/latest/animation/index.html>
- Godot Docs — Importing 3D scenes: <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html>
- Godot Docs — Your first 3D scene (montaje): <https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html>
- Blender Manual — Exporting glTF 2.0: <https://docs.blender.org/manual/en/latest/addons/import_export/scene_gltf2.html>

## ➡️ Siguiente clase

[Clase 188 - Fundamentos de UI/UX en juegos](../../parte-10-ui-ux-accesibilidad-y-localizacion/188-fundamentos-de-ui-ux-en-juegos/README.md)
