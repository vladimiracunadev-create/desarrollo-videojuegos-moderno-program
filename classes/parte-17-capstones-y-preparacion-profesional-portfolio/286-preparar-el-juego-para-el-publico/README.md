# Clase 286 — Preparar el juego para el público

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Documentación de itch.io y guías de publicación indie*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Convertir tu slice pulido en una **build que un desconocido pueda descargar y jugar sin ti al lado**. Eso implica lo que el jugador nunca agradece pero siempre nota si falta: un onboarding que enseña sin manual, opciones básicas, un mínimo de accesibilidad, guardado si hace falta, créditos, y un empaquetado que funcione en otra máquina distinta de la tuya. Publicar es un oficio propio y esta clase te da la checklist para no olvidar nada.

Al terminar tendrás una **checklist de "listo para publicar"** aplicada a tu capstone y una **build pública subida a itch.io**, probada en una máquina que no sea la tuya. Ese enlace jugable es una pieza central de tu portfolio.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Auditar su juego con una checklist de "listo para publicar".
2. Diseñar un onboarding que enseñe a jugar sin texto externo.
3. Aplicar accesibilidad mínima y opciones básicas (volumen, salir, remapeo simple).
4. Empaquetar y exportar una build funcional para otra plataforma/máquina.
5. Publicar y probar la build en itch.io verificándola en un equipo ajeno.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Onboarding | Si no sabe empezar, no juega. |
| 2 | Opciones básicas | Volumen y salir son lo mínimo esperable. |
| 3 | Accesibilidad mínima | Amplía tu público y demuestra criterio. |
| 4 | Guardado | Respeta el tiempo del jugador cuando aplica. |
| 5 | Créditos y licencias | Ético y obligatorio con assets de terceros. |
| 6 | Empaquetado / export | Un build roto no lo juega nadie. |
| 7 | Probar en otra máquina | Tu PC miente: tiene todo instalado. |
| 8 | Publicar en itch.io | El enlace jugable es tu carta de presentación. |

## 📖 Definiciones y características

- **Build final**: versión exportada y autónoma del juego lista para distribuir. Clave: debe correr sin el editor ni tus dependencias de desarrollo.
- **Onboarding**: cómo el juego enseña sus controles y objetivo en los primeros segundos. Clave: mostrar jugando gana a explicar con texto.
- **Accesibilidad mínima**: ajustes que permiten jugar a más gente (texto legible, opción de reducir efectos, controles claros). Clave: pequeñas mejoras, gran alcance.
- **Guardado / persistencia**: conservar progreso entre sesiones. Clave: imprescindible si el juego dura más que una sentada.
- **Créditos**: reconocimiento de autoría y de assets/licencias de terceros. Clave: omitirlos puede violar licencias y es mala praxis.
- **Export template**: paquete del motor que genera el ejecutable para cada plataforma. Clave: sin el correcto, el export falla o no arranca fuera.
- **Dependencia oculta**: recurso presente en tu PC pero ausente en el del jugador (fuente, runtime, ruta absoluta). Clave: la causa típica de "a mí me funciona".
- **Página de itch.io**: ficha pública con descripción, capturas y el propio build. Clave: es escaparate y canal de distribución a la vez.

## 🧰 Herramientas y preparación

