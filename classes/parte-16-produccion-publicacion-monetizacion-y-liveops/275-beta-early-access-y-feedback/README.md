# Clase 275 — Beta, early access y feedback

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Steamworks Documentation (Early Access) y prácticas de betas de estudios independientes*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Antes del lanzamiento definitivo, casi todo juego moderno pasa por manos de jugadores reales: **betas** cerradas o abiertas y, cada vez más, **Early Access** (acceso anticipado de pago mientras el juego aún se desarrolla). Estas fases no sirven solo para cazar bugs: validan si el juego es divertido, si la gente entiende sus mecánicas y si el modelo de negocio se sostiene.

En esta clase aprenderás a diseñar un **plan de beta / Early Access** con objetivos claros, a montar canales de recolección de feedback y —lo más difícil— a **interpretar** ese feedback sin caer en "diseñar por comité". Terminarás con un plan concreto y un formulario de encuesta listo para usar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir beta cerrada, beta abierta y Early Access, con sus pros y contras.
2. Definir objetivos medibles para una fase de prueba (qué hipótesis se valida).
3. Montar canales de feedback (encuestas, telemetría, comunidad) adecuados a cada objetivo.
4. Interpretar feedback separando la queja del problema real, evitando diseñar por comité.
5. Comunicar el avance con un roadmap público honesto y gestionar expectativas.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Beta cerrada vs. abierta | Controlas cantidad y perfil de testers según lo que buscas. |
| 2 | Early Access: pros y contras | Financia el desarrollo pero compromete tu tiempo y reputación. |
| 3 | Objetivos de una fase de prueba | Sin hipótesis, el feedback es ruido. |
| 4 | Canales de feedback | Cada canal captura un tipo distinto de señal. |
| 5 | Feedback cualitativo vs. cuantitativo | Uno dice "qué"; el otro dice "por qué". |
| 6 | No diseñar por comité | El jugador reporta síntomas, no diseña soluciones. |
| 7 | Roadmap público | Alinea expectativas y construye confianza. |
| 8 | Salir de Early Access | Definir qué significa "1.0" evita quedar atrapado. |

## 📖 Definiciones y características

- **Beta cerrada**: prueba con acceso restringido por invitación o clave. Clave: pocos testers, feedback profundo, riesgo de filtraciones bajo.
- **Beta abierta**: prueba pública gratuita por tiempo limitado. Clave: mucho volumen, ideal para pruebas de carga y primeras impresiones.
- **Early Access**: venta del juego inacabado con la promesa de seguir desarrollándolo. Clave: ingresos y comunidad tempranos a cambio de un compromiso público.
- **Hipótesis de prueba**: afirmación falsable que la fase debe validar (ej.: "los jugadores completan el tutorial sin ayuda"). Clave: dirige qué medir.
- **Feedback cuantitativo**: datos numéricos (retención, dónde abandonan, tiempo en tutorial). Clave: objetivo y agregable.
- **Feedback cualitativo**: opiniones, sensaciones, comentarios abiertos. Clave: revela el porqué detrás de los números.
- **Diseñar por comité**: implementar cada sugerencia literal de los jugadores. Clave: antipatrón; diluye la visión y satisface a nadie.
- **Roadmap público**: comunicación del plan de desarrollo por hitos. Clave: gestiona expectativas si es honesto y no promete fechas rígidas.

## 🧰 Herramientas y preparación

