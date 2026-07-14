# Clase 161 — Balanceo de juego: números, spreadsheets y tuning

> Parte: **8 — Game design y diseño de niveles** · Fuente: *Ian Schreiber, "Game Balance Concepts"; Schell, "The Art of Game Design"*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Cuando un juego tiene un arma que todos usan y las demás quedan olvidadas, o una unidad que gana siempre, el problema no es artístico: es de **números**. El balanceo es la disciplina de ajustar valores —coste, daño, vida, cadencia— para que ninguna opción domine y todas tengan un momento en que valen la pena. Y no se hace a ojo: se hace en **hojas de cálculo**, con fórmulas que revelan métricas derivadas como el **DPS** (daño por segundo) o el **TTK** (tiempo hasta la muerte), y se itera con datos hasta que las opciones convergen en un rango justo.

En esta clase aprenderás a construir una hoja de balanceo, a distinguir **curvas de coste/recompensa** (lineal vs exponencial), a calcular DPS y TTK, y a aplicar el concepto de **coste-efectividad** para detectar la opción rota. El entregable es una hoja de balanceo real de un conjunto de armas o unidades, ajustada iterativamente hasta que ninguna domine, con las fórmulas incluidas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Construir una hoja de balanceo con estadísticas base y métricas derivadas.
2. Calcular DPS, TTK y coste-efectividad mediante fórmulas de hoja de cálculo.
3. Distinguir curvas de coste/recompensa lineales y exponenciales y cuándo usar cada una.
4. Detectar la opción dominante o inútil comparando métricas normalizadas.
5. Iterar valores con criterio de datos hasta que las opciones queden dentro de un rango justo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Balanceo como problema numérico | Se resuelve con datos, no con opiniones. |
| 2 | La hoja de balanceo | Herramienta central del diseñador de sistemas. |
| 3 | Estadísticas base vs derivadas | Separa las palancas de los resultados. |
| 4 | DPS y TTK | Métricas comparables entre opciones distintas. |
| 5 | Coste-efectividad | Revela si un ítem "vale lo que cuesta". |
| 6 | Curvas lineal vs exponencial | Definen cómo escalan coste y recompensa. |
| 7 | Simetría vs asimetría balanceada | Distintas opciones, poder equivalente. |
| 8 | Iterar con datos | El tuning es un bucle de medir y ajustar. |

## 📖 Definiciones y características

- **Balanceo**: ajuste de valores para que las opciones sean competitivas entre sí. Clave: el objetivo no es que todo sea igual, sino que todo sea viable.
- **Estadística base**: valor de entrada que el diseñador fija directamente (daño, coste, vida). Clave: son las palancas que tocas al hacer tuning.
- **Estadística derivada**: valor calculado a partir de las base (DPS, TTK). Clave: hace comparables opciones con perfiles distintos.
- **DPS (daño por segundo)**: `daño_por_golpe × golpes_por_segundo`. Clave: normaliza el daño de armas con cadencias distintas.
- **TTK (time to kill)**: `vida_objetivo / DPS`. Clave: mide cuánto tarda una opción en matar; base del ritmo de combate.
- **Coste-efectividad**: poder obtenido por unidad de coste (p. ej. `DPS / coste`). Clave: detecta la opción rota, la que da demasiado por su precio.
- **Curva lineal**: coste o recompensa que crece a ritmo constante (`a·n + b`). Clave: predecible; buena para progresión suave.
- **Curva exponencial**: crecimiento acelerado (`a·rⁿ`). Clave: crea sensación de escalada, pero descontrola la economía si no se vigila.

## 🧰 Herramientas y preparación

La herramienta es, sin discusión, una **hoja de cálculo** (Google Sheets o LibreOffice Calc). Necesitas manejar fórmulas básicas: multiplicación, división, `MAX`/`MIN`, formato condicional para resaltar valores fuera de rango y gráficos de dispersión para ver la relación coste-poder. No hace falta programar; todo el tuning vive en celdas. Ten a mano un conjunto pequeño de opciones a balancear (4-6 armas o unidades) para que sea manejable.

