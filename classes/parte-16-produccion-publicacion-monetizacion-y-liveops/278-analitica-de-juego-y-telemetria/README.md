# Clase 278 — Analítica de juego y telemetría

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *GameAnalytics Documentation y guías de métricas de producto para juegos*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego live genera un torrente de datos, pero los datos sin propósito no ayudan a nadie. La **analítica de juego** consiste en decidir qué eventos registrar (**telemetría**), convertirlos en **métricas** significativas y mostrarlas en **dashboards** que permitan tomar decisiones informadas en lugar de opiniones. Y todo ello respetando la **privacidad** de los jugadores.

En esta clase aprenderás las métricas clave que todo equipo mira (DAU/MAU, retención D1/D7/D30, funnels, ARPU), qué eventos de telemetría emitir para calcularlas, cómo diseñar un dashboard útil y qué límites impone la privacidad. El entregable es un plan de telemetría y dashboard, incluido un pequeño snippet de cómo se emite un evento.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Definir las métricas clave (DAU/MAU, retención, funnel, ARPU) y qué decisión informa cada una.
2. Seleccionar qué eventos de telemetría registrar y con qué propiedades.
3. Diseñar la estructura de un evento de telemetría y describir cómo se emite.
4. Bosquejar un dashboard que responda preguntas de negocio concretas.
5. Aplicar principios de privacidad (minimización, consentimiento, anonimización) al plan.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Métricas de actividad (DAU/MAU) | Miden el tamaño vivo de tu base de jugadores. |
| 2 | Retención D1/D7/D30 | Es el indicador de salud más importante de un juego live. |
| 3 | Funnels | Muestran dónde se pierde a los jugadores paso a paso. |
| 4 | Métricas de monetización (ARPU/ARPPU) | Conectan el juego con su sostenibilidad económica. |
| 5 | Diseño de eventos de telemetría | Determina qué preguntas podrás responder después. |
| 6 | Dashboards | Convierten datos crudos en decisiones. |
| 7 | Decidir con datos | Reemplaza la opinión por evidencia, sin caer en el dato-por-el-dato. |
| 8 | Privacidad y cumplimiento | Registrar de más es un riesgo legal y ético. |

## 📖 Definiciones y características

- **Telemetría**: emisión de eventos desde el juego para su análisis posterior. Clave: registras el hecho, no la persona.
- **Evento**: registro de una acción con nombre y propiedades (ej.: `level_completed` con `level_id` y `duration`). Clave: bien nombrado y consistente, o el análisis se vuelve imposible.
- **DAU / MAU**: usuarios activos diarios / mensuales. Clave: su ratio (DAU/MAU) indica cuán "pegajoso" es el juego.
- **Retención Dn**: porcentaje de jugadores que vuelven n días tras instalar. Clave: D1, D7 y D30 son el pulso de la salud del juego.
- **Funnel (embudo)**: secuencia de pasos con la tasa de avance entre ellos. Clave: revela el punto exacto de abandono.
- **ARPU / ARPPU**: ingreso medio por usuario / por usuario pagador. Clave: mide monetización con y sin diluir por no pagadores.
- **Dashboard**: panel visual con las métricas clave. Clave: debe responder preguntas, no solo mostrar gráficos.
- **Minimización de datos**: registrar solo lo necesario para el objetivo. Clave: principio central de privacidad y de buen diseño.

## 🧰 Herramientas y preparación

