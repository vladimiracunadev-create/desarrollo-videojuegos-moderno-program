# Clase 283 — Construir el vertical slice

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Jason Schreier, "Blood, Sweat, and Pixels" — cómo se produce de verdad*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Pasar del plan a la producción real del vertical slice sin perderte. La diferencia entre quien termina y quien abandona no suele ser habilidad, sino **orden de trabajo**: priorizar el core loop, usar marcadores donde no importa, iterar en ciclos cortos y no caer en *rabbit holes* que devoran días a cambio de nada visible.

Al terminar tendrás un **plan de producción por tareas** de tu slice: una lista ordenada con estimaciones, dependencias y una checklist de "hecho" por tarea, más las reglas de trabajo que te mantendrán en foco. Con ese plan podrás producir el slice de forma metódica en lugar de improvisar y quemarte.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Descomponer el vertical slice en tareas pequeñas, ordenadas por dependencia y valor.
2. Priorizar el core loop antes que el contenido o la estética.
3. Decidir con criterio dónde usar arte/audio de marcador y dónde el final.
4. Trabajar en iteraciones cortas con revisión al final de cada una.
5. Detectar y salir de *rabbit holes* que no aportan al slice.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Descomponer en tareas | Lo grande asusta; lo pequeño se hace. |
| 2 | Primero el core loop | Si el corazón falla, lo demás sobra. |
| 3 | Marcador vs final | Invertir esfuerzo donde se ve, no donde no. |
| 4 | Orden y dependencias | Hacer las cosas en el orden que desbloquea. |
| 5 | Iteración corta | Ciclos breves dan feedback y moral. |
| 6 | Rabbit holes | Un detalle irrelevante puede tragarse días. |
| 7 | Estimación honesta | Planificar con tus horas reales, no ideales. |
| 8 | Checklist de "hecho" | Cerrar tareas de verdad, no al 90%. |

## 📖 Definiciones y características

- **Tarea de producción**: unidad de trabajo pequeña y accionable (idealmente de una sesión). Clave: si no cabe en un día, divídela.
- **Priorización por core loop**: hacer primero lo que permite jugar el ciclo completo. Clave: un core loop feo pero jugable vale más que arte sin juego.
- **Arte/audio de marcador**: recurso provisional que ocupa el sitio del final. Clave: úsalo en todo salvo lo que la cámara mostrará en el slice.
- **Rabbit hole**: tarea que crece sin fin y no aporta al objetivo (ej.: un sistema genérico para un caso único). Clave: se corta poniéndole límite de tiempo.
- **Iteración**: ciclo corto de construir → probar → ajustar. Clave: cada iteración deja algo jugable, no solo código.
- **Estimación**: tiempo previsto para una tarea, basado en tu ritmo real. Clave: multiplica por un factor de holgura; siempre cuesta más.
- **Camino crítico**: la secuencia de tareas de la que depende todo lo demás. Clave: cualquier retraso ahí retrasa el slice entero.
- **Timeboxing**: fijar un límite de tiempo a una tarea antes de empezarla. Clave: protege del pulido y de los rabbit holes prematuros.

## 🧰 Herramientas y preparación

