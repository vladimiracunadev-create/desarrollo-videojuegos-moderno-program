# Clase 255 — Por qué construir herramientas propias

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Editor plugins / Making plugins) y experiencia de estudios sobre pipelines de producción*
> ⏱️ Duración estimada: **60 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

El tooling es el trabajo que hace posible el resto del trabajo. Un buen conjunto de herramientas internas convierte una tarea de veinte minutos en un clic, elimina errores humanos repetitivos y —lo más valioso— **empodera a diseñadores y artistas** para iterar sin depender de un programador. En esta clase razonamos cuándo esa inversión rinde y cuándo es una distracción cara disfrazada de productividad.

Aprenderás a pensar el tooling como una decisión económica y no meramente técnica: cada herramienta tiene un coste de construcción y de mantenimiento, y solo se justifica si el ahorro acumulado a lo largo de la vida del proyecto lo supera. Analizaremos el marco **construir vs comprar vs no hacer nada**, el coste oculto de mantener herramientas frágiles, y una fórmula sencilla de **ROI** que aplicarás a tu propio proyecto para decidir con datos, no por entusiasmo, qué automatizar primero.

Esta primera clase de la parte es deliberadamente estratégica: antes de escribir un solo `@tool` o `EditorPlugin` en las clases siguientes, conviene saber **qué merece construirse**. Un equipo puede hundir semanas en herramientas elegantes que nadie usa, o ahorrar meses con un botón bien colocado. La diferencia no está en la habilidad técnica, sino en haber elegido el objetivo correcto con criterio.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar cómo una herramienta interna multiplica la productividad del equipo, no solo la individual.
2. Aplicar el criterio construir vs comprar vs no automatizar a una tarea concreta.
3. Estimar el ROI de automatizar una tarea repetitiva con una fórmula de tiempo ahorrado.
4. Identificar el coste oculto (mantenimiento, formación, deuda) de una herramienta propia.
5. Priorizar una lista de candidatos a automatización según frecuencia, riesgo y ahorro.

## 🗺️ Temas

Estos ocho temas trazan el arco de la decisión: primero entender qué es y qué aporta el tooling, luego los tres factores que gobiernan su rentabilidad, y por último los frenos (coste oculto, deuda) que evitan que construyas de más.

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es el tooling y por qué existe | Sitúa las herramientas como infraestructura, no como lujo. |
| 2 | Multiplicar productividad del equipo | Una hora invertida ahorra decenas repartidas entre varias personas. |
| 3 | Empoderar a diseñadores y artistas | Reduce el cuello de botella de "pedirle al programador". |
| 4 | Construir vs comprar (asset store, plugins) | Evita reinventar lo que ya existe y está mantenido. |
| 5 | El coste oculto del tooling | Toda herramienta se mantiene, documenta y enseña. |
| 6 | Frecuencia × tiempo × personas | Los tres factores que disparan o hunden el ROI. |
| 7 | Riesgo de error humano | Automatizar lo frágil evita bugs difíciles de rastrear. |
| 8 | Cuándo NO construir | El tiempo del programador también es finito. |

Los temas 2 y 3 son la promesa; el 4 introduce la alternativa de comprar; los temas 5 a 8 son el freno de mano que impide sobreinvertir. Mantén los tres bloques en mente al auditar tu proyecto.

## 📖 Definiciones y características

El vocabulario de esta clase es el de una decisión de inversión. Interiorízalo: te permitirá defender ante tu equipo, con términos precisos, por qué una herramienta se construye y otra no.

- **Tooling**: conjunto de herramientas internas que asisten la producción (editores, validadores, generadores). Clave: su usuario final es el propio equipo, no el jugador.
- **Productividad multiplicada**: ahorro que se repite en cada uso y en cada persona. Clave: escala con el tamaño del equipo y la vida del proyecto.
- **Construir vs comprar**: decisión entre desarrollar la herramienta o adquirir un plugin/asset existente. Clave: comprar transfiere el mantenimiento a un tercero.
- **Coste oculto**: esfuerzo de mantener, documentar y formar que no se ve en la estimación inicial. Clave: suele superar al coste de la primera versión.
- **ROI (retorno de inversión)**: relación entre el tiempo ahorrado y el tiempo invertido en construir. Clave: solo positivo si el ahorro acumulado supera la inversión.
- **Tarea repetitiva**: acción manual que se ejecuta muchas veces de forma casi idéntica. Clave: candidata ideal por su frecuencia predecible.
- **Riesgo de error**: probabilidad de que una tarea manual introduzca un fallo. Clave: eleva el valor de automatizar aunque el ahorro de tiempo sea moderado.
- **Deuda de tooling**: herramientas mal mantenidas que frenan en lugar de ayudar. Clave: una herramienta rota cuesta más que no tenerla.
- **Factor de reducción**: fracción del tiempo manual que la herramienta elimina (0 a 1). Clave: rara vez es 1; automatizar aún deja verificación y ajustes.
- **Semana de amortización**: número de semanas hasta que el ahorro iguala la inversión inicial. Clave: si supera la vida del proyecto, la herramienta no rinde.
- **Versión mínima viable de una herramienta**: la implementación más pequeña que resuelve el grueso del problema. Clave: reduce `c_build` y adelanta la amortización; se amplía solo si el uso lo justifica.