Usa Google Sheets en <https://sheets.google.com> o Calc de <https://www.libreoffice.org>. La referencia teórica más completa y gratuita es el curso "Game Balance Concepts" de Ian Schreiber en <https://gamebalanceconcepts.wordpress.com>.

## 🧪 Laboratorio guiado

Vas a construir una **hoja de balanceo** de 5 armas (o unidades) y ajustarla hasta que ninguna domine.

1. **Define las estadísticas base.** Crea columnas para: `Coste`, `Daño por golpe`, `Cadencia (golpes/s)`, `Vida` (si son unidades). Rellena 5 opciones con valores iniciales deliberadamente desbalanceados.

2. **Añade las métricas derivadas** con fórmulas. En la fila de cada arma:

```text
DPS            = Daño_por_golpe * Cadencia
TTK (vs 100hp) = 100 / DPS
Coste-efect.   = DPS / Coste          (poder por moneda)
```

3. Copia esta plantilla como punto de partida:

| Arma | Coste | Daño/golpe | Cadencia | DPS | TTK (100hp) | DPS/Coste |
|------|-------|-----------|----------|-----|-------------|-----------|
| Pistola | 10 | 12 | 3.0 | 36 | 2.78 | 3.60 |
| Escopeta | 25 | 60 | 0.8 | 48 | 2.08 | 1.92 |
| Rifle | 30 | 20 | 5.0 | 100 | 1.00 | 3.33 |
| SMG | 20 | 8 | 10.0 | 80 | 1.25 | 4.00 |
| Francotirador | 40 | 90 | 0.5 | 45 | 2.22 | 1.13 |

4. **Detecta la opción rota.** Ordena por `DPS/Coste`. La que tenga la mayor coste-efectividad es candidata a dominante (aquí la SMG con 4.00); la de menor puede ser inútil (el Francotirador con 1.13). Márcalas con formato condicional.

5. **Define el rango justo.** Decide una banda objetivo de coste-efectividad, por ejemplo `DPS/Coste` entre 2.5 y 3.5. Todo lo que quede fuera necesita ajuste.

6. **Itera el tuning.** Ajusta estadísticas **base** (no las derivadas: esas se recalculan solas) para meter cada opción en la banda. Sube el coste de la SMG o baja su cadencia; baja el coste del Francotirador o sube su daño. Recalcula.

7. **Respeta las identidades.** Balancear no es igualar: la escopeta debe seguir siendo de alto daño por golpe y el rifle de DPS sostenido. Ajusta hasta que sean **distintas pero equivalentes en valor**, no idénticas.

8. **Verifica con una curva.** Grafica `Coste` (eje X) contra `DPS` (eje Y). En un juego balanceado los puntos se alinean cerca de una curva de coste/recompensa coherente (lineal o suavemente creciente); los outliers son opciones a revisar.

9. **Documenta el rango de cada estadística.** Junto a la hoja, anota el mínimo y el máximo razonable de cada estadística base (p. ej. coste entre 10 y 50). Estos límites evitan que en futuras iteraciones un ajuste se te vaya de escala y sirven de contrato con el resto del equipo sobre qué valores son válidos.

10. Guarda la hoja con las fórmulas visibles, los rangos y un párrafo explicando qué ajustaste y por qué. Ese es el entregable.

Con esto tienes el método profesional de balanceo: medir, comparar normalizado, ajustar la palanca correcta e iterar.

> **Consejo de práctica.** El balanceo nunca termina del todo: cada mecánica nueva rompe el equilibrio anterior. Mantén la hoja viva junto al proyecto y vuelve a ella con cada cambio, en lugar de balancear una vez y darlo por cerrado.

## ✍️ Ejercicios

