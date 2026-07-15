# 🧪 Laboratorios ejecutables

> [⬅️ Volver al programa](../README.md) · [📚 Índice de clases](../classes/README.md)

Las clases explican **cómo** se hace; estos laboratorios son proyectos **reales que se abren y se juegan**. Cada uno viene en dos versiones:

- **`inicio/`** — proyecto de partida: assets, escenas e infraestructura listas, con los scripts de gameplay marcados con `TODO`. Es donde trabajas tú.
- **`solucion/`** — implementación de referencia completa y jugable. Compárala cuando te atasques (o cuando termines).

Ambas versiones se **verifican en CI con Godot headless** en cada push: se importan, compilan y arrancan. Si el badge está verde, el código de estos labs funciona de verdad.

[![Labs (Godot)](https://github.com/vladimiracunadev-create/modern-gamedev-program/actions/workflows/labs.yml/badge.svg?branch=main)](https://github.com/vladimiracunadev-create/modern-gamedev-program/actions/workflows/labs.yml)

## 📦 Laboratorios disponibles

| Lab | Parte | Qué construyes |
|---|---|---|
| [**Plataformas 2D**](plataformas-2d/README.md) | [Parte 1](../classes/parte-1-motores-2d-y-tu-primer-juego-jugable/README.md) (clases 026–045) | Un plataformas completo: controlador con game feel, monedas, enemigos, HUD, audio y récord persistente. |
| [**3D en tercera persona**](3d-tercera-persona/README.md) | [Parte 2](../classes/parte-2-desarrollo-3d-motores-escenas-y-transformaciones/README.md) (clases 046–067) | Un nivel 3D explorable: control relativo a la cámara, cámara orbital con `SpringArm3D`, cristales y portal de salida. |
| [**Shaders**](shaders/README.md) | [Parte 4](../classes/parte-4-graficos-shaders-y-rendering-moderno/README.md) (clases 086–107) | Una galería de siete shaders con sus uniforms editables en vivo: UV, ondas, disolución, contorno, agua, cel shading y post-procesado CRT. |
| [**Multijugador**](multijugador/README.md) | [Parte 7](../classes/parte-7-multijugador-y-networking/README.md) (clases 138–155) | Una arena en red con servidor autoritativo: predicción, reconciliación, interpolación de remotos y validación anti-cheat, sobre ENet puro. |
| [**IA de enemigos**](ia-enemigo/README.md) | [Parte 5](../classes/parte-5-inteligencia-artificial-para-juegos/README.md) (clases 108–125) | Un enemigo con behavior tree, cono de visión, memoria y pathfinding A\*: patrulla, te ve, te persigue, te pierde y va a buscarte. |
| [**UI accesible**](ui-accesible/README.md) | [Parte 10](../classes/parte-10-ui-ux-accesibilidad-y-localizacion/README.md) (clases 188–199) | Menú, HUD y opciones que cambian de idioma en marcha, aguantan el texto al 200 % y se navegan enteros con el teclado. |

## 🎯 Por qué hay seis labs y no dieciocho

Porque un laboratorio solo tiene sentido cuando la parte **termina en algo que se ejecuta**, y no todas terminan en eso — ni deberían.

- **Las partes de programación** (2D, 3D, shaders, IA, multijugador, UI) terminan en un proyecto que corre. Ahí un lab es lo natural, y lo tienen.
- **Las partes de arte, game design, producción y carrera** terminan en un entregable que no es un ejecutable: un set de assets coherente, un documento de diseño, un presupuesto, un portfolio. Meterlas a la fuerza en un `project.godot` no enseñaría nada — su reto verificable está en la propia clase, y ahí se queda.
- **Las que dependen de hardware o de servicios** (VR/AR, móvil y consolas, backends) no se pueden verificar en un servidor de CI sin visor, sin teléfono y sin cuenta. Prometer un lab verificado ahí sería mentir.

Y hay un tercer caso, más sutil: **partes cuyo reto no se puede verificar aunque el código corra**. El capstone de **audio** (Parte 6) pide un *"ducking audible"*, que los sonidos *"suenen distintos"* y que una transición no tenga *"corte perceptible"*: cuatro de sus ocho criterios son juicios de oído, el driver headless no mezcla y `AudioStreamRandomizer` no dice qué eligió. Un lab de audio en CI verificaría que existe un bus llamado "Musica" — la contabilidad del sistema, no el sistema. **La CI es sorda**, y prometer un badge verde sobre audio adaptativo sería justo lo que aquí no se hace. Lo mismo con el capstone de **física** (Parte 3), cuyo criterio incluye un playtest humano.

Las que faltan y sí tendrían sentido —**física** (Parte 3, con integradores propios en vez del solver), **audio** (Parte 6, la parte estructural) y **tooling** (Parte 15)— están en el [roadmap](../ROADMAP.md).

## 🔍 Qué garantiza el badge (y qué no)

Conviene ser exacto, porque es la diferencia entre "está escrito" y "funciona":

- **Los seis laboratorios se ejecutan en CI** en cada push: se importan, se arrancan con Godot headless y se les exige una prueba positiva — que el nivel se construya, que los shaders compilen, que la red conecte, que la IA decida, que la UI no se recorte. Si el badge está verde, **este código funciona**.
- **El código dentro de los README de clase no se ejecuta en CI.** Está escrito y revisado a mano, y es material de lectura: fragmentos que ilustran una idea, muchos de ellos trozos de un archivo mayor. No son proyectos que se abran.

Dicho de otra forma: el badge cubre los labs, no las 292 clases. Preferimos decirlo a que te lo encuentres.

## 🚀 Cómo usarlos

1. Instala **Godot 4.3** o superior desde <https://godotengine.org/download> (no necesitas nada más: ni plugins, ni cuentas, ni assets de pago).
2. Abre el **Project Manager** de Godot → *Import* → elige el `project.godot` del lab (por ejemplo `labs/plataformas-2d/inicio/project.godot`).
3. Pulsa **F5** para ejecutar.

> **Nota sobre Git LFS.** Los assets binarios (`.png`, `.wav`) se versionan con [Git LFS](https://git-lfs.com/) — justamente lo que enseña la [clase 015](../classes/parte-0-fundamentos-y-prerrequisitos/015-git-y-control-de-versiones-para-proyectos-de-juegos-con-lfs/README.md). Si al clonar ves archivos de texto raros en lugar de imágenes, instala LFS y ejecuta `git lfs pull`.

## 🎨 Sobre los assets

Todos los assets (sprites, texturas y sonidos) son **obra original generada por código** con [`scripts/generar_assets.py`](../scripts/generar_assets.py) y están en **dominio público (CC0)**: puedes usarlos para lo que quieras, sin atribución y sin arrastrar licencias de terceros.

Cada lab declara ahí qué assets necesita, y hay bastante menos de lo que parece: el lab 3D no trae ni una malla (todo son primitivas de Godot montadas por código) y el de shaders solo necesita dos texturas.

¿Quieres cambiarlos? Edita el generador y vuelve a ejecutarlo:

```bash
python -m pip install pillow
python scripts/generar_assets.py            # todos los labs
python scripts/generar_assets.py shaders    # solo uno
```

La CI comprueba que el generador es **determinista** (que regenerar produce exactamente los assets versionados, en los dos proyectos de cada lab).
