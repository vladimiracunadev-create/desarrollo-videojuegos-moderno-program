# Clase 281 — Elegir tu proyecto capstone y su alcance

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Jason Schreier, "Blood, Sweat, and Pixels" — la realidad del scope en producción*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Elegir el proyecto que cerrará el programa y, sobre todo, **acotarlo** para que puedas terminarlo. El fracaso número uno de un capstone no es la falta de talento sino el *scope*: una idea que en la cabeza cabe en un fin de semana y en la práctica exige seis meses. Esta clase te da criterios y una plantilla para decidir con la cabeza fría, no con la ilusión del primer día.

Al terminar tendrás una **ficha de proyecto capstone** completa: un *pitch* de una frase, tus pilares de diseño, una mecánica núcleo única, un alcance escrito en positivo y en negativo (qué sí, qué no), y una lista de riesgos con mitigaciones. Ese documento será tu contrato contigo mismo para las próximas clases.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir una idea alcanzable de una idea aspiracional según recursos y plazo reales.
2. Reconocer las señales de *scope creep* antes de que arruinen el proyecto.
3. Reducir una idea a **una sola mecánica fuerte** que la haga memorable.
4. Aplicar criterios de selección (pasión, viabilidad, valor de portfolio, riesgo) para elegir entre varias ideas.
5. Redactar una ficha de capstone con pitch, pilares, alcance, mecánica núcleo y riesgos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El error del scope | Es la causa más común de proyectos abandonados. |
| 2 | Idea alcanzable vs aspiracional | Terminar enseña más que empezar diez veces. |
| 3 | Una mecánica fuerte | Un buen juego pequeño gana a uno grande y roto. |
| 4 | Criterios de selección | Elegir con datos evita el arrepentimiento a mitad. |
| 5 | MVP y producto mínimo jugable | Define lo mínimo que ya es divertido. |
| 6 | Restricciones como aliadas | Tiempo y alcance limitados fuerzan foco. |
| 7 | Riesgos y mitigaciones | Anticipar lo que puede fallar reduce sorpresas. |
| 8 | La ficha de proyecto | Convierte la intención difusa en un contrato. |

## 📖 Definiciones y características

- **Scope (alcance)**: el conjunto total de contenido y features que el proyecto promete entregar. Clave: crece solo si no lo defiendes por escrito.
- **Scope creep**: la expansión silenciosa del alcance mediante pequeñas ideas "que no cuestan nada". Clave: cada una es barata; la suma es letal.
- **Mecánica núcleo (core mechanic)**: la acción que el jugador repite y que define la experiencia. Clave: si es divertida, tienes juego; si no, ninguna cantidad de contenido lo salva.
- **Pilar de diseño**: una frase corta que expresa una prioridad innegociable del juego (p. ej. "tensión, no acción"). Clave: sirve para decir *no* a ideas fuera de foco.
- **MVP (producto mínimo viable)**: la versión más pequeña que ya es jugable y entretenida. Clave: es lo que defiendes cuando falta tiempo.
- **Pitch**: descripción del juego en una sola frase memorable. Clave: si no cabe en una frase, aún no está enfocado.
- **Viabilidad**: relación entre lo que la idea exige y lo que tú puedes ejecutar con tu tiempo y habilidades. Clave: se estima, no se adivina.
- **Riesgo de proyecto**: cualquier incertidumbre que pueda hacer descarrilar la entrega (técnica, de arte, de tiempo). Clave: nombrarlo permite mitigarlo.

## 🧰 Herramientas y preparación

