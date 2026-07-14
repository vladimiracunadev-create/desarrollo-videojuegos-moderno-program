# Clase 213 — Capstone Parte 11: exportar y pulir para una plataforma

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Síntesis de las clases 207–212 y documentación de exportación de Godot 4*
> ⏱️ Duración estimada: **110 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Integrar todo lo aprendido en la Parte 11 en un proyecto real: **elegir una plataforma objetivo** (por ejemplo, **Android** o **Steam Deck**) y llevar un juego de Godot 4 hasta un **build pulido y publicable**. Esto significa exportar correctamente, **adaptar input, UI y rendimiento** a esa plataforma, y superar su **checklist** propia (la de tiendas móviles de la clase 208 o la de Steam Deck Verified de la clase 212).

Este capstone no introduce API nueva: consolida. Trabajarás con una **especificación**, una **checklist de la plataforma** y una **definition of done** clara, de modo que al final tengas un artefacto real (un AAB firmado o un build jugable a 1280×800 con controles por defecto) que podrías subir a la tienda. Al terminar habrás recorrido, de principio a fin, el camino de "proyecto en el editor" a "build listo para publicar".

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Elegir de forma justificada una plataforma objetivo y su checklist correspondiente.
2. Exportar un build correcto y firmado/empaquetado para esa plataforma desde Godot 4.
3. Adaptar input, UI y rendimiento a las restricciones de la plataforma elegida.
4. Aplicar una definition of done y auto-evaluar el build contra la checklist.
5. Documentar el proceso en una especificación reproducible por otra persona.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Elección de plataforma objetivo | Cada plataforma impone restricciones distintas. |
| 2 | Especificación del entregable | Define qué es "terminado" antes de empezar. |
| 3 | Export correcto | Un preset mal configurado invalida el build. |
| 4 | Adaptación de input | Gamepad/táctil/teclado según la plataforma. |
| 5 | Adaptación de UI | Resolución, legibilidad y anclas. |
| 6 | Rendimiento | El objetivo puede ser hardware modesto. |
| 7 | Checklist de plataforma | Requisitos concretos que hay que cumplir. |
| 8 | Definition of done | Cierra el proyecto con criterios objetivos. |

## 📖 Definiciones y características

- **Capstone**: proyecto integrador que reúne las competencias de la parte. Clave: produce un entregable real, no un ejercicio aislado.
- **Plataforma objetivo**: la única plataforma para la que se pule el build (Android o Steam Deck aquí). Clave: enfocar evita dispersión.
- **Especificación**: documento que fija alcance, requisitos y criterios de aceptación. Clave: es el contrato del entregable.
- **Preset de export**: configuración de Godot para generar el build (formato, firma, iconos). Clave: determina si el paquete es válido.
- **Adaptación de input**: ajustar controles al dispositivo (táctil, gamepad, teclado). Clave: jugabilidad correcta en el destino.
- **Adaptación de UI**: resolución, escalado y legibilidad para la pantalla objetivo. Clave: evita recortes y texto ilegible.
- **Checklist de plataforma**: lista de requisitos de la tienda o del sello. Clave: guía objetiva de qué falta.
- **Definition of done (DoD)**: criterios que declaran el trabajo terminado. Clave: cierra el proyecto sin ambigüedad.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y un juego propio de partes anteriores (o uno sencillo). Según la plataforma: para **Android**, el SDK/JDK configurados y un **keystore de release** (clase 208); para **Steam Deck**, la capacidad de probar a **1280×800** y, opcionalmente, **GodotSteam** (clase 212). Reutiliza los autoloads de glifos, guardado y certificación de las clases 211 y 210.

Prepara una carpeta `entrega/` con tres documentos: `especificacion.md`, `checklist.md` y `definition_of_done.md`. Documentación clave: exportación en Godot <https://docs.godotengine.org/en/stable/tutorials/export/index.html>.

## 🧪 Laboratorio guiado

Llevaremos el juego a un build pulido para la plataforma elegida. El ejemplo usa **Steam Deck**; si eliges Android, sustituye los pasos de export por los de la clase 208.

1. **Escribe la especificación** (`entrega/especificacion.md`): plataforma objetivo, resolución/orientación, esquema de control, requisitos de UI y objetivo de rendimiento.

2. **Copia la checklist de la plataforma** (`entrega/checklist.md`). Para Steam Deck, la de la clase 212 (entrada, legibilidad, compatibilidad, rendimiento); para Android, la de publicación de la clase 208.

3. **Define la Definition of Done** (`entrega/definition_of_done.md`):

```text
[ ] El build exporta sin errores ni advertencias críticas
[ ] Se juega completo con el input principal de la plataforma
[ ] Toda la UI es legible y no se recorta en la resolución objetivo
[ ] Framerate estable en el objetivo de rendimiento
[ ] La checklist de la plataforma está 100% marcada
[ ] La especificación permite reproducir el build a otra persona
```

