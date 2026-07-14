# Clase 277 — LiveOps: eventos, temporadas y contenido continuo

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Deconstructor of Fun y prácticas de LiveOps de juegos como servicio*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Muchos juegos ya no "terminan" al lanzarse: siguen vivos meses o años, alimentados por **eventos**, **temporadas** y contenido continuo. A esta operación permanente se le llama **LiveOps** (operaciones en vivo), y es lo que convierte un juego en un servicio. Bien hecha, retiene y monetiza a largo plazo; mal hecha, agota tanto a los jugadores como al equipo.

En esta clase aprenderás a pensar el juego como servicio: a diseñar un **calendario de contenido**, a equilibrar novedad y estabilidad, y a gestionar la **economía viva** sin quemar al equipo ni a la audiencia. El entregable es un calendario de contenido de tres meses para un juego live.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar el modelo de "juego como servicio" y en qué se diferencia de un producto cerrado.
2. Diseñar temporadas y eventos con objetivos de retención y monetización claros.
3. Construir un calendario de contenido de varios meses con cadencia sostenible.
4. Razonar sobre una economía viva (fuentes y sumideros) para evitar inflación o vacío.
5. Balancear novedad y estabilidad, protegiendo la salud del equipo frente al agotamiento.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Juego como servicio | Cambia el objetivo de "vender una vez" a "retener siempre". |
| 2 | Temporadas | Estructuran el contenido en ciclos con inicio y fin. |
| 3 | Eventos | Crean picos de actividad y motivos para volver. |
| 4 | Calendario de contenido | Da previsibilidad al equipo y ritmo a los jugadores. |
| 5 | Economía viva | Fuentes y sumideros determinan la salud a largo plazo. |
| 6 | Novedad vs. estabilidad | Demasiado cambio rompe; demasiado poco aburre. |
| 7 | Cadencia sostenible | El agotamiento del equipo mata más juegos live que los bugs. |
| 8 | Métricas de LiveOps | Sin retención medida, el calendario es a ciegas. |

## 📖 Definiciones y características

- **LiveOps**: operación continua de un juego lanzado con contenido y eventos periódicos. Clave: es un maratón, no un sprint.
- **Juego como servicio (GaaS)**: modelo donde el juego evoluciona y monetiza tras el lanzamiento. Clave: el valor está en la relación sostenida, no en la venta única.
- **Temporada**: ciclo de contenido acotado (semanas/meses) con tema, recompensas y a menudo un pase. Clave: da estructura y un "reinicio" motivador.
- **Evento**: actividad temporal con objetivo específico (festivo, colaboración, reto). Clave: genera picos de engagement y urgencia.
- **Calendario de contenido**: plan temporal de qué se publica y cuándo. Clave: coordina producción y comunicación.
- **Economía viva**: sistema de recursos en circulación con fuentes (se generan) y sumideros (se consumen). Clave: el desequilibrio infla o vacía la economía.
- **Fatiga de contenido**: hartazgo del jugador ante demasiados eventos o grind. Clave: se combate con ritmo y variedad, no con más volumen.
- **Cadencia**: frecuencia con la que se entrega contenido nuevo. Clave: debe ser sostenible por el equipo indefinidamente.

## 🧰 Herramientas y preparación

No necesitas motor específico: LiveOps es primero planificación. Usa una herramienta de calendario o tablero (Google Sheets, Notion, Trello) para el cronograma. Estudia cómo estructuran temporadas los juegos que juegas: fíjate en la duración, el tema y las recompensas. Lecturas útiles sobre economías y LiveOps: <https://www.deconstructoroffun.com/> y la documentación de sistemas de temporadas de motores comerciales.

Antes de planificar, define **qué métrica quieres mover** con cada pieza de contenido (retención D7, sesiones por usuario, ingresos por evento). Un calendario sin objetivos es solo un almanaque bonito. Prepara la plantilla de calendario que armaremos en el laboratorio.

## 🧪 Laboratorio guiado

Diseñarás un **calendario de contenido de 3 meses** para un juego live imaginario o el tuyo.

1. **Define el juego y su temporada.** Elige género y frecuencia de temporada (ej.: temporadas de 6 semanas). Escribe el tema de la temporada actual y su objetivo principal (ej.: recuperar jugadores inactivos).

2. **Mapa de cadencia.** Decide el ritmo por tipo de contenido y verifica que sea sostenible:

```text
| Tipo | Cadencia | Esfuerzo del equipo | Objetivo |
| Temporada nueva | cada 6 semanas | Alto | Retención + monetización |
| Evento mayor | 1 por mes | Medio | Pico de engagement |
| Evento menor / reto | semanal | Bajo | Motivo diario para volver |
| Balance/hotfix | según necesidad | Bajo-Medio | Estabilidad |
```

