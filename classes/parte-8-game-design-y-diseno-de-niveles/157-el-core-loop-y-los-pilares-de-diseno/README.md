# Clase 157 — El core loop y los pilares de diseño

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Schell, "The Art of Game Design"; Fullerton, "Game Design Workshop"*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Si abres cualquier juego que te enganche y observas qué haces minuto a minuto, verás un patrón que se repite: actúas, recibes una respuesta, avanzas un poco, y vuelves a actuar. Ese patrón es el **core loop**, el latido del juego. Un core loop bien diseñado es adictivo por sí solo, incluso con gráficos de caja gris; uno roto no lo salva ningún arte. Diseñar el core loop es, probablemente, la decisión más importante de todo el proyecto.

En esta clase descompondrás el core loop en su ciclo mínimo **acción → recompensa → progreso**, verás cómo se anidan **loops de distinta escala** (el loop de segundos, el de minutos y el de sesión/horas) y aprenderás a fijar **pilares de diseño**: 3-5 principios que actúan como brújula para decidir, ante cualquier duda, qué entra y qué se descarta. El entregable es un diagrama del core loop de un juego propio y sus tres pilares escritos.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Descomponer un core loop en el ciclo acción → recompensa → progreso.
2. Identificar y diagramar loops anidados de segundos, minutos y sesión.
3. Distinguir un core loop sano de uno roto (sin recompensa, sin progreso o sin cierre).
4. Redactar 3-5 pilares de diseño que sirvan de criterio de decisión.
5. Usar los pilares para aceptar o rechazar una feature propuesta de forma argumentada.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es el core loop | Es la actividad que el jugador repite todo el juego. |
| 2 | Ciclo acción → recompensa → progreso | El átomo de todo loop enganchante. |
| 3 | Loops anidados por escala temporal | Explica el enganche de segundos, minutos y horas. |
| 4 | El loop de sesión (meta-loop) | Es lo que hace volver al jugador mañana. |
| 5 | Diagnóstico de loops rotos | La mayoría de juegos aburridos fallan aquí. |
| 6 | Pilares de diseño | Brújula para decidir qué entra y qué no. |
| 7 | Pilares como filtro de features | Evita el scope creep y las decisiones por capricho. |
| 8 | Coherencia loop-pilares | El loop debe encarnar los pilares, no contradecirlos. |

## 📖 Definiciones y características

- **Core loop**: la secuencia de acciones que el jugador repite continuamente y que define la experiencia. Clave: si es aburrido repetido 100 veces, el juego es aburrido.
- **Acción**: la entrada significativa del jugador dentro del loop (disparar, colocar, decidir). Clave: debe ser intencional, no ruido.
- **Recompensa**: la respuesta positiva inmediata a la acción (feedback, puntos, loot). Clave: cierra el bucle y motiva la repetición.
- **Progreso**: el avance persistente que deja la vuelta del loop (nivel, poder, desbloqueo). Clave: da sentido a repetir; sin él, el loop se siente vacío.
- **Loop anidado**: un loop contenido dentro de otro de mayor escala temporal. Clave: el de segundos alimenta al de minutos, que alimenta al de sesión.
- **Loop de sesión (meta-loop)**: el ciclo que motiva cerrar el juego con ganas de volver. Clave: es la clave de la retención a largo plazo.
- **Pilar de diseño**: principio corto e innegociable que define la identidad del juego. Clave: sirve para decir "no" a ideas que lo contradicen.
- **Scope creep**: crecimiento descontrolado de features fuera de la visión. Clave: los pilares son la defensa principal contra él.

## 🧰 Herramientas y preparación

Para diagramar el loop basta papel y lápiz o una herramienta de diagramas libre como **Excalidraw** o **draw.io**; lo importante es representar ciclos con flechas que vuelven al inicio, no la estética. Ten en mente un juego propio (aunque sea una idea de una frase) para aplicar todo sobre él. Si no tienes idea propia, usa un juego existente y "ingeniería inversa" su loop.

Diagrama en <https://excalidraw.com> o <https://app.diagrams.net>. Como lectura de apoyo sobre pilares y visión de diseño, revisa las charlas de la GDC en <https://www.gdcvault.com> buscando "design pillars".

## 🧪 Laboratorio guiado

Vas a producir un **diagrama de core loop anidado** y una **hoja de pilares** para un juego propio.

1. Escribe en una frase la fantasía central del juego ("ser un ninja sigiloso", "gestionar una granja", "sobrevivir a hordas"). Esto orienta todo lo demás.

2. Identifica la **acción central**: el verbo que el jugador ejecuta más veces por minuto. Anótalo.

3. Dibuja el **loop de segundos** como un ciclo cerrado con tres nodos:

```text
   ┌─────────────┐
   │   ACCIÓN     │  (ej.: disparar a un enemigo)
   └──────┬──────┘
          ▼
   ┌─────────────┐
   │ RECOMPENSA   │  (ej.: efecto, daño, oro)
   └──────┬──────┘
          ▼
   ┌─────────────┐
   │  PROGRESO    │  (ej.: enemigo muere, avanzas)
   └──────┬──────┘
          └────────► vuelve a ACCIÓN
```

