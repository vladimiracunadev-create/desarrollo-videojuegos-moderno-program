# Clase 170 — Documentación de diseño: GDD y one-pager

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Síntesis original sobre documentación de diseño (GDD vivo, one-pager y pitch)*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Una gran idea que nadie entiende no vale nada. La documentación de diseño existe para **comunicar la visión**: alinear al equipo, guiar las decisiones y detectar contradicciones antes de programarlas. En esta clase aprenderás a escribir un **one-pager** (la síntesis que vende el juego en una página) y a estructurar un **GDD vivo** (Game Design Document) que evolucione con el proyecto en vez de morir en un cajón.

Contrastarás el **GDD monolítico** (un tomo que nadie lee ni actualiza) con el **GDD vivo / wiki de diseño** (fragmentado, enlazado y siempre al día). Escribirás un one-pager real y el índice de un GDD ligero para un juego propio, usando una plantilla completa que podrás reutilizar en tu capstone.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Distinguir GDD monolítico de GDD vivo y elegir el adecuado.
- Escribir un **one-pager** que comunique la visión en una página.
- Estructurar el índice de un **GDD ligero** por secciones enlazables.
- Redactar un **pitch** breve que capture el gancho del juego.
- Mantener la documentación como fuente de verdad viva del equipo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Para qué sirve un GDD | Alinea al equipo y previene errores caros |
| 2 | GDD monolítico vs vivo | Uno se ignora; el otro guía a diario |
| 3 | El one-pager | Sintetiza y vende la visión de un vistazo |
| 4 | El pitch | Comunica el gancho en segundos |
| 5 | Wiki de diseño | Documentación fragmentada y enlazable |
| 6 | Pilares de diseño | Anclan cada decisión a la visión |
| 7 | Documentación como comunicación | El objetivo no es escribir, es alinear |

## 📖 Definiciones y características

- **GDD (Game Design Document)**: documento que describe la visión, mecánicas y alcance del juego. Clave: herramienta de comunicación, no burocracia.
- **GDD monolítico**: un único documento extenso y estático. Clave: tiende a quedar obsoleto y a no leerse.
- **GDD vivo**: documentación fragmentada, versionada y actualizada continuamente. Clave: refleja el estado real del proyecto.
- **One-pager**: resumen de una sola página con la esencia del juego. Clave: si no cabe en una página, la visión no está clara.
- **Pitch**: frase o párrafo que captura el gancho y el género. Clave: vende la idea en segundos.
- **Pilar de diseño**: principio rector (3-4) al que toda decisión debe rendir cuentas. Clave: filtro para decir "no".
- **Wiki de diseño**: conjunto de páginas enlazadas que forman el GDD vivo. Clave: cada quien encuentra lo suyo sin leerlo todo.
- **Scope (alcance)**: lo que entra y lo que queda fuera del proyecto. Clave: documentarlo evita el feature creep.

## 🧰 Herramientas y preparación

La documentación de diseño se escribe en cualquier medio versionable: **Markdown en un repositorio** (ideal, casa con este curso), Notion, Confluence o un wiki. Para diagramas usa diagrams.net o Mermaid. Lo importante no es la herramienta sino la **disciplina de mantenerla viva**. En este curso trabajarás en Markdown para que el GDD conviva con el código en Git. Ten a mano tu juego propio (idea o el nivel de clases previas): documentarás ese.

## 🧪 Laboratorio guiado

Escribirás un **one-pager** y el **índice de un GDD ligero** para un juego propio. Entregable: dos documentos Markdown listos para tu repositorio.

**Parte A — Plantilla de one-pager.** Rellena esta estructura (una sola página):

```markdown
# <Título del juego>

**Pitch (1 frase)**: <Es un [género] donde [gancho único] ambientado en [escenario]>.

**Género y plataforma**: <p. ej. plataformas 3D · PC/consola>
**Público objetivo**: <a quién va dirigido>
**Referencias**: <2-3 juegos comparables>

## Pilares de diseño
1. <Pilar 1 — p. ej. "Cada muerte enseña algo">
2. <Pilar 2>
3. <Pilar 3>

## Bucle de juego (core loop)
<El ciclo de 1 frase: el jugador [hace] → [obtiene] → [gasta/mejora] → repite>

## Gancho / diferenciador
<Qué hace único a este juego frente a las referencias>

## Alcance
Entra: <lista corta> · Fuera: <lista corta>
```

