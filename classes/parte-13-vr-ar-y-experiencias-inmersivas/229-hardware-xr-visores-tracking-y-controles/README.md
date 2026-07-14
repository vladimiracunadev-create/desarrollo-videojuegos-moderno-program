# Clase 229 — Hardware XR: visores, tracking y controles

> Parte: **13 — VR, AR y experiencias inmersivas** · Fuente: *Khronos OpenXR y documentación de fabricantes (Meta, Valve)*
> ⏱️ Duración estimada: **65 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

El hardware XR no es un detalle de logística: cada característica del visor y de los mandos condiciona lo que puedes diseñar. Un visor **standalone** tiene la GPU de un móvil; uno de **PCVR** aprovecha una tarjeta gráfica de escritorio. Un sistema de **3DoF** no deja al jugador caminar; uno de **6DoF** con tracking *inside-out* sí. La **IPD**, la **tasa de refresco**, el **FOV** y el **passthrough** determinan comodidad, mareo y qué experiencias son realistas.

En esta clase recorres las piezas del rompecabezas: tipos de visores, sistemas de tracking, mandos y sus capacidades, y los parámetros ópticos que afectan al confort. El laboratorio es analítico: elaborarás una tabla de requisitos de hardware para tu experiencia y, para cada requisito, anotarás su implicación de diseño. El objetivo es que nunca prometas una mecánica que el hardware objetivo no puede sostener.

Piensa en el hardware como el conjunto de restricciones que definen el "campo de juego" de tu diseño. Un mismo concepto se implementa de forma muy distinta en un standalone de gama media que en un equipo PCVR de gama alta, y confundir ambos presupuestos es la causa número uno de proyectos XR que se sienten mal o directamente marean. La tabla que construyes aquí es el documento que evita esa confusión.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diferenciar visores standalone y PCVR y sus compromisos de rendimiento.
2. Explicar 3DoF vs 6DoF y el tracking inside-out frente al outside-in.
3. Describir los mandos XR y las entradas que exponen (gatillo, grip, joystick, botones).
4. Relacionar IPD, refresco y FOV con el confort y el mareo.
5. Construir una tabla de requisitos de hardware con implicaciones de diseño.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Standalone vs PCVR | Fija tu presupuesto de GPU y draw calls. |
| 2 | Estéreo y coste doble | Renderizas una imagen por ojo: el frame cuesta el doble. |
| 3 | 3DoF vs 6DoF | Decide si el jugador puede moverse y agacharse. |
| 4 | Tracking inside-out | Cámaras en el visor: sin sensores externos, con límites de oclusión. |
| 5 | Mandos y entradas | Definen qué interacciones (agarre, gatillo) son posibles. |
| 6 | IPD | Ajuste de distancia interpupilar; mal calibrado causa fatiga. |
| 7 | Tasa de refresco | 72/90/120 Hz; a más Hz, menos mareo pero más coste. |
| 8 | FOV | Campo de visión; afecta inmersión y sensación de "buceo". |
| 9 | Passthrough | Cámaras que muestran el mundo real; base de la MR. |

## 📖 Definiciones y características

- **Standalone**: visor autónomo con CPU/GPU integradas (tipo móvil). Clave: portátil y accesible, pero con presupuesto gráfico ajustado.
- **PCVR**: visor conectado a un PC que hace el render. Clave: mucha más potencia, pero requiere cable/streaming y un equipo capaz.
- **3DoF**: tracking solo de rotación (yaw, pitch, roll). Clave: la cabeza gira pero no se desplaza; nada de caminar.
- **6DoF**: tracking de rotación y posición. Clave: el jugador se agacha, se inclina y se mueve por el espacio.
- **Inside-out**: cámaras en el propio visor calculan la posición. Clave: sin sensores externos, pero sensible a poca luz y oclusiones.
- **IPD (Interpupillary Distance)**: distancia entre pupilas; se ajusta al usuario. Clave: mal ajustada produce imagen borrosa y fatiga.
- **Tasa de refresco**: fotogramas por segundo que muestra la pantalla (72/90/120 Hz). Clave: mayor refresco reduce el mareo.
- **FOV (Field of View)**: amplitud angular visible. Clave: un FOV estrecho rompe inmersión y se percibe como mirar por un tubo.
- **Outside-in**: tracking con sensores externos fijos en la habitación. Clave: muy preciso, pero requiere instalación y limita el área de juego.
- **Háptica del mando**: motores de vibración que dan feedback táctil. Clave: confirman agarres y pulsaciones sin depender solo de lo visual.

