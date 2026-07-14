# Clase 159 — Sistemas, feedback y bucles

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Donella Meadows, "Thinking in Systems"; Salen & Zimmerman, "Rules of Play"*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego es un **sistema**: un conjunto de partes que se afectan mutuamente. Y en todo sistema aparecen **bucles de feedback**, que son la razón de que unos juegos se sientan justos y emocionantes y otros se vuelvan aplastantes o eternos. Un **bucle positivo** (bola de nieve) amplifica las ventajas: quien va ganando gana más rápido, lo que puede cerrar la partida antes de tiempo. Un **bucle negativo** (catch-up) frena al líder y ayuda al rezagado, manteniendo la tensión, pero si es demasiado fuerte castiga la habilidad.

En esta clase aprenderás a pensar en sistemas, a identificar bucles de feedback positivo y negativo en juegos reales, y a razonar sobre la **estabilidad**: cuándo un juego tiende al empate perpetuo y cuándo a la victoria aplastante. El entregable es un mapa de bucles de un juego con al menos un balanceador propuesto —como el clásico **rubber-banding**— para corregir un bucle problemático.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Describir un juego como un sistema de elementos interconectados con flujos.
2. Distinguir bucles de feedback positivo (amplificadores) de negativos (estabilizadores).
3. Identificar bucles de feedback existentes en un juego que conozca.
4. Predecir el efecto de un bucle sobre la duración y la tensión de la partida.
5. Proponer un balanceador (rubber-banding u otro) para corregir un bucle problemático.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Pensamiento sistémico | Un juego es más que la suma de sus reglas. |
| 2 | Elementos, flujos y stocks | Vocabulario para modelar cualquier sistema. |
| 3 | Bucle de feedback positivo | Amplifica ventajas: emoción o desbalance. |
| 4 | Bucle de feedback negativo | Estabiliza: tensión o castigo a la habilidad. |
| 5 | Efecto bola de nieve | Cierra partidas y desincentiva remontar. |
| 6 | Catch-up y rubber-banding | Mantiene la partida viva y reñida. |
| 7 | Estabilidad del sistema | ¿Tiende al empate o a la victoria aplastante? |
| 8 | Combinar bucles | El buen diseño usa ambos a distintas escalas. |

## 📖 Definiciones y características

- **Sistema**: conjunto de elementos interconectados cuyo comportamiento global emerge de sus interacciones. Clave: no se entiende viendo las partes por separado.
- **Stock**: cantidad acumulada en el sistema (oro, vida, territorio). Clave: cambia por flujos de entrada y salida.
- **Bucle de feedback positivo**: un efecto que se refuerza a sí mismo (más A produce más A). Clave: acelera divergencias, "el rico se hace más rico".
- **Bucle de feedback negativo**: un efecto que se autocorrige (más A frena A). Clave: busca el equilibrio, estabiliza el sistema.
- **Efecto bola de nieve**: acumulación de ventaja irreversible por un bucle positivo. Clave: puede volver aburrido el final de partida.
- **Rubber-banding**: balanceador que ayuda al que va perdiendo y frena al líder. Clave: es un bucle negativo deliberado para mantener la tensión.
- **Estabilidad**: tendencia del sistema al equilibrio o a la divergencia. Clave: define si las partidas se cierran o se estancan.
- **Punto de apalancamiento**: lugar del sistema donde una pequeña intervención produce gran cambio. Clave: es donde conviene tocar para balancear.

## 🧰 Herramientas y preparación

El trabajo es de modelado conceptual, así que la herramienta principal es un **diagrama de bucles causales**: cajas (elementos), flechas con signo (+ si refuerza, − si frena) y bucles marcados como R (reinforcing/positivo) o B (balancing/negativo). Puedes hacerlo en papel o en **Excalidraw**. Elige un juego competitivo o con progresión clara (un MOBA, un juego de carreras, un 4X, un deportivo) porque los bucles se ven mejor donde hay ventaja acumulable.

Dibuja en <https://excalidraw.com>. Como fundamento de pensamiento sistémico, el libro de Donella Meadows es la referencia; hay un resumen accesible en <https://donellameadows.org/systems-thinking-resources/>.

## 🧪 Laboratorio guiado

Vas a producir un **mapa de bucles de feedback** de un juego y a diseñar un balanceador.

1. Elige el juego y su recurso de ventaja principal (oro, kills, territorio, posición en carrera).

2. **Identifica los stocks clave.** Anota 2-4 cantidades que se acumulan y determinan quién va ganando.

3. **Dibuja los enlaces causales.** Conecta con flechas los elementos e indica el signo:

```text
   Matar enemigos  ──(+)──►  Más oro
        ▲                        │
        │(+)                     ▼(+)
   Mejor equipo  ◄──(+)──  Comprar mejoras
   (Bucle R: refuerzo → bola de nieve)
```

4. **Clasifica cada bucle.** Recórrelo: si al dar la vuelta el efecto se refuerza, es **R (positivo)**; si se frena, es **B (negativo)**. Márcalo.

5. Rellena esta tabla de inventario de bucles:

| Bucle | Elementos | Tipo (R/B) | Efecto en la partida | ¿Problemático? |
|-------|-----------|------------|----------------------|----------------|
| Ej.: oro→equipo→más kills | kills, oro, equipo | R | Bola de nieve, cierra partida | Sí, muy fuerte |
| Ej.: bounty al líder→oro al rival | ventaja, recompensa | B | Ayuda a remontar, mantiene tensión | No, deseado |
| Ej.: morir→respawn con retraso | muertes, tiempo fuera | B | Castiga errores, frena al que va perdiendo | Sí, si es excesivo |
| … | | | | |

