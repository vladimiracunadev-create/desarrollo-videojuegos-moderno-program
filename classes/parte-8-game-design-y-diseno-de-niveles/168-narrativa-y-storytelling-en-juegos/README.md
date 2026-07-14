# Clase 168 — Narrativa y storytelling en juegos

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Síntesis original sobre environmental storytelling, ludonarrativa y narrativa ramificada*
> ⏱️ Duración estimada: **65 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Los videojuegos cuentan historias de formas que ningún otro medio puede: no solo *contando*, sino haciendo que el jugador *actúe* y *descubra*. En esta clase distinguirás la **narrativa embebida** (guionizada por el autor) de la **emergente** (surgida del juego), y dominarás el **environmental storytelling**: contar sin cinemáticas, usando el propio escenario.

Diseñarás la narrativa de un nivel exclusivamente a través del entorno y esbozarás un **árbol de diálogo** simple. También entenderás la **ludonarrativa**: la coherencia (o disonancia) entre lo que el juego *dice* y lo que sus *mecánicas* comunican. El resultado es un nivel que narra sin interrumpir el juego.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Diferenciar narrativa embebida, emergente y environmental storytelling.
- Diseñar la historia de un nivel usando solo composición del entorno.
- Detectar y evitar la **disonancia ludonarrativa** en un diseño.
- Esbozar un árbol de diálogo con ramificación y consecuencias.
- Elegir la técnica narrativa adecuada según el tono y el género.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Narrativa embebida vs emergente | Definen cuánto controla el autor la historia |
| 2 | Environmental storytelling | Narra sin frenar el juego con cinemáticas |
| 3 | Ludonarrativa | La mecánica es un lenguaje; debe ser coherente |
| 4 | Ramificación | Da agencia real al jugador en la historia |
| 5 | Árboles de diálogo | Estructuran conversación y elección |
| 6 | Pistas ambientales | Objetos y estados que insinúan hechos pasados |
| 7 | Ritmo narrativo | Dosificar información sostiene el misterio |

## 📖 Definiciones y características

- **Narrativa embebida**: historia prediseñada por el autor y entregada en un orden previsto. Clave: control autoral, menos libertad.
- **Narrativa emergente**: historia que surge de la interacción entre sistemas y jugador. Clave: única e irrepetible, difícil de guionizar.
- **Environmental storytelling**: contar mediante la disposición del escenario y sus objetos. Clave: el jugador *deduce*, no *recibe*.
- **Ludonarrativa**: relación entre la historia contada y la contada por las mecánicas. Clave: la coherencia refuerza el mensaje.
- **Disonancia ludonarrativa**: contradicción entre relato y mecánica (héroe pacífico que masacra a cientos). Clave: rompe la inmersión.
- **Árbol de diálogo**: grafo de nodos de conversación con opciones que ramifican. Clave: estructura la agencia conversacional.
- **Pista ambiental (set dressing narrativo)**: objeto colocado para insinuar un hecho (una silla volcada, sangre seca). Clave: economía narrativa.
- **Ritmo narrativo**: cadencia con que se revela la información. Clave: demasiado pronto aburre, demasiado tarde confunde.

## 🧰 Herramientas y preparación

