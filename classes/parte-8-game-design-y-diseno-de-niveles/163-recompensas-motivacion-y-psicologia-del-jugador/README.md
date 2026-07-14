# Clase 163 — Recompensas, motivación y psicología del jugador

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Jesse Schell, The Art of Game Design: A Book of Lenses (3ª ed.)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

¿Por qué seguimos jugando? La respuesta no está en los gráficos, sino en cómo el juego dialoga con nuestro sistema de motivación. En esta clase estudiarás la diferencia entre la **motivación intrínseca** (jugar por el placer de la actividad) y la **extrínseca** (jugar por una recompensa externa), y cómo un mal diseño de recompensas puede erosionar la primera. Verás los esquemas de refuerzo de la psicología conductual y por qué el refuerzo de proporción variable es el más "adictivo", el mismo que usa una máquina tragamonedas.

También abordarás la dimensión ética: muchas de estas técnicas se han convertido en **dark patterns** diseñados para explotar al jugador en lugar de servirlo. Aprenderás a reconocerlos y a proponer alternativas respetuosas. El marco de **tipos de jugador de Bartle** te ayudará a entender que no todos buscan la misma recompensa: hay quien juega por logro, por exploración, por socializar o por dominar a otros.

La distinción práctica que te llevarás es que una recompensa no motiva por su tamaño, sino por su significado y su timing. Un cofre que llega en el momento justo tras un reto superado vale más que diez cofres regalados sin esfuerzo. Diseñar recompensas es diseñar el ritmo del deseo: cuándo prometer, cuándo entregar y cuándo dejar que el jugador se lo gane por sí mismo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. **Diferenciar** motivación intrínseca y extrínseca y el efecto de sobrejustificación.
2. **Clasificar** esquemas de refuerzo (fijo/variable, intervalo/proporción) y su efecto.
3. **Ubicar** a los jugadores en la taxonomía de Bartle y diseñar recompensas para cada tipo.
4. **Identificar** dark patterns en sistemas de recompensa reales.
5. **Proponer** alternativas éticas que respeten la autonomía del jugador.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Intrínseca vs extrínseca | Define si el juego se disfruta o solo se "trabaja" |
| 2 | Efecto de sobrejustificación | Recompensar puede matar la diversión propia |
| 3 | Esquemas de refuerzo | Explican el ritmo y el enganche |
| 4 | Refuerzo de proporción variable | El patrón más potente y más peligroso |
| 5 | Tipos de jugador (Bartle) | No todos buscan la misma recompensa |
| 6 | Bucles de compulsión | Cómo se encadenan esfuerzo y premio |
| 7 | Dark patterns | Frontera entre enganchar y explotar |
| 8 | Diseño ético de recompensas | Fideliza sin dañar al jugador |

## 📖 Definiciones y características

- **Motivación intrínseca**: hacer algo por el placer inherente de la actividad. Clave: el juego es su propia recompensa.
- **Motivación extrínseca**: hacer algo por una recompensa externa (puntos, premios). Clave: útil para iniciar hábitos, riesgosa a largo plazo.
- **Efecto de sobrejustificación**: recompensar una actividad ya placentera reduce el interés intrínseco. Clave: cuidado al "pagar" por diversión gratuita.
- **Refuerzo de intervalo fijo**: premio tras un tiempo constante (recompensa diaria). Clave: predecible, crea rutina.
- **Refuerzo de proporción variable**: premio tras un número impredecible de acciones. Clave: máxima resistencia a la extinción, base del "loot".
- **Tipos de Bartle**: Triunfadores, Exploradores, Socializadores y Asesinos. Clave: cada uno valora recompensas distintas.
- **Bucle de compulsión (compulsion loop)**: ciclo anticipación → acción → recompensa → repetición. Clave: motor emocional del enganche.
- **Dark pattern**: diseño que engaña o presiona al jugador contra su interés (FOMO artificial, moneda ofuscada). Clave: enganche a costa de confianza.

## 🧰 Herramientas y preparación

Trabajarás con papel o un editor de texto; no hay código. Elige un juego que conozcas bien y que tenga un sistema de recompensas visible (un free-to-play móvil, un RPG con loot o un juego con pase de batalla es ideal para el análisis). Como referencia teórica usa el capítulo de motivación de Jesse Schell, *The Art of Game Design* <https://www.schellgames.com>; el modelo de tipos de jugador de Richard Bartle <https://mud.co.uk/richard/hcds.htm>; y, para el catálogo de patrones manipulativos aplicados a juegos, la wiki de dark patterns de juegos de Ramin Shokrizade y otros <https://www.darkpattern.games>. El laboratorio es analítico: producirás un mapa de recompensas y un dictamen ético.

## 🧪 Laboratorio guiado

Mapearás las recompensas de un juego real, las clasificarás por tipo y esquema, señalarás dark patterns y propondrás alternativas éticas. El entregable es `mapa-recompensas.md`.

**Paso 1 — Inventaria las recompensas.** Lista cada cosa que el juego te da: monedas, objetos, subir de nivel, historia, cosméticos, rankings. No filtres todavía.

**Paso 2 — Clasifica cada recompensa.** Para cada una anota si es intrínseca o extrínseca y qué esquema de refuerzo usa:

```text
Recompensa        Tipo         Esquema                 Tipo Bartle objetivo
Subir de nivel    extrínseca   proporción fija         Triunfador
Loot de jefe      extrínseca   proporción variable     Triunfador/Explorador
Recompensa diaria extrínseca   intervalo fijo          todos
Descubrir zona    intrínseca   —                       Explorador
```