No necesitas motor todavía: necesitas **decidir bien**. Ten a mano un documento de texto o una hoja de cálculo para la ficha, y opcionalmente una herramienta de notas como [Notion](https://www.notion.so/), [Obsidian](https://obsidian.md/) o un simple Markdown en tu repositorio. Reúne tus prototipos y aprendizajes de partes anteriores: tu capstone debería apoyarse en técnicas que ya dominas, no en un stack nuevo por estrenar.

Como lectura de fondo, la idea de esta clase se inspira en las historias reales de producción recogidas en *Blood, Sweat, and Pixels* y en charlas de GDC sobre *scoping*: busca "GDC scope" o "cutting features" en <https://www.youtube.com/user/gdconf>.

## 🧪 Laboratorio guiado

Vas a producir tu **Ficha de Proyecto Capstone**. Entregable: un archivo `capstone-ficha.md` en tu repositorio.

1. **Lluvia de 3 ideas.** Anota tres conceptos de juego que te ilusionen. Para cada uno escribe una frase de pitch con la plantilla: *"Un juego de [género] donde [acción del jugador] para [objetivo], con la particularidad de [gancho]"*.

2. **Puntúa cada idea (1-5)** en esta matriz de selección y suma:

   | Criterio | Idea A | Idea B | Idea C |
   |----------|--------|--------|--------|
   | Pasión (¿lo quiero hacer 8 semanas?) | | | |
   | Viabilidad (¿sé cómo?) | | | |
   | Valor de portfolio | | | |
   | Bajo riesgo (¿pocas incógnitas?) | | | |
   | Alcance realista | | | |

3. **Elige la ganadora** (mayor suma, con veto de "pasión": nunca elijas algo que puntúa 1-2 en pasión).

4. **Define la mecánica núcleo.** Escríbela en una frase que empiece con un verbo: "el jugador…". Si necesitas varias mecánicas para explicarla, recórtala.

5. **Escribe 2-3 pilares de diseño.** Frases cortas que priorizan (ej.: "control preciso ante todo", "cada partida dura menos de 5 min").

6. **Redacta el alcance en dos columnas** — *Incluye* / *No incluye*. La columna de "No incluye" es la más importante: ahí van multijugador, menús de opciones extensos, sistemas de progresión, etc., que hoy te tientan.

7. **Lista 3-5 riesgos** con su mitigación. Formato: "Riesgo → Mitigación". Ej.: "No sé hacer animación fluida → uso arte de marcador y priorizo game feel por código".

8. **Cierra con el MVP**: describe en un párrafo la versión mínima que, si solo llegaras a eso, ya sería un juego presentable.

Plantilla de la ficha (rellénala):

```text
# Capstone: <nombre provisional>
Pitch: <una frase>
Pilares: 1) ... 2) ... 3) ...
Mecánica núcleo: el jugador ...
Alcance — Incluye: ...
Alcance — No incluye: ...
Riesgos: R1 -> Mitigación; R2 -> ...
MVP: ...
```

## ✍️ Ejercicios

1. Reescribe tu pitch para que ocupe menos de 15 palabras sin perder el gancho.
2. Toma la idea que descartaste y lista tres features que le habrían hecho *scope creep*.
3. Para tu idea elegida, mueve una feature de "Incluye" a "No incluye" y justifica por qué el juego sigue siendo válido.
4. Convierte cada pilar de diseño en una pregunta que sirva para rechazar ideas ("¿esto respeta X?").
5. Estima en horas tu MVP y multiplícalo por 1.5; comenta si sigue cabiendo en tu plazo.
6. Busca un juego comercial pequeño (itch.io) con una sola mecánica fuerte y descríbela en una frase.

## 📝 Reto verificable

Entrega tu `capstone-ficha.md` completo y somételo a la **prueba del semáforo**: pide a un compañero (o a ti mismo tras 24 h) que lea solo el pitch y la mecánica núcleo y describa el juego. Si lo describe parecido a lo que imaginas, verde; si duda, ajusta hasta lograrlo.

**Criterio de aceptación**: la ficha contiene los seis apartados (pitch, pilares, mecánica núcleo, alcance incluye/no incluye, riesgos con mitigación, MVP), la mecánica núcleo cabe en una frase, y la columna "No incluye" tiene al menos tres elementos que hoy te tientan.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| "Mi juego necesita muchas mecánicas para ser divertido" | Falta foco. Elige la más fuerte y construye alrededor de ella; recorta el resto. |
| El alcance no para de crecer al escribirlo | No hay columna "No incluye". Escríbela primero y defiéndela. |
| Elegiste la idea "impresionante" pero no te ilusiona | Ocho semanas sin pasión matan el proyecto. Aplica el veto de pasión. |
| No sabes estimar cuánto cuesta | Prototipa la mecánica núcleo en una hora antes de comprometerte. |
| El pitch necesita un párrafo entero | La idea aún es difusa. Recorta hasta una frase con un solo gancho. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo reusar un prototipo de una parte anterior como capstone?** Sí, y es recomendable. Partir de algo que ya funciona reduce riesgo y te deja invertir el tiempo en pulido, que es donde se nota la calidad.

**❓ ¿Cuánto debe durar el juego terminado?** Poco. Un capstone de portfolio brilla más como 3-5 minutos impecables que como una hora a medio hacer.

**❓ ¿Y si mi idea es demasiado simple?** Mejor eso que demasiado grande. Una mecánica simple pero muy pulida demuestra criterio profesional, que es lo que evalúan.

**❓ ¿Puedo cambiar de idea más adelante?** Antes del vertical slice, sí. Después, cada cambio cuesta trabajo ya hecho. Por eso esta ficha existe: para decidir bien ahora.

**❓ ¿Es válido un capstone en solitario o necesito equipo?** En solitario es perfectamente válido y te da control total del alcance. Precisamente por trabajar solo debes acotar más: sin equipo, el scope realista es aún menor. Un juego pequeño y terminado por una persona impresiona más que uno grande y roto.

## 🔗 Referencias

- GDC — charlas sobre *scoping* y recorte de features: <https://www.youtube.com/user/gdconf>
- Extra Credits — "Scope: How to Design Your First Game": <https://www.youtube.com/c/extracredits>
- itch.io — catálogo para estudiar juegos pequeños de una mecánica: <https://itch.io/games>
- The Game Design Round Table — sobre pilares de diseño: <https://thegamedesignroundtable.com/>

## ➡️ Siguiente clase

[Clase 282 - De la idea al vertical slice](../282-de-la-idea-al-vertical-slice/README.md)