1. Añade una sexta arma deliberadamente rota a la hoja y ajústala hasta que entre en la banda justa.
2. Cambia la curva de coste de lineal a exponencial y observa cómo afecta a la coste-efectividad de las armas caras.
3. Introduce una estadística nueva (alcance o precisión) y discute cómo la incorporarías al cálculo de poder.
4. Calcula el TTK contra tres tipos de objetivo (50, 100, 200 hp) y comenta qué arma escala mejor.
5. Balancea tres unidades tipo piedra-papel-tijera de modo que ninguna sea dominante en el conjunto.
6. Explica por qué igualar el DPS de todas las armas sería un mal balanceo y qué se pierde.

## 📝 Reto verificable

Entrega una hoja de balanceo de al menos 5 opciones con estadísticas base y las métricas derivadas (DPS, TTK y coste-efectividad) calculadas por fórmula, una banda de rango justo definida, y evidencia de al menos dos iteraciones de tuning que metieron opciones fuera de banda dentro de ella, con un párrafo que justifique cada ajuste.

**Criterio de aceptación**: las métricas derivadas están calculadas con fórmulas (no escritas a mano), tras el tuning todas las opciones caen dentro de la banda de coste-efectividad definida, las opciones conservan identidades distintas (no quedaron con valores idénticos), y el párrafo indica qué estadística base se movió en cada ajuste y por qué esa palanca y no otra.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Todas las armas quedaron con valores casi iguales | Confundiste balancear con igualar. Ajusta para equivalencia de valor, no de números; conserva identidades. |
| Editas el DPS a mano y no cuadra | El DPS es una métrica derivada. Toca solo las estadísticas base (daño, cadencia); deja que la fórmula recalcule. |
| Una opción sigue dominando pese a subir su coste | La coste-efectividad aún está fuera de banda. Compara `DPS/Coste`, no solo el coste; puede necesitar más ajuste. |
| La progresión de coste explota a niveles altos | Usaste curva exponencial sin control. Revísala; a veces una lineal o polinómica suave equilibra mejor. |
| Balanceas por opinión sin mirar la hoja | Sin métricas normalizadas el juicio engaña. Decide siempre a partir de DPS, TTK y coste-efectividad. |
| El DPS cuadra pero en partida un arma sigue rota | El DPS ignora contexto (alcance, recarga, área). Complementa la hoja con métricas situacionales y valida en playtest. |

## ❓ Preguntas frecuentes

**❓ ¿Balancear significa que todo sea igual de fuerte?** No. Significa que todo sea igual de *valioso* en su contexto. Una opción puede ser peor en un escenario si compensa en otro; el objetivo es viabilidad, no uniformidad.

**❓ ¿Por qué usar una hoja de cálculo y no ajustar en el motor?** Porque la hoja te deja ver decenas de opciones y sus métricas derivadas de un vistazo e iterar en segundos, sin recompilar. El motor es para validar; la hoja, para diseñar los números.

**❓ ¿Cuándo conviene una curva exponencial?** Cuando quieres que cada nivel se sienta un salto grande (coste de mejoras en un idle game). Pero exige vigilar la economía, porque descontrola rápido las cantidades.

**❓ ¿Los datos reemplazan al playtesting?** No. La hoja acerca los números a un rango razonable; el playtesting revela si el balance *se siente* justo. Se complementan: modela, prueba, mide y vuelve a la hoja.

## 🔗 Referencias

- Ian Schreiber — Game Balance Concepts (curso completo): <https://gamebalanceconcepts.wordpress.com>
- Jesse Schell — The Art of Game Design (capítulo de balanceo): <https://www.schellgames.com/art-of-game-design>
- GDC Vault — spreadsheets y balancing: <https://www.gdcvault.com>
- Google Sheets — funciones y fórmulas: <https://support.google.com/docs/table/25273>

## ➡️ Siguiente clase

[Clase 162 - Aleatoriedad, azar y percepción de justicia](../162-aleatoriedad-azar-y-percepcion-de-justicia/README.md)
