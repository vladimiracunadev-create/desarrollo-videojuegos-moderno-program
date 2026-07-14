# Clase 156 — Qué es el game design: mecánicas, dinámicas y estética (MDA)

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Hunicke, LeBlanc & Zubek, "MDA: A Formal Approach to Game Design"*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El **game design** no es dibujar personajes ni programar físicas: es diseñar la experiencia que emerge cuando alguien juega. Un juego es una máquina que produce sensaciones, y el diseñador es quien ajusta esa máquina. El problema es que el diseñador trabaja desde las reglas (lo que puede controlar directamente) mientras que el jugador vive la estética (lo que siente), y ambos ven el mismo juego desde extremos opuestos. El marco **MDA** —Mechanics, Dynamics, Aesthetics— da un lenguaje para conectar esos dos extremos y razonar sobre por qué un cambio de regla altera la diversión.

En esta clase entenderás qué hace realmente un diseñador, recorrerás la cadena **mecánicas → dinámicas → estética** en ambos sentidos y conocerás las **8 clases de diversión** de Hunicke, que reemplazan la palabra vaga "divertido" por vocabulario preciso. La idea que debes interiorizar es la **asimetría de perspectivas**: el diseñador solo toca mecánicas y espera que, al jugarse, emerjan las dinámicas que producen la estética buscada; el jugador hace el viaje inverso, primero siente y casi nunca ve las reglas que lo causan. El entregable del laboratorio es un análisis MDA tabulado de un juego real: la herramienta base que usarás en toda la Parte 8.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Definir mecánicas, dinámicas y estética, y explicar por qué el diseñador y el jugador los recorren en direcciones opuestas.
2. Nombrar las 8 clases de diversión de MDA y dar un ejemplo de juego para cada una.
3. Descomponer un juego existente identificando sus mecánicas explícitas.
4. Inferir qué dinámicas emergentes producen esas mecánicas durante el juego real.
5. Diagnosticar por qué un juego "no engancha" apuntando al eslabón MDA que falla.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué hace un diseñador de juegos | Distingue el oficio del arte y la programación. |
| 2 | Las tres capas de MDA | Da un modelo mental compartido de todo juego. |
| 3 | La lectura del diseñador (M→D→A) | Es la única capa que se controla directamente. |
| 4 | La lectura del jugador (A→D→M) | Explica qué siente y compra el jugador. |
| 5 | Dinámicas emergentes | La diversión real nace aquí, no en las reglas. |
| 6 | Las 8 clases de diversión | Reemplaza "divertido" por vocabulario preciso. |
| 7 | Estética buscada vs estética lograda | Base de todo diagnóstico de diseño. |
| 8 | MDA como herramienta de análisis | Convierte la intuición en método reproducible. |

## 📖 Definiciones y características

- **Mecánica**: regla o componente formal del juego (reglas, acciones, datos, algoritmos). Clave: es lo que el diseñador escribe y controla de forma directa.
- **Dinámica**: comportamiento en tiempo de ejecución que surge cuando las mecánicas interactúan con el jugador y entre sí. Clave: es emergente, no se programa literalmente.
- **Estética**: respuesta emocional deseada en el jugador (la "diversión"). Clave: es lo que el jugador percibe primero y lo que recuerda.
- **Emergencia**: aparición de comportamientos complejos a partir de reglas simples combinadas. Clave: pocas mecánicas bien elegidas generan muchas dinámicas.
- **Las 8 clases de diversión**: sensación, fantasía, narrativa, desafío, compañerismo, descubrimiento, expresión y sumisión (pasatiempo). Clave: un juego suele apuntar a 2-3, no a todas.
- **Estética buscada**: la experiencia que el diseñador quiere provocar. Clave: sirve de brújula para decidir qué mecánica añadir o quitar.
- **Lente MDA**: mirar un juego alternando las tres capas para localizar dónde se rompe la experiencia. Clave: separa el síntoma (estética) de la causa (mecánica).
- **Juego como sistema**: conjunto de mecánicas en interacción, no una lista de features. Clave: cambiar una regla puede alterar dinámicas lejanas.

## 🧰 Herramientas y preparación

No necesitas software especializado: basta una **hoja de cálculo** (Google Sheets o LibreOffice Calc) y un juego que conozcas bien para analizarlo con honestidad. Idealmente uno simple y acotado —un arcade, un roguelike ligero o un party game— porque la cadena MDA se ve más nítida en juegos con pocas mecánicas. Ten a mano el paper original para consultar las definiciones de las 8 clases de diversión.

