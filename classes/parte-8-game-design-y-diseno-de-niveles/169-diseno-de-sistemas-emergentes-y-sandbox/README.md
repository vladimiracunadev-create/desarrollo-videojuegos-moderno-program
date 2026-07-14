# Clase 169 — Diseño de sistemas emergentes y sandbox

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Síntesis original sobre emergencia, immersive sims y diseño de posibilidades*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

La **emergencia** es la magia de que pocas reglas simples produzcan un número enorme de situaciones que el diseñador nunca previó. En esta clase estudiarás cómo los **immersive sims** y los **sandbox** logran esa profundidad no scriptando cada momento, sino diseñando **sistemas que interactúan** entre sí de forma consistente.

Aprenderás el **diseño de posibilidades**: en vez de preguntarte "¿qué hará el jugador aquí?", te preguntas "¿qué reglas cruzadas permito y qué pasa cuando chocan?". Diseñarás tres sistemas simples cuyas interacciones generen comportamiento emergente y las documentarás en una **matriz de interacciones**, la herramienta clave para razonar sobre este tipo de diseño.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Explicar la emergencia como producto de reglas simples que interactúan.
- Distinguir complejidad emergente de contenido scriptado.
- Diseñar sistemas ortogonales pensados para combinarse.
- Construir una **matriz de interacciones** que enumere los resultados cruzados.
- Aplicar el "diseño de posibilidades" propio de los immersive sims.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es la emergencia | Distingue diseño de sistemas de diseño de contenido |
| 2 | Reglas simples, resultados ricos | La profundidad no exige complejidad de reglas |
| 3 | Sistemas ortogonales | Cuando no se solapan, se combinan mejor |
| 4 | Immersive sims | Referente de máxima interacción de sistemas |
| 5 | Sandbox y espacio de posibilidad | El jugador improvisa sus propias soluciones |
| 6 | Matriz de interacciones | Herramienta para prever y balancear cruces |
| 7 | Consistencia de reglas | La confianza del jugador depende de ella |

## 📖 Definiciones y características

- **Emergencia**: aparición de comportamiento complejo a partir de reglas simples que interactúan. Clave: no está programada explícitamente.
- **Sistema**: conjunto de reglas que gobiernan un elemento (fuego, agua, gravedad). Clave: se define por sus entradas y efectos.
- **Ortogonalidad**: propiedad de sistemas que aportan efectos distintos y no redundantes. Clave: maximiza combinaciones útiles.
- **Diseño de posibilidades**: diseñar el espacio de lo que *puede* pasar en vez de guionizar lo que pasa. Clave: cede autoría al jugador.
- **Immersive sim**: género que apuesta por sistemas profundos e interconectados (Deus Ex, Dishonored). Clave: múltiples soluciones a cada problema.
- **Sandbox**: entorno abierto donde el jugador experimenta libremente. Clave: prioriza herramientas sobre objetivos fijos.
- **Matriz de interacciones**: tabla que cruza cada sistema con los demás y anota el resultado. Clave: hace visible lo emergente.
- **Consistencia**: que una regla se aplique siempre igual en todo contexto. Clave: sin ella, el jugador no puede planear.

## 🧰 Herramientas y preparación

Esta clase es de **diseño analítico**: tu herramienta es la matriz de interacciones (hoja de cálculo, tabla Markdown o papel cuadriculado). No implementarás los sistemas aquí, pero pensarás cómo lo harías en Godot: cada sistema suele modelarse como un **componente/nodo** que emite y recibe señales (por ejemplo, un `Area3D` "fuego" que al solaparse con uno "agua" produce "vapor"). Ten presente el patrón de señales de Godot (<https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html>) y el uso de grupos para consultar sistemas afectados.

## 🧪 Laboratorio guiado

Diseñarás **3 sistemas simples que interactúen** y enumerarás las interacciones emergentes en una matriz. Entregable: tabla de reglas + matriz de interacciones + lista de emergentes.

**Paso 1 — Define 3 sistemas ortogonales.** Elige un trío clásico (fuego / agua / viento) o crea el tuyo. Para cada uno, declara su regla base:

| Sistema | Regla base | Se propaga a | Estado que crea |
|---------|-----------|--------------|-----------------|
| Fuego | Quema materiales inflamables adyacentes | Madera, hierba, aceite | Ceniza, calor |
| Agua | Moja y apaga; fluye hacia abajo | Superficies, fuego | Mojado, charco |
| Viento | Empuja objetos ligeros y llamas | Fuego, humo, hojas | Dirección de propagación |

**Paso 2 — Rellena la matriz de interacciones.** Cruza cada sistema con los demás y anota el resultado emergente:

| ↓ actúa sobre → | Fuego | Agua | Viento |
|-----------------|-------|------|--------|
| **Fuego** | — | Se apaga → vapor | Se aviva y avanza |
| **Agua** | Apaga; crea vapor | — | Se ondula; se dispersa rocío |
| **Viento** | Propaga el fuego | Empuja el charco | — |