Puedes empezar con servicios gratuitos como GameAnalytics (<https://gameanalytics.com/>), o soluciones generales como PostHog, Firebase/Google Analytics o Unity Analytics. Para este laboratorio no hace falta integrar nada: diseñaremos el plan en papel. Repasa el modelo de eventos/propiedades de cualquiera de esas plataformas para entender el formato estándar.

Ten presente la dimensión legal: normativas como el RGPD europeo exigen base legal, consentimiento para ciertos usos y minimización de datos. Lee una guía introductoria de privacidad en analítica antes de decidir qué registrar: <https://gdpr.eu/>. Prepara la plantilla de eventos y el bosquejo de dashboard que construiremos abajo.

## 🧪 Laboratorio guiado

Producirás un **catálogo de eventos de telemetría**, la definición de las **métricas del dashboard** y un **snippet** de emisión de un evento.

1. **Lista las preguntas de negocio** que quieres responder (ej.: "¿dónde abandonan el tutorial?", "¿qué nivel expulsa más jugadores?", "¿convierte la tienda?"). Las métricas se derivan de las preguntas, no al revés.

2. **Diseña el catálogo de eventos.** Para cada evento define nombre, cuándo se dispara y sus propiedades. Nombra en snake_case y sé consistente:

```text
| Evento | Se dispara cuando… | Propiedades |
| session_start | arranca una sesión | platform, version, is_new_user |
| tutorial_step | se completa un paso del tutorial | step_index, duration_ms |
| level_completed | se termina un nivel | level_id, attempts, duration_ms, stars |
| level_failed | se pierde un nivel | level_id, cause, time_ms |
| store_opened | se abre la tienda | source |
| purchase_made | se confirma una compra | item_id, price, currency |
```

3. **Escribe el snippet de emisión.** En pseudocódigo tipo GDScript, muestra cómo se emite un evento con sus propiedades. Este es el único código de la clase:

```gdscript
# Emite un evento de telemetría con nombre y propiedades.
# No registres datos personales: solo el hecho del juego.
func track(nombre: String, props: Dictionary = {}) -> void:
    var evento := {
        "name": nombre,
        "ts": Time.get_unix_time_from_system(),
        "session_id": _session_id,   # anónimo, generado por sesión
        "props": props,
    }
    Analytics.enviar(evento)   # encola y envía por lotes

# Uso al terminar un nivel:
track("level_completed", {
    "level_id": nivel_actual,
    "attempts": intentos,
    "duration_ms": duracion,
    "stars": estrellas,
})
```

4. **Define las métricas del dashboard.** Para cada pregunta del paso 1, indica qué métrica la responde y de qué eventos se calcula:

```text
| Métrica | Se calcula de… | Pregunta que responde |
| Retención D1/D7 | session_start + is_new_user | ¿Vuelven los jugadores nuevos? |
| Funnel tutorial | tutorial_step por step_index | ¿En qué paso abandonan? |
| Nivel más difícil | level_failed / (completed+failed) | ¿Qué nivel expulsa gente? |
| Conversión tienda | purchase_made / store_opened | ¿La tienda convierte? |
| ARPU | suma(price) / usuarios activos | ¿Cuánto rinde por jugador? |
```

5. **Bosqueja el dashboard.** Describe (en texto o boceto) las tarjetas del panel: una fila de KPIs (DAU, retención D7, ARPU), un gráfico de funnel del tutorial y una tabla de dificultad por nivel. Cada elemento debe responder una pregunta del paso 1.

6. **Revisión de privacidad.** Marca en tu catálogo qué propiedades podrían ser personales y elimínalas o anonimízalas. Declara la política: consentimiento, minimización y retención. Entrega catálogo + snippet + métricas + dashboard + nota de privacidad.

## ✍️ Ejercicios

1. Añade dos eventos que necesitarías para medir la economía de un evento de LiveOps.
2. Convierte una pregunta de negocio nueva en el conjunto de eventos que la responden.
3. Diseña el funnel de compra completo (abrir tienda → ver ítem → confirmar → éxito) con sus tasas.
4. Identifica en tu catálogo una propiedad que viola minimización de datos y corrígela.
5. Explica la diferencia entre ARPU y ARPPU con números de ejemplo.
6. Define qué alerta automática pondrías si la retención D1 cae por debajo de un umbral.

## 📝 Reto verificable

Diseña el plan de telemetría de tu juego: un catálogo de al menos 8 eventos con propiedades, el snippet de emisión de un evento, la definición de al menos 5 métricas indicando de qué eventos se calculan, el bosquejo de un dashboard que las presente y una nota de privacidad con minimización y consentimiento.

**Criterio de aceptación**: cada métrica del dashboard es calculable a partir de eventos presentes en el catálogo; el snippet emite nombre, marca de tiempo, identificador anónimo y propiedades; y la nota de privacidad identifica y elimina o anonimiza toda propiedad personal, declarando retención y consentimiento.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Se registran datos pero nadie los usa | Se instrumentó sin preguntas de negocio. Parte siempre de la pregunta, no del evento. |
| Los nombres de eventos son inconsistentes | No hubo convención. Fija snake_case y un catálogo único revisado. |
| El funnel no cuadra con la realidad | Eventos disparados en el lugar equivocado. Verifica dónde y cuándo se emite cada uno. |
| Riesgo legal por datos personales | Se registró de más. Aplica minimización: elimina IDs personales, usa identificadores anónimos. |
| El dashboard tiene 40 gráficos y nadie decide nada | Ruido, no señal. Reduce a los KPIs que responden decisiones concretas. |

## ❓ Preguntas frecuentes

**❓ ¿Qué métrica miro primero?** La retención D1/D7. Si los jugadores no vuelven, ninguna otra métrica importa; es el mejor indicador temprano de salud.

**❓ ¿Registro todo por si acaso?** No. Registrar de más cuesta almacenamiento, complica el análisis y crea riesgo de privacidad. Registra lo que responde tus preguntas actuales.

**❓ ¿La telemetría viola la privacidad?** No si aplicas minimización, identificadores anónimos y consentimiento. Registra el hecho del juego, no a la persona; nunca datos sensibles en eventos.

**❓ ¿Puedo decidir todo con datos?** Los datos informan, no reemplazan el criterio de diseño. Dicen qué pasa; el equipo decide por qué y qué hacer. Cuidado con optimizar solo lo medible.

## 🔗 Referencias

- GameAnalytics — Documentación de eventos y métricas: <https://gameanalytics.com/docs/>
- Firebase Analytics para juegos: <https://firebase.google.com/docs/analytics>
- RGPD — información oficial: <https://gdpr.eu/>
- Unity Analytics: <https://docs.unity.com/analytics/>

## ➡️ Siguiente clase

[Clase 279 - Post-lanzamiento: parches, comunidad y retención](../279-post-lanzamiento-parches-comunidad-y-retencion/README.md)
