# Clase 263 — Control de versiones avanzado para equipos

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Git LFS, GitHub (Working with large files) y Godot 4 (Version control systems)*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Un juego no es solo código: son texturas, audio, mallas y escenas que pesan y cambian a menudo. Git, pensado para texto, se atraganta con binarios grandes y con las escenas de Godot cuando dos personas las tocan a la vez. En esta clase montamos un **flujo de versionado de equipo** apto para juegos: **Git LFS** para los binarios, un **`.gitattributes`** bien afinado, ramas por feature y las buenas prácticas que hacen que un `.tscn` casi nunca genere un conflicto imposible.

Aprenderás a rastrear assets pesados con LFS sin inflar el historial, a organizar el trabajo en ramas de característica que se integran con revisión, y —lo más valioso— a **prevenir** conflictos de escena manteniéndolas pequeñas y modulares, además de resolver uno cuando aparezca. El resultado es un repositorio donde varios desarrolladores avanzan sin pisarse.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Configurar Git LFS y rastrear tipos de asset binarios mediante `.gitattributes`.
2. Justificar por qué los binarios grandes no deben ir en Git plano y qué problema resuelve LFS.
3. Aplicar un flujo de ramas por feature con integración vía pull request.
4. Explicar por qué las escenas de Godot generan conflictos y aplicar prácticas para evitarlos.
5. Resolver un conflicto de escena sencillo y decidir cuándo es preferible rehacer el cambio.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Git y los binarios | Git guarda cada versión completa; los binarios inflan el repo. |
| 2 | Git LFS | Sustituye el binario por un puntero y guarda el archivo aparte. |
| 3 | `.gitattributes` | Declara qué rastrea LFS y cómo trata cada tipo de archivo. |
| 4 | Ramas por feature | Aíslan el trabajo en curso del código estable. |
| 5 | Pull requests y revisión | Integran cambios con una comprobación humana y de CI. |
| 6 | Conflictos en escenas | Los `.tscn` son texto, pero difíciles de fusionar a mano. |
| 7 | Escenas pequeñas y modulares | Reducen la superficie de colisión entre compañeros. |
| 8 | Estrategia ante conflicto | A veces rehacer es más seguro que fusionar. |

## 📖 Definiciones y características

- **Git LFS (Large File Storage)**: extensión que reemplaza archivos grandes por punteros de texto y almacena el binario en un servidor aparte. Clave: el historial se mantiene ligero.
- **Puntero LFS**: pequeño archivo de texto que Git versiona en lugar del binario real. Clave: el binario se descarga bajo demanda.
- **`.gitattributes`**: archivo que asigna atributos por patrón de ruta (qué va a LFS, fin de línea, merge). Clave: se versiona y aplica a todo el equipo.
- **Rama por feature**: rama efímera para una tarea concreta, partida de `main`. Clave: aísla el trabajo hasta que está listo.
- **Pull request (PR)**: propuesta de fusión revisable. Clave: combina revisión humana con checks automáticos de CI.
- **Conflicto de fusión**: cambios incompatibles en la misma zona de un archivo. Clave: Git no puede decidir y pide intervención.
- **Escena modular (`PackedScene`)**: escena pequeña reutilizable e instanciable. Clave: menos gente edita el mismo archivo a la vez.
- **`.tscn`**: formato de texto de las escenas de Godot. Clave: es diffable, pero los IDs internos complican la fusión manual.

## 🧰 Herramientas y preparación

Necesitas **Git** y el binario de **Git LFS** instalado (`git lfs version` debe responder). En Windows viene con Git for Windows; en Linux/macOS se instala aparte. Trabaja sobre un repositorio de Godot con una carpeta `assets/` que contenga imágenes y audio de prueba.

Godot guarda escenas (`.tscn`) y recursos (`.tres`) como texto por defecto, lo que ayuda al diff; conviene mantenerlo así en `Project Settings` en vez de usar formato binario. La guía oficial de Git LFS está en <https://git-lfs.com/> y las recomendaciones de Godot sobre control de versiones en <https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html>.

## 🧪 Laboratorio guiado

Vamos a configurar LFS, montar un flujo de ramas y provocar/resolver un conflicto de escena controlado.

1. Inicializa LFS en el repo y declara qué extensiones binarias rastrear. Los comandos generan/editan `.gitattributes`:

```bash
git lfs install                     # una sola vez por maquina
git lfs track "*.png" "*.jpg" "*.webp"
git lfs track "*.wav" "*.ogg" "*.mp3"
git lfs track "*.glb" "*.blend" "*.exr"
cat .gitattributes
# *.png filter=lfs diff=lfs merge=lfs -text
# *.ogg filter=lfs diff=lfs merge=lfs -text
# ...

git add .gitattributes
git commit -m "Configurar Git LFS para assets binarios"
```

2. Añade un asset y verifica que LFS lo gestiona como puntero, no como binario crudo:

```bash
cp ~/texturas/heroe.png assets/heroe.png
git add assets/heroe.png
git commit -m "Anadir textura del heroe"
git lfs ls-files          # lista los archivos rastreados por LFS
# 3a4b1c2d * assets/heroe.png
```

3. Refuerza `.gitattributes` para las escenas: márcalas como texto y evita normalizaciones raras de fin de línea que ensucian los diffs:

