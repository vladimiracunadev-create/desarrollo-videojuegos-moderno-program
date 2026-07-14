# Clase 285 — Playtesting formal y iteración con datos

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Charlas de GDC sobre playtesting y user research en videojuegos*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Aprender a probar tu juego con **personas que no lo conocen** y a convertir lo que observas en decisiones. El playtesting formal no es "que un amigo te diga si le gusta": es una sesión diseñada donde tú **observas y callas**, no guías ni defiendes, y donde recoges tanto lo que ves (comportamiento) como lo que el jugador reporta (encuesta). La regla de oro: si tienes que explicarle cómo se juega, el juego aún no lo explica.

Al terminar tendrás el **kit de playtest** de tu capstone: un guion de sesión, una lista de qué observar, una encuesta post-partida y una plantilla para registrar hallazgos y priorizarlos. Con eso podrás iterar con evidencia en lugar de con intuición o ego.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diseñar una sesión de playtest con objetivos claros y sin guiar al jugador.
2. Observar comportamiento y distinguir lo que el jugador hace de lo que dice.
3. Redactar una encuesta post-partida útil y no sesgada.
4. Recoger métricas simples que revelen dónde falla el juego.
5. Registrar hallazgos y priorizarlos por frecuencia y severidad.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Probar con desconocidos | Los conocidos te dan feedback amable e inútil. |
| 2 | No guiar durante la sesión | Si intervienes, mides tu ayuda, no tu juego. |
| 3 | Observar, no defender | Defenderte tapa el problema real. |
| 4 | Comportamiento vs opinión | Lo que hacen importa más que lo que dicen. |
| 5 | Encuestas sin sesgo | Preguntas mal hechas producen datos falsos. |
| 6 | Métricas simples | Los números revelan cuellos que no se ven. |
| 7 | Registro de hallazgos | Sin registro, el feedback se evapora. |
| 8 | Priorización | No todo se arregla; elige lo que más pesa. |

## 📖 Definiciones y características

- **Playtest formal**: sesión planificada para observar a jugadores nuevos con objetivos definidos. Clave: se prepara, no se improvisa.
- **Sesgo del creador**: tendencia a explicar y justificar el juego mientras alguien lo prueba. Clave: se combate callando y anotando.
- **Observación de comportamiento**: registrar qué hace el jugador (dónde duda, dónde muere, qué ignora). Clave: es la fuente de datos más honesta.
- **Pensar en voz alta (think-aloud)**: pedir al jugador que verbalice lo que piensa mientras juega. Clave: revela confusiones que la encuesta no capta.
- **Encuesta post-partida**: cuestionario breve tras jugar, con preguntas abiertas y escalas. Clave: evita preguntas que sugieren la respuesta.
- **Métrica**: dato cuantitativo del juego (tiempo por nivel, muertes, abandono). Clave: complementa la observación con números.
- **Severidad**: cuánto daña un problema a la experiencia. Clave: junto con la frecuencia, decide la prioridad.
- **Iteración basada en datos**: cambiar el juego según evidencia recogida, no según opiniones sueltas. Clave: cierra el ciclo probar → aprender → ajustar.

## 🧰 Herramientas y preparación

