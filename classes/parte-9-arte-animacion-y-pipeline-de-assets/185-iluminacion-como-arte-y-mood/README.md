# Clase 185 — Iluminación como arte y mood

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Godot 4 (Lights & WorldEnvironment)*
> ⏱️ Duración estimada: **100 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

La iluminación no solo hace visible una escena: la **cuenta**. La misma habitación puede sentirse acogedora al atardecer o amenazante de madrugada sin mover un solo objeto, solo cambiando cómo la iluminas. La iluminación dirige la mirada, separa al personaje del fondo, marca el tono emocional (el **mood**) y comunica hora, clima y peligro. En cine y en videojuegos se apoya en un lenguaje compartido: el esquema de **tres puntos** (key, fill, rim), la **temperatura de color** y la distinción entre luz **práctica** (una lámpara que existe en la escena) y luz **artística** (la que el artista añade para componer).

En esta clase iluminarás **una misma escena** en Godot 4 con **dos moods** opuestos —un día cálido y una noche fría— usando luces y el **WorldEnvironment**. Aprenderás a pensar la luz como decisión narrativa, no como interruptor. El código es mínimo; el trabajo está en colocar, colorear y equilibrar luces, y el entregable son dos versiones de la escena que se sienten radicalmente distintas.

Piensa en la iluminación como en la fotografía de una película: el director de foto no "enciende luces", **compone con luz**. Decide qué se ve y qué se esconde, hacia dónde va la mirada y qué siente el espectador antes de entender la escena. Ese mismo criterio, trasladado a un motor en tiempo real, es lo que separa una escena "correcta pero muerta" de una que respira.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Aplicar el esquema de **tres puntos** (key, fill, rim) a una escena 3D.
2. Usar la **temperatura de color** (cálido/frío) para fijar la hora y el mood.
3. Diferenciar y combinar luz **práctica** y luz **artística**.
4. Configurar el **WorldEnvironment** (cielo, tono, ambiente, niebla) para reforzar la atmósfera.
5. Producir **dos moods** distintos de una misma escena y justificar sus decisiones.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | La luz como narrativa | Define tono, hora y emoción sin cambiar la geometría. |
| 2 | Esquema de tres puntos | Base para modelar volumen y separar sujeto del fondo. |
| 3 | Key, fill y rim | Cada luz tiene un rol; su ratio define el drama. |
| 4 | Temperatura de color | Cálido vs frío ancla la escena en un momento y un ánimo. |
| 5 | Luz práctica vs artística | Coherencia (fuentes visibles) frente a control (composición). |
| 6 | Tipos de luz en Godot | Directional, Omni y Spot cubren sol, lámparas y focos. |
| 7 | WorldEnvironment | Cielo, tonemap, ambiente y niebla dan el "aire" de la escena. |
| 8 | Contraste y dirección de mirada | La luz guía el ojo hacia lo importante. |

## 📖 Definiciones y características

- **Mood**: tono emocional que transmite una escena. Clave: la luz es la herramienta más rápida para fijarlo.
- **Key light**: luz principal que define forma y sombras dominantes. Clave: marca la dirección y la intensidad del drama.
- **Fill light**: luz suave que rellena sombras y baja el contraste. Clave: controla cuánto misterio queda en las zonas oscuras.
- **Rim / back light**: luz trasera que perfila el contorno del sujeto. Clave: lo separa del fondo, da profundidad.
- **Temperatura de color**: medida (en kelvin) de cálido a frío. Clave: naranjas = confort/día; azules = frío/noche/peligro.
- **Luz práctica**: fuente que existe en la escena (lámpara, ventana). Clave: da credibilidad, motiva las luces artísticas.
- **DirectionalLight3D**: luz de rayos paralelos que simula el sol o la luna. Clave: es la key global de exteriores.
- **WorldEnvironment**: nodo que define cielo, ambiente, tonemap y efectos. Clave: unifica el look global de toda la escena.

## 🧰 Herramientas y preparación

