# Clase 160 — Curvas de dificultad y progresión

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Mihály Csíkszentmihályi, "Flow"; Schell, "The Art of Game Design"*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego demasiado fácil aburre; uno demasiado difícil frustra. Entre ambos hay un corredor estrecho donde el jugador está completamente absorto: el **flow** de Csíkszentmihályi, el estado en que el reto y la habilidad crecen juntos. Diseñar la **curva de dificultad** es mantener al jugador dentro de ese corredor mientras su habilidad mejora, y no es una línea recta: los buenos juegos suben en **dientes de sierra** —picos de tensión seguidos de valles de respiro— para que la dificultad se sienta como un pulso, no como una cuesta agotadora.

En esta clase entenderás el canal del flow, la diferencia entre **progresión de poder** (el jugador se vuelve más fuerte) y **progresión de reto** (los desafíos crecen), y por qué ambas deben avanzar acompasadas. El entregable es una curva de dificultad tabulada de 10 niveles, ajustada para mantener el flow, con sus dientes de sierra explícitos.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar el canal del flow como el equilibrio entre reto y habilidad.
2. Distinguir progresión de poder de progresión de reto y relacionarlas.
3. Tabular una curva de dificultad nivel a nivel con valores numéricos.
4. Aplicar el patrón de dientes de sierra para intercalar tensión y respiro.
5. Ajustar una curva que se sale del flow (aburre o frustra) hasta corregirla.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El estado de flow | Es el objetivo emocional de la curva. |
| 2 | Canal ansiedad-aburrimiento | Define los límites entre los que mantener al jugador. |
| 3 | Curva de dificultad | El plan de cómo crece el reto en el tiempo. |
| 4 | Dientes de sierra | Tensión y respiro alternados dan mejor ritmo. |
| 5 | Progresión de poder | El jugador se fortalece y sube su habilidad. |
| 6 | Progresión de reto | Los desafíos deben crecer con el jugador. |
| 7 | Desfase poder-reto | Origen del aburrimiento o la frustración. |
| 8 | Ajuste y opciones de dificultad | Distintos jugadores, distintos canales de flow. |

## 📖 Definiciones y características

- **Flow**: estado de concentración plena donde el reto iguala a la habilidad. Clave: es la sensación que buscas producir a lo largo de todo el juego.
- **Canal del flow**: banda entre la ansiedad (reto > habilidad) y el aburrimiento (habilidad > reto). Clave: la curva debe zigzaguear dentro de ella.
- **Curva de dificultad**: representación de cómo crece el reto a lo largo del juego. Clave: rara vez es lineal; sube con altibajos.
- **Dientes de sierra**: patrón de picos de dificultad seguidos de valles de alivio. Clave: el respiro hace que el siguiente pico se sienta más intenso.
- **Progresión de poder**: aumento de las capacidades del jugador (stats, ítems, destreza). Clave: sin ella el juego se estanca en dificultad percibida.
- **Progresión de reto**: aumento de la exigencia de los desafíos. Clave: debe crecer junto al poder o el flow se rompe.
- **Pico de dificultad (spike)**: subida brusca y no intencional del reto. Clave: causa frustración y abandono si no se avisa ni se recompensa.
- **Curva de aprendizaje**: ritmo al que el jugador adquiere habilidad. Clave: la dificultad debe seguir a la curva de aprendizaje, no adelantarla.

## 🧰 Herramientas y preparación

La herramienta central es una **hoja de cálculo** donde tabular, nivel a nivel, la dificultad de reto, el poder del jugador y su diferencia (la "tensión percibida"), y graficar la curva resultante. Cualquier hoja con gráfico de líneas sirve. Elige un juego con niveles o etapas discretas (plataformas, un roguelike por pisos, un shooter por oleadas) para tener 10 puntos claros que tabular.

Usa Google Sheets en <https://sheets.google.com> o Calc de <https://www.libreoffice.org>. Como fundamento del flow, revisa el resumen del modelo de Csíkszentmihályi en <https://en.wikipedia.org/wiki/Flow_(psychology)>.

## 🧪 Laboratorio guiado

Vas a producir una **curva de dificultad de 10 niveles** ajustada para mantener el flow.

1. Elige el juego y define una **escala de dificultad de 1 a 10** para el reto (1 = trivial, 10 = extremo). Define también una escala equivalente para el **poder del jugador**.

2. Rellena esta tabla con tu diseño inicial (los valores son de ejemplo; pon los tuyos):

| Nivel | Reto (1-10) | Poder jugador (1-10) | Tensión = Reto − Poder | ¿Pico o valle? | Nota de ritmo |
|-------|-------------|----------------------|------------------------|----------------|---------------|
| 1 | 2 | 1 | +1 | valle | tutorial suave |
| 2 | 3 | 2 | +1 | subida | introduce enemigo A |
| 3 | 5 | 3 | +2 | pico | mini-jefe |
| 4 | 3 | 4 | −1 | valle | respiro, loot |
| 5 | 6 | 5 | +1 | subida | combina A+B |
| 6 | 8 | 6 | +2 | pico | jefe de zona |
| 7 | 4 | 7 | −3 | valle | respiro fuerte, recompensa |
| 8 | 7 | 7 | 0 | subida | nueva mecánica C |
| 9 | 8 | 8 | 0 | subida | combina B+C |
| 10 | 9 | 8 | +1 | pico | jefe final |

3. **Grafica** el reto y el poder como dos líneas sobre los 10 niveles. Observa el corredor entre ambas.

4. **Diagnóstico de flow.** Marca los niveles donde `Tensión` es muy positiva (riesgo de ansiedad/frustración) o muy negativa (riesgo de aburrimiento). El flow ideal mantiene la tensión oscilando en un rango estrecho y positivo (p. ej. entre 0 y +2).