Necesitas tu `slice-plan.md` y un tablero de tareas. Sirve algo simple: un `TAREAS.md` con casillas, un tablero Kanban en [Trello](https://trello.com/), un [GitHub Projects](https://github.com/features/issues) o notas en tu motor. Reúne también tus prototipos previos y assets de marcador (formas, sonidos genéricos) para no bloquearte buscando arte.

Trabaja con control de versiones desde el primer commit del slice: cada iteración que deja algo jugable merece un commit. Si te falta soltura con Git, repasa lo visto en partes anteriores sobre flujo de trabajo y versionado antes de arrancar.

## 🧪 Laboratorio guiado

Entregable: un `plan-produccion.md` (o tablero) con las tareas del slice ordenadas, estimadas y con su checklist de hecho.

1. **Explota el slice en tareas.** Recorre tu `slice-plan.md` y escribe tareas pequeñas. Etiqueta cada una por capa: `[loop]`, `[arte]`, `[audio]`, `[ui]`, `[pulido]`. Ejemplo de tareas `[loop]`: "mover al jugador", "detectar objetivo del nivel", "condición de victoria", "reinicio de nivel".

2. **Ordena por camino crítico.** Coloca primero todas las tareas `[loop]` necesarias para recorrer el core loop de principio a fin con marcadores. Nada de arte final hasta que el loop se juegue entero.

3. **Estima cada tarea** en una escala simple (S = <2 h, M = media jornada, L = jornada). Suma y compara con tu plazo. Si no cabe, mueve tareas a un backlog "si sobra tiempo".

4. **Marca el nivel de acabado por tarea.** Para cada asset decide `marcador` o `final`. Regla: `final` solo si aparece en cámara durante el core loop del slice.

5. **Añade una checklist de "hecho" a cada tarea.** Mínimo tres ítems verificables. Plantilla:

   ```text
   Tarea: <nombre>  Estimación: <S/M/L>  Acabado: <marcador|final>
   Hecho cuando:
   [ ] funciona sin errores en consola
   [ ] probado en una partida real
   [ ] commit hecho
   ```

6. **Define tus reglas de foco.** Escríbelas y pégalas donde trabajas:
   - *Timebox*: si una tarea supera el doble de su estimación, paro y la reevalúo.
   - *No rabbit holes*: no construyo sistemas genéricos para casos únicos del slice.
   - *Jugable siempre*: al cerrar cada sesión el proyecto arranca y se puede jugar algo.

7. **Produce la primera iteración: el "loop gris".** Ejecuta solo las tareas `[loop]` con marcadores hasta poder recorrer el core loop completo. Haz commit. Este hito es psicológicamente clave: ya tienes juego.

8. **Itera por capas.** En las siguientes sesiones ve subiendo calidad (arte final de lo visible, audio de acciones, UI, y por último `[pulido]`). Cierra cada tarea solo cuando pase su checklist.

9. **Registra tu ritmo real.** Al cerrar cada sesión anota en una bitácora corta qué terminaste y cuánto costó frente a lo estimado. Con dos o tres sesiones tendrás tu velocidad real y podrás reajustar el plan con datos en vez de con optimismo:

   | Sesión | Tareas cerradas | Estimado | Real | Nota |
   |--------|-----------------|----------|------|------|
   | 1 | loop de movimiento | M | L | subestimé colisiones |
   | 2 | condición de victoria | S | S | ok |

## ✍️ Ejercicios

1. Divide en tres tareas más pequeñas la tarea más grande de tu lista.
2. Identifica tu camino crítico y márcalo; explica qué pasa si una de esas tareas se retrasa.
3. Elige un asset que ibas a hacer final y bájalo a marcador justificando por qué no se ve en el slice.
4. Escribe la checklist de "hecho" para tu tarea de core loop más importante.
5. Detecta en tu plan una tarea con riesgo de rabbit hole y ponle un timebox por escrito.
6. Tras tu primera iteración, anota qué estimaste mal y ajusta el resto del plan.
7. Rellena tu bitácora tras dos sesiones y calcula tu velocidad real en tareas por sesión.

## 📝 Reto verificable

Produce el **"loop gris"** de tu slice: el core loop completo, jugable de principio a fin, con arte y audio de marcador, y súbelo como commit. Adjunta el `plan-produccion.md` con las tareas restantes ordenadas y estimadas.

**Criterio de aceptación**: el proyecto arranca y permite recorrer el core loop entero al menos una vez sin errores en consola; existe un commit del "loop gris"; y el plan restante tiene tareas pequeñas con estimación, nivel de acabado y checklist de hecho.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Llevas días y aún no se puede jugar nada | Empezaste por arte/UI. Prioriza las tareas `[loop]` y logra el "loop gris" primero. |
| Una tarea "sencilla" se comió tres días | Rabbit hole sin timebox. Corta, usa una solución simple y sigue. |
| Cierras tareas que en realidad están al 90% | Falta checklist de hecho. No cierres sin cumplir sus ítems verificables. |
| El proyecto a veces no arranca | Rompiste "jugable siempre". Commitea solo estados jugables y revierte si hace falta. |
| Te desmotivas por no ver avance | Iteraciones demasiado largas. Acorta a ciclos que dejen algo jugable cada sesión. |
| Estimas siempre de menos | No usas tu velocidad real. Registra la bitácora y ajusta con datos, no con optimismo. |

## ❓ Preguntas frecuentes

**❓ ¿Cuánto marcador es demasiado?** Ninguno mientras no esté en cámara durante el core loop. En el slice, todo lo visible debe subir a final; el resto puede seguir siendo marcador indefinidamente.

**❓ ¿Debo pulir mientras construyo o al final?** Deja el pulido fino para el final (clase 284). Durante la construcción, "suficientemente bueno" para que sea jugable; el pulido tiene su fase.

**❓ ¿Qué hago si me atasco en una tarea técnica?** Aplica timebox: si superas el doble de la estimación, busca una solución más simple o un rodeo, y anota el problema como riesgo. No dejes que un muro pare el slice.

**❓ ¿Está bien commitear cosas feas?** Sí. El objetivo del slice es terminar; el código feo que funciona y está versionado vale más que el elegante que nunca llega.

**❓ ¿Cada cuánto debería hacer commit?** Al final de cada tarea cerrada y siempre que el proyecto quede jugable. Commits pequeños y frecuentes te dan puntos de retorno seguros si una iteración rompe algo.

## 🔗 Referencias

- GDC — producción y *cutting scope*: <https://www.youtube.com/user/gdconf>
- Trello — tableros Kanban gratuitos: <https://trello.com/>
- GitHub — Issues y Projects para planificar: <https://github.com/features/issues>
- Godot Docs — best practices: <https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html>

## ➡️ Siguiente clase

[Clase 284 - Pulido, game feel y el último 10%](../284-pulido-game-feel-y-el-ultimo-10-por-ciento/README.md)
