# Clase 253 — Herramientas nativas de profiling (RenderDoc)

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de RenderDoc y guía de depuración de GPU de Godot 4*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

El profiler interno de Godot te dice *cuánto* tiempo se va en la GPU, pero no *por qué*. Cuando el monitor marca que estás limitado por GPU necesitas abrir el frame y ver qué está dibujando el motor: cuántas draw calls hay, qué texturas y estados usa cada una, y dónde se pinta de más (overdraw). Para eso existe **RenderDoc**, un depurador gráfico gratuito y de código abierto que captura un frame completo y te deja inspeccionarlo llamada por llamada.

En esta clase conectarás RenderDoc a un juego de Godot 4, capturarás un frame y aprenderás a leerlo: el **Event Browser** con la lista de draw calls, el **Texture Viewer** para ver entradas y salidas de cada pasada, y el **Pipeline State** para ver los estados activos. Identificarás overdraw y draw calls redundantes, que son las causas más habituales de un frame caro en GPU. Complementa el profiler del motor con una herramienta nativa que no miente sobre lo que realmente ocurre en la tarjeta.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué aporta un depurador de GPU nativo frente al profiler del motor.
2. Conectar RenderDoc a un ejecutable de Godot y capturar un frame.
3. Navegar el Event Browser para contar y examinar draw calls.
4. Inspeccionar texturas y estados de cada pasada de render.
5. Identificar overdraw y llamadas redundantes como candidatos a optimizar.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Límite CPU vs. GPU | Determina si RenderDoc es la herramienta adecuada. |
| 2 | Qué es una captura de frame | Congela un frame para analizarlo sin prisa. |
| 3 | Event Browser | Lista todas las draw calls y eventos del frame. |
| 4 | Draw calls | Cada una tiene coste; reducirlas ayuda a la CPU y GPU. |
| 5 | Texture Viewer | Ver entradas/salidas revela pasadas y overdraw. |
| 6 | Pipeline State | Muestra shaders, blends y estados activos. |
| 7 | Overdraw | Pintar el mismo píxel muchas veces malgasta fillrate. |
| 8 | Profilers de plataforma | RenderDoc no cubre todo; consolas tienen los suyos. |

## 📖 Definiciones y características

- **Depurador de GPU**: herramienta que intercepta las llamadas gráficas de un frame para inspeccionarlas. Clave: responde al *por qué* del coste, no solo al *cuánto*.
- **Captura de frame**: instantánea de todas las llamadas de render de un único frame. Clave: se analiza offline, sin afectar al tiempo real.
- **Draw call**: orden de dibujo enviada a la GPU. Clave: cada una tiene sobrecoste de CPU; muchas pequeñas son peores que pocas grandes.
- **Event Browser**: panel de RenderDoc con la secuencia de eventos y draw calls. Clave: es el índice para navegar el frame.
- **Texture Viewer**: visor de las texturas de entrada y salida de cada evento. Clave: permite ver qué se dibuja y detectar overdraw.
- **Pipeline State**: estado del pipeline en un evento (shaders, blending, profundidad). Clave: revela configuraciones costosas o innecesarias.
- **Overdraw**: pintar varias veces el mismo píxel en un frame. Clave: transparencias y partículas apiladas lo disparan y gastan fillrate.
- **Profiler de plataforma**: herramienta específica (consolas, GPUs concretas) con acceso a contadores internos. Clave: úsalo cuando RenderDoc no alcanza.
- **Render target**: textura donde la GPU escribe el resultado de una pasada. Clave: verlo en el Texture Viewer revela qué construye cada paso del frame.
- **Pasada de render (pass)**: etapa del frame (opacos, transparencias, sombras, post-proceso). Clave: cada una tiene su coste y su propia lista de draw calls.

## 🧰 Herramientas y preparación

Descarga RenderDoc gratis desde <https://renderdoc.org/>. Funciona en Windows y Linux. Para que Godot sea capturable, exporta o ejecuta el juego con el backend gráfico **Vulkan** (Forward+ o Mobile); RenderDoc soporta Vulkan y OpenGL. Prepara una escena "pesada" con muchos objetos, transparencias o partículas, para que la captura tenga material que analizar. Ten también abierto el panel de **Monitores** de Godot para confirmar primero si estás limitado por GPU antes de capturar.