5. **Aplica dientes de sierra.** Verifica que cada 2-3 niveles de subida haya un valle de respiro. Si la curva es una rampa monótona, introduce valles: un nivel más fácil tras un jefe hace que el siguiente pico luzca más.

6. **Acompasa poder y reto.** Si en algún nivel el poder crece más rápido que el reto durante mucho tiempo, el juego aburre: sube el reto. Si el reto se dispara sin que el poder acompañe, frustra: da un ítem, un checkpoint o baja el pico.

7. **Ajusta y reitera.** Modifica los valores hasta que la tensión se mantenga en el corredor deseado a lo largo de los 10 niveles, conservando al menos dos picos y dos valles claros.

8. **Marca la introducción de mecánicas.** En la columna de notas de ritmo, señala en qué nivel entra cada mecánica nueva. Una buena curva no solo sube números: introduce un concepto, da un valle para practicarlo y luego lo combina con lo anterior en un pico. Verifica que ningún nivel exija dominar dos mecánicas nuevas a la vez, porque eso dispara la dificultad percibida por encima de la nominal.

9. **Anota los riesgos de abandono.** Para cada pico, escribe si un jugador podría abandonar ahí y qué red de seguridad tiene (checkpoint, pista, ítem). Los picos sin red son los que más jugadores pierden.

10. Guarda la tabla, el gráfico y un párrafo explicando qué ajustaste y por qué. Ese es el entregable.

Con esto tienes el método para ritmar la dificultad de cualquier juego sin depender solo de la intuición.

> **Consejo de práctica.** La dificultad que el jugador *percibe* no siempre coincide con la que *diseñaste*: una mecánica nueva sube la dificultad percibida aunque los números no cambien. Reserva los picos numéricos para niveles donde el jugador ya domine las mecánicas, y usa los valles para enseñar las nuevas.

## ✍️ Ejercicios

1. Tabula la curva de dificultad real de los primeros niveles de un juego que conozcas y señala sus dientes de sierra.
2. Encuentra un juego con un pico de dificultad injusto y propón cómo suavizarlo sin quitar el desafío.
3. Diseña dos curvas para el mismo juego: una para modo "fácil" y otra para "difícil", desplazando el canal de flow.
4. Explica con un ejemplo por qué dar demasiado poder al jugador demasiado pronto rompe el flow.
5. Convierte una rampa lineal de dificultad en dientes de sierra manteniendo la dificultad final igual.
6. Diseña el respiro (valle) ideal justo después del jefe final de un juego: ¿qué debería sentir el jugador?

## 📝 Reto verificable

Entrega la tabla de curva de dificultad de 10 niveles con reto, poder y tensión por nivel, el gráfico de las dos curvas, y un párrafo de ajuste que documente al menos dos cambios hechos para mantener el flow (por ejemplo, "bajé el reto del nivel 7 de 9 a 6 para crear un valle tras el jefe del nivel 6").

**Criterio de aceptación**: la curva tiene al menos dos picos y dos valles identificados (no es monótona), la columna de tensión está calculada como reto menos poder, ningún nivel deja una tensión extrema sin justificación de diseño, y el párrafo de ajuste explica el porqué de cada cambio en términos de flow, no solo el qué.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| La curva sube en línea recta y el juego cansa | Falta el patrón de dientes de sierra. Intercala valles de respiro cada 2-3 subidas. |
| Un nivel frustra a casi todos los jugadores | Pico de dificultad sin aviso ni recompensa. Baja el pico, añade un checkpoint o da poder antes. |
| El jugador se aburre tras conseguir cierto ítem | Progresión de poder adelantó a la de reto. Sube el reto para volver al canal del flow. |
| La tabla no tiene números, solo "fácil/difícil" | Sin escala numérica no puedes ver el corredor. Asigna valores 1-10 para poder graficar y comparar. |
| Todos los niveles tienen la misma tensión plana | Falta variación de ritmo. Un flow bueno oscila; añade contrastes de tensión controlados. |
| El jugador experto se aburre y el novato se frustra con la misma curva | Un único canal de flow no sirve para todos. Ofrece niveles de dificultad o escalado que desplacen la curva por perfil de jugador. |

## ❓ Preguntas frecuentes

**❓ ¿La curva de dificultad debe ser siempre creciente?** En tendencia sí, pero no monótona. Debe subir globalmente con valles intercalados; los descansos son parte del diseño, no un error.

**❓ ¿El flow es igual para todos los jugadores?** No. Un experto y un novato tienen canales de flow distintos. Por eso existen niveles de dificultad, ayudas opcionales o escalado dinámico: para mover el canal según el jugador.

**❓ ¿Progresión de poder y de reto son lo mismo?** No. El poder es cuánto puede el jugador; el reto es cuánto exige el juego. El flow depende de la diferencia entre ambos, así que hay que diseñarlos juntos.

**❓ ¿Cómo mido la dificultad real sin telemetría?** Con playtesting: cuenta muertes por nivel, tiempo de superación y en qué punto la gente abandona. Esos datos revelan los picos ocultos que tu escala 1-10 estimada no capturó y te dicen dónde ajustar la curva.

## 🔗 Referencias

- Mihály Csíkszentmihályi — modelo de Flow: <https://en.wikipedia.org/wiki/Flow_(psychology)>
- Jesse Schell — The Art of Game Design: <https://www.schellgames.com/art-of-game-design>
- GDC Vault — difficulty y pacing: <https://www.gdcvault.com>
- Game Maker's Toolkit — dificultad y flow: <https://www.youtube.com/c/MarkBrownGMT>

## ➡️ Siguiente clase

[Clase 161 - Balanceo de juego: números, spreadsheets y tuning](../161-balanceo-de-juego-numeros-spreadsheets-y-tuning/README.md)
