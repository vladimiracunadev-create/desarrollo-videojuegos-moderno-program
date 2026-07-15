#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera guías **PDF imprimibles en blanco y negro** a partir de los README de clase.

Los PDF NO se versionan (pesan mucho y el sitio web ya cubre la lectura online):
se generan bajo demanda en `material/`, que está en .gitignore.

Uso:
  python scripts/generar_material.py --parte 1      # solo la parte 1
  python scripts/generar_material.py --parte 0 1 2  # varias partes
  python scripts/generar_material.py --all          # las 292 clases (~10 min)
  python scripts/generar_material.py --parte 1 --solo-html   # sin PDF (rápido)

Requiere: pip install "markdown>=3.6" y Chrome o Edge instalado (headless).
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import shutil
import subprocess
import sys
import tempfile

import markdown

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLASSES = os.path.join(ROOT, "classes")
OUT = os.path.join(ROOT, "material")

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

NAVEGADORES = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
]

# CSS de impresión: cero color, denso pero legible, sin cortar bloques de código.
CSS_PRINT = """
@page { size: A4; margin: 16mm 14mm 16mm 14mm; }
* { box-sizing: border-box; }
body { font-family: Georgia, 'Times New Roman', serif; font-size: 10.5pt; line-height: 1.45;
       color: #000; background: #fff; margin: 0; }
h1 { font-size: 17pt; margin: 0 0 .2em; border-bottom: 2px solid #000; padding-bottom: .2em; }
h2 { font-size: 13pt; margin: 1.1em 0 .35em; border-bottom: 1px solid #999; padding-bottom: .12em;
     page-break-after: avoid; }
h3 { font-size: 11.5pt; margin: .8em 0 .3em; page-break-after: avoid; }
p, li { orphans: 3; widows: 3; }
ul, ol { margin: .35em 0 .35em 1.1em; padding-left: .8em; }
li { margin: .12em 0; }
blockquote { border-left: 3px solid #666; margin: .6em 0; padding: .1em .8em; font-style: italic; }
code { font-family: 'Consolas', 'DejaVu Sans Mono', monospace; font-size: 9pt;
       background: #f0f0f0; padding: .05em .25em; border-radius: 2px; }
pre { font-family: 'Consolas', 'DejaVu Sans Mono', monospace; font-size: 8.6pt; line-height: 1.35;
      background: #f4f4f4; border: 1px solid #bbb; border-radius: 3px; padding: .5em .6em;
      overflow: visible; white-space: pre-wrap; word-wrap: break-word;
      page-break-inside: avoid; }  /* no partir el código entre páginas */
pre code { background: none; padding: 0; font-size: inherit; }
table { border-collapse: collapse; width: 100%; margin: .5em 0; font-size: 9.4pt;
        page-break-inside: avoid; }
th, td { border: 1px solid #666; padding: .28em .45em; text-align: left; vertical-align: top; }
th { background: #e8e8e8; font-weight: bold; }
a { color: #000; text-decoration: none; }
a[href^="http"]::after { content: " (" attr(href) ")"; font-size: 7.5pt; color: #555;
                         word-break: break-all; }
img { max-width: 100%; filter: grayscale(100%); }
hr { border: 0; border-top: 1px solid #999; margin: 1em 0; }
.pie { margin-top: 1.4em; padding-top: .5em; border-top: 1px solid #999;
       font-size: 8pt; color: #444; text-align: center; }
"""

PLANTILLA = """<!doctype html>
<html lang="es"><head><meta charset="utf-8"><title>{title}</title>
<style>{css}</style></head><body>
{body}
<div class="pie">Programa de Desarrollo de Videojuegos Moderno · {title}<br>
github.com/vladimiracunadev-create/modern-gamedev-program · Licencia MIT</div>
</body></html>
"""

# Los enlaces relativos no sirven en papel: se quedan como texto.
LINK_REL = re.compile(r"\[([^\]]+)\]\((?!https?://)[^)]+\)")


