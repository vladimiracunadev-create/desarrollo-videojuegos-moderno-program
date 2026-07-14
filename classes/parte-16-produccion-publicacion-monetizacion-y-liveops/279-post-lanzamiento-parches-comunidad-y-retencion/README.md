# Clase 279 — Post-lanzamiento: parches, comunidad y retención

> Parte: **16 — Producción, publicación, monetización y LiveOps** · Fuente: *Post-mortems de GDC y guías de gestión de comunidad de estudios independientes*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El lanzamiento no es la meta: es el punto de partida de la relación con tus jugadores. Las semanas y meses posteriores definen si el juego construye una comunidad leal o se apaga. Eso depende de tres cosas: una **cadencia de parches** que corrija y mejore sin romper, una **gestión de comunidad** que escuche y responda, y una estrategia de **retención y reactivación** que mantenga vivo el interés.

En esta clase aprenderás a planificar el soporte post-lanzamiento como un programa con fechas y responsables, a gestionar reseñas y comunidad sin quemarte, y a decidir el momento difícil: cuándo seguir invirtiendo y cuándo parar. El entregable es un plan de soporte post-lanzamiento de 90 días.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diseñar una cadencia de parches (hotfix, menores, mayores) con criterios de despliegue.
2. Gestionar la comunidad y responder reseñas de forma constructiva y escalable.
3. Definir tácticas de retención y de reactivación de jugadores inactivos.
4. Priorizar el trabajo post-lanzamiento entre bugs, mejoras y contenido nuevo.
5. Reconocer las señales que indican cuándo reducir o detener el soporte.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Soporte post-lanzamiento | Es donde se gana o se pierde la comunidad. |
| 2 | Cadencia de parches | El ritmo comunica compromiso y estabilidad. |
| 3 | Notas de parche | Cómo comunicas los cambios afecta la percepción. |
| 4 | Gestión de comunidad | Una comunidad cuidada se vuelve tu mejor marketing. |
| 5 | Responder reseñas | Las respuestas públicas moldean la reputación. |
| 6 | Retención | Mantener a un jugador cuesta menos que conseguir uno nuevo. |
| 7 | Reactivación | Recuperar inactivos es una palanca de crecimiento barata. |
| 8 | Cuándo parar | Reconocer el fin evita agotar recursos sin retorno. |

## 📖 Definiciones y características

- **Soporte post-lanzamiento**: conjunto de actividades de mantenimiento y mejora tras publicar. Clave: es un programa planificado, no reacción improvisada.
- **Cadencia de parches**: ritmo previsible de actualizaciones (hotfix, menor, mayor). Clave: la previsibilidad genera confianza.
- **Hotfix**: parche urgente para un fallo crítico. Clave: rápido y acotado, sin cambios de alcance.
- **Notas de parche (patch notes)**: comunicación de qué cambió en una actualización. Clave: transparencia que la comunidad valora.
- **Gestión de comunidad (community management)**: cuidar el diálogo con los jugadores en redes y foros. Clave: escuchar y moderar, no solo anunciar.
- **Retención**: capacidad de que los jugadores sigan volviendo. Clave: más barata y valiosa que la adquisición.
- **Reactivación**: recuperar jugadores que dejaron de jugar. Clave: campañas y ganchos dirigidos a inactivos.
- **Fin de vida (EOL)**: decisión de reducir o cesar el soporte. Clave: se planifica y se comunica con dignidad.

## 🧰 Herramientas y preparación

Necesitas los canales de comunidad de tu juego (Discord, foros de Steam, redes) y acceso a las reseñas de tu tienda. Para organizar el plan usa un tablero o calendario. Estudia las notas de parche de juegos que sigues para ver tono y estructura. Guía útil de gestión de comunidad: <https://partner.steamgames.com/doc/store/communityhub>.

Ten a mano tus métricas de la clase anterior: la retención D1/D7/D30 y los puntos de abandono del funnel te dirán dónde enfocar los parches y las campañas de reactivación. Prepara la plantilla de plan de 90 días que armaremos en el laboratorio.

## 🧪 Laboratorio guiado

Elaborarás un **plan de soporte post-lanzamiento de 90 días**.

1. **Define la cadencia de parches.** Establece tipos y ritmo, con criterio de despliegue:

```text
| Tipo | Cadencia | Alcance | Criterio de despliegue |
| Hotfix | según necesidad | 1-2 arreglos críticos | Bug bloqueante confirmado |
| Parche menor | quincenal | bugs + ajustes de balance | Lote probado, sin regresiones |
| Parche mayor | ~cada 6 semanas | features / contenido | Hito planificado y testeado |
```

2. **Diseña el calendario de 90 días.** Divide en tres tramos (0–30, 31–60, 61–90) con foco distinto: el primer mes suele ser estabilización (bugs y calidad de vida), el segundo mejoras según feedback, el tercero contenido/retención. Escribe qué entra en cada tramo.