Documentación de apoyo: guía de RenderDoc en <https://renderdoc.org/docs/> y depuración/optimización de GPU en Godot en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>. RenderDoc no captura el editor: hazlo sobre el juego en ejecución (F5) o sobre el ejecutable exportado.

## 🧪 Laboratorio guiado

Capturaremos un frame de un juego Godot con RenderDoc, contaremos las draw calls y buscaremos overdraw. Los pasos alternan el editor de Godot y la interfaz de RenderDoc.

1. Primero confirma en Godot que el problema es de GPU, no de CPU. Añade este script de diagnóstico a la escena y ejecútalo:

```gdscript
extends Node

func _process(_delta: float) -> void:
	# Tiempo de CPU por frame (en ms) para compararlo con el coste de GPU.
	var cpu_ms := Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	# Contadores utiles para el analisis previo a RenderDoc:
	var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var primitivas := Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	print("CPU: %.2f ms | Draw calls: %d | Primitivas: %d" % [cpu_ms, draw_calls, primitivas])
```

2. Observa la cifra de **draw calls** en consola. Si es alta (cientos o miles) y el tiempo de GPU domina el frame, tienes un buen caso para RenderDoc. Anota el número: será tu línea base.

3. Prepara Godot para exportar/ejecutar con Vulkan. Verifica en **Proyecto → Ajustes → Rendering → Renderer** que el método sea Forward+ o Mobile (ambos usan Vulkan). Exporta un ejecutable de escritorio, o localiza el binario de Godot que corre tu proyecto.

4. Abre RenderDoc. En la pestaña **Launch Application**, en *Executable Path* apunta al ejecutable del juego (o al binario de Godot con tu proyecto como argumento en *Command-line Arguments*). Pulsa **Launch**. El juego arranca con la superposición de RenderDoc visible ("overlay").

5. Con el juego corriendo, sitúate en la escena pesada y pulsa **F12** (o **Print Screen**), la tecla de captura de RenderDoc. Verás en el overlay que se guardó una captura. Cierra el juego para volver a RenderDoc.

6. Abre la captura (aparece como miniatura). Ve al **Event Browser**: es la lista completa de eventos del frame. Cuenta cuántas draw calls (entradas tipo *Draw* / *DrawIndexed*) hay y compáralo con la cifra que anotaste desde Godot. Localiza grupos de llamadas repetidas: candidatos a agrupar por batching o instancing.

7. Selecciona una draw call y abre el **Texture Viewer**. A la izquierda ves las texturas de entrada (los materiales) y a la derecha el render target de salida. Recorre varias draw calls de la pasada de transparencias: si muchas escriben sobre la misma zona de pantalla, tienes **overdraw**. Activa la visualización de "quad overdraw" si tu versión la ofrece para verlo como mapa de calor.

8. Abre el **Pipeline State** de una draw call cara. Revisa si tiene *blending* activado (transparencia), qué shader usa y si el test de profundidad está bien configurado. Una pasada opaca con blending innecesario, o partículas grandes muy solapadas, son las causas típicas del overdraw que acabas de ver. Con esta evidencia ya puedes volver a Godot y optimizar con criterio: reducir partículas, recortar transparencias solapadas o combinar mallas para bajar draw calls. Recaptura tras cada cambio y compara.

9. Cierra el ciclo correlacionando lo visto en RenderDoc con los monitores de Godot en tiempo real. Muestra las draw calls en pantalla para verificar cada optimización sin recapturar cada vez:

```gdscript
extends Label

func _process(_delta: float) -> void:
	# Espejo en vivo de lo que RenderDoc mostro en el Event Browser.
	var draws := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var prims := Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	text = "Draw calls: %d\nPrimitivas: %d\nFPS: %d" % [
		draws, prims, Engine.get_frames_per_second()]
```

