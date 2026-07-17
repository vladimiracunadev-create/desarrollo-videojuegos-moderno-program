#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Arma el **manual completo del curso**: las 292 clases, en orden, en un solo sitio
para leer de corrido, consultar o descargar.

Genera dos cosas:

1. `manual/MANUAL-COMPLETO.md` — VERSIONADO. Todo el curso en un único Markdown,
   con su índice arriba. Se lee en el repo (GitHub), en el sitio web (GitHub
   Pages, donde se convierte a una página HTML) o descargándolo. Es texto: pesa
   ~3 MB y se versiona sin problema.

2. `material/MANUAL-COMPLETO.pdf` — NO versionado, bajo demanda (`--pdf`). El
   mismo contenido, imprimible en blanco y negro. Sale a `material/`, que está
   en .gitignore, porque son ~28 MB y se regenera solo.

Cómo trata cada clase al meterla en el manual
---------------------------------------------
* Le quita la navegación «⬅️ anterior / ➡️ siguiente»: en un manual se pasa página
  y el índice de arriba ya deja saltar a cualquier clase.
* Baja los títulos para que encajen en la jerarquía del manual: un solo H1 (el
  título del manual), cada parte en H2 y cada clase en H3, sin saltos de nivel.
* Reescribe los enlaces: a otra clase, salta a su ancla dentro del manual; a un
  lab o al roadmap, apunta a su sitio real.

Es idempotente y la CI comprueba que está al día (igual que el índice, el
glosario y la navegación): editar una clase y olvidar regenerar se detecta.

Uso:  python scripts/generar_manual.py            # (re)genera manual/MANUAL-COMPLETO.md
      python scripts/generar_manual.py --check    # no escribe; falla si hay drift
      python scripts/generar_manual.py --pdf       # + material/MANUAL-COMPLETO.pdf
Requiere: markdown y Chrome/Edge solo para --pdf.
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLASSES = os.path.join(ROOT, "classes")
MANUAL_DIR = os.path.join(ROOT, "manual")
MANUAL_MD = os.path.join(MANUAL_DIR, "MANUAL-COMPLETO.md")
MATERIAL = os.path.join(ROOT, "material")

RE_H1 = re.compile(r"^#\s+(.+?)\s*$", re.M)
RE_NAV = re.compile(r"\n##\s+(?:⬅️\s+Clase anterior|➡️\s+(?:Siguiente|Fin del programa))")
RE_LINK = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
RE_FENCE = re.compile(r"^(\s*)(```|~~~)")

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass


def gh_slug(texto: str) -> str:
    """El ancla que GitHub genera para un título: minúsculas, fuera lo que no sea
    letra/dígito/espacio/guion (los acentos se conservan), espacios a guiones."""
    s = re.sub(r"[^\w\s-]", "", texto.strip().lower(), flags=re.UNICODE)
    return s.replace(" ", "-")


class Clase:
    def __init__(self, ruta: str) -> None:
        self.ruta = ruta
        self.dir = os.path.dirname(ruta)
        self.numero = int(os.path.basename(self.dir)[:3])
        with open(ruta, encoding="utf-8") as f:
            self._texto = f.read()
        m = RE_H1.search(self._texto)
        bruto = m.group(1) if m else os.path.basename(self.dir)
        self.titulo = re.sub(r"^Clase\s+\d{3}\s*[—-]\s*", "", bruto).strip()

    @property
    def encabezado(self) -> str:
        return f"Clase {self.numero:03d} — {self.titulo}"

    @property
    def ancla(self) -> str:
        return gh_slug(self.encabezado)

    def texto(self) -> str:
        return self._texto


class Parte:
    def __init__(self, pdir: str, clases: list[Clase]) -> None:
        self.dir = pdir
        self.idx = int(re.search(r"parte-(\d+)", pdir).group(1))
        self.clases = clases
        with open(os.path.join(pdir, "README.md"), encoding="utf-8") as f:
            self._intro = f.read()
        m = RE_H1.search(self._intro)
        self.titulo = re.sub(r"^Parte\s+\d+\s*[—-]\s*", "", m.group(1)).strip() if m else pdir

    @property
    def encabezado(self) -> str:
        return f"Parte {self.idx} — {self.titulo}"

    @property
    def ancla(self) -> str:
        return gh_slug(self.encabezado)

    def intro(self) -> str:
        t = RE_H1.sub("", self._intro, count=1)                       # fuera el H1
        return re.sub(r"^\s*>\s*\[⬅️[^\n]*\n", "", t, count=1, flags=re.M)  # fuera la nav


