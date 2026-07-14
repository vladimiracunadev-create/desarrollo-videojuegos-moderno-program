# Clase 158 — Mecánicas, verbos y economía del jugador

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Anna Anthropy & Naomi Clark, "A Game Design Vocabulary"; Fullerton, "Game Design Workshop"*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Todo lo que un jugador puede hacer se resume en **verbos**: saltar, disparar, comprar, construir, hablar. El conjunto de verbos define el juego más que cualquier gráfico. Y cuando esos verbos mueven recursos —oro, madera, vida, munición— aparece una **economía**: un sistema de fuentes que generan recursos y sumideros que los consumen. Si la economía está desequilibrada, el juego se rompe: el jugador acumula oro infinito y nada tiene valor, o se queda sin munición y el juego se vuelve injusto.

En esta clase aprenderás a inventariar los verbos del jugador, a modelar la economía como un flujo de **fuentes y sumideros**, y a detectar los desequilibrios típicos: inflación (demasiadas fuentes), estrangulamiento (demasiados sumideros) y monedas que dejan de importar. El entregable es una tabla que mapea verbos y economía de un juego real, con al menos un desequilibrio identificado y una propuesta de arreglo.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Inventariar los verbos que un juego pone a disposición del jugador.
2. Clasificar cada flujo de recurso como fuente o sumidero.
3. Modelar una economía interna en una tabla de fuentes/sumideros por moneda.
4. Detectar inflación, estrangulamiento y monedas sin valor.
5. Proponer un ajuste de economía que restaure el equilibrio sin romper la diversión.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El verbo como unidad de diseño | Define qué es capaz de hacer el jugador. |
| 2 | Verbos primarios vs secundarios | Distingue el core del apoyo. |
| 3 | Recursos y monedas | Son la sangre que mueve el sistema económico. |
| 4 | Fuentes (sources) | De dónde entra cada recurso al sistema. |
| 5 | Sumideros (sinks) | Dónde se consume; sin ellos hay inflación. |
| 6 | Inflación y devaluación | El fallo económico más común en juegos. |
| 7 | Estrangulamiento de recursos | Cuando el jugador se queda sin nada y se frustra. |
| 8 | Balance de flujo | Fuentes y sumideros deben conversar. |

## 📖 Definiciones y características

- **Verbo del jugador**: acción significativa que el jugador puede ejecutar (moverse, atacar, comerciar). Clave: el conjunto de verbos es la definición operativa del juego.
- **Verbo primario**: verbo del core loop, usado a cada segundo. Clave: si es insatisfactorio, todo el juego lo es.
- **Recurso**: cantidad que el jugador acumula, gasta o pierde (vida, oro, tiempo, munición). Clave: solo importa si es escaso y decidible.
- **Fuente (source)**: mecanismo que introduce un recurso en la economía (loot, ingresos, regeneración). Clave: controla la velocidad de acumulación.
- **Sumidero (sink)**: mecanismo que retira un recurso del sistema (compras, reparaciones, impuestos). Clave: sin sumideros el recurso pierde valor.
- **Inflación**: exceso de recurso circulante que devalúa su utilidad. Clave: suele venir de fuentes demasiado generosas sin sumideros.
- **Estrangulamiento**: escasez que bloquea el progreso y frustra. Clave: nace de sumideros excesivos o fuentes tacañas.
- **Economía cerrada vs abierta**: si el recurso circula sin salir o se genera/destruye libremente. Clave: define cuánto control tienes sobre la inflación.

## 🧰 Herramientas y preparación

El trabajo es de modelado, así que la herramienta central es una **hoja de cálculo** (Google Sheets o LibreOffice Calc) donde tabular fuentes, sumideros y tasas por unidad de tiempo. Elige un juego con economía visible —un RPG, un city-builder, un juego de cartas coleccionables, un roguelike con tienda— porque el flujo se ve mejor cuando hay monedas explícitas. Ten a mano una partida real para medir tasas reales, no supuestas.

Usa Google Sheets en <https://sheets.google.com> o Calc de <https://www.libreoffice.org>. Para profundizar en economías de juego, la charla clásica "Ratchets, Clickers and Grinders" y material sobre economy design en <https://www.gdcvault.com> son buen punto de partida.

## 🧪 Laboratorio guiado

Vas a producir un **mapa de verbos y economía** de un juego, con diagnóstico de desequilibrios.

1. **Inventario de verbos.** Lista todos los verbos que el juego ofrece y márcalos como primario (P) o secundario (S):

| Verbo | P/S | ¿Consume o genera recursos? | ¿Cuál? |
|-------|-----|-----------------------------|--------|
| Ej.: atacar | P | Consume munición, genera oro (loot) | Munición, Oro |
| … | | | |

2. **Lista de monedas/recursos.** Enumera cada recurso económico del juego (oro, gemas, madera, vida, energía).

3. **Tabla de fuentes.** Para cada recurso, lista de dónde entra y a qué tasa aproximada:

| Recurso | Fuente | Tasa aprox. (por minuto/partida) |
|---------|--------|----------------------------------|
| Ej.: Oro | Matar enemigos | ~50/min |
| Ej.: Oro | Vender objetos | ~20/min |

4. **Tabla de sumideros.** Para cada recurso, lista dónde se consume y a qué tasa:

| Recurso | Sumidero | Tasa aprox. |
|---------|----------|-------------|
| Ej.: Oro | Comprar pociones | ~30/min |
| Ej.: Oro | Reparar equipo | ~10/min |
| Ej.: Oro | Mejorar armas (coste creciente) | ~15/min |
| Ej.: Oro | Peaje o impuesto de zona | ~5/min |

