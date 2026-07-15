# 📝 Autoevaluaciones y progreso

> [⬅️ Volver al programa](../README.md) · [📚 Índice completo](../classes/README.md) · [🧭 Rutas por rol](../rutas/README.md)

Dos herramientas para saber si de verdad estás aprendiendo, no solo leyendo.

## 📝 Autoevaluación

**90 preguntas** — una batería de 5 por cada una de las 18 partes. Cada pregunta tiene 4 opciones y, al corregir, la **explicación de por qué** la respuesta correcta lo es.

👉 **[Hacer la autoevaluación](https://vladimiracunadev-create.github.io/modern-gamedev-program/autoevaluaciones/quiz.html)**

Las preguntas están escritas a partir del contenido real de las clases, y muchos distractores son **errores que la gente comete de verdad** (los mismos que documenta la sección "Errores comunes" de cada clase).

| Resultado | Qué significa |
|---|---|
| **≥ 80 %** | Dominas la parte: sigue adelante. |
| **50–79 %** | Repasa las clases de lo que fallaste. |
| **< 50 %** | Vuelve a la parte antes de continuar: lo siguiente asume esto. |

## ✅ Seguimiento de progreso

Marca las **292 clases** conforme las completes y mira tu avance por parte y global.

👉 **[Ver mi progreso](https://vladimiracunadev-create.github.io/modern-gamedev-program/autoevaluaciones/progreso.html)**

> **Privacidad:** todo ocurre en tu navegador. Las respuestas y el progreso se guardan en `localStorage` y **no se envían a ningún servidor**. Si borras los datos del navegador, se pierden.

## 🛠️ Para contribuir preguntas

Las preguntas viven en [`preguntas.json`](preguntas.json) con esta estructura:

```json
{
  "partes": [
    {
      "idx": 0,
      "titulo": "Fundamentos y prerrequisitos",
      "preguntas": [
        {
          "q": "¿Por qué se multiplica la velocidad por delta?",
          "opciones": ["...", "...", "...", "..."],
          "correcta": 1,
          "exp": "Explicación breve de por qué es correcta."
        }
      ]
    }
  ]
}
```

Reglas: exactamente **4 opciones**, `correcta` es el índice **0–3**, y `exp` es obligatoria. Las páginas se sirven tal cual desde el sitio; no hay build.