Para betas necesitas un canal de distribución (claves de Steam Playtest, itch.io con acceso restringido, o TestFlight/Google Play para móvil) y un canal de comunidad (Discord suele ser el estándar: <https://discord.com/>). Para encuestas basta Google Forms (<https://forms.google.com>) o Typeform. Revisa la guía oficial de Early Access de Steam para entender expectativas de la plataforma: <https://partner.steamgames.com/doc/store/earlyaccess>.

Ten claro antes de empezar **qué quieres aprender** de la fase. Una beta sin hipótesis genera un montón de comentarios inconexos que nadie sabe accionar. Prepara la plantilla de plan y el formulario que construiremos en el laboratorio.

## 🧪 Laboratorio guiado

Producirás un **plan de beta / Early Access** y un **formulario de encuesta** concreto.

1. **Define la fase y su tipo.** Decide si harás beta cerrada, abierta o Early Access, y escribe una frase justificando la elección según tu objetivo (¿validar diversión? ¿probar servidores? ¿financiar desarrollo?).

2. **Escribe 3 hipótesis medibles.** Cada una debe poder confirmarse o refutarse con datos. Ejemplos:
   - "El 80% de los jugadores termina el primer nivel sin abandonar."
   - "La mecánica de sigilo se entiende sin explicación explícita."
   - "El precio propuesto no genera rechazo mayoritario en los comentarios."

3. **Diseña la matriz de canales.** Para cada hipótesis, indica qué canal la mide:

```text
| Hipótesis | Canal principal | Métrica / señal | Umbral de éxito |
| Terminan nivel 1 | Telemetría | % que llega al nivel 2 | ≥ 80% |
| Sigilo se entiende | Encuesta + observación | ítem "supe qué hacer" | ≥ 4/5 medio |
| Precio aceptable | Comunidad/comentarios | ratio menciones + vs - | mayoría neutral/positiva |
```

4. **Construye el formulario de encuesta.** Redacta 8–10 preguntas que combinen escala (1–5) y abiertas. Incluye al menos:
   - Net Promoter: "¿Recomendarías el juego? (0–10)".
   - Claridad: "¿En algún momento no supiste qué hacer? ¿Dónde?".
   - Diversión por sistema: valora combate, exploración, progresión (1–5).
   - Pregunta abierta única: "Si pudieras cambiar UNA cosa, ¿cuál?".
   - Evita preguntas que pidan al jugador diseñar ("¿qué feature agregarías?") como fuente única de decisiones.

5. **Define el bucle de interpretación.** Escribe la regla con la que convertirás feedback en decisiones: agrupa comentarios por tema, cuenta frecuencia, separa el **síntoma** ("el jefe es injusto") de la **causa hipotética** ("no se telegrafía el ataque") y solo entonces decide el arreglo. Documenta qué NO cambiarás aunque lo pidan, para proteger la visión.

6. **Redacta un roadmap público** de 3–4 hitos con lenguaje de fases ("Próximo", "En estudio", "No planeado"), sin fechas rígidas. Ejemplo de estructura:

```text
| Estado | Elemento | Nota pública |
| Próximo | Modo cooperativo local | En desarrollo activo |
| En estudio | Editor de niveles | Evaluando viabilidad técnica |
| No planeado | Multijugador online | Fuera del alcance actual |
```

Entrega plan + formulario + roadmap.

## ✍️ Ejercicios

1. Reescribe una hipótesis vaga ("ver si gusta") como afirmación medible con umbral.
2. Clasifica cinco comentarios reales de jugadores en síntoma vs. solución propuesta.
3. Diseña la política de acceso de una beta cerrada: cupos, criterios de selección, NDA sí/no.
4. Enumera tres riesgos de lanzar en Early Access y cómo los mitigarías.
5. Convierte tres quejas frecuentes en un único problema de diseño subyacente.
6. Redacta el mensaje de bienvenida a testers explicando qué feedback te es útil y cuál no.

## 📝 Reto verificable

Elabora un plan de beta o Early Access completo para tu juego: tipo de fase justificado, 3 hipótesis medibles con umbrales, matriz de canales, formulario de encuesta de 8–10 preguntas, regla de interpretación anti-comité y un roadmap público de 3–4 hitos.

**Criterio de aceptación**: cada hipótesis tiene una métrica y un umbral concretos; cada hipótesis está cubierta por al menos un canal en la matriz; el formulario contiene preguntas de escala y abiertas y no delega el diseño en los jugadores; y el plan declara explícitamente al menos una decisión que NO se cambiará pese al feedback.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| La beta produce mil comentarios inconexos | No había hipótesis. Define qué quieres aprender antes de abrir accesos. |
| El juego cambia de rumbo cada semana | Se está diseñando por comité. Filtra síntoma de solución y protege la visión. |
| Early Access se estanca años sin llegar a 1.0 | Falta definición de "terminado". Fija criterios de salida desde el inicio. |
| Los testers reportan poco y tarde | Fricción alta o canal equivocado. Facilita el reporte y pide feedback dentro del juego. |
| La comunidad se siente traicionada al lanzar | Roadmap prometió fechas o features que no llegaron. Usa lenguaje de fases, no promesas. |

## ❓ Preguntas frecuentes

**❓ ¿Beta abierta o cerrada?** Cerrada para feedback profundo y control; abierta para volumen, pruebas de carga y hype. Muchas producciones hacen ambas en momentos distintos.

**❓ ¿Early Access le baja el valor a mi 1.0?** No necesariamente: bien gestionado construye comunidad e ingresos. Mal gestionado (sin avances visibles) quema reputación. La diferencia es la cadencia de entregas.

**❓ ¿Debo implementar lo que más piden los jugadores?** Escucha el problema, no la solución literal. La feature más pedida suele ser un parche a un problema que se resuelve mejor de otra forma.

**❓ ¿Cuándo salgo de Early Access?** Cuando cumples los criterios de "1.0" que definiste al entrar, no cuando se acaban las ideas. Esa definición previa es lo que te protege.

## 🔗 Referencias

- Steamworks — Early Access: <https://partner.steamgames.com/doc/store/earlyaccess>
- Steam Playtest: <https://partner.steamgames.com/doc/store/playtesting>
- Google Forms: <https://forms.google.com>
- GDC Vault (charlas sobre playtesting): <https://www.gdcvault.com/>

## ➡️ Siguiente clase

[Clase 276 - Lanzamiento: checklist y día del launch](../276-lanzamiento-checklist-y-dia-del-launch/README.md)