## 🧰 Herramientas y preparación

Esta clase es **analítica**: no escribimos GDScript todavía, sino que preparamos el terreno para las cinco clases siguientes, en las que sí construiremos herramientas reales con `@tool` y `EditorPlugin`. Necesitas un proyecto propio (o uno de prácticas de partes anteriores) sobre el que puedas observar tu flujo de trabajo real durante una sesión.

Ten a mano una hoja de cálculo o un archivo de texto para registrar tiempos. Revisa la introducción oficial a los plugins para dimensionar lo que Godot permite automatizar: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html>. La visión general del sistema de plugins está en <https://docs.godotengine.org/en/stable/tutorials/plugins/index.html>.

Conviene también echar un vistazo al **Asset Library** integrado en Godot (pestaña *AssetLib* del editor), porque muchas herramientas que crees necesitar ya existen mantenidas por la comunidad. Parte del ejercicio de esta clase es aprender a mirar ahí **antes** de decidir construir: comprar (o instalar gratis) suele ganar a construir cuando la herramienta no es específica de tu juego.

## 🧪 Laboratorio guiado

Vamos a **auditar tu propio proyecto** y decidir con números qué automatizar. El entregable es una tabla de ROI, no código; es el único laboratorio de la parte sin GDScript, y su producto alimentará directamente lo que construyas en las clases 256 a 260.

1. Trabaja media hora sobre tu proyecto en Godot como lo harías normalmente (colocar objetos, ajustar valores, exportar, renombrar assets). Con un cronómetro, **anota cada acción manual repetitiva** que hagas más de una vez. No filtres todavía: registra incluso las tareas que parecen triviales, porque una acción de diez segundos repetida cien veces al día es un candidato de tooling tan legítimo como una tarea larga y ocasional.

2. De esa lista, elige las **tres tareas repetitivas** más frecuentes. Para cada una registra tres datos: minutos por ejecución (`t`), veces que se repite por semana (`f`) y personas que la hacen (`p`). Sé honesto con `f`: la tendencia natural es sobreestimar la frecuencia de lo que nos aburre y subestimar la de lo que hacemos en piloto automático. Si puedes, revisa el historial de commits o el registro de la jornada para anclar el número en datos reales y no en la memoria.

3. Estima el **ahorro semanal** de automatizarla como `ahorro = t × f × p × factor_reduccion`, donde `factor_reduccion` es la fracción de tiempo que la herramienta elimina (por ejemplo, `0.9` si deja la tarea casi instantánea). Resiste la tentación de poner `1.0`: casi ninguna automatización elimina el 100% del trabajo, porque siempre queda revisar el resultado o corregir el caso raro que la herramienta no cubre.

4. Estima el **coste de construcción** en horas (`c_build`) y un coste de mantenimiento semanal (`c_mant`). Calcula la **semana de amortización**: `semanas = c_build / (ahorro_semanal − c_mant)`. Si el denominador es negativo o el resultado supera la vida esperada del proyecto, esa herramienta **no se construye**. Un denominador negativo es la señal más brutal y más útil de todas: significa que mantener la herramienta cuesta más de lo que ahorra, por lo que jamás se amortizará por muchas semanas que pasen.

5. Ordena las tres candidatas por `semanas` ascendente. La primera es tu mejor inversión de tooling. Escribe una frase por cada una: *"Automatizar X ahorra N min/semana y se amortiza en M semanas"*.

6. Contrasta con un **ejemplo numérico resuelto** para calibrar tu tabla. Supón la tarea "colocar 40 postes de valla a mano" con `t = 8` min, `f = 6` veces/semana, `p = 1` persona y `factor_reduccion = 0.9`. El ahorro semanal es `8 × 6 × 1 × 0.9 = 43.2` min. Si construir el generador cuesta `c_build = 3` horas (180 min) y `c_mant = 5` min/semana, la amortización es `180 / (43.2 − 5) ≈ 4.7` semanas. Con un proyecto de seis meses por delante, la herramienta se paga con creces: **se construye**. Repite este cálculo con tus tres tareas y compara resultados.

7. Marca junto a cada tarea si además reduce **riesgo de error** (por ejemplo, exportar con ajustes equivocados). Una tarea de ahorro moderado pero alto riesgo puede subir de prioridad aunque su ROI puro sea menor.

