# Clase 267 — Producción de juegos: scope, milestones y agile

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Clinton Keith, Agile Game Development (2ª ed.)*
> ⏱️ Duración estimada: **55 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

La diferencia entre un juego que se termina y uno que muere a medias rara vez es el talento: casi siempre es la **producción**. Esta clase te enseña a definir un **scope realista**, a dividir el proyecto en **milestones** con criterios de "hecho" verificables, y a aplicar **agile/scrum** adaptado al desarrollo de videojuegos, donde el diseño es incierto y la diversión no se puede planificar en un diagrama de Gantt cerrado.

Trabajarás con el **triángulo alcance-tiempo-calidad** como herramienta de decisión diaria: entenderás que solo puedes fijar dos de sus tres vértices y que "recortar scope" no es fracasar, sino la habilidad central de un productor. Al final tendrás un plan de milestones y un backlog de sprint listos para tu propio proyecto.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Definir el scope de un juego separando el núcleo jugable de los añadidos opcionales.
- Planificar milestones estándar (prototipo, vertical slice, alpha, beta, gold) con criterios de aceptación.
- Aplicar un ciclo scrum (sprints, backlog, review, retro) al contexto de un juego.
- Usar el triángulo alcance-tiempo-calidad para tomar decisiones de recorte.
- Construir y priorizar un backlog de sprint con historias estimadas.

## 🗺️ Temas

Estos ocho temas trazan el recorrido de un productor: primero acotar qué se va a construir, después dividirlo en hitos medibles, y por último organizar el trabajo diario con un método iterativo. La idea rectora que los une es que en juegos el plan sirve para adaptarse, no para cumplirse al pie de la letra.

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Scope realista y "core loop" | Define qué es el juego mínimo viable y qué es opcional |
| 2 | Milestones estándar de la industria | Dan estructura y puntos de decisión medibles |
| 3 | Vertical slice | Prueba que la visión funciona antes de escalar producción |
| 4 | Agile vs cascada en juegos | El diseño incierto exige iteración, no planes cerrados |
| 5 | Scrum: sprints y ceremonias | Ritmo sostenible con entregas frecuentes |
| 6 | Backlog y estimación | Prioriza el trabajo y hace visible el progreso |
| 7 | Triángulo alcance-tiempo-calidad | Marco para decidir qué sacrificar cuando algo cede |
| 8 | Definition of Done | Evita el "casi terminado" que nunca cierra |

## 📖 Definiciones y características

Este vocabulario es el idioma común de cualquier equipo de producción. Interiorizarlo te permite comunicarte con publishers, colaboradores y herramientas sin ambigüedad, y sobre todo distinguir entre estimar (puntos, velocidad) y prometer (fechas), que es donde más proyectos se rompen.

- **Scope**: conjunto total de características, contenido y calidad comprometidos. Clave: se recorta, no se infla; el scope creep mata proyectos.
- **Milestone**: hito con entregable y criterios verificables (prototipo, vertical slice, alpha, beta, gold). Clave: cada uno responde una pregunta de riesgo.
- **Vertical slice**: fragmento pequeño del juego pulido a calidad final. Clave: demuestra la diversión y sirve para pitch.
- **Sprint**: iteración corta (1-3 semanas) con un objetivo y entregable. Clave: alcance fijo, fecha fija.
- **Backlog**: lista priorizada de trabajo pendiente (épicas, historias, tareas). Clave: siempre ordenada por valor.
- **Story point**: unidad relativa de esfuerzo/complejidad, no de horas. Clave: mide velocidad, no promete fechas exactas.
- **Definition of Done (DoD)**: lista de condiciones para considerar terminada una tarea. Clave: incluye probado e integrado, no solo "código escrito".
- **Triángulo de restricciones**: alcance, tiempo y calidad interdependientes. Clave: fijar dos obliga a ceder el tercero.

## 🧰 Herramientas y preparación