**Paso 3 — Dibuja el bucle de compulsión.** En 3-4 pasos describe el ciclo principal: anticipación → acción → recompensa → repetición. Señala dónde vive la incertidumbre.

**Paso 4 — Señala dark patterns.** Revisa la lista y marca los que aparezcan:

```markdown
| Dark pattern            | ¿Presente? | Cómo se manifiesta            |
|-------------------------|------------|-------------------------------|
| FOMO / temporizadores   | sí/no      | ...                           |
| Moneda ofuscada         | sí/no      | ...                           |
| Pago para saltar espera | sí/no      | ...                           |
| Recompensa por racha    | sí/no      | ...                           |
```

**Paso 5 — Propón alternativas éticas.** Para cada dark pattern encontrado, escribe una alternativa que mantenga el enganche sin manipular (por ejemplo: sustituir un temporizador de FOMO por contenido que no caduca).

**Paso 6 — Test del sol.** Antes del dictamen, aplica esta prueba rápida a cada dark pattern detectado: ¿el mecanismo funcionaría igual si el jugador entendiera perfectamente cómo opera? Si depende de la confusión, la prisa o la vergüenza, es manipulación; si sobrevive a la luz del día, es diseño legítimo.

**Paso 7 — Dictamen.** Escribe un párrafo: ¿el juego respeta la autonomía del jugador o la explota? Justifica con dos ejemplos concretos de tu tabla y termina con una recomendación de diseño accionable para el equipo del juego.

**Checklist del entregable:**

- [ ] Hay al menos seis recompensas inventariadas.
- [ ] Cada una está clasificada por tipo (intrínseca/extrínseca) y esquema.
- [ ] El bucle de compulsión tiene 3-4 pasos con la incertidumbre marcada.
- [ ] La tabla de dark patterns cubre los cuatro tipos listados.
- [ ] Cada dark pattern presente tiene una alternativa ética viable.
- [ ] El dictamen justifica su veredicto con dos ejemplos concretos.

## ✍️ Ejercicios

1. Da un ejemplo propio del efecto de sobrejustificación (algo que dejó de gustarte cuando empezaron a premiártelo).
2. Diseña una recompensa distinta para cada uno de los cuatro tipos de Bartle en un mismo juego.
3. Explica por qué el refuerzo de proporción variable resiste más la extinción que el de intervalo fijo.
4. Identifica un dark pattern en un juego que juegues y reescríbelo como mecánica ética.
5. Propón una recompensa puramente intrínseca para un juego que hoy dependa solo de premios extrínsecos.
6. Diseña un bucle de compulsión sano de 4 pasos para un juego educativo.

## 📝 Reto verificable

Entrega `mapa-recompensas.md` con: el inventario de recompensas, la tabla de clasificación (tipo, esquema y tipo de Bartle), el bucle de compulsión, la tabla de dark patterns con sus alternativas éticas y el dictamen final.

**Criterio de aceptación**: hay al menos seis recompensas inventariadas y clasificadas correctamente por tipo y esquema; el bucle de compulsión tiene 3-4 pasos con la incertidumbre señalada; se identifica al menos un dark pattern con una alternativa ética concreta y viable; el dictamen justifica su veredicto con dos ejemplos de la tabla.

## ⚠️ Errores comunes

| Síntoma | Causa y cómo arreglar |
|---------|-----------------------|
| El juego se siente un "trabajo" | Todo es extrínseco. Añade recompensas intrínsecas (maestría, exploración, expresión). |
| El interés cae al añadir premios | Efecto de sobrejustificación. No recompenses lo que ya se disfruta por sí mismo. |
| Solo enganchas a un tipo de jugador | Diseñaste una sola vía de recompensa. Cubre varios tipos de Bartle. |
| Enganche alto pero mala reputación | Cruzaste a dark pattern. Sustituye presión y engaño por valor real. |
| Recompensas que dejan de motivar | Esquema demasiado predecible. Introduce variabilidad controlada. |

## ❓ Preguntas frecuentes

**❓ ¿Toda recompensa extrínseca es mala?** No. Es excelente para arrancar un hábito o guiar al principiante. El riesgo es que sustituya por completo al placer intrínseco a largo plazo.

**❓ ¿El refuerzo variable es siempre un dark pattern?** No. Es una herramienta legítima que crea sorpresa y emoción. Se vuelve dark pattern cuando se combina con dinero real y presión psicológica para explotar al jugador.

**❓ ¿Los tipos de Bartle son categorías fijas?** No; un mismo jugador mezcla motivaciones y cambia según el juego y el momento. Úsalos como lentes de diseño, no como etiquetas rígidas.

**❓ ¿Cómo sé si crucé la línea ética?** Pregúntate si estarías cómodo explicando el mecanismo a la cara del jugador. Si el sistema depende de que no entienda lo que pasa, es un dark pattern.

## 🔗 Referencias

- Jesse Schell, *The Art of Game Design: A Book of Lenses* (3ª ed.) — <https://www.schellgames.com>
- Richard Bartle, *Hearts, Clubs, Diamonds, Spades: Players Who Suit MUDs* — <https://mud.co.uk/richard/hcds.htm>
- Dark Patterns in Games (catálogo) — <https://www.darkpattern.games>
- Tracy Fullerton, *Game Design Workshop* (4ª ed.) — CRC Press

## ➡️ Siguiente clase

[Clase 164 - Onboarding y enseñar sin tutoriales](../164-onboarding-y-ensenar-sin-tutoriales/README.md)