Cuando el número de draw calls del Label baje tras combinar mallas o usar `MultiMesh`, sabrás que la optimización que RenderDoc te sugirió funcionó, y solo entonces vale la pena hacer una nueva captura para confirmar el resto del frame.

## ✍️ Ejercicios

1. Captura un frame antes y después de activar el batching/instancing de un grupo de objetos y compara el número de draw calls en el Event Browser.
2. Añade un sistema de partículas grande y transparente, captura y localiza el overdraw en el Texture Viewer.
3. Usa `Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)` para mostrar las draw calls en pantalla en tiempo real y correlaciónalas con la captura.
4. Identifica en el Pipeline State qué draw calls usan blending y decide cuáles podrían ser opacas.
5. Captura el frame de una escena con muchas luces con sombra y observa cuántas pasadas de sombra genera cada una.
6. Documenta con capturas de pantalla de RenderDoc un antes/después de una optimización concreta.

## 📝 Reto verificable

Toma una escena que esté limitada por GPU, captura un frame con RenderDoc y produce un pequeño informe: número de draw calls, la draw call o pasada más cara identificada, evidencia de overdraw (con la vista del Texture Viewer) y una hipótesis de optimización. Aplica el cambio en Godot, recaptura y compara las draw calls y el tiempo de frame antes y después.

**Criterio de aceptación**: el informe incluye el conteo de draw calls medido tanto en Godot (`RENDER_TOTAL_DRAW_CALLS_IN_FRAME`) como en el Event Browser de RenderDoc, señala una fuente concreta de overdraw o de llamadas redundantes con captura, y demuestra con una segunda captura que la optimización redujo draw calls o el tiempo de GPU de forma medible.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| RenderDoc no captura nada | El juego usa un backend no soportado. Ejecuta con Vulkan (Forward+/Mobile), no con un modo incompatible. |
| Intentas capturar el editor | RenderDoc captura el juego, no el editor. Lanza el ejecutable o el proyecto con F5 bajo RenderDoc. |
| Optimizas sin haber medido CPU vs. GPU | Si el cuello era CPU, RenderDoc no ayuda. Confirma con Monitores antes de capturar. |
| El conteo de draw calls no cuadra con Godot | RenderDoc muestra todas las pasadas (sombras, post) que Godot agrega. Es esperable; compara tendencias. |
| No encuentras el overdraw | No estás en la pasada de transparencias. Filtra los eventos de blending en el Event Browser. |
| La captura es enorme y lenta | Capturaste una escena con demasiada geometría. Aísla el caso mínimo que reproduce el problema. |

## ❓ Preguntas frecuentes

**❓ ¿RenderDoc reemplaza al profiler de Godot?** No, lo complementa. El profiler del motor te dice *cuándo* mirar (estás limitado por GPU); RenderDoc te dice *qué* está pasando dentro de ese frame.

**❓ ¿Necesito Vulkan sí o sí?** RenderDoc soporta Vulkan y OpenGL. En Godot 4, Forward+ y Mobile usan Vulkan, que es la ruta mejor soportada para capturar.

**❓ ¿Puedo usar RenderDoc en consolas?** No; cada consola tiene su propio profiler nativo bajo NDA. RenderDoc cubre PC (Windows/Linux). Para consola usa las herramientas del fabricante.

**❓ ¿Qué busco primero en una captura?** Cuenta draw calls (¿demasiadas y pequeñas?) y busca overdraw en la pasada de transparencias. Son las dos causas más frecuentes de un frame caro en GPU.

## 🔗 Referencias

- RenderDoc — sitio oficial y descarga: <https://renderdoc.org/>
- RenderDoc — documentación: <https://renderdoc.org/docs/>
- Godot Docs — Performance y optimización de GPU: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — clase Performance (monitores): <https://docs.godotengine.org/en/stable/classes/class_performance.html>

## ➡️ Siguiente clase

[Clase 254 - Capstone Parte 14: optimizar un proyecto a 60 fps](../254-capstone-parte-14-optimizar-un-proyecto-a-60-fps/README.md)
