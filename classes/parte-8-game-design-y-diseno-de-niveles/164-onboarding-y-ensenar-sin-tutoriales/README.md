# Clase 164 — Onboarding y enseñar sin tutoriales

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Scott Rogers, Level Up! The Guide to Great Video Game Design*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Los mejores juegos te enseñan a jugar sin que te des cuenta de que te están enseñando. En esta clase estudiarás el **onboarding**: los primeros minutos en los que el jugador decide si el juego merece su tiempo y en los que debe aprender las mecánicas sin muros de texto ni pop-ups intrusivos. El caso canónico es el primer nivel de *Super Mario Bros.*, que enseña a moverse, saltar, evitar enemigos y recoger power-ups usando solo el diseño del espacio, sin una sola palabra de instrucción.

Aprenderás a **introducir mecánicas de forma escalonada**: presentar una idea en un entorno seguro, dejar que el jugador la practique, subir el reto y luego combinarla con otras. Verás técnicas de **señalización** (guiar con luz, forma y disposición) y por qué los tutoriales de texto largos son casi siempre una señal de que el diseño de nivel falló en enseñar por sí mismo. El objetivo es que diseñes un onboarding que enseñe a través del espacio, no del manual.

El principio que subyace a todo el enfoque es sencillo de enunciar y difícil de ejecutar: muestra, no expliques. Un jugador que descubre por sí mismo que puede saltar sobre un enemigo recuerda esa regla mucho mejor que uno al que se lo dijo un cartel. El diseñador convierte cada regla en una situación cuidadosamente construida donde esa regla es la respuesta natural.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. **Explicar** por qué enseñar por diseño supera a los tutoriales de texto.
2. **Descomponer** el aprendizaje de una mecánica en introducción, práctica, reto y combinación.
3. **Diseñar** una secuencia de onboarding de 3-4 pasos de nivel sin texto.
4. **Aplicar** señalización visual para guiar sin instrucciones explícitas.
5. **Construir** una tabla de introducción escalonada de mecánicas para un juego.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Los primeros minutos | Deciden retención y primera impresión |
| 2 | Enseñar por diseño | El nivel es el mejor profesor |
| 3 | Introducción escalonada | Evita saturar al jugador |
| 4 | Entorno seguro de práctica | Permite fallar sin castigo al aprender |
| 5 | Señalización visual | Guía la atención sin palabras |
| 6 | Combinación de mecánicas | Genera profundidad tras el dominio |
| 7 | El problema de los muros de texto | Rompen el flujo y no se leen |
| 8 | Tabla de introducción de mecánicas | Planifica el orden de enseñanza |

## 📖 Definiciones y características

- **Onboarding**: primeros minutos donde el jugador aprende y se engancha. Clave: retención temprana.
- **Enseñar por diseño**: transmitir reglas mediante el propio nivel, sin texto. Clave: el jugador descubre en vez de leer.
- **Introducción escalonada**: presentar una mecánica a la vez y subir el reto gradualmente. Clave: carga cognitiva controlada.
- **Entorno seguro (safe space)**: zona donde probar una mecánica sin morir. Clave: fomenta el aprendizaje por experimentación.
- **Señalización (signposting)**: uso de luz, color, forma o layout para dirigir la atención. Clave: guía implícita.
- **Momento "ajá"**: instante en que el jugador comprende una mecánica por sí mismo. Clave: aprendizaje memorable y satisfactorio.
- **Muro de texto**: bloque de instrucciones que interrumpe el juego. Clave: síntoma de que el nivel no enseña solo.
- **Curva de introducción**: orden en que se presentan y combinan las mecánicas. Clave: estructura del aprendizaje.

## 🧰 Herramientas y preparación

