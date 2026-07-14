# Clase 165 — Diseño de niveles: principios y lenguaje visual

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Scott Rogers, Level Up! The Guide to Great Video Game Design*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un nivel bien diseñado guía al jugador sin necesidad de flechas ni carteles: la propia arquitectura, la luz y el color le dicen a dónde ir. En esta clase estudiarás el **lenguaje visual** del diseño de niveles, un vocabulario prestado del cine y la arquitectura que usa **líneas de guía (leading lines)**, contraste de luz, color saturado y **landmarks** para dirigir la mirada y el movimiento del jugador de forma inconsciente.

Aprenderás a colocar **affordances** (señales de que algo es interactuable), a usar **breadcrumbing** (migas que invitan a avanzar, como monedas en fila) y a leer las **líneas de deseo (desire paths)**: las rutas que los jugadores toman de forma natural aunque no las hayas planeado. Analizarás un nivel conocido para descubrir cómo su autor te llevó de la mano sin que lo notaras, y bosquejarás un layout aplicando estas técnicas. La meta es que dejes de diseñar espacios "bonitos" y empieces a diseñar espacios que *comunican*.

Detrás de todas estas técnicas hay una misma idea: el jugador toma cientos de micro-decisiones de navegación por segundo, casi todas inconscientes, y el diseñador puede inclinar esas decisiones sin que el jugador lo perciba. Una barandilla que apunta a la derecha, una luz cálida al final de un pasillo o una moneda flotando sobre un saliente son órdenes silenciosas. Dominar el lenguaje visual es aprender a dar esas órdenes sin levantar la voz.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. **Reconocer** líneas de guía, luz, color y landmarks en un nivel existente.
2. **Explicar** cómo las affordances comunican interactividad sin texto.
3. **Aplicar** breadcrumbing para invitar al avance sin forzarlo.
4. **Analizar** un nivel conocido identificando sus técnicas de guía visual.
5. **Bosquejar** un layout que dirija al jugador con lenguaje visual.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Guiar la mirada | El jugador va donde mira |
| 2 | Líneas de guía (leading lines) | Dirigen sin cartelería |
| 3 | Luz y contraste | La atención va a lo iluminado |
| 4 | Color como señal | Distingue lo importante de lo decorativo |
| 5 | Landmarks | Orientan y previenen que el jugador se pierda |
| 6 | Affordances | Comunican qué es interactuable |
| 7 | Breadcrumbing | Invita a avanzar con recompensas pequeñas |
| 8 | Líneas de deseo | Revelan la intención real del jugador |

## 📖 Definiciones y características

- **Lenguaje visual**: conjunto de señales gráficas que guían al jugador sin texto. Clave: comunica por diseño, no por instrucción.
- **Línea de guía (leading line)**: elemento del entorno (una viga, un río, una barandilla) que apunta hacia el objetivo. Clave: el ojo sigue la línea.
- **Contraste de luz**: zonas iluminadas atraen; las oscuras repelen o esconden. Clave: la luz es una flecha implícita.
- **Landmark (hito)**: elemento grande y único visible desde lejos (una torre, una montaña). Clave: orienta y ancla el mapa mental.
- **Affordance**: propiedad visual que sugiere una acción (un saliente amarillo dice "agárrate"). Clave: interactividad legible.
- **Breadcrumbing**: rastro de pequeñas recompensas que invita a seguir un camino. Clave: guía sin obligar.
- **Línea de deseo (desire path)**: ruta que el jugador toma de forma natural, planeada o no. Clave: retroalimenta el diseño real.
- **Coherencia visual**: consistencia en el significado de colores y formas. Clave: si el rojo es peligro, siempre lo es.

## 🧰 Herramientas y preparación

