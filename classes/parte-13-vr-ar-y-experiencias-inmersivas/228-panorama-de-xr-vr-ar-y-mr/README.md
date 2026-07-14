# Clase 228 — Panorama de XR: VR, AR y MR

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Khronos Group — OpenXR Overview y guías de diseño XR*
> ⏱️ Duración estimada: **60 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La realidad extendida (**XR**) es el término paraguas que engloba la realidad virtual (**VR**), la realidad aumentada (**AR**) y la realidad mixta (**MR**). Cada una plantea un contrato distinto con el jugador: la VR lo aísla en un mundo sintético, la AR superpone información al mundo real y la MR combina ambos permitiendo que lo virtual reaccione al entorno físico. Entender estas diferencias no es teoría: determina el hardware, el presupuesto de rendimiento, el estilo de interacción y, sobre todo, el confort del usuario.

En esta clase construyes el mapa mental completo antes de tocar Godot. Verás los casos de uso donde cada modalidad brilla, por qué el **mareo (cybersickness)** es el enemigo número uno de la VR y cómo el rendimiento se vuelve una restricción de salud, no solo de fluidez. El laboratorio es analítico: partiendo de una idea de experiencia, elegirás VR, AR o MR con criterios explícitos y defenderás la decisión.

La decisión de modalidad es la más barata de cambiar ahora y la más cara de cambiar después. Elegir bien aquí condiciona positivamente todo el resto de la parte: qué hardware asumes (clase 229), cómo mueves al jugador sin marearlo (clase 232) y cómo diseñas la interacción con las manos (clase 233). Por eso empezamos por el panorama y no por el código.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Definir VR, AR, MR y XR y distinguirlas con ejemplos concretos.
2. Asociar cada modalidad con casos de uso donde aporta más valor.
3. Explicar qué es el mareo (cybersickness) y por qué el rendimiento lo condiciona.
4. Describir el ecosistema actual de dispositivos (standalone, PCVR, AR móvil).
5. Elegir la modalidad adecuada para una idea usando criterios de diseño.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | VR: inmersión total | El jugador sustituye su entorno; máxima presencia y máximo riesgo de mareo. |
| 2 | AR: superposición | Añade capas sobre el mundo real sin aislar; ideal para utilidad y contexto. |
| 3 | MR: fusión reactiva | Lo virtual respeta la geometría física; passthrough y anclajes espaciales. |
| 4 | XR como paraguas | Un mismo estándar (OpenXR) cubre todo el espectro. |
| 5 | Cybersickness | El mareo define límites de locomoción, fps y diseño. |
| 6 | Presupuesto de rendimiento | 72–90+ fps no es lujo: es requisito de confort físico. |
| 7 | Ecosistema de hardware | Quest, PCVR y AR móvil imponen restricciones distintas. |
| 8 | Grados de libertad | 3DoF vs 6DoF cambia radicalmente qué experiencias son viables. |
| 9 | Presencia | La sensación de "estar ahí" es la métrica de éxito de la VR. |

## 📖 Definiciones y características

- **VR (Realidad Virtual)**: entorno sintético que reemplaza por completo la visión del usuario. Clave: máxima inmersión, máxima exigencia de confort.
- **AR (Realidad Aumentada)**: elementos virtuales superpuestos al mundo real, normalmente vía cámara del móvil o gafas. Clave: el mundo real sigue siendo el escenario.
- **MR (Realidad Mixta)**: lo virtual y lo físico coexisten e interactúan; los objetos digitales se ocluyen y anclan a superficies reales. Clave: requiere entender la geometría del entorno.
- **XR (Realidad Extendida)**: término paraguas que agrupa VR, AR y MR. Clave: es el ámbito de estándares como OpenXR.
- **Cybersickness**: malestar (náusea, sudor, desorientación) por conflicto entre lo que el ojo ve y lo que el oído interno siente. Clave: se agrava con caídas de fps y movimiento no controlado por el jugador.
- **Presencia**: sensación de "estar realmente ahí". Clave: se rompe con latencia, baja tasa de frames o interacciones poco naturales.
- **Passthrough**: uso de las cámaras del visor para mostrar el entorno real dentro de un dispositivo VR. Clave: habilita MR en hardware standalone.
- **DoF (Grados de libertad)**: 3DoF sigue solo la rotación de la cabeza; 6DoF sigue rotación y posición. Clave: 6DoF permite moverse y agacharse; 3DoF no.
- **Flujo óptico**: cantidad de movimiento visual percibido, sobre todo en la visión periférica. Clave: cuanto mayor es, más probable es el mareo; se reduce con viñetas de confort.
- **Ecosistema standalone**: dispositivos autónomos tipo Meta Quest, con GPU de móvil. Clave: máxima accesibilidad y volumen de usuarios, presupuesto gráfico limitado.
- **PCVR**: visor conectado a un PC potente que hace el render. Clave: máxima calidad gráfica a cambio de menos portabilidad y mayor coste de entrada.
- **AR móvil**: realidad aumentada a través de la cámara y pantalla de un teléfono. Clave: no requiere hardware dedicado, pero ocupa las manos del usuario.

