# Clase 166 — Pacing, ritmo y composición de un nivel

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Scott Rogers, Level Up! The Guide to Great Video Game Design*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un nivel entero de acción sin pausa agota; un nivel entero de calma aburre. El **pacing** es el arte de alternar tensión y descanso para mantener al jugador enganchado sin fatigarlo. En esta clase estudiarás el nivel como una pieza con estructura dramática: una **introducción** que presenta el reto, un **desarrollo** con picos y valles de intensidad, un **clímax** que concentra la máxima dificultad y un **remate (cooldown)** que deja respirar antes de terminar.

Aprenderás a pensar en la **curva de intensidad** de un nivel como una línea que sube y baja, y a colocar deliberadamente los **valles** (descansos, exploración, narrativa) después de cada **pico** (combate, plataformeo tenso, jefe). Verás cómo la **densidad de encuentros** y la variación de mecánicas evitan la monotonía, y por qué el clímax debe llegar cerca del final pero no exactamente al borde. El objetivo es que dibujes el mapa de pacing de un nivel completo, con sus encuentros y descansos ubicados con intención.

La analogía útil es la música: una canción que suena a todo volumen de principio a fin cansa el oído, igual que un nivel que grita sin parar cansa al jugador. El silencio da valor al sonido y la calma da valor a la tensión. Un buen diseñador de niveles compone como un músico: coloca los momentos fuertes donde más impacten y protege esos picos con la quietud que los rodea.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. **Describir** la estructura de un nivel como introducción, desarrollo, clímax y remate.
2. **Trazar** una curva de intensidad con picos y valles equilibrados.
3. **Ubicar** descansos deliberados tras los momentos de máxima tensión.
4. **Regular** la densidad de encuentros para evitar monotonía y fatiga.
5. **Diseñar** el mapa de pacing de un nivel con encuentros y descansos por tramo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Tensión y descanso | El contraste sostiene el interés |
| 2 | Curva de intensidad | Visualiza el ritmo del nivel |
| 3 | Picos y valles | Estructuran la experiencia emocional |
| 4 | Estructura dramática | Da forma de historia al recorrido |
| 5 | Clímax | Concentra el mayor reto y satisfacción |
| 6 | Remate (cooldown) | Cierra sin dejar al jugador exhausto |
| 7 | Densidad de encuentros | Controla la carga por tramo |
| 8 | Variación de mecánicas | Evita la repetición fatigante |

## 📖 Definiciones y características

- **Pacing (ritmo)**: alternancia planificada de intensidad a lo largo del nivel. Clave: evita fatiga y aburrimiento.
- **Curva de intensidad**: gráfico de la tensión percibida por tramo. Clave: herramienta para ver el ritmo de un vistazo.
- **Pico (peak)**: momento de máxima tensión (combate, salto difícil, jefe). Clave: genera adrenalina y logro.
- **Valle (valley)**: momento de calma (exploración, narrativa, recolección). Clave: recupera energía y da contraste.
- **Estructura dramática**: introducción → desarrollo → clímax → remate. Clave: da forma reconocible al recorrido.
- **Clímax**: el pico más alto, cerca del final. Clave: cúspide emocional del nivel.
- **Remate (cooldown)**: descenso tras el clímax que cierra la experiencia. Clave: evita terminar en agotamiento.
- **Densidad de encuentros**: cantidad de retos por unidad de espacio o tiempo. Clave: regula la carga cognitiva y física.

## 🧰 Herramientas y preparación

Trabajarás con papel o una herramienta de dibujo simple; puedes trazar la curva a mano o en una hoja de cálculo asignando un valor de intensidad (1-10) por tramo. Excalidraw <https://excalidraw.com> sirve para el diagrama. Elige un nivel que conozcas para analizar su ritmo. Como referencia teórica usa el capítulo de pacing de Scott Rogers, *Level Up!* <https://www.wiley.com>, y el concepto de "curva de intensidad" tal como lo popularizó el diseño de niveles de *Half-Life* y lo describe la comunidad de Valve/Level Design; un buen resumen accesible está en los análisis de pacing de Game Maker's Toolkit <https://www.youtube.com/c/MarkBrownGMT>. El laboratorio es analítico: producirás un gráfico de intensidad y una tabla, sin código.

## 🧪 Laboratorio guiado

Diseñarás el mapa de pacing de un nivel: dividirás el nivel en tramos, asignarás intensidad a cada uno y colocarás encuentros y descansos formando una curva con clímax y remate. El entregable es `pacing-nivel.md` con la curva y la tabla.

**Paso 1 — Define el nivel y divídelo en tramos.** Elige un nivel (propio o a diseñar) y córtalo en 6-10 tramos secuenciales (T1, T2, …). Anota qué pasa en cada uno.

**Paso 2 — Asigna intensidad a cada tramo.** Puntúa de 1 (calma total) a 10 (tensión máxima). El clímax debe ser el valor más alto y estar cerca del final, no al borde:

```text
Tramo  Intensidad
T1        2   (introducción, movimiento seguro)
T2        5   (primer combate)
T3        3   (descanso, exploración)
T4        6   (plataformeo tenso)
T5        4   (respiro + narrativa)
T6        8   (oleada de enemigos)
T7        9   (clímax / mini-jefe)
T8        3   (remate: salida tranquila)
```

**Paso 3 — Traza la curva.** Dibuja los puntos y únelos. Debes ver subidas (picos) y bajadas (valles) alternadas, un clímax marcado y un descenso final (remate).