Lee el artículo fundacional de Hunicke, LeBlanc y Zubek en <https://users.cs.northwestern.edu/~hunicke/MDA.pdf> y, como complemento accesible, la entrada sobre MDA de la wiki de diseño de juegos en <https://en.wikipedia.org/wiki/MDA_framework>.

Antes de empezar, ten claras las **8 clases de diversión** para poder etiquetar con precisión: *sensación* (el placer del acto en sí), *fantasía* (encarnar un rol o mundo), *narrativa* (una historia que se desarrolla), *desafío* (superar obstáculos), *compañerismo* (interacción social), *descubrimiento* (explorar lo desconocido), *expresión* (crear y personalizar) y *sumisión* (el juego como pasatiempo relajante). Cada una es una promesa emocional distinta; nombrar cuál persigue tu juego evita diseñar a ciegas.

Para el análisis conviene elegir un juego que **hayas jugado de verdad**, no uno que solo hayas visto en vídeo: las dinámicas emergentes solo se sienten jugando. Si dudas entre varios, prefiere el más simple; es más fácil aislar la cadena M→D→A cuando hay cinco mecánicas que cuando hay cincuenta.

## 🧪 Laboratorio guiado

Vas a producir un **análisis MDA tabulado** de un juego que conozcas. El entregable es una tabla completa más un párrafo de diagnóstico.

1. Elige un juego acotado (ej.: *Tetris*, *Slay the Spire*, *Among Us*, *Vampire Survivors*). Anótalo como encabezado del análisis.

2. Declara la **estética buscada**: marca de las 8 clases las 2-3 que crees que el juego persigue. Ejemplo para *Tetris*: desafío y sensación.

3. Lista las **mecánicas** en la primera columna. Sé concreto: no "hay bloques" sino "las piezas caen a velocidad creciente", "una fila completa se elimina", "la partida acaba si la pila toca el techo".

4. Para cada mecánica, escribe la **dinámica emergente** que produce durante el juego: el comportamiento observable del jugador, no la regla. Ejemplo: la velocidad creciente → el jugador entra en un estado de decisiones cada vez más rápidas y errores por presión.

5. En una tercera columna, marca a qué **clase de diversión** contribuye esa dinámica. Copia esta plantilla:

| Mecánica (regla) | Dinámica emergente (qué pasa al jugar) | Clase de diversión | ¿Refuerza la estética buscada? |
|------------------|----------------------------------------|--------------------|-------------------------------|
| Ej.: velocidad de caída creciente | Tensión y decisiones rápidas bajo presión | Desafío, Sensación | Sí |
| Ej.: rotación libre de piezas | Planificación espacial y "encaje" satisfactorio | Desafío | Sí |
| Ej.: previsualización de la siguiente pieza | Planificación anticipada, reduce el azar puro | Desafío | Sí |
| Ej.: limpiar 4 líneas a la vez (Tetris) | Riesgo calculado: acumular para la jugada grande | Desafío, Expresión | Sí |
| Ej.: sin condición de victoria, solo supervivencia | Bucle sin cierre; puede cansar en sesiones largas | (ninguna) | No |
| … | … | … | … |

6. Completa al menos **6 filas**. Fuerza al menos una fila donde la dinámica **no** refuerce la estética buscada (una mecánica que distrae o contradice el objetivo).

7. **Revisa la coherencia global.** Recorre la columna de clases de diversión: ¿la mayoría de dinámicas empujan hacia las 2-3 clases que declaraste como estética buscada? Si una clase aparece mucho pero no la declaraste, quizá el juego persigue algo distinto de lo que creías. Ajusta tu declaración de estética buscada si los datos de la tabla te contradicen; esto es diseño honesto.

8. Escribe un **párrafo de diagnóstico** (4-6 líneas): ¿la máquina produce la estética buscada? ¿Qué mecánica sobra o falta? Si tuvieras que cambiar una sola regla para acercar la experiencia a la estética buscada, ¿cuál y por qué?

9. **Contrasta con un jugador.** Si puedes, muestra el juego a alguien que no lo conozca durante cinco minutos y pregúntale qué sintió. Compara su respuesta espontánea con la estética que declaraste: si coinciden, tu lectura M→D→A es sólida; si no, tienes una pista valiosa de que alguna mecánica está produciendo una dinámica inesperada.

10. Guarda la tabla y el párrafo como `analisis-mda-<juego>.md` o una hoja de cálculo. Este es tu entregable.

Con esto ya tienes el reflejo básico del diseñador: mirar cualquier juego y ver las tres capas en vez de una lista de features. En las siguientes clases usarás esta misma disciplina para el core loop, la economía, los sistemas y el balanceo.