## 🧰 Herramientas y preparación

Esta clase es conceptual, así que no necesitas escribir código todavía, pero sí tener el marco correcto. Ten a mano la documentación de **XR en Godot 4** (<https://docs.godotengine.org/en/stable/tutorials/xr/index.html>) y la **OpenXR Overview** de Khronos (<https://www.khronos.org/openxr/>). Si dispones de un visor (Meta Quest, por ejemplo) o un móvil con soporte AR, tenerlo cerca ayuda a intuir las diferencias.

Prepara una plantilla de decisión sencilla (una tabla) donde para cada idea anotes: nivel de inmersión deseado, movilidad del usuario, necesidad de ver el entorno real, precisión de tracking requerida y presupuesto de hardware. Esa tabla será tu entregable del laboratorio.

Como material de referencia, revisa un par de ejemplos comerciales por modalidad: un juego VR de acción (inmersión total), una app AR de medición o filtros faciales (superposición sobre el mundo) y una experiencia MR de decoración de interiores (objetos virtuales anclados a tu sala). Ver casos reales calibra tu intuición antes de puntuar tu propia idea.

## 🧪 Laboratorio guiado

Este laboratorio es **analítico**: elegirás la modalidad XR correcta para una idea concreta con criterios verificables.

1. Elige una idea de experiencia. Ejemplo de trabajo: *"una app para practicar el montaje de un motor de bicicleta"*.

2. Redacta en una nota los cinco criterios de decisión: (a) ¿el usuario debe ver sus manos y el mundo real?, (b) ¿necesita moverse por un espacio?, (c) ¿la experiencia debe ocluir el entorno?, (d) ¿qué precisión de anclaje espacial exige?, (e) ¿qué hardware asumen los usuarios?

3. Puntúa cada modalidad (VR / AR / MR) de 1 a 5 en cada criterio. Para la bicicleta: ver el mundo real puntúa alto en AR/MR y bajo en VR.

4. Suma y contrasta. En el ejemplo, la MR (passthrough en un standalone) gana: el usuario ve la bici real con guías virtuales superpuestas y ancladas.

5. Justifica en dos frases por qué las otras dos modalidades pierden. VR aísla del objeto físico real; AR móvil obliga a sostener el teléfono y libera menos las manos.

6. Deriva tres implicaciones técnicas de tu elección. Para MR: necesitas passthrough, anclajes espaciales estables y un presupuesto de fps alto porque el confort no es negociable.

7. Escribe una conclusión de una línea con la modalidad elegida y la restricción de rendimiento asociada (por ejemplo, "MR standalone a 72 fps mínimos sostenidos").

8. Como validación cruzada, repite el análisis para una segunda idea de naturaleza opuesta (por ejemplo, *"un shooter espacial frenético"*). Observa cómo, para esta, la VR gana claramente: la inmersión total y el aislamiento del entorno son deseables, y el mareo se mitiga con teletransporte y una cabina fija como marco de referencia.

9. Contrasta ambos resultados en una frase: la misma matriz de criterios lleva a modalidades distintas según el objetivo. Esto demuestra que la elección es metodológica, no de gusto personal.

Aunque no toques Godot, este análisis es exactamente el primer paso de cualquier proyecto XR profesional y evita rehacer todo el diseño más adelante. Un error de modalidad detectado tarde obliga a rehacer arte, interacción y locomoción; detectado aquí, cuesta una tabla.

Guarda el documento resultante: será tu punto de partida en la clase 229, donde traducirás la modalidad elegida en requisitos concretos de hardware, y volverás a él en el capstone de la parte para justificar todas tus decisiones de diseño con una traza clara desde el concepto inicial.

## ✍️ Ejercicios

1. Define VR, AR, MR y XR con tus palabras y un ejemplo comercial real por cada una.
2. Da dos casos de uso donde la AR aporte más valor que la VR y explica por qué.
3. Describe una situación en la que el mareo arruinaría una experiencia VR y una mitigación.
4. Compara 3DoF y 6DoF indicando una experiencia viable solo con 6DoF.
5. Explica por qué "60 fps está bien" es falso en VR y qué cifra buscar.
6. Aplica la tabla de decisión a una idea propia y anota la modalidad ganadora.
7. Identifica una app comercial que combine modalidades (por ejemplo, passthrough que pasa a VR) y describe la transición.
8. Argumenta en un párrafo por qué el confort es una decisión de diseño y no de optimización final.

## 📝 Reto verificable

Toma una idea de experiencia inmersiva (propia o asignada) y produce un documento breve de decisión que incluya: la matriz de puntuación de las tres modalidades sobre cinco criterios, la modalidad elegida, la justificación del descarte de las otras dos y tres implicaciones técnicas (hardware, tracking y presupuesto de fps).

**Criterio de aceptación**: el documento presenta una matriz con puntuaciones numéricas por criterio, una modalidad ganadora coherente con esas puntuaciones, y al menos tres implicaciones técnicas concretas (incluida una cifra de fps objetivo) derivadas de la elección.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Confundir AR con MR | AR solo superpone; MR ancla y ocluye. Aplica el criterio "¿lo virtual reacciona a la geometría real?". |
| Elegir VR "porque impresiona más" | La inmersión total no siempre encaja. Puntúa por criterios, no por espectáculo. |
| Ignorar el mareo en el diseño | El confort es de diseño, no de post. Decide locomoción y fps desde el inicio. |
| Asumir 6DoF sin verificar hardware | Muchos móviles/gafas son 3DoF. Confirma DoF antes de prometer movimiento libre. |
| Prometer passthrough en cualquier visor | No todos lo ofrecen con calidad. Verifica soporte MR del dispositivo objetivo. |
| Tratar el confort como un "arreglo final" | El mareo se evita en el diseño. Decide locomoción, marco de referencia y fps desde el concepto. |

## ❓ Preguntas frecuentes

**❓ ¿La MR necesita gafas transparentes?** No necesariamente. Muchos visores standalone hacen MR por *passthrough*: cámaras que muestran el entorno real dentro de una pantalla opaca.

**❓ ¿Por qué se marea la gente en VR y no en AR?** En AR el mundo real sigue como referencia visual estable. En VR todo el campo visual es sintético, así que cualquier discrepancia con el oído interno provoca conflicto.

**❓ ¿XR es lo mismo que "metaverso"?** No. XR es un conjunto de tecnologías; "metaverso" es un concepto de producto/mercado que puede o no usar XR.

**❓ ¿Necesito hardware caro para aprender?** No para esta clase. El análisis es conceptual; el hardware ayuda a intuir, pero puedes seguir el curso con el simulador de Godot en las clases prácticas.

**❓ ¿Una experiencia puede combinar modalidades?** Sí. Hay apps que arrancan en passthrough (MR) para situar al usuario en su sala y luego oscurecen el entorno para pasar a VR total. La clave es que cada transición sea deliberada y cómoda.

## 🔗 Referencias

- Khronos — OpenXR Overview: <https://www.khronos.org/openxr/>
- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Meta — VR comfort y best practices: <https://developers.meta.com/horizon/resources/>
- Godot Docs — Introducing XR: <https://docs.godotengine.org/en/stable/tutorials/xr/introducing_xr_tools.html>
- Khronos — What is OpenXR (whitepaper): <https://www.khronos.org/files/openxr-10-reference-guide.pdf>
- Godot Docs — XR tools y simulador: <https://github.com/GodotVR/godot-xr-tools>

## ➡️ Siguiente clase

[Clase 229 - Hardware XR: visores, tracking y controles](../229-hardware-xr-visores-tracking-y-controles/README.md)