3. **Plantilla de notas de parche.** Crea el formato que usarás en cada actualización:

```text
Versión X.Y — fecha
🐛 Correcciones: ...
⚖️ Balance: ...
✨ Mejoras / calidad de vida: ...
📋 Conocido / próximo: ...
Gracias a la comunidad por reportar: ...
```

4. **Plan de gestión de comunidad.** Define: canales oficiales, frecuencia de presencia, tono de voz, política de moderación y quién responde. Incluye una guía para **responder reseñas negativas**: agradecer, no discutir, ofrecer solución o reconocer el problema, invitar al canal de soporte.

5. **Retención y reactivación.** Lista 3 tácticas de retención (ej.: recompensa de login, evento de fin de semana, mejora de onboarding para D1) y 2 de reactivación (ej.: notificación "vuelve y recibe X", anuncio de gran parche a inactivos). Ata cada táctica a una métrica de la clase 278.

6. **Criterios de fin de soporte.** Escribe las señales que te harían reducir o parar y cómo lo comunicarías con respeto a la comunidad. Estructura la decisión con umbrales concretos:

```text
| Señal | Umbral | Acción |
| Población activa | DAU < X durante 4 semanas | Reducir a solo hotfix |
| Ingreso vs coste | ingresos < coste de soporte | Anunciar fin de parches mayores |
| Prioridad de equipo | siguiente proyecto lo requiere | Transición planificada |
```

Entrega cadencia + calendario 90 días + plantilla de notas + plan de comunidad + tácticas + criterios de EOL.

## ✍️ Ejercicios

1. Redacta las notas de parche de una actualización menor ficticia con tu plantilla.
2. Responde por escrito a una reseña negativa real usando la guía de tono definida.
3. Prioriza una lista de 6 tareas post-lanzamiento entre bug, mejora y contenido, y justifica el orden.
4. Diseña una campaña de reactivación con su gancho, su público (inactivos Dn) y su métrica.
5. Define el umbral concreto de población o ingresos que dispararía tu decisión de EOL.
6. Escribe el mensaje a la comunidad anunciando que el soporte mayor termina, con tono digno.

## 📝 Reto verificable

Elabora un plan de soporte post-lanzamiento de 90 días para tu juego con: cadencia de parches (hotfix/menor/mayor con criterios), calendario dividido en tres tramos mensuales con foco, plantilla de notas de parche, plan de gestión de comunidad con guía de respuesta a reseñas, al menos 3 tácticas de retención y 2 de reactivación ligadas a métricas, y criterios explícitos de fin de soporte.

**Criterio de aceptación**: la cadencia especifica ritmo y criterio de despliegue por tipo de parche; el calendario cubre 90 días con foco definido por tramo; cada táctica de retención/reactivación está ligada a una métrica concreta; y los criterios de EOL son cuantificables (umbral de población o ingresos), no vagos.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| La comunidad siente abandono tras el launch | No hubo cadencia de parches. Publica actualizaciones previsibles, aunque sean pequeñas. |
| Las discusiones con jugadores escalan en público | Se respondió a la defensiva. Agradece, no discutas, lleva el detalle a soporte. |
| Los parches introducen bugs nuevos | Se despliega sin regresión. Aplica la suite de regresión de la clase 274 antes de publicar. |
| Se invierte en contenido y nadie vuelve | No se atacó la retención D1/D7. Arregla el onboarding antes que añadir contenido tardío. |
| El equipo mantiene un juego muerto por inercia | Falta criterio de EOL. Define umbrales y comunica el cierre con dignidad. |

## ❓ Preguntas frecuentes

**❓ ¿Cada cuánto debo parchear?** Con la frecuencia que puedas sostener sin bajar la calidad. La previsibilidad importa más que la velocidad: mejor quincenal cumplido que diario caótico.

**❓ ¿Debo responder todas las reseñas negativas?** No todas, pero sí las representativas y las que exponen problemas reales. Una buena respuesta pública ayuda a muchos futuros lectores.

**❓ ¿Retención o adquisición?** Primero retención: no tiene sentido atraer jugadores a un juego del que se van. Arregla la fuga antes de abrir el grifo.

**❓ ¿Cómo sé cuándo parar?** Cuando el coste de sostenerlo supera el retorno y el equipo aporta más en otro proyecto. Define umbrales por adelantado para no decidirlo con el ego.

## 🔗 Referencias

- Steamworks — Community Hub: <https://partner.steamgames.com/doc/store/communityhub>
- GDC Vault — post-mortems y community management: <https://www.gdcvault.com/>
- Steamworks — Updating your game: <https://partner.steamgames.com/doc/store/updates>
- CMX / guías de gestión de comunidad: <https://cmxhub.com/>

## ➡️ Siguiente clase

[Clase 280 - Capstone Parte 16: un plan de producción y lanzamiento](../280-capstone-parte-16-un-plan-de-produccion-y-lanzamiento/README.md)
