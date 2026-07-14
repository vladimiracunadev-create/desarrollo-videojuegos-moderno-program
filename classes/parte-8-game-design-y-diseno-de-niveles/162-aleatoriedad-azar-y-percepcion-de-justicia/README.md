# Clase 162 — Aleatoriedad, azar y percepción de justicia

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Jesse Schell, The Art of Game Design: A Book of Lenses (3ª ed.)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El azar es una de las herramientas más poderosas y peligrosas del diseñador: bien usado genera tensión, rejugabilidad y sorpresa; mal usado produce frustración y la sensación de que el juego "hace trampa". En esta clase separarás el azar como mecanismo matemático del azar como experiencia percibida, que casi nunca coinciden. El cerebro humano no es un buen estimador de probabilidad: ve patrones donde hay ruido y espera "compensaciones" que la matemática no ofrece.

Aprenderás a distinguir la **aleatoriedad de entrada** (antes de que el jugador decida) de la **aleatoriedad de salida** (después de decidir), a elegir distribuciones adecuadas y a corregir la percepción de injusticia con técnicas como los **pity timers** y la aleatoriedad sin reemplazo. El objetivo final es diseñar sistemas de azar que se sientan justos aunque el jugador no vea los números por dentro.

La idea central que llevarás de esta clase es que el diseñador no controla la suerte de un jugador concreto, pero sí controla la *forma de la distribución* y, sobre todo, el peor caso posible. Diseñar azar es diseñar colas: decidir cuán extrema puede llegar a ser la mala suerte antes de que el sistema intervenga.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. **Distinguir** aleatoriedad de entrada y de salida y elegir cuál conviene a cada mecánica.
2. **Comparar** distribuciones (uniforme, ponderada, gaussiana) según el efecto buscado.
3. **Diseñar** un sistema de loot o críticos con probabilidades y un pity timer.
4. **Explicar** por qué el jugador percibe rachas como injustas (falacia del jugador, agrupamiento).
5. **Tabular** la experiencia esperada de un sistema de azar (media, varianza, peor caso).

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Azar matemático vs percibido | Explica la brecha entre números y sensación |
| 2 | Input vs output randomness | Define si el azar respeta o anula la habilidad |
| 3 | Distribuciones de probabilidad | Cambian la textura de la experiencia |
| 4 | Falacia del jugador y rachas | Fuente principal de la percepción de injusticia |
| 5 | Pity timers y suelo de suerte | Acotan el peor caso y calman la frustración |
| 6 | Aleatoriedad sin reemplazo | Evita repeticiones y sequías extremas |
| 7 | Pseudo-aleatoriedad y semillas | Permite reproducir y auditar el azar |
| 8 | Transparencia del azar | Comunicar probabilidades genera confianza |

## 📖 Definiciones y características

