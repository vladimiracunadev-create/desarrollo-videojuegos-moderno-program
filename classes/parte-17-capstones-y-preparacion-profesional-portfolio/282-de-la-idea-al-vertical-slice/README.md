# Clase 282 — De la idea al vertical slice

> Parte: **17 — Capstones y preparación profesional / portfolio** · Fuente: *Charlas de GDC sobre "vertical slice" y producción indie*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Transformar tu ficha de capstone en un plan de **vertical slice**: una porción pequeña del juego, pero **completa y pulida a nivel final**, que demuestre de qué va la experiencia. No es un prototipo feo que prueba una idea, ni un juego entero a medio hacer; es un trozo representativo listo para enseñar, como una loncha vertical de una tarta que atraviesa todas sus capas.

Al terminar tendrás un **documento de planificación del vertical slice**: qué contenido y sistemas incluye, qué queda fuera, cuál es el "core" a demostrar y qué significa exactamente "pulido" para este proyecto. Este plan es el que ejecutarás en la clase siguiente, así que su claridad determina si terminas o te pierdes.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Definir qué es y qué no es un vertical slice frente a prototipo y demo.
2. Elegir la porción del juego que mejor representa la experiencia completa.
3. Especificar el *core loop* que el slice debe demostrar de principio a fin.
4. Escribir criterios de "pulido" concretos y verificables para el slice.
5. Trazar la ruta prototipo → slice separando lo que se pule de lo que se descarta.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es un vertical slice | Es el entregable estrella de tu portfolio. |
| 2 | Slice vs prototipo vs demo | Cada uno tiene un propósito distinto. |
| 3 | Elegir la porción representativa | Un mal trozo vende mal un gran juego. |
| 4 | El core loop a demostrar | Es el corazón que el slice debe latir. |
| 5 | Definir "pulido" | Sin criterio, "pulido" nunca se termina. |
| 6 | Alcance del slice (dentro/fuera) | Evita que el slice se vuelva el juego entero. |
| 7 | De prototipo a slice | Reusar lo que sirve, tirar lo que estorba. |
| 8 | Criterios de "hecho" | Saber cuándo parar es una habilidad. |

## 📖 Definiciones y características

- **Vertical slice**: una sección del juego terminada al nivel de calidad final. Clave: atraviesa todas las capas (jugabilidad, arte, audio, UI) aunque sea breve.
- **Prototipo**: build rápida y desechable para responder una pregunta de diseño. Clave: se juzga por lo que enseña, no por su acabado.
- **Demo**: versión pública pensada para que otros la jueguen, a menudo derivada del slice. Clave: prioriza *onboarding* y estabilidad.
- **Core loop**: el ciclo de acciones que el jugador repite (actuar → recompensa → progreso → actuar). Clave: el slice existe para demostrarlo entero.
- **Contenido representativo**: el nivel o escenario que mejor captura el tono y la mecánica del juego. Clave: elígelo por lo que comunica, no por lo fácil.
- **Definición de pulido**: lista explícita de qué debe sentirse/verse acabado en el slice. Clave: la escribes tú, no la intuición.
- **Placeholder (marcador)**: arte o audio provisional que ocupa el lugar del final. Clave: en un slice, se sustituye por el definitivo en las zonas visibles.
- **Definition of Done**: condiciones que una tarea debe cumplir para considerarse terminada. Clave: cierra la puerta al pulido infinito.
- **Hito (milestone)**: estado intermedio verificable de la producción del slice. Clave: permite medir avance real sin autoengaño.
- **Alcance del slice**: la frontera explícita entre lo que el slice muestra y lo que deja para después. Clave: sin ella, el slice tiende a crecer hasta ser el juego entero.

## 🧰 Herramientas y preparación

Recupera tu `capstone-ficha.md` de la clase anterior: será la entrada de esta planificación. Trabaja en tu editor de notas habitual y, si te ayuda, abre el motor para inventariar qué prototipos y assets ya tienes reutilizables. No escribas código nuevo todavía: esta clase es de diseño de producción.

