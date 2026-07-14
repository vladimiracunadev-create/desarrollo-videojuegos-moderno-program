# Clase 276 — Lanzamiento: checklist y día del launch

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Steamworks Documentation (Launching your game) y post-mortems de lanzamientos indie*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El día del lanzamiento es el momento de mayor visibilidad y también de mayor riesgo: si algo se rompe, se rompe delante de todo tu público a la vez. La diferencia entre un launch caótico y uno controlado casi nunca es suerte; es una **checklist** preparada con semanas de antelación y un **plan para el día D** que dice quién hace qué, en qué orden y qué se hace si algo falla.

En esta clase construirás una checklist de lanzamiento que cubre build, tienda, prensa, comunidad y soporte, y un guion del día del launch con capacidad de **hotfix** y gestión de la avalancha de mensajes. El objetivo es que llegues al lanzamiento sin sorpresas evitables.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Construir una checklist de lanzamiento por áreas (build, tienda, prensa, comunidad, soporte).
2. Secuenciar las tareas del día del launch con responsables y horarios.
3. Preparar un procedimiento de hotfix para desplegar arreglos críticos con rapidez.
4. Anticipar y gestionar la avalancha de reseñas, mensajes y reportes del día D.
5. Definir criterios de "listo para publicar" (go/no-go) que eviten lanzar a ciegas.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Checklist como red de seguridad | Lo que no está escrito se olvida bajo presión. |
| 2 | Build final y verificación | Publicar el build equivocado es un error clásico y caro. |
| 3 | Página de tienda lista | Es tu escaparate; un fallo aquí cuesta ventas. |
| 4 | Prensa y creadores de contenido | El alcance del día D depende de esto. |
| 5 | Comunidad y soporte | El primer día genera picos de mensajes y reportes. |
| 6 | El día del launch minuto a minuto | La coordinación evita el caos. |
| 7 | Hotfix bajo presión | Los bugs graves aparecen justo al abrir a todos. |
| 8 | Decisión go/no-go | Da un criterio objetivo para publicar o esperar. |

## 📖 Definiciones y características

- **Checklist de lanzamiento**: lista exhaustiva de tareas verificables antes de publicar. Clave: cada ítem tiene responsable y estado.
- **Build de release**: la versión final compilada, firmada y verificada que se sube a la tienda. Clave: debe coincidir bit a bit con lo probado.
- **Go/no-go**: reunión o criterio que decide si se lanza en la fecha prevista. Clave: da permiso para posponer sin drama.
- **Hotfix**: parche urgente que corrige un fallo crítico en producción. Clave: proceso ensayado, no improvisado.
- **Embargo de prensa**: fecha/hora acordada hasta la que la prensa no publica. Clave: concentra la cobertura en el momento óptimo.
- **Press kit**: paquete con descripción, capturas, tráiler y contacto para medios. Clave: baja la fricción para que hablen de ti.
- **Avalancha del día D**: pico simultáneo de ventas, reseñas, reportes y mensajes. Clave: se gestiona con turnos y respuestas preparadas.
- **Ventana de wishlist**: acumulación previa de listas de deseos que se convierten en ventas al lanzar. Clave: influye en el algoritmo de la tienda el día del launch.

## 🧰 Herramientas y preparación

Necesitas acceso al backend de tu tienda (Steamworks, App Store Connect, Google Play Console o el panel de itch.io). Revisa la guía de lanzamiento de Steam para conocer los pasos obligatorios: <https://partner.steamgames.com/doc/store/application/launchchecklist>. Ten preparado un **press kit** (una herramienta común es presskit(): <https://dopresskit.com/>) y una lista de contactos de prensa y creadores.

Para el día D conviene un canal interno de coordinación (Discord/Slack) y un documento vivo donde marcar el avance en tiempo real. Prepara respuestas plantilla para las preguntas y reportes más probables, para no redactarlas en caliente.

## 🧪 Laboratorio guiado

Producirás una **checklist de lanzamiento completa** y un **plan del día D**.

1. **Checklist por áreas.** Crea `checklist-lanzamiento.md` con cinco secciones y ítems verificables (marca [ ]). Ejemplo de estructura mínima:

```text
BUILD
[ ] Build de release compilado desde la rama correcta y con versión etiquetada
[ ] Probado en todas las plataformas objetivo (Win/Mac/Linux o móvil)
[ ] Sin claves de depuración, logs verbosos ni contenido de prueba
[ ] Tamaño de descarga y requisitos verificados

TIENDA
[ ] Página con descripción, capturas actualizadas, tráiler y etiquetas
[ ] Precio y regiones configurados; descuento de lanzamiento definido
[ ] Fecha y hora de publicación confirmadas (con zona horaria)

PRENSA
[ ] Press kit publicado y enlazado
[ ] Claves de reseña enviadas con embargo claro
[ ] Tráiler de lanzamiento programado

COMUNIDAD
[ ] Anuncio de lanzamiento redactado y programado
[ ] Redes y Discord listos, moderación reforzada
[ ] FAQ de lanzamiento publicada

SOPORTE
[ ] Canal de reportes de bugs abierto y visible
[ ] Respuestas plantilla para incidencias comunes
[ ] Procedimiento de hotfix ensayado
```

