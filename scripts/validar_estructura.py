#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Valida la integridad del currículo del Programa de Desarrollo de Videojuegos Moderno.

Comprueba:
  1. Cada parte (classes/parte-*/) tiene su README.md.
  2. Cada carpeta de clase (classes/parte-*/NNN-slug/) tiene su README.md no trivial.
  3. La numeración de clases es secuencial y sin huecos dentro de lo construido.
  4. Cada clase incluye las secciones pedagógicas obligatorias.
  5. Todos los enlaces internos a archivos .md resuelven (no hay enlaces rotos).

Uso:  python scripts/validar_estructura.py
Salida: código 0 si todo está bien; 1 si hay errores (para CI).
"""
from __future__ import annotations
import os
import re
import sys

# La salida puede contener emojis/acentos; en Windows la consola usa cp1252 por
# defecto y reventaría al imprimir. Forzamos UTF-8 cuando es posible.
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLASSES = os.path.join(ROOT, "classes")
MIN_BYTES = 600  # un README real es mucho mayor; esto detecta stubs vacíos
LINK_RE = re.compile(r"\]\((\.\.?/[^)]+\.md)\)")

# Secciones que TODA clase debe incluir (robustez pedagógica).
SECCIONES_REQUERIDAS = [
    "## 🎯 Objetivo",
    "## 📚 Resultados de aprendizaje",
    "## 🧪 Laboratorio guiado",
    "## 📝 Reto verificable",
    "## ⚠️ Errores comunes",
    "## ❓ Preguntas frecuentes",
    "## 🔗 Referencias",
]
# La última clase de una parte enlaza a "Siguiente clase" o a "Siguiente paso";
# la última clase del programa cierra con "Fin del programa". Aceptamos los tres.
SIGUIENTE_RE = re.compile(r"^##\s+➡️\s+(Siguiente|Fin del programa)", re.MULTILINE)


def main() -> int:
    errores: list[str] = []
    n_partes = 0
    n_clases = 0

    if not os.path.isdir(CLASSES):
        print("ERROR: no existe el directorio classes/")
        return 1

    for parte in sorted(os.listdir(CLASSES)):
        pdir = os.path.join(CLASSES, parte)
        if not (os.path.isdir(pdir) and parte.startswith("parte-")):
            continue
        n_partes += 1
        if not os.path.isfile(os.path.join(pdir, "README.md")):
            errores.append(f"Falta README de parte: {parte}/README.md")

        # Numeración secuencial POR PARTE (el programa se construye por partes).
        nums_parte: list[int] = []
        for clase in sorted(os.listdir(pdir)):
            cdir = os.path.join(pdir, clase)
            if not os.path.isdir(cdir):
                continue
            n_clases += 1
            m = re.match(r"^(\d{3})-", clase)
            if m:
                nums_parte.append(int(m.group(1)))
            readme = os.path.join(cdir, "README.md")
            if not os.path.isfile(readme):
                errores.append(f"Falta README de clase: {parte}/{clase}/README.md")
                continue
            if os.path.getsize(readme) < MIN_BYTES:
                errores.append(f"README demasiado corto (<{MIN_BYTES} B): {parte}/{clase}/README.md")
                continue
            contenido = open(readme, encoding="utf-8").read()
            faltan = [s for s in SECCIONES_REQUERIDAS if s not in contenido]
            if faltan:
                errores.append(
                    f"Secciones faltantes en {parte}/{clase}/README.md: "
                    + ", ".join(f'"{s}"' for s in faltan)
                )
            if not SIGUIENTE_RE.search(contenido):
                errores.append(
                    f'Falta encabezado "## ➡️ Siguiente..." en {parte}/{clase}/README.md'
                )

        # Los números de una parte deben ser un rango contiguo (sin huecos ni duplicados).
        if nums_parte:
            nums_parte.sort()
            esperado = list(range(nums_parte[0], nums_parte[0] + len(nums_parte)))
            if nums_parte != esperado:
                faltan = sorted(set(esperado) - set(nums_parte))
                dup = sorted({x for x in nums_parte if nums_parte.count(x) > 1})
                if faltan:
                    errores.append(f"Huecos en la numeracion de {parte}: {faltan}")
                if dup:
                    errores.append(f"Numeros duplicados en {parte}: {dup}")

    # Enlaces internos .md en todo el árbol de classes/.
    enlaces = 0
    rotos = 0
    for cur, _, files in os.walk(CLASSES):
        for fn in files:
            if not fn.endswith(".md"):
                continue
            p = os.path.join(cur, fn)
            with open(p, encoding="utf-8") as fh:
                txt = fh.read()
            for mm in LINK_RE.finditer(txt):
                enlaces += 1
                tgt = os.path.normpath(os.path.join(cur, mm.group(1)))
                if not os.path.exists(tgt):
                    rotos += 1
                    errores.append(f"Enlace roto en {os.path.relpath(p, ROOT)} -> {mm.group(1)}")

    print("== Validacion del Programa de Desarrollo de Videojuegos Moderno ==")
    print(f"Partes construidas : {n_partes}")
    print(f"Clases construidas : {n_clases}")
    print(f"Enlaces .md revisados: {enlaces} (rotos: {rotos})")

    if errores:
        print(f"\nFALLO: {len(errores)} problema(s):")
        for e in errores[:50]:
            print(f"  - {e}")
        if len(errores) > 50:
            print(f"  ... y {len(errores) - 50} mas")
        return 1

    print("\nOK: estructura y enlaces integros.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