Para calibrar el nivel de calidad, juega dos o tres *vertical slices* públicos o demos de itch.io (<https://itch.io/games/demos>) y anota qué te hace pensar "esto está terminado". Referencias sobre el concepto abundan en GDC: busca "vertical slice" en <https://www.youtube.com/user/gdconf>.

## 🧪 Laboratorio guiado

Entregable: un archivo `slice-plan.md` que define tu vertical slice.

1. **Declara el core loop.** Dibújalo como un ciclo de 3-5 pasos. Ej.: *entrar a sala → resolver desafío → obtener recompensa → abrir siguiente sala*. El slice debe permitir recorrer este ciclo al menos una vez completo.

2. **Elige la porción representativa.** Decide qué mostrará el slice: normalmente **un nivel o escenario corto** que contenga el core loop entero. Escribe por qué ese trozo representa el juego mejor que otros.

3. **Escribe el alcance del slice en dos columnas:**

   | Dentro del slice | Fuera del slice |
   |------------------|-----------------|
   | 1 nivel jugable de principio a fin | Resto de niveles |
   | Core loop completo | Sistemas de meta-progresión |
   | Arte final de lo visible | Arte de zonas no mostradas |
   | 1 enemigo/obstáculo pulido | Bestiario completo |
   | Audio de acciones clave | Banda sonora completa |

4. **Define "pulido" para este slice.** Lista 6-8 criterios concretos y verificables. Ejemplos: "el salto tiene *coyote time*", "cada golpe emite sonido y sacudida de pantalla", "las transiciones entre pantallas usan un fundido", "no hay assets de marcador visibles en cámara".

5. **Inventaría el punto de partida.** Marca qué de tus prototipos previos reusas tal cual, qué reharás y qué descartas. Sé honesto: reusar código feo que funciona vale más que reescribir por estética.

6. **Fija tu Definition of Done del slice.** Una frase que, cuando sea cierta, significa que el slice está terminado. Ej.: "un desconocido juega el nivel entero sin bugs y sin marcadores visibles, y sonríe al menos una vez".

7. **Estima a grosso modo** el esfuerzo en días o sesiones. Si supera tu plazo, recorta de la columna "Dentro" hacia "Fuera" hasta que quepa.

8. **Marca los hitos del slice.** Divide la producción en tres estados verificables para poder medir avance sin engañarte:

   | Hito | Qué significa | Cómo lo compruebo |
   |------|---------------|-------------------|
   | Loop gris | Core loop jugable con marcadores | Se recorre el ciclo de principio a fin |
   | Slice vestido | Arte y audio final de lo visible | No hay marcadores en cámara |
   | Slice pulido | Cumple la Definition of Done | Un desconocido lo juega sin fricción |

## ✍️ Ejercicios

1. Redacta tu core loop en una sola frase y luego como diagrama de ciclo.
2. Justifica en tres líneas por qué elegiste esa porción y no otra.
3. Convierte dos criterios vagos de pulido ("que se sienta bien") en criterios verificables.
4. Identifica un asset de tu juego que puede quedarse como marcador fuera de cámara sin dañar el slice.
5. Escribe tu Definition of Done y explícale a un compañero cómo la comprobarías.
6. Compara tu slice planeado con una demo real de itch.io: ¿qué le falta al tuyo para sentirse igual de acabado?
7. Ubica cada elemento de tu juego en uno de los tres hitos (loop gris / vestido / pulido) y comenta cuál será el más costoso.

## 📝 Reto verificable

Entrega `slice-plan.md` y valida su alcance con la **regla de la semana**: si trabajando a tu ritmo real no podrías terminar el slice en el plazo que te queda, recorta hasta que sí. Documenta al menos un recorte que hiciste para lograrlo.

**Criterio de aceptación**: el plan contiene core loop, porción representativa justificada, tabla dentro/fuera con mínimo cuatro filas cada columna, 6-8 criterios de pulido verificables, inventario de reuso y una Definition of Done comprobable; y consta un recorte explícito de alcance.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El slice se convierte en "todo el juego pero peor" | Confundes slice con demo entera. Limita a un nivel/escenario y pule solo eso. |
| No sabes cuándo estará "pulido" | Falta la lista de criterios. Escríbelos verificables antes de producir. |
| Eliges el nivel más fácil de hacer, no el más representativo | El slice vende el juego; elige el trozo que mejor lo comunica. |
| Rehaces prototipos que ya funcionaban | Estética prematura. Reusa lo que funciona y pule solo lo visible. |
| El core loop no se completa en el slice | Recortaste una pieza del ciclo. Asegura que se recorra entero al menos una vez. |
| Nunca sientes que el slice está "terminado" | Falta Definition of Done. Escríbela comprobable y para al cumplirla. |

## ❓ Preguntas frecuentes

**❓ ¿Cuánto debe durar el slice para el jugador?** Suele bastar con 2-5 minutos de juego que recorran el core loop completo con calidad final.

**❓ ¿Puedo usar arte de marcador en el slice?** Sí, pero no en lo que la cámara muestra durante el core loop. Lo visible debe sentirse acabado; lo oculto puede ser marcador.

**❓ ¿El slice es lo mismo que el MVP?** Están emparentados. El MVP es "lo mínimo que ya es jugable"; el vertical slice es "ese mínimo llevado a calidad final". El slice suele ser tu MVP pulido.

**❓ ¿Y si el core loop aún no es divertido?** Entonces el slice no debe empezar. Vuelve al prototipo, itera la mecánica núcleo y solo pásate al slice cuando el loop enganche.

**❓ ¿Cuántos enemigos, objetos o niveles pongo en el slice?** Los mínimos para demostrar el core loop con calidad: a menudo un solo nivel, un obstáculo o enemigo bien resuelto y una recompensa bastan. La variedad se muestra después; el slice demuestra la sensación.

**❓ ¿El slice tiene que incluir menús y pantalla de título?** Solo lo justo para entrar y salir del core loop con dignidad. Un menú mínimo y una pantalla de fin bastan; los menús extensos de opciones pertenecen a la fase de preparación para el público, no al slice.

## 🔗 Referencias

- GDC — charlas sobre vertical slice y producción: <https://www.youtube.com/user/gdconf>
- itch.io — demos para calibrar calidad: <https://itch.io/games/demos>
- Game Maker's Toolkit — sobre core loops y game feel: <https://www.youtube.com/c/MarkBrownGMT>
- Godot Docs — best practices de organización de proyecto: <https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html>

## ➡️ Siguiente clase

[Clase 283 - Construir el vertical slice](../283-construir-el-vertical-slice/README.md)