> **Consejo de práctica.** Repite este análisis con un juego distinto cada semana. En pocas semanas verás las tres capas de forma automática y sabrás, ante cualquier cambio de regla, qué dinámica y qué estética alterará. Ese es el músculo central del diseñador.

## ✍️ Ejercicios

1. Repite el análisis MDA con un juego de género opuesto al del laboratorio (si hiciste un arcade, haz un juego narrativo).
2. Toma un juego que te aburra y localiza en qué eslabón MDA falla: ¿mecánicas pobres, dinámicas triviales o estética mal elegida?
3. Elige dos juegos con la misma mecánica central (ej.: saltar) y muestra que producen estéticas distintas; explica por qué.
4. Escribe la lectura A→D→M de un jugador: parte de "quiero sentir tensión" y deduce qué mecánicas debería tener el juego.
5. Para un juego que ames, argumenta cuál de las 8 clases de diversión es la dominante y cuál la secundaria.
6. Propón una mecánica nueva para el juego del laboratorio y predice la dinámica emergente que provocaría antes de asumir que "será divertida".

## 📝 Reto verificable

Analiza con MDA un juego que **nunca hayas estudiado formalmente** y entrega la tabla de al menos 7 mecánicas con sus dinámicas y clases de diversión, más el párrafo de diagnóstico. Incluye una recomendación de diseño concreta ("cambiaría X mecánica por Y para reforzar la estética Z").

**Criterio de aceptación**: cada fila distingue claramente regla (mecánica) de comportamiento (dinámica) —no repite la misma frase en ambas columnas—, al menos una fila señala una mecánica que no refuerza la estética buscada, y la recomendación final apunta a una mecánica específica, no a un deseo genérico ("hacerlo más divertido").

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Las columnas Mecánica y Dinámica dicen lo mismo | Confundes regla con comportamiento. La mecánica es lo que programas; la dinámica es lo que el jugador hace por culpa de ella. Reescribe la dinámica en términos de acción del jugador. |
| El análisis marca las 8 clases de diversión | Un juego enfocado apunta a 2-3. Elige las dominantes y justifica; marcar todas equivale a no elegir. |
| "Este juego es divertido y ya" | Falta vocabulario. Sustituye "divertido" por la clase concreta (desafío, descubrimiento…) para poder diseñar sobre ello. |
| Se listan features (gráficos, menús) como mecánicas | Una mecánica es una regla de juego, no un elemento de presentación. Filtra lo que afecta a las reglas del sistema. |
| El diagnóstico no propone ningún cambio | Analizar sin concluir no es diseño. Termina siempre con una decisión accionable sobre una mecánica. |
| Se analiza el juego "ideal" y no el que existe | Describes lo que crees que debería pasar, no lo que pasa al jugar. Basa las dinámicas en partidas reales observadas. |

## ❓ Preguntas frecuentes

**❓ ¿MDA sirve para diseñar o solo para analizar?** Para ambos. Analizas leyendo M→D→A y diseñas leyendo A→D→M: partes de la estética buscada y deduces qué mecánicas la producirían.

**❓ ¿Las dinámicas se programan?** No directamente. Programas mecánicas; las dinámicas emergen de cómo esas mecánicas interactúan con el jugador. Por eso conviene prototipar y observar en vez de asumir.

**❓ ¿Un juego debe cubrir las 8 clases de diversión?** No. Perseguir todas dispersa el diseño. Los mejores juegos suelen dominar 2-3 clases y sacrifican el resto conscientemente.

**❓ ¿La estética de MDA es lo mismo que el apartado visual del juego?** No, y es la confusión más frecuente. En MDA "estética" significa la respuesta emocional del jugador (desafío, descubrimiento…), no los gráficos ni el arte. Un juego feo puede tener una estética MDA excelente.

## 🔗 Referencias

- Hunicke, LeBlanc & Zubek — MDA: A Formal Approach to Game Design: <https://users.cs.northwestern.edu/~hunicke/MDA.pdf>
- Jesse Schell — The Art of Game Design (sitio del libro): <https://www.schellgames.com/art-of-game-design>
- Marco MDA (resumen): <https://en.wikipedia.org/wiki/MDA_framework>
- Extra Credits — What Makes Us Roll (diseño de experiencias): <https://www.youtube.com/c/extracredits>

## ➡️ Siguiente clase

[Clase 157 - El core loop y los pilares de diseño](../157-el-core-loop-y-los-pilares-de-diseno/README.md)