**Parte B — Índice de GDD ligero.** Estructura el GDD como wiki enlazable, no como tomo. Índice sugerido:

```markdown
# GDD — <Título> (documento vivo · v0.1)

1. Visión y pilares        → visión de una línea + 3 pilares
2. Core loop y pilares      → el bucle detallado
3. Mecánicas               → una página por mecánica principal
4. Sistemas                → reglas e interacciones (ver Clase 169)
5. Niveles y pacing        → objetivos de diseño por nivel (ver Clase 167)
6. Narrativa               → tono, ambientación, storytelling (ver Clase 168)
7. Estética y referencias  → moodboard, dirección de arte
8. Audio                   → tono sonoro y música
9. UI/UX                   → wireframes y flujo de menús
10. Alcance y riesgos      → qué entra, qué no, y qué puede fallar
```

**Parte C — Reglas de un GDD vivo.**

- **Versiona** el documento (cabecera con versión y fecha).
- **Enlaza**, no dupliques: una sola fuente de verdad por tema.
- **Marca decisiones abiertas** con `TODO` o `[por decidir]`.
- **Actualiza al cambiar**: si el juego cambió y el GDD no, el GDD miente.

Entrega el one-pager (Parte A) y el índice del GDD (Parte B) rellenos para tu juego.

## ✍️ Ejercicios

1. Reduce tu pitch a una sola frase de menos de 25 palabras.
2. Escribe los 3 pilares de diseño de tu juego y justifica cada uno.
3. Describe tu core loop en una frase con el patrón hace → obtiene → gasta.
4. Redacta la sección "Alcance" separando lo que entra de lo que queda fuera.
5. Convierte una sección monolítica en dos páginas enlazadas de wiki.
6. Añade una cabecera de versión y marca dos decisiones abiertas como `[por decidir]`.

## 📝 Reto verificable

Entrega un **one-pager completo** (una página) y el **índice de un GDD ligero** para un juego propio, ambos en Markdown, con pitch, pilares de diseño, core loop y alcance definidos, y con el GDD estructurado como documento vivo versionado.

**Criterio de aceptación**: el one-pager cabe en una página e incluye pitch de una frase, 3 pilares, core loop y alcance (entra/fuera); el índice del GDD tiene al menos 8 secciones enlazables, una cabecera con versión y fecha, y al menos una decisión marcada como abierta.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El GDD nadie lo lee | Es monolítico; fragméntalo en wiki enlazable y vivo |
| El one-pager ocupa tres páginas | No hay síntesis; recorta hasta la esencia en una página |
| El documento contradice al juego | No se actualiza; versiona y actualiza al cambiar |
| Los pilares no ayudan a decidir | Son vagos; hazlos accionables como filtro de "no" |
| El pitch no engancha | Falta diferenciador; nombra qué lo hace único |
| El alcance crece sin control | Feature creep; documenta explícitamente qué queda fuera |

## ❓ Preguntas frecuentes

**¿Cuánto debe ocupar un GDD?** Lo mínimo para alinear al equipo. Un GDD vivo puede ser corto: crece solo donde aporta claridad, no por completismo.

**¿One-pager o GDD, cuál primero?** El one-pager. Fuerza a cristalizar la visión antes de detallar; el GDD la desarrolla después.

**¿Sirve un GDD si trabajo solo?** Sí: es tu memoria y tu filtro de decisiones. Evita que tu juego derive sin rumbo y documenta el porqué de cada elección.

**¿Markdown en Git o una herramienta dedicada?** Markdown en Git casa con el flujo de este curso: versiona, se enlaza y vive junto al código. Herramientas como Notion valen si el equipo ya las usa.

## 🔗 Referencias

- Mermaid (diagramas en Markdown): <https://mermaid.js.org/>
- diagrams.net (editor de diagramas): <https://www.diagrams.net/>
- The Game Design Document (guía general): <https://www.gamedeveloper.com/>
- Level Design Book — Documentation: <https://book.leveldesignbook.com/>

## ➡️ Siguiente clase

Continúa con [Clase 171 - Capstone Parte 8: diseñar y greyboxear un nivel completo](../171-capstone-parte-8-disenar-y-greyboxear-un-nivel-completo/README.md), donde integrarás todo lo aprendido en un nivel documentado y jugable.