No necesitas motor: bosquejarás en papel cuadriculado o con una herramienta de diagramas (Excalidraw <https://excalidraw.com> o draw.io). Ten a mano vídeo o recuerdo del primer nivel de un plataformas clásico para analizar. Como referencia de análisis del método, revisa la lección del diseño del World 1-1 de *Super Mario Bros.* documentada por Eurogamer/Nintendo y el capítulo de onboarding de Scott Rogers, *Level Up!* <https://www.wiley.com>. Un recurso clásico sobre enseñar mecánicas por diseño es la serie *Boss Keys* y análisis de Game Maker's Toolkit <https://www.youtube.com/c/MarkBrownGMT>. El laboratorio es analítico: producirás bocetos y tablas, no código.

## 🧪 Laboratorio guiado

Diseñarás el onboarding de una mecánica en 3-4 pasos de nivel, sin una sola palabra de texto, y crearás la tabla de introducción de mecánicas del juego. El entregable es `onboarding.md` con bocetos.

**Paso 1 — Elige la mecánica.** Una sola, concreta y observable: por ejemplo "el doble salto", "empujar cajas" o "disparar a interruptores". Anota qué debe aprender el jugador.

**Paso 2 — Diseña la secuencia de 4 pasos.** Aplica el patrón introducción → práctica → reto → combinación:

```text
Paso 1 (Introducción): situación donde la mecánica es la única salida obvia y segura.
Paso 2 (Práctica): repetir la mecánica con variación menor, aún sin peligro mortal.
Paso 3 (Reto): usar la mecánica bajo presión (tiempo, enemigo, precisión).
Paso 4 (Combinación): mezclar con una mecánica ya conocida.
```

**Paso 3 — Boceta cada paso.** Un croquis simple por paso (bloques, el jugador, la meta, los peligros). No hace falta arte: cajas y flechas bastan.

**Paso 4 — Añade la señalización.** Marca en cada boceto cómo guías la mirada sin texto: una moneda que invita a saltar, luz sobre la salida, un enemigo colocado para forzar la acción.

**Paso 5 — Construye la tabla de introducción de mecánicas.** Para el juego completo, ordena cuándo aparece cada mecánica:

```markdown
| Orden | Mecánica       | Se introduce en   | Se combina con        |
|-------|----------------|-------------------|-----------------------|
| 1     | mover/saltar   | Nivel 1, tramo A  | —                     |
| 2     | doble salto    | Nivel 1, tramo C  | plataformas móviles   |
| 3     | empujar cajas  | Nivel 2           | doble salto           |
```

**Paso 6 — Prueba del amigo imaginario.** Recorre tu secuencia poniéndote en la piel de alguien que nunca ha jugado nada parecido. En cada paso pregúntate: ¿qué es lo primero que probaría? Si la respuesta no coincide con lo que quieres enseñar, ajusta la disposición del espacio hasta que la acción correcta sea también la más tentadora.

**Paso 7 — Justifica el "sin texto".** Escribe un párrafo explicando cómo el jugador entiende cada paso sin leer nada, apoyándote en la señalización y el entorno seguro. Señala qué pasaría si eliminaras el entorno seguro del primer paso: probablemente el jugador aprendería la mecánica muriendo, una lección mucho más frustrante.

**Checklist del entregable:**

- [ ] La mecánica elegida es una sola, concreta y observable.
- [ ] La secuencia sigue el orden introducción → práctica → reto → combinación.
- [ ] Cada paso tiene un boceto, aunque sea de cajas y flechas.
- [ ] Cada paso incluye al menos una señal visual explícita.
- [ ] La tabla ordena un mínimo de tres mecánicas con su punto de introducción.
- [ ] Ninguna parte del onboarding depende de texto instructivo.

## ✍️ Ejercicios

1. Analiza el primer nivel de un juego que conozcas y anota qué mecánica enseña sin decirlo.
2. Reescribe un tutorial de texto real como una secuencia de 3 pasos de nivel.
3. Diseña un entorno seguro para practicar una mecánica peligrosa antes de exponerla al riesgo.
4. Elige una señal visual (luz, color o forma) y muestra cómo guiar al jugador hacia una salida oculta.
5. Ordena cinco mecánicas de un juego en una curva de introducción sin saturar los primeros minutos.
6. Detecta un muro de texto en un juego y propón cómo convertirlo en enseñanza por diseño.

## 📝 Reto verificable

Entrega `onboarding.md` con: la mecánica elegida, la secuencia de 3-4 pasos (introducción, práctica, reto, combinación), un boceto por paso con señalización marcada, la tabla de introducción de mecánicas y el párrafo que justifica el aprendizaje sin texto.

**Criterio de aceptación**: la secuencia tiene al menos 3 pasos que siguen el orden introducción→práctica→reto(→combinación); cada paso incluye un boceto y al menos una señal visual explícita; la tabla ordena un mínimo de tres mecánicas con su punto de introducción; ninguna parte del onboarding depende de texto instructivo y el párrafo lo justifica.

## ⚠️ Errores comunes

| Síntoma | Causa y cómo arreglar |
|---------|-----------------------|
| El jugador no sabe qué hacer | Falta señalización. Añade luz, color o un objeto que invite a la acción. |
| Muro de texto al empezar | Confías en instrucciones. Traslada la enseñanza al diseño del espacio. |
| El jugador muere al aprender | No hay entorno seguro. Introduce la mecánica sin peligro mortal primero. |
| Demasiadas mecánicas de golpe | Sin escalonar. Presenta una a la vez y espera a que se domine. |
| El "momento ajá" no ocurre | El paso de introducción es ambiguo. Haz que la mecánica sea la única salida obvia. |
| El jugador olvida una mecánica | No se refuerza. Reintrodúcela combinada más adelante. |

## ❓ Preguntas frecuentes

**❓ ¿Los tutoriales de texto son siempre malos?** No; sistemas complejos (estrategia, gestión) a veces los necesitan. Pero para mecánicas de acción, enseñar por diseño casi siempre gana en flujo y memorabilidad.

**❓ ¿Cuánto debe durar el onboarding?** Lo mínimo para que el jugador sea competente y quiera seguir. Si tras varios minutos aún estás enseñando lo básico, el ritmo es demasiado lento.

**❓ ¿Puedo mezclar dos mecánicas nuevas en el mismo paso?** Es arriesgado. Introduce cada una por separado y combínalas solo cuando ambas estén dominadas.

**❓ ¿Cómo sé si mi onboarding funciona sin playtesters?** No lo sabes con certeza; el playtest es imprescindible. Pero un buen indicador es si un desconocido supera el primer tramo sin preguntar qué hacer.

## 🔗 Referencias

- Scott Rogers, *Level Up! The Guide to Great Video Game Design* — <https://www.wiley.com>
- Game Maker's Toolkit (análisis de enseñanza por diseño) — <https://www.youtube.com/c/MarkBrownGMT>
- Jesse Schell, *The Art of Game Design: A Book of Lenses* (3ª ed.) — <https://www.schellgames.com>
- The Design of Super Mario Bros. World 1-1 (referencia de análisis) — <https://en.wikipedia.org/wiki/Super_Mario_Bros.>

## ➡️ Siguiente clase

[Clase 165 - Diseño de niveles: principios y lenguaje visual](../165-diseno-de-niveles-principios-y-lenguaje-visual/README.md)