6. **Diagnóstico de estabilidad.** ¿El sistema tiende a la bola de nieve (un R dominante) o al empate perpetuo (un B dominante)? Escribe una frase.

7. **Diseña un balanceador.** Elige el bucle problemático y añade un bucle B que lo compense. Ejemplos: bounty extra por matar al líder (rubber-banding), recompensas de catch-up, costes crecientes para el que domina. Descríbelo y di sobre qué punto de apalancamiento actúa.

8. **Predice el efecto.** ¿Cómo cambia la duración y la tensión de la partida tras tu balanceador? Advierte del riesgo: un rubber-banding demasiado fuerte castiga la habilidad y frustra al buen jugador.

9. **Simula mentalmente dos partidas.** Recorre el sistema imaginando una partida donde un jugador toma ventaja temprana y otra donde ambos van parejos. ¿Tu balanceador mantiene viva la primera sin volver irrelevante la segunda? Anota el resultado; si el balanceador solo funciona en un escenario, necesita ajuste.

10. Guarda diagrama + tabla + balanceador + notas de simulación como entregable.

Con esto ya lees cualquier juego como un sistema de bucles, no como una lista de reglas sueltas.

## ✍️ Ejercicios

1. Identifica el bucle de bola de nieve más famoso de un MOBA o RTS que conozcas y dibújalo.
2. Encuentra un juego con rubber-banding evidente (carreras) y discute si te parece justo o tramposo.
3. Diseña un bucle negativo para un juego de mesa donde el líder siempre gana sin remontada posible.
4. Explica por qué demasiado feedback negativo puede volver una partida aburrida (empate perpetuo).
5. Toma el juego del laboratorio y propón un bucle positivo nuevo que aumente la emoción sin cerrar la partida antes de tiempo.
6. Clasifica la regeneración de vida de un shooter como bucle B y discute cómo afecta al ritmo de combate.

## 📝 Reto verificable

Entrega el mapa de bucles de un juego con al menos dos bucles identificados (uno R y uno B), la tabla de inventario, el diagnóstico de estabilidad y el diseño de un balanceador para el bucle más problemático, incluyendo la predicción de su efecto y una advertencia de su riesgo si se exagera.

**Criterio de aceptación**: cada bucle está clasificado como R o B con su recorrido justificado (no solo etiquetado), el diagnóstico afirma explícitamente hacia dónde tiende el sistema, y el balanceador propuesto es un bucle B/R concreto que actúa sobre un elemento nombrado, con una predicción de efecto y su riesgo de sobrecorrección.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El diagrama es una lista de reglas sin ciclos | No trazaste el retorno. Un bucle debe volver sobre sí mismo; sigue las flechas hasta cerrar el ciclo. |
| Confundes bucle positivo con "cosa buena" | Positivo/negativo se refiere a refuerzo/estabilización, no a bueno/malo. Un bucle positivo puede arruinar la partida. |
| El rubber-banding hace que ganar no importe | Balanceador demasiado fuerte. Redúcelo hasta que ayude a remontar pero no borre la ventaja de jugar bien. |
| Las partidas terminan en empates eternos | Domina el feedback negativo. Introduce un bucle positivo o una condición de cierre temporal. |
| Solo detectas un tipo de bucle | Casi todo juego tiene ambos. Busca deliberadamente los estabilizadores y los amplificadores. |
| El balanceador borra por completo la ventaja del líder | Sobrecorrección: el bucle B anula el mérito. Escálalo con la brecha (más ayuda cuanto mayor la diferencia) en vez de aplicarlo plano. |

## ❓ Preguntas frecuentes

**❓ ¿Todos los juegos necesitan rubber-banding?** No. Los juegos que premian la maestría (ajedrez, fighting games) suelen evitarlo. Es útil sobre todo en juegos casuales o para varios jugadores donde quieres partidas reñidas hasta el final.

**❓ ¿Un bucle positivo siempre es malo?** No. Aporta emoción y sensación de poder; el problema es cuando es tan fuerte que decide la partida demasiado pronto. La clave es su magnitud, no su existencia.

**❓ ¿Cómo sé si mi sistema es estable?** Simula o juega varias partidas: si la ventaja inicial casi siempre decide el resultado, domina un bucle positivo; si nadie logra cerrar nunca, domina uno negativo.

**❓ ¿Dónde conviene intervenir para balancear un sistema?** En su punto de apalancamiento: el enlace donde un pequeño cambio propaga gran efecto. Suele ser la fuente que alimenta el bucle problemático, no el síntoma final. Toca la causa, no la consecuencia.

## 🔗 Referencias

- Donella Meadows — Thinking in Systems (recursos): <https://donellameadows.org/systems-thinking-resources/>
- Salen & Zimmerman — Rules of Play: <https://mitpress.mit.edu/9780262240451/rules-of-play/>
- GDC Vault — feedback loops y system design: <https://www.gdcvault.com>
- Game Balance Concepts (Ian Schreiber): <https://gamebalanceconcepts.wordpress.com>

## ➡️ Siguiente clase

[Clase 160 - Curvas de dificultad y progresión](../160-curvas-de-dificultad-y-progresion/README.md)
