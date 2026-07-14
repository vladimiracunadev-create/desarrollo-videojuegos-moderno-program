# Clase 284 — Pulido, game feel y el último 10%

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Jan Willem Nijman (Vlambeer), "The Art of Screenshake" (charla)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Dedicar el esfuerzo al "último 10%" que separa un proyecto de estudiante de un juego que se siente profesional. Ese 10% suele costar el 90% de la percepción de calidad: es el *game feel* (el jugo o *juice*), el remate audiovisual, las transiciones y el pulido de la interfaz. También aprenderás lo contrario, igual de importante: **cuándo parar**, porque el pulido no tiene fondo y puede tragarse tu plazo.

Al terminar tendrás una **checklist de pulido** aplicada a tu slice, con las mejoras priorizadas por impacto/coste, y habrás implementado al menos las de mayor retorno. El objetivo no es pulirlo todo, sino elegir los pocos toques que hacen que el juego "cobre vida".

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es el *game feel* y cómo el *juice* refuerza cada acción del jugador.
2. Aplicar técnicas de pulido de alto impacto (feedback, transiciones, audio, UI).
3. Priorizar mejoras por relación impacto/esfuerzo en lugar de por gusto.
4. Reconocer cuándo el pulido deja de rendir y decidir parar.
5. Auditar su slice con una checklist de pulido y ejecutar los cambios elegidos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El último 10% | Es donde se percibe la calidad profesional. |
| 2 | Game feel y juice | Hace que cada acción se sienta satisfactoria. |
| 3 | Feedback multisensorial | El jugador entiende el juego sin leer. |
| 4 | Transiciones y remate | Une las partes y evita cortes bruscos. |
| 5 | Pulido de audio | El sonido vende impacto y presencia. |
| 6 | Pulido de UI | Una interfaz clara transmite cuidado. |
| 7 | Priorizar por impacto/coste | El tiempo es finito; el pulido, infinito. |
| 8 | Cuándo parar | Saber terminar es parte del oficio. |

## 📖 Definiciones y características

- **Game feel**: la sensación táctil de controlar el juego, más allá de sus reglas. Clave: se construye con respuesta inmediata y refuerzo a cada input.
- **Juice**: capa de efectos que amplifica acciones sin cambiar la mecánica (partículas, sacudidas, sonidos). Clave: mucho refuerzo por poco código.
- **Screenshake**: sacudida breve de cámara al impactar o golpear. Clave: usada con mesura da peso; en exceso marea.
- **Feedback**: toda respuesta del juego a una acción (visual, sonora, háptica). Clave: cada input debería producir una reacción perceptible.
- **Tweening / easing**: interpolar valores con curvas suaves en vez de saltos. Clave: convierte movimientos mecánicos en agradables.
- **Transición**: puente visual entre estados o pantallas (fundidos, wipes). Clave: elimina cortes secos que rompen la inmersión.
- **Feedback anticipatorio**: pistas que preceden a una acción (parpadeo antes de un ataque). Clave: hace el juego legible y justo.
- **Ley de rendimientos decrecientes del pulido**: cada hora extra de pulido aporta menos que la anterior. Clave: identifica el punto donde conviene parar.

## 🧰 Herramientas y preparación

