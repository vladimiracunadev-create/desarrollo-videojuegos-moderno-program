#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Comprueba que los assets versionados coinciden con lo que produce el generador.

Compara **contenido**, no bytes: dos PNG con los mismos píxeles pueden tener
bytes distintos según la versión de Pillow/zlib (el encoder comprime distinto),
y eso no es un fallo. Lo que debe mantenerse estable es la imagen y el audio.

Uso:  python scripts/verificar_assets.py
Salida: 0 si todo coincide; 1 si algún asset difiere o falta (para CI).
"""
from __future__ import annotations

import os
import sys
import tempfile
import wave

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import generar_assets  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass


def _img_igual(a: str, b: str) -> tuple[bool, str]:
    ia, ib = Image.open(a), Image.open(b)
    if ia.size != ib.size:
        return False, f"tamaño {ia.size} vs {ib.size}"
    if ia.mode != ib.mode:
        return False, f"modo {ia.mode} vs {ib.mode}"
    if ia.tobytes() != ib.tobytes():
        return False, "los píxeles difieren"
    return True, "ok"


def _wav_igual(a: str, b: str) -> tuple[bool, str]:
    with wave.open(a) as wa, wave.open(b) as wb:
        if wa.getparams()[:4] != wb.getparams()[:4]:
            return False, f"formato {wa.getparams()[:4]} vs {wb.getparams()[:4]}"
        if wa.readframes(wa.getnframes()) != wb.readframes(wb.getnframes()):
            return False, "las muestras difieren"
    return True, "ok"


def _verificar_lab(lab: str, fallos: list[str]) -> int:
    revisados = 0
    with tempfile.TemporaryDirectory() as tmp:
        generar_assets.generar_en(lab, tmp)

        for destino in generar_assets.destinos_de(lab):
            rel_dir = os.path.relpath(destino, ROOT)
            if not os.path.isdir(destino):
                fallos.append(f"falta el directorio {rel_dir}")
                continue

            for nombre in sorted(os.listdir(tmp)):
                esperado = os.path.join(tmp, nombre)
                actual = os.path.join(destino, nombre)
                rel = os.path.join(rel_dir, nombre).replace("\\", "/")

                if not os.path.isfile(actual):
                    fallos.append(f"{rel}: no está versionado")
                    continue

                revisados += 1
                if nombre.endswith(".png"):
                    ok, motivo = _img_igual(esperado, actual)
                elif nombre.endswith(".wav"):
                    ok, motivo = _wav_igual(esperado, actual)
                else:
                    continue
                if not ok:
                    fallos.append(f"{rel}: {motivo}")

            # Un asset de sobra suele ser basura de un renombrado a medias.
            for nombre in sorted(os.listdir(destino)):
                if nombre.endswith((".png", ".wav")) and not os.path.isfile(os.path.join(tmp, nombre)):
                    rel = os.path.join(rel_dir, nombre).replace("\\", "/")
                    fallos.append(f"{rel}: versionado pero el generador ya no lo produce")
    return revisados


def main() -> int:
    fallos: list[str] = []
    revisados = 0

    print("== Verificacion de assets de los laboratorios ==")
    for lab in generar_assets.LABS:
        n = _verificar_lab(lab, fallos)
        print(f"  {lab}: {n} asset(s) comparados")
        revisados += n

    print(f"Assets comparados: {revisados}")

    if fallos:
        print(f"\nFALLO: {len(fallos)} diferencia(s):")
        for f in fallos:
            print(f"  - {f}")
        print("\nSi el cambio es intencionado, ejecuta:  python scripts/generar_assets.py")
        return 1

    print("\nOK: los assets versionados coinciden con el generador.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