**Paso 4 — Coloca encuentros y descansos.** Rellena la tabla asociando cada tramo con su contenido:

```markdown
| Tramo | Intensidad | Tipo      | Contenido                     |
|-------|-----------|-----------|-------------------------------|
| T1    | 2         | descanso  | tutorial de movimiento        |
| T2    | 5         | pico      | 3 enemigos básicos            |
| T3    | 3         | descanso  | sala de exploración con loot  |
| ...   | ...       | ...       | ...                           |
```

**Paso 5 — Revisa la densidad.** Comprueba que no hay dos picos altos seguidos sin valle entre medias ni una llanura larga sin variación. Ajusta si detectas monotonía.

**Paso 6 — Lee la curva en voz alta.** Recorre tu gráfico narrando la experiencia como si contaras una historia: "empieza tranquilo, sube al primer combate, respira, tensa de nuevo, estalla en el clímax y cierra en calma". Si la narración suena plana o caótica al contarla, la curva necesita ajuste antes de justificarla.

**Paso 7 — Justifica el clímax y el remate.** Escribe un párrafo explicando por qué situaste el clímax donde está y qué función cumple el remate final para el jugador. Añade qué cambiarías si este nivel fuera el último de un juego (un clímax mayor, un remate más largo) frente a uno intermedio.

**Checklist del entregable:**

- [ ] El nivel está dividido en 6-10 tramos con intensidad numérica.
- [ ] La curva muestra al menos dos picos y dos valles alternados.
- [ ] El clímax es el valor máximo y está cerca (no al borde) del final.
- [ ] Hay un remate descendente tras el clímax.
- [ ] No hay dos picos altos consecutivos sin valle intermedio.
- [ ] El párrafo justifica la posición del clímax y la función del remate.

## ✍️ Ejercicios

1. Traza la curva de intensidad de un nivel que conozcas y marca su clímax.
2. Detecta un nivel con dos picos seguidos sin descanso y propón dónde insertar un valle.
3. Diseña un remate de tres tramos que baje la tensión sin aburrir tras un jefe.
4. Varía la mecánica de dos picos consecutivos para que no se sientan repetitivos.
5. Ajusta la densidad de encuentros de un tramo saturado sin cambiar su intensidad total.
6. Compara el pacing de un nivel de acción con el de uno de exploración y describe la diferencia.

## 📝 Reto verificable

Entrega `pacing-nivel.md` con: el nivel dividido en 6-10 tramos, la intensidad asignada a cada uno, la curva trazada (a mano o en hoja), la tabla de encuentros/descansos y el párrafo que justifica clímax y remate.

**Criterio de aceptación**: el nivel tiene entre 6 y 10 tramos con intensidad numérica; la curva muestra al menos dos picos y dos valles alternados, un clímax que es el máximo y está cerca (no al final absoluto) del cierre, y un remate descendente; no hay dos picos altos consecutivos sin valle intermedio; el párrafo justifica coherentemente la posición del clímax y la función del remate.

## ⚠️ Errores comunes

| Síntoma | Causa y cómo arreglar |
|---------|-----------------------|
| El nivel agota al jugador | Picos encadenados sin descanso. Inserta valles entre los momentos de máxima tensión. |
| El nivel aburre | Llanura larga de baja intensidad. Añade picos y varía las mecánicas. |
| Final anticlimático | El clímax llegó demasiado pronto o falta. Coloca el pico máximo cerca del cierre. |
| Terminar en agotamiento | No hay remate. Añade un cooldown que baje la tensión antes de acabar. |
| Todo se siente igual | Baja variación de mecánicas. Alterna tipos de encuentro y reto. |
| Dificultad percibida errática | Densidad de encuentros desigual sin intención. Regula la carga por tramo. |

## ❓ Preguntas frecuentes

**❓ ¿El clímax debe ser siempre un jefe?** No necesariamente. Puede ser una oleada intensa, una secuencia de plataformeo al límite o una persecución. Lo esencial es que sea el punto de mayor tensión del nivel.

**❓ ¿Por qué no terminar justo en el clímax?** Porque un descenso breve (remate) da cierre emocional y evita dejar al jugador exhausto. Es el equivalente al desenlace tras el punto álgido de una historia.

**❓ ¿Cuántos picos debe tener un nivel?** No hay número fijo; depende de la duración. La regla útil es que cada pico vaya seguido de un valle y que la tendencia general suba hacia el clímax.

**❓ ¿El pacing es lo mismo que la dificultad?** Están relacionados pero no son iguales. La dificultad es cuán difícil es superar un reto; el pacing es cómo se distribuye la intensidad emocional, que incluye tensión, calma y variedad, no solo dificultad.

## 🔗 Referencias

- Scott Rogers, *Level Up! The Guide to Great Video Game Design* — <https://www.wiley.com>
- Game Maker's Toolkit (pacing y curvas de intensidad) — <https://www.youtube.com/c/MarkBrownGMT>
- Jesse Schell, *The Art of Game Design: A Book of Lenses* (3ª ed.) — <https://www.schellgames.com>
- Tracy Fullerton, *Game Design Workshop* (4ª ed.) — CRC Press

## ➡️ Siguiente clase

[Clase 167 - Diseño de niveles con propósito y el bucle greybox](../167-diseno-de-niveles-con-proposito-y-el-bucle-greybox/README.md)