## 🧰 Herramientas y preparación

No necesitas escribir código en esta clase, pero sí datos reales. Consulta las especificaciones del visor que te interese (por ejemplo, la ficha técnica de Meta Quest o de un visor SteamVR) y la documentación de **OpenXR** para entender qué capacidades expone de forma estándar (<https://www.khronos.org/openxr/>). La página de **XR en Godot** lista qué dispositivos están soportados (<https://docs.godotengine.org/en/stable/tutorials/xr/index.html>).

Prepara una hoja de cálculo o tabla con columnas: *característica de hardware*, *valor mínimo requerido*, *implicación de diseño* y *riesgo si no se cumple*. La llenarás en el laboratorio. Ten también claro tu dispositivo objetivo: no es lo mismo diseñar para un standalone de gama media que para PCVR de gama alta.

Si no tienes un visor concreto en mente, elige uno popular como referencia (un standalone de gama media es una apuesta razonable por volumen de mercado) y trabaja sobre sus especificaciones publicadas. Anota sus cifras reales de refresco, DoF y mandos: esas cifras convertirán la tabla en un documento accionable y no en una lista de deseos.

## 🧪 Laboratorio guiado

Laboratorio **analítico**: derivarás los requisitos de hardware de tu experiencia y sus consecuencias de diseño.

1. Retoma la idea de la clase 228 y su modalidad elegida. Anótala arriba de la tabla.

2. Fila **plataforma**: decide standalone o PCVR. Implicación: si es standalone, fija un presupuesto agresivo (pocos draw calls, materiales simples, iluminación horneada).

3. Fila **DoF**: 3DoF o 6DoF. Implicación: si tu diseño incluye caminar o esquivar, exige 6DoF; si es 3DoF, rediseña a experiencias estacionarias (mirar alrededor, apuntar).

4. Fila **mandos**: enumera las entradas que usarás (gatillo para disparar, grip para agarrar, joystick para girar). Implicación: si el mando objetivo no tiene joystick, tu locomoción no puede depender de él.

5. Fila **refresco**: fija el objetivo (por ejemplo 72 Hz en standalone). Implicación: tu tiempo por frame es ~13,8 ms; todo debe caber ahí.

6. Fila **FOV e IPD**: anota que el usuario debe poder ajustar IPD y que el FOV limita cuánta UI colocas en los bordes. Implicación: coloca lo importante en el centro del campo visual.

7. Fila **passthrough**: márcala solo si tu modalidad es MR. Implicación: confirma que el dispositivo objetivo ofrece passthrough con calidad usable.

8. Revisa la columna *riesgo*: para cada requisito no garantizado, escribe el plan B (por ejemplo, "si no hay 6DoF, deshabilitar movimiento continuo y usar teleport a puntos fijos").

9. Añade una fila **presupuesto gráfico** derivada del refresco: a 72 Hz dispones de ~13,8 ms por frame, y en estéreo renderizas dos veces, así que tu escena real cuesta el doble. Anota un tope orientativo de draw calls y de resolución de texturas para tu plataforma.

10. Cierra con una fila **entorno de prueba**: indica si validarás en visor real, en streaming PCVR o en el simulador de godot-xr-tools, y qué aspecto puede o no comprobarse en cada uno (el confort real solo se juzga con hardware).

Con esta tabla evitas el error más caro en XR: descubrir en la fase de pruebas que el hardware no soporta la mecánica central. La tabla se convierte además en el contrato técnico que compartes con artistas y diseñadores para que sus assets y mecánicas respeten el presupuesto desde el primer día.

Revisa la tabla al final de cada hito del proyecto: a medida que el diseño evoluciona, algún requisito puede endurecerse (más objetos en pantalla, más interacción simultánea) y conviene comprobar que el hardware objetivo sigue siendo suficiente. Una tabla viva vale mucho más que una foto fija hecha una sola vez al principio.

## ✍️ Ejercicios

1. Compara un visor standalone y uno PCVR en potencia, movilidad y coste.
2. Explica con un ejemplo por qué una experiencia de esquivar exige 6DoF.
3. Enumera las entradas típicas de un mando XR y a qué acción de juego asocias cada una.
4. Describe qué le ocurre a la imagen si la IPD está mal ajustada.
5. Justifica por qué 90 Hz es más cómodo que 60 Hz en VR.
6. Diseña el plan B de tu experiencia si el hardware objetivo resulta ser 3DoF.
7. Calcula el tiempo por frame disponible a 72, 90 y 120 Hz y comenta la diferencia.
8. Explica una limitación del tracking inside-out y una situación real donde falle.

## 📝 Reto verificable

Entrega una tabla de requisitos de hardware para tu experiencia con al menos seis filas (plataforma, DoF, mandos, refresco, FOV/IPD, passthrough), cada una con su valor mínimo, su implicación de diseño y un plan de mitigación si el requisito no se cumple.

**Criterio de aceptación**: la tabla contiene seis o más características con valores concretos (incluida una tasa de refresco objetivo y el tiempo por frame asociado), cada fila enlaza a una decisión de diseño explícita, y cada requisito crítico tiene un plan B verificable.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Diseñar movimiento libre para hardware 3DoF | Se prometió desplazamiento sin 6DoF. Verifica DoF y adapta la locomoción. |
| Escena pesada que va a tirones en standalone | Presupuesto gráfico ignorado. Baja draw calls, hornea luces, simplifica materiales. |
| UI en los bordes que el usuario no ve | FOV limitado. Reubica la información al centro del campo visual. |
| Usuarios con fatiga visual | IPD sin ajustar. Recuérdales calibrar la IPD física del visor. |
| Mareo pese a buen diseño | Refresco bajo o inestable. Fija y sostén la tasa de refresco objetivo. |
| Mandos que se pierden al juntar las manos | Oclusión de las cámaras inside-out. Diseña interacciones dentro del campo de visión del visor. |

## ❓ Preguntas frecuentes

**❓ ¿El tracking inside-out necesita sensores en la habitación?** No. Las cámaras van en el visor y calculan la posición del entorno. Su punto débil es la poca luz y que los mandos queden fuera del campo de las cámaras.

**❓ ¿Puedo desarrollar sin visor físico?** Sí para gran parte del curso. Godot ofrece un simulador y puedes validar lógica; el visor es imprescindible solo para juzgar confort real.

**❓ ¿Más FOV siempre es mejor?** Aporta inmersión, pero un FOV muy amplio con render pesado dispara el coste. Es un compromiso con el rendimiento.

**❓ ¿PCVR está muerto frente al standalone?** No. PCVR sigue ofreciendo la máxima calidad gráfica; el standalone gana en accesibilidad y volumen de usuarios. Muchos proyectos publican en ambos.

**❓ ¿Por qué el render en VR cuesta el doble?** Porque dibujas una imagen por ojo (visión estéreo). Aunque hay optimizaciones que comparten trabajo entre ambas vistas, el punto de partida es renderizar la escena dos veces por frame.

## 🔗 Referencias

- Khronos — OpenXR: <https://www.khronos.org/openxr/>
- Godot Docs — XR: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- Meta — Developer resources: <https://developers.meta.com/horizon/>
- Valve — SteamVR: <https://partner.steamgames.com/doc/features/steamvr/openxr>
- Godot Docs — XR performance y optimización: <https://docs.godotengine.org/en/stable/tutorials/xr/index.html>
- godot-xr-tools (simulador para probar sin visor): <https://github.com/GodotVR/godot-xr-tools>

## ➡️ Siguiente clase

[Clase 230 - OpenXR y el estándar abierto](../230-openxr-y-el-estandar-abierto/README.md)