Trabajas sobre el slice que produjiste. Ten a mano tu motor y los recursos de partes anteriores sobre *tweening*, partículas, cámara y audio: la mayoría del *juice* se logra combinando técnicas que ya conoces. Para sonidos rápidos de marcador-a-final, [jsfxr/sfxr](https://sfxr.me/) genera efectos retro al instante y libres.

La referencia canónica es la charla de Vlambeer **"The Art of Screenshake"**: búscala en <https://www.youtube.com/user/gdconf>. Complementa con el libro *Game Feel* de Steve Swink para el marco conceptual. Antes de tocar nada, graba un clip de tu slice "antes" para comparar el impacto del pulido después.

## 🧪 Laboratorio guiado

Entregable: una **checklist de pulido priorizada** (`pulido-checklist.md`) y el slice con las mejoras top implementadas.

1. **Audita tu slice con esta checklist.** Marca el estado actual de cada ítem (✓ / ✗ / parcial):

   ```text
   FEEDBACK
   [ ] cada acción del jugador emite sonido
   [ ] los impactos tienen efecto visual (partícula/flash)
   [ ] hay screenshake sutil en golpes/muertes
   [ ] el objetivo/victoria se comunica con claridad
   JUICE
   [ ] elementos aparecen/desaparecen con easing, no de golpe
   [ ] hay anticipación antes de acciones importantes
   [ ] recompensas destacan (color, escala, sonido)
   TRANSICIONES
   [ ] fundido al iniciar y terminar el nivel
   [ ] cambios de estado sin cortes secos
   AUDIO
   [ ] sonido ambiente o música de fondo
   [ ] volúmenes equilibrados (nada satura)
   UI
   [ ] textos legibles y alineados
   [ ] estados claros (menú, pausa, fin) 
   [ ] no hay assets de marcador visibles en cámara
   ```

2. **Prioriza por impacto/coste.** Pasa cada ítem pendiente a una tabla y puntúa impacto (1-3) y coste (1-3). Ordena por impacto/coste descendente:

   | Mejora | Impacto | Coste | Ratio | ¿Hago? |
   |--------|---------|-------|-------|--------|
   | Sonido de golpe | 3 | 1 | 3.0 | Sí |
   | Screenshake | 3 | 1 | 3.0 | Sí |
   | Partículas de muerte | 2 | 2 | 1.0 | Quizá |

3. **Ejecuta el top.** Implementa las mejoras de mayor ratio primero. Suelen ser baratísimas y muy visibles: sonido a cada acción, un flash blanco al impactar, un *screenshake* leve, un fundido de entrada/salida.

4. **Aplica la regla del "un toque más".** Añade a cada acción clave *dos* refuerzos de sentidos distintos (p. ej. golpe = sonido + partícula + micro-pausa). Combinar canales multiplica la sensación.

5. **Revisa el exceso.** Baja cualquier efecto que maree o distraiga (screenshake fuerte, demasiadas partículas). El pulido bueno se nota sin gritar.

6. **Graba el "después"** y compáralo con el "antes". Si el salto de sensación es evidente, vas bien.

7. **Decide dónde parar.** Marca en tu checklist la línea a partir de la cual las mejoras restantes tienen ratio bajo. Deja esas fuera del slice y anótalas como "futuro". Terminar en un buen punto es el objetivo.

## ✍️ Ejercicios

1. Elige una acción del juego y añádele tres refuerzos de sentidos distintos; describe el efecto.
2. Implementa un *screenshake* parametrizable y encuentra por prueba el valor que da peso sin marear.
3. Sustituye un cambio de pantalla brusco por una transición con fundido.
4. Añade anticipación (parpadeo/sonido) a una acción importante y comenta si mejora la legibilidad.
5. Reordena tu tabla impacto/coste y justifica qué dejarías fuera si te quedara media jornada.
6. Compara tu clip "antes/después" y anota los tres cambios que más aportaron.

## 📝 Reto verificable

Aplica las mejoras de mayor ratio de tu checklist al slice y entrega dos clips ("antes" y "después") junto al `pulido-checklist.md` con las prioridades marcadas y la línea de "hasta aquí pulo".

**Criterio de aceptación**: en el clip "después", cada acción principal del jugador produce feedback perceptible (sonido + efecto visual), existe al menos una transición suave entre estados, no hay assets de marcador visibles en cámara, y la checklist documenta qué mejoras se hicieron y cuáles se dejaron fuera con criterio de impacto/coste.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El juego se siente "muerto" pese a funcionar | Falta feedback. Añade sonido y efecto visual a cada acción del jugador. |
| El screenshake marea o distrae | Intensidad o duración excesivas. Bájalas hasta que se sienta sin llamar la atención. |
| Pules detalles que nadie nota y no terminas | Ignoras impacto/coste. Prioriza por ratio y para en los de ratio bajo. |
| Transiciones bruscas rompen la inmersión | No hay fundidos entre estados. Añade transiciones cortas de entrada/salida. |
| Efectos preciosos pero el juego va a tirones | Exceso de partículas/efectos. Reduce cantidad y respeta el rendimiento. |

## ❓ Preguntas frecuentes

**❓ ¿El juice no es solo "maquillaje"?** No: el feedback comunica reglas y refuerza el aprendizaje del jugador. Un buen *juice* hace el juego más legible y satisfactorio, no solo más bonito.

**❓ ¿Cuándo sé que debo parar de pulir?** Cuando las mejoras restantes tienen ratio impacto/coste bajo y tu plazo aprieta. Marca esa línea por escrito y respétala.

**❓ ¿Puedo pulir con arte de marcador?** El *game feel* por código (screenshake, easing, timing) funciona incluso con marcadores. Pero en el slice lo visible debe estar en arte final; combina ambas cosas.

**❓ ¿Cuánto sonido es suficiente?** Al menos un sonido por acción del jugador y por evento importante (impacto, recompensa, victoria/derrota), más un fondo. El silencio total lee como "sin terminar".

## 🔗 Referencias

- Vlambeer — "The Art of Screenshake" (GDC): <https://www.youtube.com/user/gdconf>
- Steve Swink — *Game Feel* (libro): <http://www.game-feel.com/>
- sfxr / jsfxr — generador de efectos de sonido: <https://sfxr.me/>
- Game Maker's Toolkit — game feel y secretos de diseño: <https://www.youtube.com/c/MarkBrownGMT>

## ➡️ Siguiente clase

[Clase 285 - Playtesting formal y iteración con datos](../285-playtesting-formal-y-iteracion-con-datos/README.md)