Guarda esta tabla: la herramienta ganadora es una excelente candidata para practicar `@tool` y `EditorPlugin` en las clases siguientes, cerrando el círculo entre la decisión estratégica de hoy y la implementación técnica que viene.

La lección observable: al final tendrás una tabla donde el ROI, y no la intuición, dicta qué herramienta merece las clases siguientes.

## ✍️ Ejercicios

1. Amplía la auditoría a cinco tareas y clasifícalas en un cuadrante frecuencia-alta/baja × ahorro-alto/bajo.
2. Para una de tus tareas, busca en el Asset Library de Godot si ya existe un plugin que la resuelva y compara comprar vs construir.
3. Estima el coste oculto de una herramienta que ya usas (documentar, enseñar a un compañero) en horas anuales.
4. Redefine `factor_reduccion` de forma realista para una de tus tareas y recalcula la semana de amortización.
5. Identifica una tarea de tu lista que NO merezca automatizarse y justifica por qué con números.
6. Escribe el "contrato" de una herramienta futura: qué entra, qué sale y qué NO hace.
7. Estima el punto de equilibrio en semanas de una herramienta que ya usas y compáralo con cuánto llevas usándola: ¿ya se pagó?

## 📝 Reto verificable

Entrega una tabla de ROI de tooling para tu proyecto con al menos cuatro tareas repetitivas reales. Cada fila debe incluir `t`, `f`, `p`, `factor_reduccion`, `ahorro_semanal`, `c_build`, `c_mant` y `semanas` de amortización, más una columna de riesgo. Concluye con una recomendación priorizada: qué herramienta construir primero, cuál comprar y cuál descartar.

**Criterio de aceptación**: la tabla justifica numéricamente la prioridad elegida (la herramienta recomendada tiene la menor semana de amortización o el mayor riesgo evitado) y al menos una tarea queda explícitamente descartada con su razón cuantitativa.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| "Construí una herramienta que nadie usó" | No mediste frecuencia real. Audita el flujo antes de construir y valida con quien la usará. |
| El mantenimiento consume más de lo que ahorra | Ignoraste el coste oculto. Incluye `c_mant` en el ROI y descarta si el denominador es negativo. |
| Reinventar un plugin que ya existía | Saltaste el paso construir vs comprar. Revisa el Asset Library antes de escribir código. |
| Automatizar una tarea que se hace una vez al año | El ahorro no compensa. Prioriza por frecuencia × personas, no por lo tediosa que parezca. |
| La herramienta quedó sin documentar y se abandonó | Deuda de tooling. Presupuesta documentación y formación como parte del coste. |
| Sobreingeniería: una herramienta enorme para un problema pequeño | Optimizaste el diseño, no el ROI. Construye la versión mínima que resuelve el 80% y amplía solo si el uso lo pide. |

## ❓ Preguntas frecuentes

**❓ ¿No es siempre bueno automatizar?** No. Automatizar algo raro o barato añade una herramienta que hay que mantener sin apenas retorno. El ROI decide.

**❓ ¿Cómo estimo el coste de construir si nunca hice la herramienta?** Usa un rango pesimista y súmale mantenimiento. Si el ROI es positivo incluso con la estimación alta, la decisión es sólida.

**❓ ¿Comprar un plugin no es "hacer trampa"?** Al contrario: transfiere el mantenimiento a un tercero y te deja construir solo lo que es específico de tu juego.

**❓ ¿El riesgo de error cuenta aunque el ahorro de tiempo sea pequeño?** Sí. Evitar un bug de exportación caro puede justificar una herramienta que apenas ahorra minutos.

**❓ ¿Y el valor de empoderar a un artista o diseñador?** Es difícil de cuantificar pero real: una herramienta que quita al diseñador la dependencia de un programador elimina esperas y desbloquea iteración. Súmalo como un factor cualitativo junto al ROI numérico.

**❓ ¿No frena esta clase tan analítica el aprendizaje técnico?** Al contrario: las cinco clases siguientes son intensamente técnicas (`@tool`, `EditorPlugin`, gizmos), y sin este filtro económico correrías el riesgo de dominar la técnica y aun así construir la herramienta equivocada. Elegir bien el objetivo es la mitad del trabajo.

## 🔗 Referencias

- Godot Docs — Making plugins: <https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html>
- Godot Docs — Plugins (índice): <https://docs.godotengine.org/en/stable/tutorials/plugins/index.html>
- Godot Docs — Running code in the editor (`@tool`): <https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html>
- Godot Asset Library: <https://godotengine.org/asset-library/asset>
- Godot Docs — EditorPlugin (referencia para dimensionar lo construible): <https://docs.godotengine.org/en/stable/classes/class_editorplugin.html>

## ➡️ Siguiente clase

[Clase 256 - Scripts de editor (@tool) en Godot](../256-scripts-de-editor-tool-en-godot/README.md)