def buscar_navegador() -> str | None:
    for c in NAVEGADORES:
        if os.path.isfile(c):
            return c
    return shutil.which("chrome") or shutil.which("chromium") or shutil.which("msedge")


def clases(partes: list[int] | None) -> list[tuple[int, str, str]]:
    """[(num, ruta_readme, slug_parte)] filtradas por parte."""
    out = []
    for pdir in sorted(glob.glob(os.path.join(CLASSES, "parte-*"))):
        pslug = os.path.basename(pdir)
        pidx = int(re.search(r"parte-(\d+)", pslug).group(1))
        if partes is not None and pidx not in partes:
            continue
        for cdir in sorted(glob.glob(os.path.join(pdir, "*"))):
            base = os.path.basename(cdir)
            rm = os.path.join(cdir, "README.md")
            if os.path.isdir(cdir) and re.match(r"^\d{3}-", base) and os.path.isfile(rm):
                out.append((int(base[:3]), rm, pslug))
    return sorted(out)


def a_html(md_texto: str) -> tuple[str, str]:
    m = re.search(r"^#\s+(.+)$", md_texto, re.MULTILINE)
    title = re.sub(r"[#*`]", "", m.group(1)).strip() if m else "Clase"
    # Quitamos la navegación entre clases: en papel no aporta.
    md_texto = re.sub(r"^##\s+➡️\s+(Siguiente|Fin del programa).*(?:\n(?!##).*)*", "",
                      md_texto, flags=re.MULTILINE)
    md_texto = LINK_REL.sub(r"\1", md_texto)
    cuerpo = markdown.markdown(md_texto, extensions=["tables", "fenced_code", "sane_lists"])
    return title, PLANTILLA.format(title=title, css=CSS_PRINT, body=cuerpo)


def main() -> int:
    ap = argparse.ArgumentParser(description="Genera guías PDF imprimibles (B/N) por clase.")
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--parte", nargs="+", type=int, help="números de parte (0-17)")
    g.add_argument("--all", action="store_true", help="todas las clases")
    ap.add_argument("--solo-html", action="store_true", help="no generar PDF (rápido, para revisar)")
    args = ap.parse_args()

    lista = clases(None if args.all else args.parte)
    if not lista:
        print("No hay clases para esos filtros.")
        return 1

    navegador = None
    if not args.solo_html:
        navegador = buscar_navegador()
        if navegador is None:
            print("ERROR: no se encontró Chrome ni Edge. Usa --solo-html o instala un navegador.")
            return 1

    os.makedirs(OUT, exist_ok=True)
    hechos = 0
    for num, rm, pslug in lista:
        title, html = a_html(open(rm, encoding="utf-8").read())
        destino = os.path.join(OUT, pslug)
        os.makedirs(destino, exist_ok=True)
        base = f"clase-{num:03d}"

        if args.solo_html:
            with open(os.path.join(destino, base + ".html"), "w", encoding="utf-8") as f:
                f.write(html)
            hechos += 1
            continue

        with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as tmp:
            tmp.write(html)
            ruta_tmp = tmp.name
        pdf = os.path.join(destino, base + ".pdf")
        try:
            subprocess.run(
                [navegador, "--headless=new", "--disable-gpu", "--no-sandbox",
                 "--no-pdf-header-footer", f"--print-to-pdf={pdf}",
                 "file:///" + ruta_tmp.replace("\\", "/")],
                check=True, timeout=90,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            hechos += 1
            print(f"  [{hechos}/{len(lista)}] {os.path.relpath(pdf, ROOT)}")
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as e:
            print(f"  ERROR en la clase {num:03d}: {e}")
        finally:
            os.unlink(ruta_tmp)

    tipo = "HTML" if args.solo_html else "PDF"
    print(f"\n{hechos}/{len(lista)} guías {tipo} generadas en material/")
    print("Nota: material/ está en .gitignore (los PDF no se versionan).")
    return 0 if hechos == len(lista) else 1


if __name__ == "__main__":
    raise SystemExit(main())