4. Dibuja el **loop de minutos** que envuelve al anterior: qué objetivo de mediano plazo persigue el jugador (completar una oleada, limpiar una sala, cumplir un pedido) y qué recompensa/progreso da al cerrarse.

5. Dibuja el **loop de sesión**: qué hace que el jugador quiera volver mañana (subir de nivel meta, desbloquear personaje, avanzar en la historia).

6. Rellena esta tabla de coherencia:

| Escala | Acción típica | Recompensa | Progreso persistente | ¿Motiva la siguiente vuelta? |
|--------|---------------|------------|----------------------|------------------------------|
| Segundos | | | | |
| Minutos | | | | |
| Sesión | | | | |

7. Redacta **3 pilares de diseño**. Cada pilar es una frase corta y accionable. Ejemplo para un stealth: "El sigilo siempre gana al combate", "El jugador nunca muere sin saber por qué", "Cada nivel se puede resolver de tres formas".

8. Aplica los pilares como filtro: escribe **dos features candidatas**, una que un pilar acepte y otra que un pilar rechace, y justifica la decisión. Este contraste demuestra que tus pilares realmente sirven para decidir.

9. Guarda diagrama + tabla + pilares como entregable.

Con esto tienes la columna vertebral del juego: un latido claro y una brújula para no perder el rumbo.

## ✍️ Ejercicios

1. Haz ingeniería inversa del core loop de un juego que juegues a diario y dibújalo en las tres escalas.
2. Encuentra un juego cuyo loop de segundos sea genial pero cuyo loop de sesión sea débil, y explica por qué lo abandonaste.
3. Reescribe uno de tus tres pilares para que sea más específico y más fácil de aplicar como filtro.
4. Propón una feature popular (crafteo, multijugador) y decide con tus pilares si entra o no; argumenta.
5. Toma el juego del laboratorio y elimina mentalmente la recompensa del loop de segundos: describe cómo cambia la sensación.
6. Diseña un loop de sesión para un juego que hoy no tenga razón para volver mañana.

## 📝 Reto verificable

Entrega el diagrama de core loop en tres escalas anidadas de un juego (propio o analizado), la tabla de coherencia completa y una hoja con 3-5 pilares. Añade un mini-registro de tres decisiones de diseño resueltas usando los pilares (feature, pilar aplicado, decisión).

**Criterio de aceptación**: los tres loops están dibujados como ciclos cerrados (la flecha vuelve al inicio), cada escala tiene acción + recompensa + progreso identificados, y al menos una de las tres decisiones registradas es un "no" argumentado por un pilar (rechazar una feature, no solo aceptarlas todas).

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El loop es una lista lineal, no un ciclo | Falta el retorno. Asegúrate de que la última flecha vuelva a la acción inicial: si no vuelve, no es un loop. |
| Hay acción y recompensa pero el juego cansa | Falta el progreso persistente. Añade algo que quede tras cada vuelta (poder, desbloqueo, avance). |
| Los pilares son genéricos ("que sea divertido") | No filtran nada. Reescríbelos como criterios que permitan decir "no" a features concretas. |
| Cinco pilares que se contradicen | Demasiados y sin jerarquía. Reduce a 3, ordénalos y resuelve las contradicciones. |
| El loop de sesión no existe | No hay razón para volver. Diseña una meta-progresión o un gancho de "mañana desbloqueo X". |

## ❓ Preguntas frecuentes

**❓ ¿Cuál es la diferencia entre core loop y gameplay?** El core loop es la estructura repetida (acción-recompensa-progreso); el gameplay es toda la experiencia. El loop es el esqueleto sobre el que cuelga el resto.

**❓ ¿Un juego puede tener varios core loops?** Puede tener loops anidados o paralelos (combate y economía, por ejemplo), pero suele haber uno dominante. Si hay varios sin jerarquía, el foco se dispersa.

**❓ ¿Cuántos pilares debo tener?** Entre 3 y 5. Menos de 3 no dan cobertura; más de 5 dejan de ser memorables y de servir como filtro rápido de decisiones.

**❓ ¿Los pilares se pueden cambiar durante el desarrollo?** Sí, pero rara vez y con mucha justificación. Cambiar un pilar suele implicar rediseñar el juego; por eso se fijan pronto y se defienden.

## 🔗 Referencias

- Jesse Schell — The Art of Game Design (lentes de la experiencia): <https://www.schellgames.com/art-of-game-design>
- Tracy Fullerton — Game Design Workshop: <https://www.gamedesignworkshop.com>
- GDC Vault — charlas sobre design pillars y core loops: <https://www.gdcvault.com>
- Excalidraw — herramienta de diagramas: <https://excalidraw.com>

## ➡️ Siguiente clase

[Clase 158 - Mecánicas, verbos y economía del jugador](../158-mecanicas-verbos-y-economia-del-jugador/README.md)