Bosquejarás con papel cuadriculado o una herramienta de diagramas como Excalidraw <https://excalidraw.com> o draw.io. Elige un nivel que recuerdes bien (un plataformas, un shooter o un juego de aventura) y ten a mano capturas o vídeo para analizarlo. Como referencia teórica usa el capítulo de diseño de niveles de Scott Rogers, *Level Up!* <https://www.wiley.com>, y para el uso de color y luz como guía, los estudios de la comunidad sobre el diseño de niveles de *Half-Life 2* y *Uncharted* (por ejemplo, el análisis de affordances de World of Level Design <https://www.worldofleveldesign.com>). El laboratorio es analítico: producirás un análisis anotado y un boceto, sin código.

## 🧪 Laboratorio guiado

Analizarás un nivel conocido para descubrir cómo guía al jugador y luego bosquejarás un layout propio aplicando lenguaje visual. El entregable es `analisis-nivel.md` con el análisis y un boceto anotado.

**Paso 1 — Elige y describe el nivel.** Anota el juego, el nivel y el objetivo del jugador (llegar de A a B, encontrar una llave, sobrevivir). Elige un nivel donde recuerdes haberte movido con soltura: esa fluidez suele ser señal de buen lenguaje visual funcionando de fondo.

**Paso 2 — Cataloga las técnicas de guía.** Recorre el nivel mentalmente y marca cada técnica que encuentres:

```markdown
| Técnica            | ¿Dónde aparece?              | ¿Hacia qué guía?        |
|--------------------|------------------------------|-------------------------|
| Línea de guía      | pasarela que apunta al fondo | la salida               |
| Luz / contraste    | puerta iluminada en penumbra | el siguiente objetivo   |
| Color señal        | agarres pintados de amarillo | zonas escalables        |
| Landmark           | torre visible desde el inicio| orientación global      |
| Breadcrumbing      | monedas en fila hacia arriba | plataforma oculta       |
```

**Paso 3 — Identifica las líneas de deseo.** ¿Hay un atajo o una ruta "no oficial" que los jugadores tomarían? Márcala y razona por qué. Pregúntate qué haría un jugador con prisa o uno que ya conoce el nivel: sus rutas revelan las líneas de deseo más comunes.

**Paso 3b — Distingue guía fuerte de guía suave.** Anota cuáles señales del nivel son *fuertes* (imposibles de ignorar, como una única puerta iluminada) y cuáles *suaves* (invitaciones que se pueden desatender, como una moneda opcional). Un buen nivel combina ambas: las fuertes garantizan el avance y las suaves premian la curiosidad.

**Paso 4 — Bosqueja tu propio layout.** Dibuja un nivel simple (inicio, objetivo, uno o dos obstáculos). Usa cajas, flechas y símbolos; el arte no importa.

**Paso 5 — Anota tu boceto.** Sobre el dibujo, marca con flechas y notas dónde pusiste cada técnica: la línea de guía, la luz, el color señal, el landmark y las migas. Cada elemento debe tener un propósito de guía; si colocaste algo "porque queda bonito" pero no comunica nada, anótalo aparte como decoración, no como guía.

**Paso 5b — Verifica la coherencia de color.** Repasa que cada color mantenga un único significado en todo tu layout: si el amarillo marca lo escalable, no lo uses también para lo peligroso. La incoherencia de color es una de las causas más frecuentes de confusión del jugador.

**Paso 6 — Recorrido del ojo.** Antes de la prueba final, traza sobre tu boceto la línea que seguiría la mirada de un jugador al aparecer: dónde se posa primero, hacia dónde se desliza, dónde se detiene. Si esa línea no termina en el objetivo, reordena las señales hasta que lo haga.

**Paso 7 — Prueba de "sin HUD".** Escribe un párrafo: si quitaras todo el HUD y los marcadores de objetivo, ¿el jugador aún sabría a dónde ir? Justifica con las técnicas que colocaste e identifica cuál es la señal más fuerte de tu nivel y cuál la más débil o redundante.

**Checklist del entregable:**

- [ ] La tabla cataloga al menos cuatro técnicas de guía distintas.
- [ ] Cada técnica indica dónde aparece y hacia qué guía.
- [ ] Se identifica y razona al menos una línea de deseo.
- [ ] El boceto propio anota como mínimo tres técnicas con su propósito.
- [ ] Está trazado el recorrido del ojo hasta el objetivo.
- [ ] El párrafo argumenta la navegabilidad sin HUD.