Esta es una clase de diseño analítico: tu herramienta principal es una **plantilla de guion ambiental** y un **editor de grafos** (papel, diagrams.net o el propio croquis). Para el diálogo, familiarízate con plugins de Godot como **Dialogue Manager** (<https://github.com/nathanhoad/godot_dialogue_manager>) o **Dialogic** (<https://docs.dialogic.pro/>), aunque en esta clase solo esbozarás el árbol, no lo implementarás. Ten a mano el blockout de la Clase 167: le añadirás capas narrativas.

## 🧪 Laboratorio guiado

Diseñarás la narrativa de un nivel por el entorno (sin cinemáticas) y esbozarás un árbol de diálogo. Entregable: una plantilla ambiental completa + un diagrama del árbol.

**Parte A — Plantilla de environmental storytelling.** Rellena esta tabla para tu nivel:

| Zona | Qué ve el jugador | Qué debe deducir | Cómo se refuerza |
|------|-------------------|------------------|------------------|
| Entrada | Barricada improvisada, casquillos | Aquí hubo una defensa fallida | Luz tenue, silencio |
| Pasillo | Marcas de arrastre hacia una puerta | Alguien fue llevado a la fuerza | Sangre seca dirige la mirada |
| Sala final | Un diario abierto, radio encendida | El desenlace del conflicto | Único foco de luz de la sala |

Reglas de la técnica:

- **Muestra estados, no textos**: una habitación *dice* lo que pasó por cómo está.
- **Usa la luz como narrador**: el ojo va a lo iluminado; ilumina lo que importa.
- **Coherencia física**: si hubo lucha, debe haber rastro consistente por todo el espacio.
- **Economía**: menos objetos bien elegidos comunican más que un escenario saturado.
- **Deja que el jugador cierre el círculo**: insinúa; que él complete la conclusión.

**Parte B — Chequeo de ludonarrativa.** Para cada mecánica del nivel, verifica que no contradice el relato:

- [ ] Si el tono es de sigilo/tensión, ¿las mecánicas premian evitar el combate?
- [ ] Si el personaje es vulnerable, ¿el diseño le da desventaja mecánica real?
- [ ] ¿La recompensa del nivel encaja con lo que la historia valora?
- [ ] ¿Las acciones que el juego permite contradicen lo que el relato afirma del personaje?
- [ ] ¿El fracaso (perder, morir) se lee de forma coherente con la ficción?

**Parte C — Árbol de diálogo.** Esboza un grafo simple con una decisión que ramifique y confluya:

```text
[NPC: "No deberías estar aquí."]
      |
  +---+-------------------+
  |                       |
[Opción A: "Vengo a ayudar"]   [Opción B: "Apártate"]
  |                       |
[NPC confía → abre puerta] [NPC hostil → alarma]
  |                       |
  +----------+------------+
             |
     [Escena final del nivel]   (los caminos confluyen con estado distinto)
```

Anota qué **variable de estado** cambia en cada rama (p. ej. `npc_confia = true/false`) y cómo afecta al final. Entrega la plantilla A, el checklist B y el diagrama C.

## ✍️ Ejercicios

1. Cuenta un mismo suceso (una traición) con tres pistas ambientales distintas.
2. Reescribe una escena de cinemática como environmental storytelling puro.
3. Identifica un caso real de disonancia ludonarrativa y propón cómo corregirlo.
4. Añade una tercera opción de diálogo que ramifique a un final alternativo.
5. Diseña una zona donde la luz sea el único elemento que guía la deducción.
6. Convierte tu árbol lineal en uno con una decisión que altere el estado final.

## 📝 Reto verificable

Entrega el **diseño narrativo de un nivel** contado por completo a través del entorno (sin cinemáticas ni cuadros de texto expositivos), acompañado del árbol de diálogo esbozado y del checklist de coherencia ludonarrativa resuelto.

**Criterio de aceptación**: la plantilla ambiental cubre al menos 3 zonas con "qué ve / qué deduce / cómo se refuerza"; el árbol de diálogo tiene como mínimo una ramificación con una variable de estado nombrada; y el checklist ludonarrativo está respondido justificando cada punto.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| La historia se cuenta solo con texto | Traduce la exposición a estados del entorno y luz |
| El jugador no capta la pista | La pista es ambigua o mal iluminada; refuérzala con guiado |
| Mecánicas contradicen el relato | Disonancia ludonarrativa; alinea recompensas y tono |
| El árbol de diálogo explota en ramas | Falta confluencia; haz que los caminos vuelvan a unirse con estado distinto |
| Todo el nivel narra a la vez | Sin ritmo; dosifica las revelaciones por zonas |
| La deducción exige conocimiento externo | Coherencia rota; la pista debe leerse dentro del propio mundo |

## ❓ Preguntas frecuentes

**¿El environmental storytelling sustituye al guion?** No: lo complementa. Muchos juegos combinan diálogo puntual con un entorno que narra el trasfondo sin interrumpir.

**¿La narrativa emergente se puede diseñar?** No se guioniza, pero se *habilita*: diseñas sistemas cuya interacción genera historias, algo que verás en la Clase 169.

**¿Cuántas ramas debe tener un árbol de diálogo?** Las mínimas para dar agencia significativa. Demasiadas ramas cuestan mucho y a menudo confluyen igual: prioriza decisiones que cambien el estado.

**¿La disonancia ludonarrativa siempre es un error?** No siempre; algunos juegos la usan deliberadamente como comentario. El problema es la disonancia *accidental*, que rompe la inmersión sin querer.

## 🔗 Referencias

- Godot Dialogue Manager: <https://github.com/nathanhoad/godot_dialogue_manager>
- Dialogic (Godot): <https://docs.dialogic.pro/>
- Level Design Book — Storytelling: <https://book.leveldesignbook.com/process/layout/storytelling>
- GDC — Environmental Storytelling (charlas): <https://www.gdcvault.com/>

## ➡️ Siguiente clase

Continúa con [Clase 169 - Diseño de sistemas emergentes y sandbox](../169-diseno-de-sistemas-emergentes-y-sandbox/README.md), donde diseñarás sistemas cuya interacción genera historias por sí sola.