3. **Construye el calendario de 12 semanas.** Crea una tabla semana a semana. Cada fila indica qué se publica, el objetivo y una nota de riesgo. Ejemplo de tres semanas:

```text
| Semana | Contenido | Objetivo (métrica) | Riesgo/nota |
| 1 | Arranque Temporada 4 + pase | Retención D7 | No solapar con festivo externo |
| 2 | Evento menor: reto de fin de semana | Sesiones/usuario | Reusar assets, bajo costo |
| 3 | Evento de colaboración | Nuevos usuarios | Depende de socio externo; plan B |
```

4. **Diseña la economía del evento estrella.** Para uno de los eventos, lista las **fuentes** (cómo ganan la moneda del evento) y los **sumideros** (en qué la gastan). Asegura que el sumidero absorba la fuente para no inflar la economía, y que haya algo deseable que comprar.

5. **Protege al equipo.** Marca en el calendario las semanas de mayor carga y añade al menos una semana "ligera" de estabilización cada mes. Escribe una regla explícita anti-agotamiento (ej.: nada de lanzamientos grandes en dos semanas seguidas).

6. **Define el bucle de aprendizaje.** Indica qué medirás tras cada evento y cómo ajustarás el siguiente. Estructura el retro de cada pieza así:

```text
| Evento | Métrica objetivo | Resultado | Aprendizaje | Ajuste al próximo |
| Reto fin de semana | sesiones/usuario | +12% | Buena tracción | Repetir mensual |
| Colaboración externa | usuarios nuevos | por debajo del umbral | Socio poco relevante | Cambiar de socio |
```

Entrega calendario + mapa de cadencia + economía del evento + regla anti-agotamiento.

## ✍️ Ejercicios

1. Diseña el tema y las recompensas de una temporada para tu género favorito.
2. Convierte un evento de éxito ajeno en una versión reducida factible para un equipo pequeño.
3. Enumera tres fuentes y tres sumideros de una moneda de evento y justifica el equilibrio.
4. Detecta en un calendario dado dos semanas con riesgo de fatiga y reordénalas.
5. Define la métrica de éxito de un evento menor y su umbral.
6. Escribe la política de "descanso" del calendario: cuándo el equipo NO publica nada grande.

## 📝 Reto verificable

Diseña un calendario de contenido de 3 meses (12 semanas) para un juego live con: tema de temporada y objetivo, mapa de cadencia por tipo de contenido, tabla semanal con objetivo y riesgo por fila, el diseño de economía (fuentes/sumideros) de al menos un evento y una regla explícita anti-agotamiento reflejada en el calendario.

**Criterio de aceptación**: el calendario cubre 12 semanas con al menos un objetivo medible por pieza de contenido; la economía del evento estrella tiene fuentes y sumideros equilibrados; y existe al menos una semana ligera de estabilización por mes marcada como tal para proteger al equipo.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Los jugadores se van pese a mucho contenido | Fatiga de contenido. Reduce volumen, aumenta variedad y añade descansos. |
| La moneda del evento pierde todo valor | Economía inflada: fuentes sin sumideros. Añade sinks deseables que absorban la generación. |
| El equipo termina exhausto tras dos meses | Cadencia insostenible. Planifica semanas ligeras y evita lanzamientos grandes seguidos. |
| Cada evento parece igual al anterior | Falta de tema/novedad. Varía mecánicas y recompensas, no solo los números. |
| Nadie sabe si un evento funcionó | No se definió métrica de éxito. Fija objetivo y umbral antes de lanzarlo. |

## ❓ Preguntas frecuentes

**❓ ¿LiveOps sirve para juegos pequeños o solo para los grandes?** Sirve a cualquier escala; lo que cambia es la cadencia. Un equipo pequeño puede sostener eventos ligeros mensuales sin colapsar.

**❓ ¿Cada cuánto lanzo una temporada nueva?** Depende de tu capacidad de producción. Mejor una cadencia lenta y cumplida que una rápida que agote al equipo y baje la calidad.

**❓ ¿Cómo evito la inflación de la economía?** Asegura que por cada fuente de recursos exista un sumidero atractivo; si generas más de lo que se consume, el valor se derrumba.

**❓ ¿Qué priorizo: novedad o estabilidad?** Ambas. Sin novedad se aburren; sin estabilidad se frustran. El calendario debe alternar picos de novedad con semanas de pulido.

## 🔗 Referencias

- Deconstructor of Fun — análisis de LiveOps y economías: <https://www.deconstructoroffun.com/>
- GameAnalytics — LiveOps guides: <https://gameanalytics.com/blog/>
- Steamworks — Seasonal/event best practices: <https://partner.steamgames.com/doc/features/events>
- GDC Vault — charlas de LiveOps: <https://www.gdcvault.com/>

## ➡️ Siguiente clase

[Clase 278 - Analítica de juego y telemetría](../278-analitica-de-juego-y-telemetria/README.md)