5. **Balance de flujo.** Para cada recurso calcula `flujo neto = suma(fuentes) − suma(sumideros)`. Un flujo netamente positivo y creciente indica inflación; uno netamente negativo, estrangulamiento.

6. **Diagnóstico.** Identifica al menos **un desequilibrio**. Nómbralo (inflación / estrangulamiento / moneda sin valor) y explica su síntoma en la experiencia ("a la hora 3 el oro no sirve para nada porque ya lo tengo todo").

7. **Propuesta de arreglo.** Ajusta el sistema con una intervención mínima. Ejemplo de palancas: añadir un sumidero (mejoras caras, impuesto), reducir una fuente (menos loot), o introducir una moneda premium separada. Escribe cómo cambiaría el flujo neto.

8. **Traza el flujo en el tiempo.** Con el flujo neto por recurso, proyecta cómo evoluciona el stock del jugador a lo largo de una partida de 30 minutos: multiplica el flujo neto por minuto y grafica la línea. Un stock que sube sin techo confirma inflación; uno que toca cero antes del final confirma estrangulamiento. Esta proyección hace visible el problema mejor que cualquier descripción.

9. Guarda las tablas, la proyección y el diagnóstico como entregable. Esta hoja es la base del balanceo numérico que profundizarás en la Clase 161.

> **Consejo de práctica.** Una economía sana rara vez es de flujo neto cero constante: suele alternar tramos de acumulación (el jugador ahorra) con tramos de gasto (compra algo grande). Busca ese pulso de ahorro-gasto en vez de un equilibrio plano; el pulso es lo que da sentido a ganar dinero.

## ✍️ Ejercicios

1. Inventaría los verbos de un juego minimalista (ej.: un endless runner) y discute si necesita más verbos o menos.
2. Encuentra en un juego que juegues una moneda que dejó de importarte y explica qué sumidero le falta.
3. Modela la economía de vida/salud de un shooter como fuentes (botiquines, regen) y sumideros (daño).
4. Diseña un sumidero nuevo para un juego con inflación de oro sin subir la dificultad de combate.
5. Toma dos verbos del juego del laboratorio y proponlos fusionar o eliminar; argumenta el impacto.
6. Convierte una economía abierta en una cerrada y describe cómo cambia el control sobre la inflación.

## 📝 Reto verificable

Entrega el mapa completo de verbos + economía de un juego con al menos dos recursos distintos, incluyendo tablas de fuentes y sumideros con tasas estimadas, el cálculo de flujo neto por recurso, un desequilibrio identificado y una propuesta de arreglo con su efecto esperado sobre el flujo.

**Criterio de aceptación**: cada recurso tiene al menos una fuente y un sumidero listados con tasa numérica, el flujo neto está calculado (no solo descrito), el desequilibrio identificado se justifica con el número del flujo, y la propuesta de arreglo indica explícitamente qué palanca mueve (fuente o sumidero) y cómo cambia el signo o magnitud del flujo neto.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El jugador acumula oro infinito y nada vale | Faltan sumideros. Añade consumos recurrentes (mantenimiento, mejoras escalables) o reduce las fuentes. |
| El jugador se queda sin munición y odia el juego | Estrangulamiento: sumideros demasiado agresivos. Sube las fuentes o baja el consumo. |
| Una moneda existe pero el jugador la ignora | No tiene un sumidero deseable. Dale algo valioso que solo se compre con ella. |
| La tabla no tiene tasas, solo descripciones | Sin números no hay diagnóstico. Estima tasas por minuto o por partida jugando de verdad. |
| Todos los verbos parecen igual de importantes | No distinguiste primarios de secundarios. Marca los del core loop; son los que debes pulir primero. |
| Añades sumideros y el jugador los siente como castigo | El sumidero no es deseable, solo punitivo. Convierte el gasto en algo aspiracional (mejoras, cosméticos) en vez de un impuesto seco. |

## ❓ Preguntas frecuentes

**❓ ¿Qué diferencia hay entre un recurso y una moneda?** Toda moneda es un recurso, pero no todo recurso es moneda. El oro se intercambia (moneda); la vida se gestiona pero no se comercia (recurso). El modelado fuentes/sumideros aplica a ambos.

**❓ ¿Por qué la inflación es tan común en los juegos?** Porque las fuentes son fáciles y satisfactorias de añadir (loot, recompensas) y los sumideros se sienten como castigos, así que se descuidan. El equilibrio exige diseñar sumideros deseables.

**❓ ¿Añadir verbos siempre mejora el juego?** No. Cada verbo nuevo aumenta la carga cognitiva y el coste de balancear. Antes de sumar un verbo, pregúntate si profundiza una dinámica existente o solo añade ruido; a veces quitar verbos mejora el foco.

**❓ ¿Cómo estimo tasas si no tengo telemetría?** Juega tramos cronometrados y anota cuánto ganas y gastas de cada recurso por minuto. Aunque sean aproximadas, revelan el signo del flujo neto, que es lo que importa.

## 🔗 Referencias

- Anna Anthropy & Naomi Clark — A Game Design Vocabulary: <https://www.penguinrandomhouse.com/books/313337/a-game-design-vocabulary/>
- Tracy Fullerton — Game Design Workshop: <https://www.gamedesignworkshop.com>
- GDC Vault — economy design y "Ratchets, Clickers and Grinders": <https://www.gdcvault.com>
- Game Balance Concepts (Ian Schreiber): <https://gamebalanceconcepts.wordpress.com>

## ➡️ Siguiente clase

[Clase 159 - Sistemas, feedback y bucles](../159-sistemas-feedback-y-bucles/README.md)