Usarás **Godot 4.x** (<https://godotengine.org/download>). Puedes partir de una escena 3D propia de clases anteriores o montar una sencilla: un suelo, unas paredes, un par de props y un personaje o cápsula como sujeto. Los nodos de luz están en *Add Node → Light* (**DirectionalLight3D**, **OmniLight3D**, **SpotLight3D**) y necesitarás un **WorldEnvironment** con un **Environment** asignado. Activa **SDFGI** o luz de ambiente para un resultado más rico (Rendering → Global Illumination). Trabaja con el renderer **Forward+** para acceder a todas las funciones. Crea `iluminacion_curso/` y guarda dos escenas o dos ramas de la misma para comparar moods.

Un consejo de flujo: mantén la geometría y las cámaras **idénticas** entre las dos versiones y cambia solo la iluminación y el Environment. Solo así la comparación es honesta y demuestra que el mood proviene de la luz, no de mover cosas. Usa la misma posición de cámara (puedes guardar un `Camera3D` con transform fijo) para tus capturas finales.

## 🧪 Laboratorio guiado

Iluminarás la misma escena con dos moods: **día cálido** y **noche fría**, usando luces y WorldEnvironment.

1. **Escena base neutra.** Monta o abre la escena. Añade un **WorldEnvironment** con un Environment nuevo y un **DirectionalLight3D**. Deja todo neutro (blanco, intensidad media) como punto de partida.

   > Partir de un estado neutro y "aburrido" es intencional: te da una línea base contra la cual medir cada decisión de mood. Si empiezas ya con luces de colores, mezclarás causas y no sabrás qué aporta cada cambio.

2. **Mood A — Día cálido: key.** Orienta el **DirectionalLight3D** en ángulo bajo (tarde). Sube su energía, pon **Color** cálido (naranja suave) y activa **sombras**. Esta es tu key: define la dirección de toda la luz.

   > La dirección de la key lo es todo: una luz cenital (mediodía) aplana los rostros y da sombras duras bajo los ojos; una luz lateral y baja (tarde) modela el volumen y alarga las sombras, mucho más expresiva. Elige el ángulo pensando en la emoción, no solo en "la hora".

3. **Fill del día.** En el Environment, sube la **Ambient Light** con un tono cálido tenue, o añade un **OmniLight3D** amplio y suave del lado opuesto para rellenar sombras sin borrarlas del todo. Busca un contraste medio, agradable.

   > El fill nunca debe competir con la key: si iguala su intensidad, la escena se aplana y pierde el sentido de dirección. Piensa en el fill como "cuánta información quiero conservar en las sombras". Mucho fill = todo visible y amable; poco fill = misterio y drama.

4. **Rim y práctica.** Añade un **rim** trasero (Omni o Spot débil, ligeramente frío) que perfile al sujeto. Si la escena tiene una lámpara o ventana, coloca una luz **práctica** que la justifique.

   > El rim es el truco más rentable de la iluminación de personajes: una fina línea de luz en el borde separa al sujeto del fondo y le da presencia tridimensional. Suele funcionar mejor si es de temperatura **opuesta** a la key (rim frío con key cálida, o al revés).

5. **Environment del día.** Ajusta el **Sky** a un cielo claro, sube ligeramente la **Tonemap** (Filmic/ACES) y la exposición. Opcional: niebla cálida muy sutil para dar profundidad. Guarda esta versión como `escena_dia.tscn`.

   > El **tonemap** decide cómo se comprimen las luces altas y las sombras: Filmic y ACES dan un contraste cinematográfico y evitan blancos "quemados", mientras que Linear se ve plano. Ajusta el tonemap y la exposición como último paso, una vez colocadas las luces, para pulir el look global sin re-tocar cada foco.

6. **Mood B — Noche fría: reset de color.** Duplica la escena a `escena_noche.tscn`. Cambia la key: baja mucho su energía, gírala como luz de **luna**, y ponle un **azul frío**. Reduce las sombras duras.

   > Al pasar de día a noche no basta con bajar el brillo: cambia también el **tamaño de fuente** de la luz. El sol da sombras nítidas; la luna, muy tenue, da sombras más difusas y suaves. Ajustar la suavidad de la sombra, no solo la intensidad, es lo que vende que sea "de noche".

7. **Fill y práctica nocturnas.** Baja el ambiente a un azul muy oscuro. Ahora las **prácticas** ganan protagonismo: enciende una lámpara cálida (Omni naranja pequeño) que contraste con el frío general; ese choque cálido/frío es puro mood.

   > El contraste cálido/frío es uno de los recursos más potentes de la dirección de arte: el ojo se va instintivamente al punto cálido dentro de un ambiente frío. Úsalo para dirigir la mirada del jugador hacia lo importante (una puerta, un objetivo, un personaje).

8. **Environment nocturno.** Cambia el cielo a noche, baja la exposición, añade **niebla** azulada y sube un poco el contraste del tonemap para hundir las sombras. Considera un rim frío más marcado para no perder al sujeto.

   > En noches conviene apoyarse en la **iluminación global** (SDFGI) o en luces de ambiente muy tenues: si dejas las sombras totalmente a negro, el jugador no verá por dónde caminar. El objetivo no es "todo oscuro", sino "poca luz bien dirigida" que mantenga la legibilidad del espacio jugable.

9. **Comparar.** Renderiza o captura ambas versiones desde el mismo ángulo. Ponlas lado a lado y pregúntate: ¿un desconocido diría que transmiten emociones distintas sin que se lo expliques? Si la respuesta es no, exagera el contraste de temperatura y el ratio key/fill hasta que la diferencia sea inequívoca. **Entregable**: `escena_dia.tscn` y `escena_noche.tscn` (misma geometría) más dos capturas que evidencien el cambio de mood, con una nota de las decisiones tomadas.

## ✍️ Ejercicios

1. Crea un tercer mood: **tormenta/peligro** (frío desaturado, contraste alto, sin práctica cálida).
2. Aísla el efecto del **rim**: apágalo y enciéndelo y describe cómo cambia la separación del sujeto.
3. Cambia solo la **temperatura** de la key del día (de cálido a neutro) y anota el impacto emocional.
4. Añade una luz **práctica animada** (parpadeo de vela) con un tween sobre su energía.
5. Ajusta la **niebla** en la noche hasta lograr sensación de profundidad sin perder el sujeto.
6. Prueba dos **tonemaps** distintos (Filmic vs ACES) en el mismo mood y compara.

## 📝 Reto verificable

Entrega la **misma escena** iluminada en **dos moods claramente diferenciados** (p. ej. día cálido y noche fría), cada uno con un esquema de tres puntos identificable, al menos una luz práctica coherente y un WorldEnvironment ajustado. Acompaña cada versión con una captura desde el mismo ángulo.

**Criterio de aceptación**: sin modificar la geometría, las dos versiones transmiten emociones distintas; en cada una se pueden señalar key, fill y rim, existe al menos una luz práctica justificada, y las capturas evidencian el contraste de temperatura y contraste entre ambos moods.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| La escena se ve plana y sin volumen | Fill demasiado fuerte iguala key y sombras. Aumenta el ratio key/fill. |
| Todo se ve "lavado" o quemado | Exposición/energía excesiva. Baja intensidad o ajusta el tonemap. |
| El sujeto se funde con el fondo | Falta **rim**. Añade una luz trasera que perfile su contorno. |
| La noche se ve solo oscura, no fría | Faltó cambiar la **temperatura**; oscurecer no basta. Da tinte azul y contrasta con una práctica cálida. |
| Sombras con bandas o ruido | Parámetros de sombra bajos. Ajusta bias/resolución de la luz. |
| El WorldEnvironment no afecta | No hay Environment asignado o hay dos WorldEnvironment. Deja uno con Environment válido. |

## ❓ Preguntas frecuentes

**❓ ¿La luz artística no rompe el realismo?** No si respeta la lógica de la escena. Los artistas añaden luces que no existen físicamente, pero las motivan con prácticas plausibles (una ventana, un fuego), de modo que el ojo las acepta.

**❓ ¿Cuál es un buen ratio key/fill?** Depende del mood: un ratio alto (fill muy tenue) da drama y misterio; uno bajo (fill cercano al key) da un look plano y amable. Ajústalo a la emoción que buscas, no hay un número único.

**❓ ¿Temperatura cálida o fría para peligro?** Suele ser fría y desaturada, pero el contraste importa más que el color absoluto: una única luz cálida en un mar de azul frío puede resultar más inquietante que todo frío.

**❓ ¿Conviene abusar de la niebla?** Con moderación es oro: da profundidad y separa planos. En exceso aplana y esconde el trabajo; úsala para reforzar el mood, no para tapar la escena.

## 🔗 Referencias

- Godot Docs — Lights and shadows: <https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html>
- Godot Docs — Environment and post-processing: <https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html>
- Godot Docs — DirectionalLight3D: <https://docs.godotengine.org/en/stable/classes/class_directionallight3d.html>
- Godot Docs — Using SDFGI (GI): <https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_sdfgi.html>
- Godot Docs — WorldEnvironment: <https://docs.godotengine.org/en/stable/classes/class_worldenvironment.html>

## ➡️ Siguiente clase

[Clase 186 - Pipeline de assets: nomenclatura, LODs y optimización](../186-pipeline-de-assets-nomenclatura-lods-y-optimizacion/README.md)