def cargar() -> list[Parte]:
    partes: list[Parte] = []
    for pdir in sorted(glob.glob(os.path.join(CLASSES, "parte-*")),
                       key=lambda p: int(re.search(r"parte-(\d+)", p).group(1))):
        rutas = glob.glob(os.path.join(pdir, "[0-9][0-9][0-9]-*", "README.md"))
        clases = sorted((Clase(r) for r in rutas), key=lambda c: c.numero)
        if clases:
            partes.append(Parte(pdir, clases))
    return partes


# --- Transformar contenido ----------------------------------------------------
def _resolver_enlace(destino: str, base_dir: str, indice: dict[int, Clase]) -> str:
    if destino.startswith(("http://", "https://", "#", "mailto:")):
        return destino
    ruta, _, frag = destino.partition("#")
    absoluto = os.path.normpath(os.path.join(base_dir, ruta))
    rel = os.path.relpath(absoluto, ROOT).replace("\\", "/")
    m = re.match(r"classes/parte-\d+[^/]*/(\d{3})-[^/]*/README\.md$", rel)
    if m:                                    # enlace a otra clase -> ancla interna
        c = indice.get(int(m.group(1)))
        return f"#{c.ancla}" if c else destino
    # cualquier otra cosa (labs, roadmap, índice): su ruta real desde manual/
    salida = os.path.relpath(absoluto, MANUAL_DIR).replace("\\", "/")
    return salida + (("#" + frag) if frag else "")


def transformar(texto: str, base_dir: str, indice: dict[int, Clase],
                subir_titulos: int) -> str:
    """Quita la navegación, sube N niveles los títulos y reescribe los enlaces,
    respetando los bloques de código (ni un '#' ni un '](...)' de dentro se toca)."""
    m = RE_NAV.search(texto)
    if m:
        texto = texto[:m.start()].rstrip() + "\n"

    salida, en_fence, marca = [], False, ""
    for linea in texto.splitlines():
        f = RE_FENCE.match(linea)
        if f:
            if not en_fence:
                en_fence, marca = True, f.group(2)
            elif f.group(2) == marca:
                en_fence = False
            salida.append(linea)
            continue
        if en_fence:
            salida.append(linea)
            continue
        if subir_titulos and linea.startswith("#"):
            linea = "#" * subir_titulos + linea
        linea = RE_LINK.sub(
            lambda mo: f"[{mo.group(1)}]({_resolver_enlace(mo.group(2), base_dir, indice)})",
            linea)
        salida.append(linea)
    return "\n".join(salida).strip()


def construir(partes: list[Parte], indice: dict[int, Clase]) -> str:
    total = sum(len(p.clases) for p in partes)
    doc: list[str] = []

    # Portada (único H1 del documento).
    doc.append("# 📖 Manual completo — Desarrollo de Videojuegos Moderno\n")
    doc.append(f"> [⬅️ Volver al programa](../README.md) · "
               f"[📚 Índice de clases](../classes/README.md) · "
               f"[🧪 Laboratorios](../labs/README.md)\n")
    doc.append(f"Las **{total} clases** del programa, en orden, para leer de corrido. "
               "Usa el índice para saltar a cualquier clase; cada una enlaza de vuelta aquí.\n")
    doc.append("> **¿Lo quieres en PDF imprimible?** Se genera bajo demanda "
               "(pesa demasiado para versionarlo):\n>\n"
               "> ```bash\n"
               "> python scripts/generar_manual.py --pdf   # material/MANUAL-COMPLETO.pdf\n"
               "> ```\n")

    # Índice.
    doc.append("## Contenido\n")
    for p in partes:
        rango = f"{p.clases[0].numero:03d}–{p.clases[-1].numero:03d}"
        doc.append(f"- **[{p.encabezado}](#{p.ancla})** · {len(p.clases)} clases · {rango}")
        for c in p.clases:
            doc.append(f"    - [{c.encabezado}](#{c.ancla})")
    doc.append("")

    # Cuerpo.
    for p in partes:
        doc.append(f"## {p.encabezado}\n")
        intro = transformar(p.intro(), p.dir, indice, subir_titulos=1)  # H2->H3
        if intro:
            doc.append(intro + "\n")
        for c in p.clases:
            doc.append("---\n")
            # H1 clase -> H3; H2 secciones -> H4; H3 -> H5.
            doc.append(transformar(c.texto(), c.dir, indice, subir_titulos=2) + "\n")

    return "\n".join(doc).strip() + "\n"


