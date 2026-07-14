# Clase 262 — Integración continua (CI) para juegos

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de GitHub Actions y Godot 4 (Exporting from the command line)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

La integración continua (CI) convierte el "en mi máquina funciona" en "en cada push se construye y se prueba, automáticamente, en una máquina limpia". En esta clase montamos un **workflow de GitHub Actions** que, en cada empujón al repositorio, descarga Godot en modo headless, exporta el juego y publica el ejecutable como **artefacto** descargable. Es la continuación natural de la clase anterior: tomamos el build por CLI y lo delegamos a un runner en la nube.

Aprenderás la anatomía de un archivo `.github/workflows/*.yml` —eventos, jobs, steps—, cómo obtener el binario y las plantillas de Godot dentro del runner, cómo cachear descargas para acelerar, y cómo subir el resultado con `actions/upload-artifact`. Con esto, cada colaborador sabe en minutos si su cambio rompe el build, sin que nadie tenga que exportar a mano.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es la integración continua y qué problemas de equipo resuelve en un proyecto de juego.
2. Leer y escribir la estructura de un workflow de GitHub Actions: `on`, `jobs`, `runs-on`, `steps`.
3. Obtener el binario de Godot headless y las export templates dentro de un runner Linux.
4. Exportar el juego en el runner y publicar el resultado con `actions/upload-artifact`.
5. Disparar el workflow en cada push y leer los logs para diagnosticar un build roto.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es CI | Detecta builds rotos al instante, no el día del release. |
| 2 | GitHub Actions y su YAML | Es el sistema de CI integrado en GitHub, gratuito para repos públicos. |
| 3 | Eventos (`on: push`) | Definen cuándo se ejecuta el workflow. |
| 4 | Runners y `runs-on` | La máquina limpia donde corre cada job. |
| 5 | Obtener Godot en el runner | Sin editor local, hay que descargar binario y plantillas. |
| 6 | Exportar en CI | Reutiliza el comando `--headless --export-release`. |
| 7 | Artefactos | Hacen descargable el ejecutable resultante del build. |
| 8 | Caché de dependencias | Evita re-descargar Godot en cada ejecución. |

## 📖 Definiciones y características

- **Integración continua (CI)**: práctica de construir y probar el proyecto automáticamente en cada cambio. Clave: acorta el ciclo entre error y detección.
- **Workflow**: archivo YAML en `.github/workflows/` que describe la automatización. Clave: se versiona junto al código.
- **Evento (`on`)**: disparador del workflow (`push`, `pull_request`, `workflow_dispatch`). Clave: decide cuándo corre.
- **Job**: unidad que se ejecuta en un runner; contiene pasos. Clave: los jobs pueden correr en paralelo.
- **Runner**: máquina virtual efímera (`ubuntu-latest`, `windows-latest`). Clave: parte siempre limpia, sin tu configuración local.
- **Step**: un paso del job, sea un `run` de shell o un `uses` de acción reutilizable. Clave: se ejecutan en orden.
- **Acción (`uses`)**: componente reutilizable publicado (p. ej. `actions/checkout`). Clave: se fija por versión (`@v4`).
- **Artefacto**: archivo que el workflow sube para descargar después. Clave: es tu build entregable desde la web de GitHub.

## 🧰 Herramientas y preparación

Necesitas un repositorio en **GitHub** con el proyecto de Godot y su `export_presets.cfg` con un preset de Linux (por ejemplo "Linux/X11"), porque exportaremos en un runner Linux. En el runner descargaremos un binario **headless** de Godot y sus **export templates**; ambos se publican como `.zip` en las releases oficiales, cuya URL sigue un patrón fijo por versión.

Crea la carpeta `.github/workflows/` en la raíz. Cada `.yml` que pongas ahí es un workflow independiente. La referencia de sintaxis está en <https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions> y la acción de artefactos en <https://github.com/actions/upload-artifact>. Para no reescribir la descarga, existe la acción comunitaria `chickensoft-games/setup-godot`, aunque aquí lo haremos manualmente para entender cada paso.

## 🧪 Laboratorio guiado

Vamos a crear un workflow que **exporte el juego en cada push** y suba el ejecutable como artefacto.

1. Crea el archivo `.github/workflows/build.yml`. Empieza por la cabecera de disparadores y el job:

```yaml
name: Build del juego

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:   # permite lanzarlo a mano desde la pestaña Actions

jobs:
  export-linux:
    runs-on: ubuntu-latest
    env:
      GODOT_VERSION: "4.3"
      EXPORT_PRESET: "Linux/X11"
```

2. Añade los pasos. Primero clonar el repo, luego descargar Godot headless y sus plantillas en las rutas donde el motor las espera:

```yaml
    steps:
      - name: Clonar repositorio
        uses: actions/checkout@v4

      - name: Descargar Godot headless y plantillas
        run: |
          BASE="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable"
          wget -q "${BASE}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip" -O godot.zip
          wget -q "${BASE}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz" -O templates.tpz
          unzip -q godot.zip
          mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 godot
          chmod +x godot
          # Las plantillas van en la ruta que Godot busca por version
          mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable
          unzip -q templates.tpz
          mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable/
```

3. Exporta el juego reutilizando el comando de la clase anterior. Crea la carpeta de salida primero:

```yaml
      - name: Exportar build de release
        run: |
          mkdir -p build/linux
          ./godot --headless --export-release "${EXPORT_PRESET}" build/linux/juego.x86_64
          ls -la build/linux
```

4. Publica el resultado como artefacto descargable. Nómbralo con el número de ejecución para trazabilidad:

```yaml
      - name: Subir artefacto
        uses: actions/upload-artifact@v4
        with:
          name: juego-linux-${{ github.run_number }}
          path: build/linux/
          if-no-files-found: error   # falla si la exportacion no genero nada
```

5. Haz `git add`, `commit` y `push`. Abre la pestaña **Actions** del repositorio: verás el workflow ejecutándose. Al terminar en verde, el artefacto aparece al final de la ejecución, listo para descargar. Si el build falla, el log del paso "Exportar" señala la línea exacta.

La lección observable: sin que nadie abra el editor, cada push produce y publica un ejecutable en una máquina limpia. Si el proyecto no compila o falta un preset, GitHub lo marca en rojo antes de que llegue a otro colaborador.

## ✍️ Ejercicios

1. Añade un segundo job `export-web` que exporte el preset "Web" y suba su artefacto por separado.
2. Cachea la descarga de Godot con `actions/cache` usando `GODOT_VERSION` en la clave para no re-bajarlo cada vez.
3. Restringe el workflow para que solo suba artefactos en pushes a `main`, usando una condición `if: github.ref == 'refs/heads/main'`.
4. Incrusta la versión de Git en el nombre del artefacto tomándola de `git describe` dentro de un paso.
5. Añade un `workflow_dispatch` con un input de texto para elegir el preset a exportar.
6. Configura `concurrency` para cancelar ejecuciones antiguas cuando llega un push nuevo a la misma rama.

## 📝 Reto verificable

Escribe un workflow completo `.github/workflows/build.yml` que, en cada push a `main`, descargue Godot headless y sus plantillas, exporte el juego para Linux y suba el ejecutable como artefacto con la versión de Git en el nombre. El workflow debe fallar (rojo) si la exportación no genera archivos.

**Criterio de aceptación**: al empujar a `main`, la pestaña Actions muestra el workflow en verde y ofrece un artefacto descargable cuyo nombre incluye la versión; al romper el proyecto a propósito (borrar el preset), la ejecución termina en rojo señalando el paso de exportación y sin subir artefacto.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| `No export template found` en el runner | Las plantillas no están en la ruta esperada. Colócalas en `~/.local/share/godot/export_templates/<version>.stable/`. |
| El workflow no aparece en Actions | El YAML está mal indentado o fuera de `.github/workflows/`. Valida la sintaxis y la ubicación. |
| El artefacto está vacío | La exportación falló silenciosamente. Añade `if-no-files-found: error` y revisa el log del export. |
| `Permission denied` al ejecutar godot | Falta `chmod +x godot` tras descomprimir. Añádelo antes de invocarlo. |
| El build tarda muchísimo cada vez | Se re-descarga Godot en cada run. Usa `actions/cache` para las plantillas y el binario. |

## ❓ Preguntas frecuentes

**❓ ¿GitHub Actions es gratis?** Para repositorios públicos, sí, con minutos generosos. Los privados tienen una cuota mensual gratuita y luego se factura por minuto de runner.

**❓ ¿Puedo exportar Windows y macOS también?** Sí. Windows funciona bien desde un runner Linux; macOS requiere `runs-on: macos-latest` y, para firmar/notarizar, credenciales adicionales.

**❓ ¿Por qué fijar la versión de las acciones con `@v4`?** Para reproducibilidad y seguridad: una versión flotante podría cambiar de comportamiento sin avisar y romper tu build.

**❓ ¿Corre esto también los tests?** El workflow de esta clase solo exporta. En la clase 264 integraremos la ejecución de tests GUT como un paso previo al export.

## 🔗 Referencias

- GitHub Docs — Workflow syntax: <https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions>
- GitHub — `actions/upload-artifact`: <https://github.com/actions/upload-artifact>
- Godot Docs — Exporting projects: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html>
- chickensoft-games/setup-godot (acción para instalar Godot en CI): <https://github.com/chickensoft-games/setup-godot>

## ➡️ Siguiente clase

[Clase 263 - Control de versiones avanzado para equipos](../263-control-de-versiones-avanzado-para-equipos/README.md)