2. **Criterios go/no-go.** Escribe la lista de condiciones que DEBEN cumplirse para lanzar (ej.: cero bugs bloqueantes abiertos, build verificado, página aprobada por la tienda). Define quién toma la decisión y cuándo.

3. **Plan del día D minuto a minuto.** Redacta un guion con horarios, tareas y responsable. Ejemplo:

```text
| Hora | Tarea | Responsable | Contingencia |
| T-2h | Verificar build publicable en modo revisión | Dev | Retrasar si falla |
| T-1h | Reunión go/no-go final | Todo el equipo | Posponer launch |
| T-0  | Pulsar publicar / quitar embargo | Producción | — |
| T+0  | Anuncio en redes y Discord | Comunidad | — |
| T+1h | Monitoreo de crashes y reseñas | Dev + soporte | Activar hotfix |
| T+4h | Primer resumen de estado | Producción | — |
```

4. **Procedimiento de hotfix.** Documenta los pasos para desplegar un arreglo urgente: quién autoriza, cómo se prueba en mínimo tiempo, cómo se comunica a los jugadores y cómo se revierte si empeora las cosas.

5. **Gestión de la avalancha.** Prepara 5 respuestas plantilla (crash al iniciar, problema de compra, bug conocido, elogio, pregunta de reembolso) y define turnos de atención para las primeras horas. Entrega checklist + go/no-go + plan del día D + procedimiento de hotfix.

## ✍️ Ejercicios

1. Añade a tu checklist tres ítems específicos de tu plataforma objetivo que hoy no están.
2. Escribe el mensaje de anuncio de lanzamiento para redes en menos de 280 caracteres.
3. Define el umbral que dispara un hotfix (ej.: crash que afecta a >X% de jugadores).
4. Redacta el correo de envío de claves de reseña con embargo, fecha y enlace al press kit.
5. Diseña el turno de las primeras 6 horas: quién vigila crashes, quién responde comunidad.
6. Haz una versión "no-go": qué comunicarías si tuvieras que posponer 48 horas antes.

## 📝 Reto verificable

Elabora la checklist de lanzamiento completa de tu juego con las cinco áreas e ítems verificables, la lista de criterios go/no-go con responsable, el plan del día D minuto a minuto con contingencias y un procedimiento de hotfix documentado.

**Criterio de aceptación**: la checklist cubre build, tienda, prensa, comunidad y soporte con al menos tres ítems accionables cada una; el plan del día D asigna responsable y contingencia a cada tarea; y el procedimiento de hotfix especifica quién autoriza, cómo se prueba, cómo se comunica y cómo se revierte.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Se publicó un build con contenido de prueba | Faltó verificar el build final. Añade verificación de build como ítem go/no-go bloqueante. |
| La página de tienda tenía capturas viejas al lanzar | La tienda no se actualizó a tiempo. Congela y revisa la página días antes. |
| El equipo improvisó ante un crash masivo | No había procedimiento de hotfix ensayado. Documenta y practica el despliegue de emergencia. |
| Los mensajes del día D desbordaron al equipo | No había turnos ni respuestas plantilla. Prepara turnos y plantillas por adelantado. |
| La cobertura de prensa se dispersó | No hubo embargo coordinado. Define fecha/hora de embargo y envía claves con antelación. |

## ❓ Preguntas frecuentes

**❓ ¿A qué hora conviene lanzar?** En una franja donde tu equipo esté despierto y disponible para vigilar y responder; publicar y desaparecer es el peor escenario.

**❓ ¿Necesito descuento de lanzamiento?** Un descuento breve de lanzamiento suele impulsar la visibilidad inicial y la conversión de wishlists, pero verifica las reglas de precios de tu plataforma.

**❓ ¿Qué pasa si encuentro un bug grave justo después de publicar?** Activa tu procedimiento de hotfix: comunica que estás al tanto, despliega el arreglo probado y evita silencio; la comunidad perdona bugs, no perdona indiferencia.

**❓ ¿Puedo posponer el lanzamiento a último momento?** Sí, y a veces es lo correcto. Por eso existe el go/no-go: da un marco para posponer sin que parezca una crisis improvisada.

## 🔗 Referencias

- Steamworks — Launch checklist: <https://partner.steamgames.com/doc/store/application/launchchecklist>
- presskit() de Rami Ismail: <https://dopresskit.com/>
- Google Play — Launch checklist: <https://developer.android.com/distribute/best-practices/launch/launch-checklist>
- App Store — Submit your apps: <https://developer.apple.com/app-store/submissions/>

## ➡️ Siguiente clase

[Clase 277 - LiveOps: eventos, temporadas y contenido continuo](../277-liveops-eventos-temporadas-y-contenido-continuo/README.md)