Necesitas una herramienta de tablero (Trello, Jira, GitHub Projects o Notion) y una hoja de cálculo para el plan de milestones. No hace falta código. Ten a mano la idea de tu juego con al menos su core loop identificado. Recomendado: leer los capítulos de scrum de [Agile Game Development](https://www.agilegamedevelopment.com/) y la guía oficial [Scrum Guide](https://scrumguides.org/). Para estimación relativa, revisa el concepto de planning poker.

Antes de empezar, dedica diez minutos a escribir en una frase qué experiencia quieres que viva el jugador: ese enunciado ("pilar de diseño") será el filtro para aceptar o rechazar cada feature del backlog. Si una tarea no sirve a ese pilar, es candidata a recorte. Ten también claras las restricciones reales de tu contexto: cuántas horas por semana puedes dedicar y con cuánta gente cuentas, porque esos dos números fijan tu velocidad y, por tanto, tu scope máximo realista.

## 🧪 Laboratorio guiado

**Entregable: plan de milestones + backlog del primer sprint de tu juego.**

Parte 1 — Tabla de milestones (hoja de cálculo). Completa una fila por milestone:

| Milestone | Pregunta que responde | Criterio de aceptación | Fecha objetivo | Riesgos |
|-----------|----------------------|------------------------|----------------|---------|
| Prototipo | ¿El core loop es divertido? | Loop jugable 2 min, sin arte final | | |
| Vertical slice | ¿La visión funciona a calidad final? | 1 nivel pulido representativo | | |
| Alpha | ¿Están todas las features? | Feature-complete, contenido parcial | | |
| Beta | ¿El juego está completo y estable? | Content-complete, solo bugs | | |
| Gold | ¿Se puede lanzar? | Cero bugs bloqueantes, build final | | |

Parte 2 — Backlog del Sprint 1. Escribe 6-10 historias con formato "Como [jugador/rol] quiero [X] para [beneficio]", asigna story points (1,2,3,5,8) y prioridad (Alta/Media/Baja). Define el **objetivo del sprint** en una frase y la **DoD** del equipo (ej.: compilado, probado en build, revisado). Marca qué historias caben en la velocidad estimada.

Parte 3 — Prueba de recorte. Simula que pierdes un 30% del tiempo disponible. Sobre tu backlog, tacha las historias que no sirven al pilar de diseño y reordena el resto. El objetivo es demostrar que sabes qué es núcleo y qué es prescindible: un plan sano sigue siendo jugable incluso después del recorte. Anota qué features moverías a una lista de "post-lanzamiento" en lugar de eliminarlas.

**Rúbrica de autoevaluación del laboratorio:**

- [ ] Cada milestone tiene un criterio binario (se cumple o no, sin ambigüedad).
- [ ] El backlog está ordenado por valor/riesgo, no por orden de ocurrencia.
- [ ] Las estimaciones usan puntos relativos, no horas.
- [ ] El objetivo del sprint cabe en una sola frase.
- [ ] Tras el recorte del 30%, el juego mínimo sigue siendo jugable.

## ✍️ Ejercicios

Resuélvelos sobre tu propio proyecto siempre que sea posible; el valor está en aplicar los conceptos a decisiones reales, no en respuestas teóricas.

1. Escribe el core loop de tu juego en una sola frase y lista tres features que NO son parte del núcleo.
2. Para cada milestone, redacta un criterio de aceptación medible y binario (se cumple o no).
3. Convierte una idea grande ("sistema de crafteo") en una épica dividida en 4 historias.
4. Estima 8 historias con puntos y justifica por qué una vale 8 y otra 2.
5. Aplica el triángulo: si pierdes un mes de tiempo, describe dos recortes de scope alternativos.
6. Redacta la Definition of Done de tu equipo con al menos cinco condiciones.

## 📝 Reto verificable

Crea un plan de producción completo para tu juego: (a) tabla de los cinco milestones con criterios de aceptación y fechas, (b) backlog de Sprint 1 con mínimo 6 historias estimadas y priorizadas, (c) objetivo de sprint, y (d) Definition of Done. Entrégalo como documento u hoja de cálculo.

**Criterio de aceptación**: cada milestone tiene un criterio binario y verificable; el backlog está priorizado y estimado en puntos; el objetivo del sprint es una sola frase clara; la DoD tiene al menos cinco condiciones concretas y comprobables.

## ⚠️ Errores comunes

Casi todos los fallos de producción son variantes de dos errores: comprometer más de lo que cabe en el tiempo real, y dejar los criterios de "hecho" tan vagos que nada se cierra del todo. Vigila estos síntomas y corrígelos temprano.

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El proyecto nunca llega a beta | Scope inflado. Recorta al core loop y mueve el resto a "post-lanzamiento" |
| Milestones que "casi" se cumplen | Criterios vagos. Reescríbelos como binarios y medibles |
| Sprints que siempre se desbordan | Se compromete más que la velocidad real. Planifica según velocidad histórica |
| Vertical slice sin pulir | Se confundió con demo técnica. Debe estar a calidad final, aunque sea corto |
| Estimar en horas exactas | Falsa precisión. Usa puntos relativos y mide velocidad |
| Backlog desordenado | Sin priorización. Ordénalo siempre por valor/riesgo antes del sprint |

## ❓ Preguntas frecuentes

**¿Cuánto debe durar un sprint?** Entre una y tres semanas. Dos es lo más común; lo importante es mantenerlo constante para medir velocidad.

**¿Agile sirve para un desarrollador solo?** Sí, en versión ligera: backlog priorizado, sprints cortos y una retro personal bastan para mantener ritmo y foco.

**¿Qué pasa si no termino un milestone a tiempo?** Recorta scope, no calidad ni el hito. Mover la fecha una y otra vez es la señal más clara de un plan irreal.

**¿Cuándo hago el vertical slice?** Tras validar el prototipo. Es lo que llevas a publishers e inversores, así que debe verse y sentirse como el juego final.

**¿Qué diferencia hay entre alpha y beta?** En alpha el juego es feature-complete (están todas las mecánicas, aunque falte contenido); en beta es content-complete y el trabajo se centra en estabilizar y corregir bugs, no en añadir cosas nuevas.

**¿Puedo saltarme el prototipo si tengo clara la idea?** No conviene. El prototipo existe para responder la pregunta más barata y peligrosa —¿esto es divertido?— antes de invertir meses. Tener la idea clara no garantiza que funcione al jugarla.

## 🔗 Referencias

Empieza por Keith para la teoría de agile aplicada a juegos y por la Scrum Guide para el marco base; el resto sirve para profundizar en casos y plantillas concretas.

- Clinton Keith — Agile Game Development: <https://www.agilegamedevelopment.com/>
- Scrum Guide (oficial): <https://scrumguides.org/>
- Heather Chandler — The Game Production Toolbox: <https://www.routledge.com/>
- GDC Vault, charlas de producción: <https://www.gdcvault.com/>
- Atlassian, guía de agile: <https://www.atlassian.com/agile>

## ➡️ Siguiente clase

[Clase 268 - Formar y gestionar un equipo](../268-formar-y-gestionar-un-equipo/README.md)
