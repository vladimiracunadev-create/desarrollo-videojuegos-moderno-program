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

> Más laboratorios (IA, multijugador) se irán añadiendo siguiendo el [roadmap](../ROADMAP.md).

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