# --- PDF (reutiliza el pipeline B/N de generar_material) ----------------------
def generar_pdf(md_texto: str) -> int:
    try:
        import markdown
    except ImportError:
        print("Falta 'markdown'. Instálalo: pip install \"markdown>=3.6\"")
        return 1
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import generar_material as gm

    navegador = gm.buscar_navegador()
    if navegador is None:
        print("No encontré Chrome ni Edge (hacen falta para el PDF).")
        return 1

    md = gm.LINK_REL.sub(r"\1", md_texto)  # en papel los enlaces relativos van a texto
    cuerpo = markdown.markdown(md, extensions=["tables", "fenced_code", "sane_lists"])
    html = gm.PLANTILLA.format(title="Manual completo", css=gm.CSS_PRINT, body=cuerpo)

    os.makedirs(MATERIAL, exist_ok=True)
    pdf = os.path.join(MATERIAL, "MANUAL-COMPLETO.pdf")
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as tmp:
        tmp.write(html)
        ruta_tmp = tmp.name
    try:
        print("Generando el PDF (son ~300 páginas: puede tardar un par de minutos)...")
        subprocess.run(
            [navegador, "--headless=new", "--disable-gpu", "--no-sandbox",
             "--no-pdf-header-footer", f"--print-to-pdf={pdf}",
             "file:///" + ruta_tmp.replace("\\", "/")],
            check=True, timeout=600,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as e:
        print(f"Chrome falló generando el PDF: {e}")
        return 1
    finally:
        os.unlink(ruta_tmp)
    print(f"  {os.path.relpath(pdf, ROOT)} ({os.path.getsize(pdf) // 1024} KB)")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description="Genera el manual completo del curso.")
    ap.add_argument("--check", action="store_true",
                    help="no escribe: falla si el manual versionado está desactualizado")
    ap.add_argument("--pdf", action="store_true",
                    help="además, material/MANUAL-COMPLETO.pdf (imprimible B/N)")
    args = ap.parse_args()

    partes = cargar()
    if not partes:
        print("No encontré clases.")
        return 1
    indice = {c.numero: c for p in partes for c in p.clases}
    total = sum(len(p.clases) for p in partes)
    print(f"== Manual: {len(partes)} partes, {total} clases ==")

    contenido = construir(partes, indice)

    actual = ""
    if os.path.isfile(MANUAL_MD):
        with open(MANUAL_MD, encoding="utf-8") as f:
            actual = f.read()

    if args.check:
        if actual != contenido:
            print("\nFALLO: manual/MANUAL-COMPLETO.md está desactualizado.")
            print("Ejecuta: python scripts/generar_manual.py")
            return 1
        print("OK: el manual está al día.")
        return 0

    os.makedirs(MANUAL_DIR, exist_ok=True)
    if actual != contenido:
        with open(MANUAL_MD, "w", encoding="utf-8", newline="\n") as f:
            f.write(contenido)
        print(f"  {os.path.relpath(MANUAL_MD, ROOT)} ({len(contenido) // 1024} KB) actualizado")
    else:
        print(f"  {os.path.relpath(MANUAL_MD, ROOT)} sin cambios")

    if args.pdf:
        rc = generar_pdf(contenido)
        if rc != 0:
            return rc

    print("\nOK: manual generado.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