## ✍️ Ejercicios

1. Encuentra una línea de guía en una foto o captura de un juego y explica hacia dónde dirige el ojo.
2. Rediseña un pasillo aburrido añadiendo un landmark que oriente al jugador.
3. Elige un color y define su significado consistente en todo un nivel (por ejemplo, verde = seguro).
4. Coloca breadcrumbing para llevar al jugador a un secreto sin marcarlo en el mapa.
5. Analiza un nivel donde te perdiste y diagnostica qué técnica de guía faltaba.
6. Dibuja dos versiones de la misma sala: una que atraiga a la izquierda y otra a la derecha, solo con luz.

## 📝 Reto verificable

Entrega `analisis-nivel.md` con: la descripción del nivel analizado, la tabla de técnicas de guía catalogadas, la identificación de al menos una línea de deseo, un boceto anotado de un layout propio y el párrafo de la prueba "sin HUD".

**Criterio de aceptación**: la tabla cataloga al menos cuatro técnicas distintas con su ubicación y hacia qué guían; se identifica y razona al menos una línea de deseo; el boceto propio incluye anotadas como mínimo tres técnicas de guía con propósito explícito; el párrafo argumenta de forma coherente si el jugador se orientaría sin HUD.

## ⚠️ Errores comunes

| Síntoma | Causa y cómo arreglar |
|---------|-----------------------|
| El jugador se pierde | Faltan landmarks o líneas de guía. Añade un hito visible y orienta la arquitectura hacia el objetivo. |
| No distingue lo interactuable | Affordances débiles. Usa color o forma consistente para lo que se puede tocar. |
| El jugador ignora el camino principal | Sin breadcrumbing ni luz. Guía con migas y contraste hacia la ruta deseada. |
| Colores sin significado claro | Incoherencia visual. Fija un código de color y respétalo en todo el nivel. |
| Dependencia total del marcador de objetivo | El nivel no comunica solo. Diseña la guía para que funcione sin HUD. |
| Atajos rompen el nivel | Ignoraste las líneas de deseo. Detéctalas en playtest y decídelas o bloquéalas a propósito. |

## ❓ Preguntas frecuentes

**❓ ¿El lenguaje visual reemplaza al HUD?** No lo reemplaza, lo complementa. Un buen nivel debería seguir siendo navegable con el HUD desactivado; el marcador de objetivo es una ayuda, no la única guía.

**❓ ¿La luz siempre atrae al jugador?** En general sí: el ojo va al contraste. Puedes usarlo para guiar hacia la salida o, deliberadamente, para esconder secretos en la penumbra.

**❓ ¿Qué diferencia una affordance de un landmark?** La affordance comunica una acción posible (esto se escala); el landmark comunica orientación (estoy cerca de la torre). Uno guía la mano, el otro el mapa mental.

**❓ ¿Debo eliminar todas las líneas de deseo?** No. A veces son atajos que enriquecen la rejugabilidad. La clave es detectarlas y decidir conscientemente si las integras, las premias o las bloqueas. Recuerda además que los principios se mantienen en 2D y en 3D, aunque cambian las herramientas: en 2D pesan el color y la silueta, y en 3D entran la profundidad, la iluminación y el encuadre de la cámara.

## 🔗 Referencias

- Scott Rogers, *Level Up! The Guide to Great Video Game Design* — <https://www.wiley.com>
- World of Level Design (guía visual y affordances) — <https://www.worldofleveldesign.com>
- Jesse Schell, *The Art of Game Design: A Book of Lenses* (3ª ed.) — <https://www.schellgames.com>
- Game Maker's Toolkit (lenguaje visual en niveles) — <https://www.youtube.com/c/MarkBrownGMT>

## ➡️ Siguiente clase

[Clase 166 - Pacing, ritmo y composición de un nivel](../166-pacing-ritmo-y-composicion-de-un-nivel/README.md)