- **Aleatoriedad de entrada (input randomness)**: el azar ocurre antes de la decisión del jugador (mapa generado, mano repartida). Clave: el jugador planifica alrededor de él, premia habilidad.
- **Aleatoriedad de salida (output randomness)**: el azar ocurre después de decidir (tirada de daño, probabilidad de acierto). Clave: puede anular una buena decisión, úsala con cuidado.
- **Distribución uniforme**: todos los resultados igual de probables (un dado). Clave: máxima incertidumbre, cola plana.
- **Distribución ponderada**: cada resultado tiene un peso distinto. Clave: controla rareza de loot.
- **Distribución gaussiana**: resultados agrupados en torno a una media (suma de varios dados). Clave: extremos raros, más "predecible".
- **Falacia del jugador (gambler's fallacy)**: creer que un evento improbable "ya toca" tras una racha. Clave: cada tirada independiente no tiene memoria.
- **Pity timer**: mecanismo que garantiza un premio tras N intentos fallidos. Clave: elimina el peor caso desesperante.
- **Pseudo-aleatoriedad**: secuencia determinista que parece aleatoria a partir de una semilla. Clave: reproducible y auditable.

## 🧰 Herramientas y preparación

No necesitas motor ni código: basta una hoja de cálculo (LibreOffice Calc, Google Sheets o Excel) para modelar probabilidades y un editor de texto para el entregable. Ten a mano una calculadora de probabilidad acumulada; la mayoría de hojas tienen funciones como `RAND()` y `BINOM.DIST` si quieres experimentar. Como referencia teórica usa el capítulo sobre azar y probabilidad de Jesse Schell, *The Art of Game Design* <https://www.schellgames.com>, y para el fenómeno de agrupamiento de rachas, la técnica de "pseudo-random distribution" documentada por la comunidad de Dota 2 <https://liquipedia.net/dota2/Pseudo_Random_Distribution>. El laboratorio es analítico: producirás una tabla de sistema de loot, no un script.

## 🧪 Laboratorio guiado

Diseñarás el sistema de azar de un objeto o golpe crítico, con distribución explícita y pity timer, y tabularás la experiencia esperada. El entregable es un archivo `sistema-azar.md`.

**Paso 1 — Elige la mecánica.** Puede ser una tirada de crítico (probabilidad de daño doble) o una caja de loot con varias rarezas. Anota qué decide el azar y si es de entrada o de salida.

**Paso 2 — Define la tabla de probabilidad.** Asigna pesos a cada resultado. Los pesos deben sumar 100 %:

```text
Rareza     Peso     Prob.
Común       60 %    0.60
Rara        30 %    0.30
Épica        8 %    0.08
Legendaria   2 %    0.02
```

**Paso 3 — Calcula la experiencia esperada.** Para la legendaria (p = 0.02), la media de intentos hasta el primer éxito es 1/p = 50 tiradas. Calcula también la probabilidad de NO obtenerla en 50 intentos: (1 − 0.02)^50 ≈ 0.36 (36 % de jugadores seguirán sin ella). Esa es la fuente de la queja "llevo 50 y nada". La fórmula general del peor caso al percentil 95 es ln(1 − 0.95) / ln(1 − p); para p = 0.02 da ≈ 149 intentos, el número que un jugador desafortunado podría llegar a sufrir.

**Paso 4 — Añade un pity timer.** Decide un techo, por ejemplo: a partir del intento 40 sin legendaria, la probabilidad sube +5 % por intento hasta garantizarla en el 60. Describe la regla en texto.

**Paso 5 — Tabula el peor caso.** Rellena esta plantilla comparando con y sin pity:

```markdown
| Métrica                         | Sin pity | Con pity |
|---------------------------------|----------|----------|
| Media de intentos a legendaria  | 50       | ~35      |
| Peor caso razonable (95 %)      | 149      | 60       |
| Sensación esperada del jugador  | ...      | ...      |
```

**Paso 6 — Simula mentalmente 10 jugadores.** Antes de justificar, imagina diez jugadores abriendo tu caja. Con la legendaria al 2 %, aproximadamente cuatro seguirán sin ella tras 50 intentos y uno podría pasar de 100. Anota cómo se sentiría cada uno: esa dispersión es el corazón del problema de percepción.

**Paso 7 — Justifica la percepción.** Escribe un párrafo explicando por qué el pity mejora la *sensación* de justicia aunque la probabilidad media apenas cambie: acota el peor caso, que es lo que el jugador recuerda y comparte en foros y redes. La media consuela al diseñador; el peor caso define la reputación del sistema.

**Checklist del entregable:**

- [ ] La tabla de pesos suma exactamente 100 %.
- [ ] Hay al menos un cálculo de media (1/p) correcto.
- [ ] Hay un cálculo de probabilidad de sequía (potencia).
- [ ] El pity timer está descrito con una regla concreta y un techo.
- [ ] La tabla peor caso compara con y sin pity.
- [ ] El párrafo relaciona peor caso y percepción de justicia.

## ✍️ Ejercicios

1. Da un ejemplo de tu experiencia de juego donde el azar de salida anuló una buena decisión y propón cómo convertirlo en azar de entrada.
2. Diseña una tirada de daño con distribución gaussiana (suma de 2 dados) y explica por qué "se siente" más justa que un solo dado de igual media.
3. Calcula cuántas tiradas necesita un evento del 5 % para que la mitad de los jugadores lo haya visto al menos una vez.
4. Propón un pity timer para una probabilidad del 1 % y estima el peor caso resultante.
5. Explica con la falacia del jugador por qué un jugador cree que "ya le toca" tras 10 fallos seguidos.
6. Convierte una tabla de loot con reemplazo en una sin reemplazo y describe cómo cambia la experiencia en sesiones largas.

## 📝 Reto verificable

Entrega `sistema-azar.md` con: la mecánica elegida (entrada o salida), la tabla de pesos que sume 100 %, el cálculo de media e improbabilidad de sequía, la regla del pity timer y la tabla comparativa peor caso con/sin pity más el párrafo de justificación.

**Criterio de aceptación**: los pesos suman exactamente 100 %; el documento incluye al menos un cálculo numérico correcto de media (1/p) y uno de probabilidad de sequía; el pity timer está descrito con una regla concreta y acota el peor caso por debajo del caso sin pity; el párrafo relaciona explícitamente peor caso y percepción de justicia.

## ⚠️ Errores comunes

| Síntoma | Causa y cómo arreglar |
|---------|-----------------------|
| Jugadores enfadados por sequías largas | Solo miras la media, ignoras el peor caso. Añade un pity timer y comunica el techo. |
| El azar anula la habilidad | Abusas de aleatoriedad de salida. Mueve el azar antes de la decisión (entrada). |
| Repeticiones molestas ("otra vez lo mismo") | Sorteas con reemplazo. Usa aleatoriedad sin reemplazo o bolsa barajada. |
| Los pesos no suman 100 % | Error de tabla. Normaliza dividiendo cada peso por la suma total. |
| Percepción de trampa del sistema | Falta transparencia. Muestra las probabilidades o al menos la existencia del pity. |
| Rachas "imposibles" reportadas por jugadores | Confundes independencia con agrupamiento. Es esperable; usa distribución pseudo-aleatoria para suavizar. |

## ❓ Preguntas frecuentes

**❓ ¿El azar de salida es siempre malo?** No. En juegos casuales o de fiesta aporta remontadas y risas. El problema es usarlo en juegos competitivos donde el jugador espera que la habilidad decida.

**❓ ¿Un pity timer no rompe la emoción del azar?** No si el techo es alto. Conserva la sorpresa en el rango normal y solo interviene en la cola extrema que arruina la experiencia.

**❓ ¿Por qué mi RNG "verdadero" se siente injusto?** Porque el azar real produce agrupamientos que el jugador interpreta como sesgo. La aleatoriedad pseudo-aleatoria (probabilidad creciente) se siente más justa aunque sea menos "pura".

**❓ ¿Debo mostrar las probabilidades al jugador?** Depende del tono y la ley local (muchas jurisdicciones lo exigen en cajas de pago). La transparencia genera confianza y reduce las teorías conspirativas.

## 🔗 Referencias

- Jesse Schell, *The Art of Game Design: A Book of Lenses* (3ª ed.) — <https://www.schellgames.com>
- Pseudo Random Distribution (Dota 2, agrupamiento de rachas) — <https://liquipedia.net/dota2/Pseudo_Random_Distribution>
- Tracy Fullerton, *Game Design Workshop* (4ª ed.) — CRC Press
- Falacia del jugador (referencia general) — <https://es.wikipedia.org/wiki/Falacia_del_jugador>

## ➡️ Siguiente clase

[Clase 163 - Recompensas, motivación y psicología del jugador](../163-recompensas-motivacion-y-psicologia-del-jugador/README.md)