4. **Adapta el input** con un detector central que fije el esquema al arrancar y en caliente:

```gdscript
extends Node

# Selecciona el esquema de control según lo que hay disponible.
enum Esquema { TECLADO_RATON, GAMEPAD, TACTIL }
var esquema: Esquema = Esquema.TECLADO_RATON

func _ready() -> void:
	if DisplayServer.is_touchscreen_available():
		esquema = Esquema.TACTIL
	elif not Input.get_connected_joypads().is_empty():
		esquema = Esquema.GAMEPAD
	Input.joy_connection_changed.connect(func(_id, con):
		if con: esquema = Esquema.GAMEPAD)
```

5. **Adapta la UI**: fija la resolución base y el estiramiento en Project Settings (1280×800, `canvas_items`, `keep`), y garantiza tamaños de fuente legibles con un `Theme`. Recorre todos los menús buscando recortes.

6. **Revisa el rendimiento**: abre el **Monitor** (Debugger → Monitors) mientras juegas y vigila FPS y tiempo de frame. Reduce coste donde haga falta (menos partículas, texturas más ligeras).

7. **Exporta el build**. Para Steam Deck, exporta un build de **Windows** (corre bajo Proton) o **Linux**; para Android, exporta el **AAB firmado** con el keystore de release:

```bash
# Export headless por línea de comandos (útil para CI). Ajusta el nombre del preset.
godot --headless --export-release "Windows Desktop" build/juego.exe
```

8. **Auto-evalúa**: juega el build final en la resolución/dispositivo objetivo y marca cada ítem de la checklist y de la DoD. Corrige lo pendiente e itera hasta cerrar todos los criterios.

Con los tres documentos completos y el build superando la checklist, tienes un entregable publicable para tu plataforma objetivo.

## ✍️ Ejercicios

1. Repite el capstone para una **segunda** plataforma y compara qué cambió en export, input y UI.
2. Añade a la especificación una sección de "requisitos mínimos" del dispositivo objetivo.
3. Automatiza el export con un pequeño script `bash` que genere el build en un solo comando.
4. Integra un logro real (GodotSteam en Deck, o PGS en Android) y márcalo en la checklist.
5. Mide FPS antes y después de tus optimizaciones y documenta la mejora.
6. Pide a un compañero que reproduzca tu build siguiendo solo tu especificación y anota qué faltó.

## 📝 Reto verificable

Entrega un **build pulido y publicable** de tu juego para una plataforma objetivo (Android o Steam Deck), acompañado de los tres documentos: **especificación**, **checklist de la plataforma** (100% marcada) y **definition of done** cumplida. El build debe exportar sin errores, jugarse completo con el input principal de la plataforma, tener UI legible sin recortes y rendimiento estable.

**Criterio de aceptación**: el build se genera correctamente (AAB firmado para Android, o ejecutable jugable a 1280×800 para Steam Deck), se completa una partida con el input propio de la plataforma sin recortes de UI, y las tres piezas de documentación están completas y son coherentes con el build entregado.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El export falla o genera un build inválido | Preset mal configurado (firma, formato, plantillas). Revisa el preset de la plataforma. |
| El juego no se controla bien en el destino | No adaptaste el input al dispositivo. Usa el detector de esquema y acciones. |
| La UI se recorta en la resolución objetivo | Layout fijo. Usa contenedores, anclas y Stretch Mode adecuado. |
| Caídas de framerate en hardware modesto | Coste gráfico alto. Perfila con Monitors y reduce carga. |
| Nadie puede reproducir tu build | La especificación es incompleta. Documenta versión, preset y pasos exactos. |

## ❓ Preguntas frecuentes

**❓ ¿Debo pulir para varias plataformas a la vez?** No en este capstone. Elige una y llévala hasta el final; enfocar produce un entregable de mayor calidad.

**❓ ¿Vale un build de Windows para Steam Deck?** Sí: la Deck ejecuta juegos de Windows bajo Proton. También puedes exportar Linux nativo. Prueba a 1280×800.

**❓ ¿Qué diferencia una especificación de una checklist?** La especificación describe qué construyes y por qué; la checklist enumera requisitos concretos que verificar. La DoD declara cuándo está terminado.

**❓ ¿Puedo usar CI para exportar?** Sí. `godot --headless --export-release "<preset>" <salida>` permite generar el build sin abrir el editor, ideal para automatizar.

## 🔗 Referencias

- Godot Docs — Exporting projects: <https://docs.godotengine.org/en/stable/tutorials/export/index.html>
- Godot Docs — Exporting from the command line: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html#exporting-from-the-command-line>
- Godot Docs — Multiple resolutions: <https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html>
- Godot Docs — The Profiler / Monitors: <https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html>

## ➡️ Siguiente clase

[Clase 214 - El navegador como plataforma de juegos](../../parte-12-juegos-web-y-html5/214-el-navegador-como-plataforma-de-juegos/README.md)
