#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera `glosario/README.md` a partir de las secciones "📖 Definiciones y
características" de las 292 clases.

Cada clase define sus términos; este script los reúne, los ordena
alfabéticamente y enlaza cada uno a la clase donde se explica. Si un término
aparece en varias clases, se listan todas las apariciones.

Uso:  python scripts/generar_glosario.py
"""
from __future__ import annotations

import glob
import os
import re
import unicodedata

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLASSES = os.path.join(ROOT, "classes")
OUT_DIR = os.path.join(ROOT, "glosario")

try:
    import sys
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

# "- **Término**: definición. Clave: ..."
DEF_RE = re.compile(r"^\s*[-*]\s+\*\*(.+?)\*\*\s*:\s*(.+)$", re.MULTILINE)
H1_CLASE_RE = re.compile(r"^#\s+Clase\s+(\d{3})\s*[—-]\s*(.+)$", re.MULTILINE)


def sin_acentos(s: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", s)
                   if unicodedata.category(c) != "Mn").lower()


def limpiar(txt: str) -> str:
    """Recorta la definición: nos quedamos con la frase principal."""
    txt = txt.strip()
    # La convención del curso añade "Clave: ..." al final; sobra en el glosario.
    txt = re.split(r"\s*Clave:\s*", txt)[0].strip()
    return txt.rstrip(".") + "." if txt and not txt.endswith((".", "!", "?")) else txt


def main() -> int:
    # término -> lista de (num_clase, titulo_clase, ruta, definicion)
    entradas: dict[str, list[tuple[int, str, str, str]]] = {}

    for pdir in sorted(glob.glob(os.path.join(CLASSES, "parte-*"))):
        pslug = os.path.basename(pdir)
        for cdir in sorted(glob.glob(os.path.join(pdir, "*"))):
            base = os.path.basename(cdir)
            rm = os.path.join(cdir, "README.md")
            if not (os.path.isdir(cdir) and re.match(r"^\d{3}-", base) and os.path.isfile(rm)):
                continue
            txt = open(rm, encoding="utf-8").read()
            m = H1_CLASE_RE.search(txt)
            if not m:
                continue
            num, titulo = int(m.group(1)), m.group(2).strip()

            partes = txt.split("## 📖 Definiciones y características", 1)
            if len(partes) != 2:
                continue
            bloque = partes[1].split("\n## ", 1)[0]
            ruta = f"../classes/{pslug}/{base}/README.md"

            for term, definicion in DEF_RE.findall(bloque):
                term = term.strip()
                d = limpiar(definicion)
                if not term or not d:
                    continue
                entradas.setdefault(term, []).append((num, titulo, ruta, d))

    # Agrupar por inicial (ignorando acentos y símbolos de formato).
    # Ojo: la clave de orden debe usar la MISMA normalización que la inicial; si
    # no, términos como `Engine.is_editor_hint()` (que empiezan por backtick)
    # ordenan aparte pero se agrupan en "E" y parten el grupo en dos.
    def clave(t: str) -> str:
        return sin_acentos(t.strip("`*_\"'“”")).strip()

    def inicial(t: str) -> str:
        c = clave(t)[:1].upper()
        return c if c.isalpha() else "#"

    ordenados = sorted(entradas.items(),
                       key=lambda kv: (inicial(kv[0]) == "#", inicial(kv[0]), clave(kv[0]), kv[0]))
    iniciales = sorted({inicial(t) for t, _ in ordenados}, key=lambda c: (c == "#", c))

    lineas = [
        "# 📖 Glosario",
        "",
        "> [⬅️ Volver al programa](../README.md) · [📚 Índice completo](../classes/README.md) · [🔎 Buscador](https://vladimiracunadev-create.github.io/modern-gamedev-program/buscar.html)",
        "",
        f"**{len(ordenados)} términos** recopilados automáticamente de las secciones "
        "*Definiciones y características* de las 292 clases. Cada término enlaza a la clase "
        "donde se explica en contexto.",
        "",
        "> Este archivo se genera con `python scripts/generar_glosario.py`. No lo edites a mano: "
        "corrige la definición en la clase de origen y vuelve a generarlo.",
        "",
        "**Índice:** " + " · ".join(f"[{c}](#{c.lower() if c != '#' else 'otros'})" for c in iniciales),
        "",
        "---",
        "",
    ]

    actual = None
    for term, apariciones in ordenados:
        ini = inicial(term)
        if ini != actual:
            actual = ini
            lineas.append(f"## {ini if ini != '#' else 'Otros'}")
            lineas.append("")
        apariciones.sort()
        num, _titulo, ruta, definicion = apariciones[0]
        refs = ", ".join(f"[{n:03d}]({r})" for n, _t, r, _d in apariciones)
        lineas.append(f"**{term}** — {definicion} · {refs}")
        lineas.append("")

    os.makedirs(OUT_DIR, exist_ok=True)
    with open(os.path.join(OUT_DIR, "README.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lineas).rstrip() + "\n")

    total_refs = sum(len(v) for v in entradas.values())
    print(f"Glosario generado: {len(ordenados)} términos, {total_refs} referencias a clases.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
