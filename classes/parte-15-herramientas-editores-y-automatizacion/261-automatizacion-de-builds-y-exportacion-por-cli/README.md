# Clase 261 — Automatización de builds y exportación por CLI

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (Exporting from the command line / Command line tutorial)*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Exportar un juego no debería exigir abrir el editor, hacer clic en menús y esperar. En esta clase aprendemos a **construir builds desde la línea de comandos** con `godot --headless`, de modo que una sola orden produzca el ejecutable final de forma reproducible. Esta es la pieza que después conectaremos a integración continua: si el build se automatiza, cualquier máquina —tu portátil o un runner en la nube— puede generarlo igual.

Trabajaremos con los **presets de exportación** (`export_presets.cfg`), con la diferencia entre `--export-release`, `--export-debug` y `--export-pack`, y con el papel de las **plantillas de exportación**. Terminaremos escribiendo un **script de build en bash** que versiona la salida y genera artefactos para varias plataformas en un solo paso, incrustando el número de versión en el nombre de archivo para que nunca confundas dos builds.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Exportar un proyecto de Godot 4 sin abrir el editor usando `godot --headless --export-release "Preset" salida`.
2. Explicar la diferencia entre `--export-release`, `--export-debug` y `--export-pack` y cuándo usar cada uno.
3. Configurar presets reutilizables en `export_presets.cfg` y referenciarlos por nombre desde la CLI.
4. Instalar las plantillas de exportación necesarias y diagnosticar el error de "no export template found".
5. Escribir un script bash que genere builds versionados para varias plataformas y falle limpiamente si algo va mal.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | El modo `--headless` | Ejecuta Godot sin ventana ni GPU, ideal para servidores y scripts. |
| 2 | Presets de exportación | Encapsulan plataforma, opciones y ruta; se referencian por nombre. |
| 3 | Plantillas de exportación | Sin ellas la exportación falla; hay que instalarlas por versión. |
| 4 | Release vs debug | El build de release desactiva el depurador y reduce tamaño. |
| 5 | `--export-pack` (.pck) | Empaqueta solo assets para DLC o actualizaciones sin re-exportar el binario. |
| 6 | Códigos de salida | Permiten que un script sepa si el build tuvo éxito. |
| 7 | Versionado del build | Incrustar la versión evita confundir artefactos. |
| 8 | Scripts multiplataforma | Una orden genera Windows, Linux y web de una vez. |

## 📖 Definiciones y características

- **`--headless`**: arranca Godot sin ventana ni contexto gráfico. Clave: obligatorio en máquinas sin pantalla (CI); antes se usaba `--no-window`.
- **Preset de exportación**: bloque en `export_presets.cfg` con nombre, plataforma y opciones. Clave: la CLI lo invoca por su nombre exacto entre comillas.
- **Plantilla de exportación (export template)**: binario base del motor por plataforma que se fusiona con tu `.pck`. Clave: debe coincidir con la versión de Godot.
- **`--export-release`**: genera el ejecutable en modo producción (sin depurador). Clave: es lo que distribuyes al jugador.
- **`--export-debug`**: genera un ejecutable con depuración remota habilitada. Clave: útil para probar en el dispositivo real.
- **`--export-pack`**: exporta solo el paquete de datos (`.pck` o `.zip`), sin binario. Clave: base de parches y contenido descargable.
- **Código de salida (exit code)**: entero que devuelve el proceso; `0` es éxito. Clave: un script lo comprueba para abortar la cadena si falla.
- **Artefacto**: el archivo resultante del build. Clave: se nombra con versión y plataforma para trazabilidad.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** accesible desde la terminal. En Windows el ejecutable suele llamarse `Godot_v4.x-stable_win64.exe`; conviene crear un alias o añadirlo al `PATH` como `godot`. Debes tener instaladas las **export templates** de tu versión exacta: desde el editor, `Editor → Manage Export Templates → Download and Install`, o por CLI con `godot --headless --install-android-build-template` para Android. Sin plantillas, la exportación aborta.

Define al menos un preset desde `Project → Export` (por ejemplo "Windows Desktop" y "Linux/X11"), guárdalo y verás aparecer `export_presets.cfg` en la raíz del proyecto. La documentación de referencia está en <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html> y el tutorial de línea de comandos en <https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html>.

## 🧪 Laboratorio guiado

Vamos a exportar un proyecto **sin abrir el editor** y luego a envolver el proceso en un script de build reproducible.

1. Verifica que Godot responde por CLI y que las plantillas están instaladas:

```bash
godot --version
# Ej.: 4.3.stable.official.77dcf97d8

# Lista rápida de presets definidos (inspecciona el archivo)
cat export_presets.cfg | grep 'name='
# name="Windows Desktop"
# name="Linux/X11"
```

2. Exporta un único preset de release. La ruta de salida debe existir; créala antes:

```bash
mkdir -p build/windows
godot --headless --export-release "Windows Desktop" build/windows/juego.exe
echo "Codigo de salida: $?"   # 0 significa exito
```

3. Ahora escribe el script de build multiplataforma con versionado. Crea `build.sh` en la raíz del proyecto:

```bash
#!/usr/bin/env bash
set -euo pipefail   # aborta ante error, variable sin definir o fallo en tuberia

GODOT="${GODOT:-godot}"           # permite sobreescribir el binario con una variable
VERSION="$(git describe --tags --always 2>/dev/null || echo 'dev')"
OUT="build/${VERSION}"

echo ">> Construyendo version ${VERSION}"
rm -rf "${OUT}"
mkdir -p "${OUT}/windows" "${OUT}/linux" "${OUT}/web"

# Cada exportacion usa el nombre EXACTO del preset en export_presets.cfg
"${GODOT}" --headless --export-release "Windows Desktop" "${OUT}/windows/juego-${VERSION}.exe"
"${GODOT}" --headless --export-release "Linux/X11"       "${OUT}/linux/juego-${VERSION}.x86_64"
"${GODOT}" --headless --export-release "Web"             "${OUT}/web/index.html"

echo ">> Builds generados en ${OUT}:"
find "${OUT}" -type f -maxdepth 2 -print
```

4. Dale permisos de ejecución y lánzalo. Si un preset no existe o falta su plantilla, `set -e` detiene el script en ese punto con código distinto de cero:

```bash
chmod +x build.sh
./build.sh
# >> Construyendo version v0.3.1-2-gab12cd3
# >> Builds generados en build/v0.3.1-2-gab12cd3: ...
```

5. Comprueba el `.pck` por separado. Para publicar un parche de solo datos, exporta el paquete sin binario:

```bash
godot --headless --export-pack "Windows Desktop" build/parche/data.pck
```

La lección observable: una sola orden reproduce el build completo, con la versión de Git incrustada en cada archivo, sin tocar el editor. Ese script es exactamente lo que ejecutará el runner de CI en la próxima clase.

## ✍️ Ejercicios

1. Añade a `build.sh` una variable `PRESETS` como array y recorre los presets con un bucle `for`, reduciendo la repetición.
2. Haz que el script escriba un archivo `build/${VERSION}/manifest.txt` con la fecha, el hash de Git y el tamaño de cada artefacto.
3. Exporta un preset en modo debug con `--export-debug` y compara el tamaño del ejecutable frente al de release.
4. Genera un `.pck` con `--export-pack` y arráncalo desde un binario base con `godot --main-pack data.pck`.
5. Añade una comprobación previa que aborte con mensaje claro si `godot --version` no encuentra el binario.
6. Empaqueta los tres directorios de salida en un `.zip` versionado usando `zip -r`.

## 📝 Reto verificable

Crea un script `build.sh` que, a partir de un proyecto con al menos dos presets, genere builds de release versionados con `git describe`, escriba un `manifest.txt` con hash, fecha y tamaño de cada artefacto, y aborte con código distinto de cero (y mensaje legible) si falta un preset o una plantilla de exportación.

**Criterio de aceptación**: ejecutar `./build.sh` en una máquina limpia produce una carpeta `build/<version>/` con un ejecutable por plataforma y un `manifest.txt` correcto; forzar el fallo (renombrar un preset) hace que el script termine con `echo $?` distinto de `0` sin dejar builds a medias.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| `No export template found at ...` | Faltan las plantillas de esa versión. Instálalas desde `Manage Export Templates` o descárgalas para la versión exacta. |
| `Project export failed... preset "X" not found` | El nombre del preset no coincide (mayúsculas, espacios). Cópialo literal desde `export_presets.cfg`. |
| El `.exe` sale pero la carpeta de salida no existía | Godot no crea rutas intermedias. Haz `mkdir -p` de la carpeta antes de exportar. |
| Funciona en tu PC pero falla en CI por falta de ventana | Olvidaste `--headless`. En servidores sin GPU es obligatorio. |
| El script sigue tras un error de exportación | Falta `set -e`. Añádelo o comprueba `$?` tras cada `godot`. |

## ❓ Preguntas frecuentes

**❓ ¿`--headless` y `--no-window` son lo mismo?** En Godot 4 usa `--headless`: arranca sin servidor de audio ni ventana. `--no-window` quedó obsoleto.

**❓ ¿Necesito el editor instalado en el runner?** No: basta el binario de Godot y las export templates de esa versión. No hace falta abrir el editor.

**❓ ¿Por qué versionar el nombre del artefacto?** Para no confundir dos builds. Un `juego.exe` sin versión hace imposible saber qué commit contiene; `juego-v0.3.1.exe` es inequívoco.

**❓ ¿Puedo exportar Android/iOS por CLI?** Sí, pero requieren cadena de herramientas adicional (SDK/NDK, firmas). El comando es el mismo; la preparación del entorno es más larga.

## 🔗 Referencias

- Godot Docs — Exporting projects: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html>
- Godot Docs — Command line tutorial: <https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html>
- Godot Docs — Exporting for dedicated servers / headless: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html>
- GNU Bash Manual — Set builtin (`set -euo pipefail`): <https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin>

## ➡️ Siguiente clase

[Clase 262 - Integración continua (CI) para juegos](../262-integracion-continua-ci-para-juegos/README.md)
