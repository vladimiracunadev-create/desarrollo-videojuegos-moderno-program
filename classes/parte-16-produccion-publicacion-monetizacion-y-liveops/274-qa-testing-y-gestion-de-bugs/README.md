# Clase 274 — QA, testing y gestión de bugs

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Google Testing Blog y prácticas de la Game Developers Conference sobre QA*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El control de calidad (QA) no es "jugar hasta que algo se rompa": es una disciplina con método, artefactos y trazabilidad. En esta clase separamos dos actividades que a menudo se confunden —el **testing automatizado** (código que verifica código) y el **QA manual/exploratorio** (personas que ejercen el juego con criterio)— y montamos el circuito que conecta ambas con el equipo de desarrollo.

Al terminar sabrás escribir un **plan de pruebas** para una funcionalidad concreta, redactar un **reporte de bug** que otra persona pueda reproducir sin preguntarte nada, y **triar** una lista de defectos asignando severidad y prioridad. Estos tres artefactos son la columna vertebral de cualquier producción, desde un juego de una persona hasta un estudio con cientos.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir QA, testing automatizado y testing exploratorio, y decidir cuándo usar cada uno.
2. Redactar un plan de pruebas de una funcionalidad con casos, precondiciones y resultados esperados.
3. Escribir un reporte de bug reproducible con pasos, entorno, resultado esperado vs. obtenido.
4. Diferenciar **severidad** (impacto técnico) de **prioridad** (urgencia de negocio) y aplicarlas al triaje.
5. Organizar defectos en un bug tracker con estados y planificar una pasada de regresión.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | QA vs. testing automatizado | Cubren riesgos distintos; ninguno reemplaza al otro. |
| 2 | Plan de pruebas | Convierte "probar" en algo repetible y medible. |
| 3 | Testing exploratorio | Encuentra lo que ningún caso escrito previó. |
| 4 | Anatomía de un reporte de bug | Un bug irreproducible es un bug que no se arregla. |
| 5 | Severidad vs. prioridad | Evita arreglar lo trivial antes que lo grave. |
| 6 | Triaje de defectos | Ordena el trabajo cuando los bugs superan al tiempo. |
| 7 | Bug tracker y estados | Da trazabilidad de "reportado" a "cerrado". |
| 8 | Pruebas de regresión | Impide que un arreglo rompa algo que funcionaba. |

## 📖 Definiciones y características

- **QA (Quality Assurance)**: disciplina que asegura la calidad de todo el proceso, no solo del producto. Clave: es preventiva, no solo detectora.
- **Testing automatizado**: código (unitario, de integración, smoke) que verifica comportamiento sin intervención humana. Clave: rápido y repetible, ideal para regresión.
- **Testing exploratorio**: exploración manual con hipótesis sobre dónde puede fallar el juego. Clave: creativo, insustituible para "feel" y casos raros.
- **Plan de pruebas**: documento con casos de prueba, precondiciones, pasos y resultados esperados. Clave: define qué significa "probado".
- **Caso de prueba**: unidad mínima verificable con entrada, acción y salida esperada. Clave: pasa o falla, sin ambigüedad.
- **Reporte de bug**: registro estructurado de un defecto reproducible. Clave: su valor es la reproducibilidad.
- **Severidad**: cuán dañino es el fallo (bloqueante, mayor, menor, cosmético). Clave: es una medida técnica objetiva.
- **Prioridad**: cuán pronto debe arreglarse (P0…P3). Clave: la decide el negocio, puede diferir de la severidad.
- **Regresión**: reaparición de un fallo antiguo tras un cambio. Clave: se combate con una suite de casos que se repiten en cada build.

## 🧰 Herramientas y preparación