**Paso 3 — Lista de emergentes.** Deriva situaciones que ningún sistema define por sí solo pero surgen del cruce:

- Viento + fuego + hierba = incendio que avanza en la dirección del viento.
- Agua vertida cuesta arriba de un fuego = barrera que lo detiene al fluir hacia abajo.
- Fuego + agua en zona cerrada = vapor que reduce visibilidad (nuevo uso táctico).
- Viento fuerte + charco = dispersa rocío que humedece superficies lejanas.
- Fuego que crea calor + viento = corriente ascendente que altera trayectorias ligeras.

Observa que ninguno de estos comportamientos aparece escrito en la regla base de un sistema aislado: todos nacen del cruce. Esa es la firma de la emergencia — el diseñador define las reglas, el jugador descubre las combinaciones.

**Paso 4 — Chequeo de consistencia.** Verifica que ninguna interacción sea una excepción especial: si el fuego apaga con agua, debe hacerlo *siempre*, no solo en la sala scriptada. Marca cada celda como *regla general* o *excepción* (evita excepciones).

Un truco útil: para cada celda, pregúntate "¿el jugador esperaría este resultado si conoce las dos reglas por separado?". Si la respuesta es no, o la interacción es un caso especial, o falta comunicar mejor una de las reglas base.

**Paso 5 — Boceto de implementación.** Para UNA interacción, escribe en pseudo-GDScript cómo se dispararía por señales:

```gdscript
# Boceto: el sistema Fuego reacciona a solaparse con Agua.
func _on_area_entered(otra: Area3D) -> void:
    if otra.is_in_group("agua"):
        apagar()                 # regla general, no caso especial
        _emitir_vapor(global_position)
```

## ✍️ Ejercicios

1. Diseña un cuarto sistema (electricidad) y amplía la matriz a 4x4.
2. Encuentra una interacción de tu matriz que rompa el balance y propón un ajuste.
3. Reescribe una interacción "excepción" como regla general consistente.
4. Enumera 5 soluciones distintas a un mismo obstáculo usando tus sistemas.
5. Identifica dos sistemas que sean redundantes (no ortogonales) y diferéncialos.
6. Diseña una "trampa emergente" que el jugador pueda tender combinando dos sistemas.

## 📝 Reto verificable

Entrega el diseño de **3 sistemas ortogonales** con su tabla de reglas, la **matriz de interacciones** completa (todos los cruces resueltos) y una lista de al menos **4 comportamientos emergentes** derivados que no estén definidos explícitamente en ningún sistema individual.

**Criterio de aceptación**: los 3 sistemas son ortogonales (no redundantes); la matriz tiene todas las celdas de cruce rellenas y marcadas como regla general o excepción; y cada emergente de la lista se puede rastrear a la combinación concreta de reglas que lo produce.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Los sistemas no producen sorpresas | Son redundantes; hazlos ortogonales con efectos distintos |
| Hay reglas "solo aquí" | Excepciones scriptadas; conviértelas en reglas generales |
| El jugador no confía en las reglas | Inconsistencia; aplica cada regla igual en todo contexto |
| La matriz tiene celdas vacías | Interacciones sin definir; decide qué pasa en cada cruce |
| Todo se resuelve de una sola forma | Poca ortogonalidad; añade un sistema que abra rutas nuevas |
| El balance se rompe con una combo | Interacción demasiado potente; ajusta coste o efecto |

## ❓ Preguntas frecuentes

**¿Emergencia significa caos incontrolable?** No: significa variedad dentro de reglas consistentes. El diseñador acota el espacio de posibilidad, no cada resultado.

**¿Necesito muchos sistemas para tener emergencia?** No. Tres sistemas ortogonales bien cruzados dan más profundidad que diez redundantes. La riqueza está en las interacciones, no en el número.

**¿Cómo balanceo algo que no puedo prever del todo?** Con la matriz identificas las combinaciones peligrosas y ajustas costes; luego el playtest revela las que se te escaparon.

**¿Los immersive sims son el único género emergente?** No, pero son el ejemplo más puro. Roguelikes, sandbox y muchos sistémicos comparten el mismo principio de reglas cruzadas.

## 🔗 Referencias

- Godot Docs — Signals: <https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html>
- Godot Docs — Groups: <https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html>
- GDC — Systemic design de immersive sims (charlas): <https://www.gdcvault.com/>
- Game Design Vocabulary — Emergence (referencia general): <https://www.gamedeveloper.com/>

## ➡️ Siguiente clase

Continúa con [Clase 170 - Documentación de diseño: GDD y one-pager](../170-documentacion-de-diseno-gdd-y-one-pager/README.md), donde aprenderás a comunicar y documentar la visión de estos sistemas.