Necesitas una build jugable de tu slice y 3-5 personas que **no** hayan visto el juego (compañeros de otros grupos, familiares poco jugadores, gente de comunidades). Para la encuesta basta [Google Forms](https://forms.google.com/) o un papel. Para registrar comportamiento, una hoja impresa o una grabación de pantalla con [OBS Studio](https://obsproject.com/) si el testeador lo permite.

Si tu juego puede emitir un log simple (tiempo por nivel, número de muertes, si terminó), déjalo listo; unas pocas líneas de registro en archivo bastan y se apoyan en lo visto en partes anteriores. Prepara un espacio tranquilo y ensaya el guion para no caer en la tentación de ayudar.

## 🧪 Laboratorio guiado

Entregable: un `kit-playtest.md` (guion + qué observar + encuesta + plantilla de hallazgos) y los resultados de al menos 3 sesiones.

1. **Fija 2-3 objetivos de la sesión.** Ejemplos: "¿entienden el objetivo sin que se lo diga?", "¿dónde se atascan?", "¿terminan el nivel?". Todo lo que observes debe servir a un objetivo.

2. **Escribe el guion del facilitador.** Debe incluir qué dices y qué **no** dices:

   ```text
   INTRO (lo que digo):
   - "Gracias por probar. No estoy evaluándote a ti, sino al juego."
   - "Piensa en voz alta: dime qué crees que puedes hacer."
   - "No voy a ayudarte; si te atascas, es información valiosa."
   DURANTE (lo que hago):
   - Callo. Anoto. No respondo preguntas de cómo se juega.
   - Registro dónde duda, dónde muere, qué ignora.
   CIERRE:
   - Paso la encuesta. Agradezco. Solo entonces explico dudas.
   ```

3. **Lista qué observar.** Tabla con columnas: momento, qué hizo, qué esperabas, señal de problema. Presta atención a: primeros 30 segundos, dónde vacila, dónde repite errores, dónde abandona.

4. **Diseña la encuesta post-partida** (5-7 ítems, sin sesgo). Mezcla escalas y abiertas:
   - "En una frase, ¿de qué iba el juego?" (mide si el juego se explica)
   - "¿En qué momento te sentiste perdido?" (abierta)
   - "Del 1 al 5, ¿qué tan claro era el objetivo?"
   - "Del 1 al 5, ¿qué tan bien se sentía el control?"
   - "¿Qué quitarías o cambiarías?"
   Evita "¿te gustó?": invita a la cortesía, no a la verdad.

5. **Corre las sesiones.** Una persona a la vez. Cumple el guion a rajatabla: cada vez que sientas ganas de ayudar, anótalo como un fallo de diseño en lugar de intervenir.

6. **Vuelca los hallazgos** en la plantilla de priorización:

   | Hallazgo | Nº de testers que lo tuvieron | Severidad (1-3) | Prioridad | Acción |
   |----------|-------------------------------|-----------------|-----------|--------|
   | No entienden que hay que saltar el hueco | 3/4 | 3 | Alta | Añadir pista visual |

7. **Prioriza y decide.** Ordena por (frecuencia × severidad). Elige los 2-3 de arriba para arreglar; el resto va al backlog. Anota qué NO vas a tocar y por qué.

8. **Itera** aplicando los arreglos de mayor prioridad y, si puedes, vuelve a testear con una persona nueva para confirmar que mejoró.

## ✍️ Ejercicios

1. Reescribe tres preguntas sesgadas de una encuesta para hacerlas neutrales.
2. Durante una sesión, anota cada vez que sentiste el impulso de ayudar y qué revela sobre tu juego.
3. Define una métrica simple que tu juego pueda registrar y explica qué problema detectaría.
4. Rellena la tabla de priorización con hallazgos reales de un test y ordénalos.
5. Elige un hallazgo de baja prioridad y justifica por qué NO lo arreglarás ahora.
6. Compara lo que un tester dijo con lo que hizo y comenta la diferencia.

## 📝 Reto verificable

Realiza al menos **3 sesiones de playtest con personas nuevas**, registra los hallazgos en la plantilla priorizada y aplica al menos un cambio derivado del hallazgo de mayor prioridad. Entrega el `kit-playtest.md`, la tabla de hallazgos y una nota del cambio implementado.

**Criterio de aceptación**: constan 3+ testers que no conocían el juego, el facilitador no guio durante la partida (documentado en el guion), la encuesta no contiene preguntas sesgadas, los hallazgos están priorizados por frecuencia × severidad, y hay al menos un cambio hecho a partir del hallazgo top con su justificación.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Todos "juegan bien" y no encuentras problemas | Testeas con conocidos que ya saben o que te ayudan. Prueba con desconocidos y calla. |
| Acabas explicando cómo se juega | Rompes la regla de no guiar. Anota tu impulso como fallo de onboarding y no intervengas. |
| El feedback es "está guay" y poco más | Preguntas sesgadas o vagas. Usa preguntas abiertas y de comportamiento concreto. |
| Recoges opiniones contradictorias y no sabes qué hacer | Falta priorización. Ordena por frecuencia × severidad y arregla lo de arriba. |
| Cambias el juego por un comentario de una sola persona | Un dato aislado no es tendencia. Espera patrón entre varios testers. |

## ❓ Preguntas frecuentes

**❓ ¿Cuántos testers necesito?** Con 3-5 personas nuevas ya emergen los problemas más graves. No hace falta una muestra grande para el capstone; hace falta que sean desconocidos.

**❓ ¿Y si el tester me hace una pregunta durante la partida?** Devuélvela con suavidad ("¿qué crees tú que harías?") y anota que el juego no lo comunicó. Responder tapa el problema que buscas medir.

**❓ ¿Debo creer más lo que dicen o lo que hacen?** Lo que hacen. La gente racionaliza y es cortés al hablar; el comportamiento observado es la evidencia más fiable.

**❓ ¿Tengo que arreglar todo lo que aparezca?** No. Prioriza por frecuencia y severidad, arregla lo alto y documenta qué dejas fuera. Perseguir cada hallazgo rompe el plazo.

## 🔗 Referencias

- GDC — playtesting y user research: <https://www.youtube.com/user/gdconf>
- Google Forms — encuestas rápidas: <https://forms.google.com/>
- OBS Studio — grabar sesiones de prueba: <https://obsproject.com/>
- Nielsen Norman Group — sobre think-aloud y usabilidad: <https://www.nngroup.com/articles/thinking-aloud-the-1-usability-tool/>

## ➡️ Siguiente clase

[Clase 286 - Preparar el juego para el público](../286-preparar-el-juego-para-el-publico/README.md)