No necesitas herramientas de pago. Un **bug tracker** puede ser desde una hoja de cálculo bien estructurada hasta GitHub Issues (<https://docs.github.com/issues>), Trello, Jira o Linear. Para este laboratorio bastan GitHub Issues o una tabla en Markdown. Ten a mano el juego que vienes construyendo en el curso (o cualquier build jugable) para tener defectos reales que reportar.

Familiarízate con el vocabulario estándar leyendo el glosario de severidad/prioridad de cualquier tracker y una guía de bug reporting: <https://www.atlassian.com/software/jira/guides/getting-started/best-practices>. Prepara además una plantilla de reporte reutilizable (la construiremos abajo) para no improvisar el formato cada vez.

## 🧪 Laboratorio guiado

Producirás tres entregables: una **plantilla de reporte de bug**, un **plan de pruebas** de una funcionalidad y una **lista triada** de bugs.

1. **Plantilla de reporte de bug.** Crea un archivo `plantilla-bug.md` con esta estructura y consérvalo como base para todos tus reportes:

```text
Título: [resumen en una línea, verbo + qué falla]
ID: BUG-000
Severidad: Bloqueante | Mayor | Menor | Cosmético
Prioridad: P0 | P1 | P2 | P3
Entorno: build/versión, plataforma, resolución, dispositivo
Precondiciones: estado necesario antes de empezar
Pasos para reproducir:
  1. ...
  2. ...
  3. ...
Resultado esperado: ...
Resultado obtenido: ...
Frecuencia: siempre | intermitente (X de Y intentos)
Evidencia: captura, vídeo, log
Notas: workaround conocido, hipótesis de causa
```

2. **Elige una funcionalidad** de tu juego (ej.: "recoger monedas y sumar puntaje") y escribe un **plan de pruebas** con al menos 6 casos. Cada fila debe poder ejecutarse sin interpretación:

```text
| ID | Caso | Precondición | Pasos | Resultado esperado |
| CP-01 | Recoger 1 moneda | Jugador con 0 puntos | Tocar la moneda | Puntaje = valor de la moneda; moneda desaparece |
| CP-02 | Recoger todas | Nivel con 5 monedas | Recogerlas | Puntaje = suma; contador a 0 |
| CP-03 | Moneda ya recogida | Moneda tomada | Volver a pasar | No suma de nuevo |
| CP-04 | Recoger al morir | Vida = 0 en el frame | Tocar moneda | No suma tras game over |
| CP-05 | Persistencia | Cambio de nivel | Pasar de nivel | Puntaje se conserva |
| CP-06 | Límite superior | Puntaje cercano al máximo | Recoger monedas | Sin overflow ni número negativo |
```

3. **Ejecuta el plan** sobre tu juego. Marca cada caso como *Pass* / *Fail*. Por cada *Fail*, abre un reporte usando la plantilla del paso 1.

4. **Triaje.** Reúne una lista de 8–10 bugs (los que encontraste más los de esta lista de ejemplo) y asigna severidad y prioridad a cada uno. Justifica en una frase por qué la prioridad puede no coincidir con la severidad (ej.: un crash en una pantalla que nadie visita puede ser Bloqueante de severidad pero P2 de prioridad).

5. **Ordena** la lista triada por prioridad y entrega las tres piezas: plantilla, plan de pruebas ejecutado y lista triada.

## ✍️ Ejercicios

1. Reescribe un reporte de bug vago ("el juego se rompe a veces") hasta hacerlo reproducible.
2. Añade a tu plan de pruebas dos casos límite (valores extremos) y dos casos negativos (entradas inválidas).
3. Clasifica cinco defectos reales por severidad y explica cada decisión en una frase.
4. Define los estados de tu bug tracker (ej.: Nuevo → Confirmado → En curso → Resuelto → Verificado → Cerrado) y qué los dispara.
5. Diseña una **suite de regresión** mínima: elige los 5 casos que ejecutarías en cada build antes de publicar.
6. Convierte tres casos de tu plan en la especificación de tres pruebas automatizadas (describe entrada y aserción, sin codificarlas).

## 📝 Reto verificable

Toma una funcionalidad de tu juego, escribe un plan de pruebas de mínimo 8 casos, ejecútalo, abre reportes para todos los fallos con la plantilla y entrega una lista triada con severidad, prioridad y una suite de regresión de 5 casos marcada.

**Criterio de aceptación**: cada reporte de bug puede reproducirse por una persona ajena siguiendo solo los pasos escritos; cada caso del plan tiene resultado esperado inequívoco y veredicto Pass/Fail; y la lista triada está ordenada por prioridad con al menos un caso donde severidad y prioridad difieren, justificado.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Nadie logra reproducir el bug reportado | Faltan precondiciones o entorno. Añade versión de build, plataforma y estado exacto previo. |
| Se arreglan cosméticos mientras hay crashes abiertos | Se confunde severidad con prioridad. Triar por prioridad de negocio, no por lo fácil. |
| Cada arreglo rompe algo distinto | No hay suite de regresión. Define casos fijos que se ejecuten en cada build. |
| El plan de pruebas "pasa" pero el juego falla en manos de usuarios | Solo hay casos felices. Agrega casos límite, negativos y exploratorios. |
| El tracker está lleno de bugs "Nuevo" desde hace meses | No hay triaje periódico. Agenda una sesión de triaje recurrente. |

## ❓ Preguntas frecuentes

**❓ ¿El testing automatizado reemplaza al QA manual?** No. Automatiza lo repetible y verificable; el juicio humano sobre diversión, feel y casos imprevistos es insustituible.

**❓ ¿Severidad y prioridad no son lo mismo?** No. Severidad mide el daño técnico; prioridad mide la urgencia de arreglarlo. Un crash raro puede ser severo pero de baja prioridad.

**❓ ¿Cuántos casos debe tener un plan de pruebas?** Los suficientes para cubrir camino feliz, límites, negativos y regresión de esa funcionalidad; la cantidad la fija el riesgo, no un número mágico.

**❓ ¿Qué hago con bugs intermitentes?** Regístralos igual, anota la frecuencia (X de Y intentos) y toda variable de entorno; el patrón de reproducción suele emerger de esos datos.

## 🔗 Referencias

- Atlassian — Bug tracking best practices: <https://www.atlassian.com/software/jira/guides/getting-started/best-practices>
- Google Testing Blog: <https://testing.googleblog.com/>
- GitHub Issues docs: <https://docs.github.com/issues>
- Ministry of Testing — Exploratory testing: <https://www.ministryoftesting.com/>

## ➡️ Siguiente clase

[Clase 275 - Beta, early access y feedback](../275-beta-early-access-y-feedback/README.md)