```bash
cat >> .gitattributes <<'EOF'
# Escenas y recursos de Godot: texto, diff legible, sin conversion CRLF
*.tscn text eol=lf
*.tres text eol=lf
*.gd   text eol=lf
EOF
git add .gitattributes
git commit -m "Tratar escenas y scripts como texto LF"
```

4. Monta el flujo de ramas por feature. Dos compañeros trabajan aislados:

```bash
git switch -c feature/menu-pausa      # rama de una tarea concreta
# ...editas escenas y scripts del menu de pausa...
git add . && git commit -m "Menu de pausa funcional"
git push -u origin feature/menu-pausa
# Luego abres un Pull Request hacia main para revision + CI
```

5. Provoca y resuelve un conflicto de escena **pequeña**. Si dos ramas cambian el mismo `.tscn`, al fusionar aparece el conflicto. Para escenas modulares y diminutas, lo pragmático suele ser quedarse con una versión y reaplicar el cambio menor:

```bash
git switch main
git merge feature/menu-pausa
# CONFLICT (content): Merge conflict in ui/menu.tscn
git checkout --theirs ui/menu.tscn    # toma la version de la rama entrante
# ...reabres la escena en Godot, reaplicas a mano el ajuste que faltaba...
git add ui/menu.tscn
git commit -m "Resolver conflicto de menu.tscn tomando la rama feature"
```

La lección observable: los binarios viajan por LFS sin inflar el historial, cada tarea vive en su rama, y como las escenas son pequeñas y modulares, el único conflicto se resuelve tomando una versión y reaplicando un retoque menor en el editor. Cuanto más grande fuera esa escena, más doloroso sería.

## ✍️ Ejercicios

1. Añade a `.gitattributes` el rastreo LFS de `*.ttf` y `*.mp4`, confírmalo y verifica con `git lfs ls-files`.
2. Migra un binario ya commiteado en Git plano a LFS con `git lfs migrate import --include="*.png"` en una rama de prueba.
3. Divide una escena grande en dos `PackedScene` instanciadas y explica cómo reduce la probabilidad de conflicto.
4. Crea dos ramas que editen escenas distintas, fusiónalas ambas a `main` y comprueba que no hay conflicto.
5. Configura una rama protegida `main` en GitHub que exija PR y checks verdes antes de fusionar.
6. Escribe una nota de equipo (README) con la política de ramas y de qué va a LFS.

## 📝 Reto verificable

Configura un repositorio de juego con Git LFS rastreando al menos tres tipos de asset binario vía `.gitattributes`, un flujo de ramas por feature documentado, y demuestra la resolución de un conflicto de escena provocado a propósito. Entrega el `.gitattributes` y el historial que evidencie la resolución.

**Criterio de aceptación**: `git lfs ls-files` muestra los assets binarios gestionados por LFS (no como blobs en el historial), existe al menos una rama `feature/*` integrada por fusión, y el log documenta un conflicto de `.tscn` resuelto con un commit de merge explicado; las escenas del proyecto son pequeñas y modulares en lugar de una única escena monolítica.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El repo pesa gigas pese a usar LFS | Añadiste `.gitattributes` después de commitear binarios. Migra con `git lfs migrate import` para reescribir el historial. |
| Al clonar, los assets son archivos de texto de 130 bytes | Falta `git lfs pull` o LFS no está instalado en esa máquina. Instálalo y ejecuta `git lfs pull`. |
| Conflictos constantes en un `.tscn` enorme | La escena es monolítica. Divídela en subescenas instanciadas para que cada uno toque partes distintas. |
| Diffs de escena llenos de cambios de fin de línea | Falta `eol=lf` en `.gitattributes`. Decláralo y renormaliza con `git add --renormalize .`. |
| `git lfs track` no surte efecto | Rastreaste tras commitear el archivo. Los patrones solo afectan a lo que se añade después; re-añade el archivo. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo fusionar automáticamente dos escenas en conflicto?** No de forma fiable: los IDs internos de nodos y sub-recursos hacen que la fusión textual sea arriesgada. Por eso se prioriza prevenir con escenas pequeñas.

**❓ ¿LFS tiene coste?** El almacenamiento y ancho de banda de LFS en GitHub tienen cuota gratuita y luego se paga. Alternativas self-hosted evitan ese coste.

**❓ ¿Debo usar formato binario para escenas (.scn) para acelerar?** No para el desarrollo compartido: el texto (`.tscn`) permite diffs y revisión. El binario solo tiene sentido en exportación, no en el repo.

**❓ ¿Qué va a LFS y qué no?** A LFS: imágenes, audio, vídeo, mallas, fuentes, `.blend`. En Git normal: scripts, escenas, recursos de texto y configuración, que son pequeños y diffables.

## 🔗 Referencias

- Git LFS — sitio oficial y guía: <https://git-lfs.com/>
- GitHub Docs — Managing large files: <https://docs.github.com/repositories/working-with-files/managing-large-files>
- Godot Docs — Version control systems: <https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html>
- Pro Git (libro) — Git Attributes: <https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes>

## ➡️ Siguiente clase

[Clase 264 - Testing automatizado de juegos (GUT)](../264-testing-automatizado-de-juegos-gut/README.md)