Necesitas tu motor con los *export templates* instalados y una cuenta en [itch.io](https://itch.io/) (gratuita). Para subir builds cómodamente, [Butler](https://itch.io/docs/butler/) (la CLI de itch.io) permite publicar y actualizar por comando. Ten preparadas 2-3 capturas y un GIF corto del juego para la ficha.

Lo más importante: consigue **otra máquina** (un compañero, otro PC, un portátil) para probar el build. Tu equipo de desarrollo tiene instalado todo lo que el juego podría necesitar y por eso oculta los fallos de empaquetado. Repasa lo visto en la parte de plataformas sobre exportación específica de tu motor antes de empezar.

## 🧪 Laboratorio guiado

Entregable: `publicacion-checklist.md` completada y una build pública en itch.io probada en otra máquina.

1. **Recorre la checklist de "listo para publicar"** y marca el estado de cada ítem:

   ```text
   ONBOARDING
   [ ] los controles se muestran al empezar (o se enseñan jugando)
   [ ] el objetivo del juego se entiende sin manual
   [ ] primer minuto sin bloqueos ni pantallas confusas
   OPCIONES / ACCESIBILIDAD
   [ ] control de volumen (o al menos mute)
   [ ] forma clara de pausar y de salir
   [ ] texto legible (tamaño/contraste suficientes)
   [ ] opción de reducir efectos intensos (si aplica)
   PERSISTENCIA
   [ ] guarda progreso si el juego dura más de una sentada
   [ ] el guardado sobrevive a cerrar y reabrir
   CIERRE
   [ ] pantalla de créditos con autoría y assets de terceros
   [ ] licencias de assets respetadas y citadas
   BUILD
   [ ] exporta sin errores
   [ ] arranca en otra máquina limpia
   [ ] no depende de rutas absolutas de tu PC
   [ ] tamaño razonable y sin archivos de desarrollo dentro
   ```

2. **Arregla el onboarding.** Añade un cartel de controles al inicio o, mejor, un primer tramo que los enseñe jugando (un salto forzado, una flecha que señala). Verifícalo con alguien que no haya jugado.

3. **Añade opciones básicas.** Como mínimo: volumen o mute, pausa y salir. Si tu juego usa efectos intensos (destellos, screenshake fuerte), ofrece reducirlos.

4. **Asegura el guardado** si procede. Comprueba que cerrar y reabrir conserva el progreso; guarda en la ruta de datos de usuario del sistema, nunca junto al ejecutable.

5. **Escribe los créditos.** Tu nombre, el rol, y **cada asset de terceros** con su autor y licencia. Revisa que cada fuente, sonido o sprite externo permita su uso y atribución.

6. **Exporta la build.** Genera el ejecutable para tu plataforma objetivo con los export templates. Revisa que no arrastre archivos de desarrollo ni rutas absolutas.

7. **Prueba en otra máquina.** Copia el build a un equipo distinto y ejecútalo desde cero. Anota cualquier "a mí me funcionaba": fuentes que faltan, ventana mal dimensionada, controles no mapeados.

8. **Publica en itch.io.** Crea la página: título, descripción corta, 2-3 capturas, un GIF y controles listados. Sube el build (arrastrando o con Butler), marca visibilidad pública o con enlace, y verifica descargando tú mismo el archivo publicado.

## ✍️ Ejercicios

1. Rediseña tu onboarding para enseñar un control sin usar texto; describe cómo.
2. Añade una opción de accesibilidad concreta y explica a quién ayuda.
3. Redacta la pantalla de créditos incluyendo licencias de al menos un asset externo.
4. Exporta la build y lístala: comprueba que no incluye archivos de desarrollo.
5. Prueba en otra máquina y documenta un fallo de "a mí me funcionaba" y su arreglo.
6. Escribe la descripción de la ficha de itch.io en menos de 60 palabras con un gancho.

## 📝 Reto verificable

Publica tu capstone (o su vertical slice) en **itch.io** con página completa y verifica que se descarga y juega en una máquina distinta de la tuya. Entrega el enlace público y la `publicacion-checklist.md` con todos los ítems resueltos o justificados.

**Criterio de aceptación**: existe un enlace público de itch.io que se descarga y arranca en otra máquina sin dependencias de tu PC; el juego tiene onboarding comprensible sin ayuda externa, control de volumen/salir, y una pantalla de créditos que cita los assets de terceros con su licencia; la checklist está completa.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| "A mí me funcionaba" y en otro PC no arranca | Dependencia oculta o ruta absoluta. Prueba en máquina limpia y empaqueta los recursos correctamente. |
| El jugador no sabe qué hacer al empezar | Falta onboarding. Enseña controles y objetivo jugando en el primer minuto. |
| El build pesa cientos de MB o incluye código fuente | Exportaste archivos de desarrollo. Excluye assets crudos y limpia el export. |
| El guardado se pierde al reabrir | Guardas junto al ejecutable o en carpeta protegida. Usa la ruta de datos de usuario del sistema. |
| Usaste una fuente/sonido sin permiso | Licencia no verificada. Revisa y cita cada asset, o sustitúyelo por uno libre. |

## ❓ Preguntas frecuentes

**❓ ¿itch.io o Steam para el capstone?** itch.io: es gratis, inmediato y sin proceso de aprobación. Steam tiene coste y requisitos; déjalo para cuando tengas un producto comercial. El enlace de itch.io ya sirve de portfolio.

**❓ ¿Cuánta accesibilidad necesito?** El mínimo ya diferencia: texto legible, volumen/mute, controles claros y opción de reducir efectos intensos. No hace falta un sistema completo para demostrar criterio.

**❓ ¿Debo firmar o notarizar el ejecutable?** Para un capstone en itch.io no es necesario. Basta con avisar en la ficha de posibles advertencias del SO y dar instrucciones claras de ejecución.

**❓ ¿Por qué probar en otra máquina si en la mía va perfecto?** Porque tu equipo tiene instaladas fuentes, runtimes y rutas que el del jugador no. La prueba en máquina limpia es la única forma fiable de detectar dependencias ocultas.

## 🔗 Referencias

- itch.io — cómo subir y publicar un juego: <https://itch.io/docs/creators/getting-started>
- Butler — CLI para publicar builds: <https://itch.io/docs/butler/>
- Game Accessibility Guidelines — accesibilidad mínima: <https://gameaccessibilityguidelines.com/>
- Godot Docs — exportar proyectos: <https://docs.godotengine.org/en/stable/tutorials/export/index.html>

## ➡️ Siguiente clase

[Clase 287 - Tu portfolio de desarrollador de juegos](../287-tu-portfolio-de-desarrollador-de-juegos/README.md)
