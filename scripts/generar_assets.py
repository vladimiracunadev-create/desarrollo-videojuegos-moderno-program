#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera los assets de los laboratorios (sprites, texturas y SFX) de forma procedural.

Todo lo que produce este script es obra original creada por código, por lo que
se publica bajo **CC0 / dominio público**: no depende de packs de terceros ni
arrastra licencias ajenas. Es reproducible: borra `assets/` y vuelve a correrlo.

Cada laboratorio tiene su propio conjunto de assets (ver LABS) y se genera por
duplicado en sus dos proyectos: `inicio/assets/` y `solucion/assets/`, que deben
ser idénticos.

Uso:  python scripts/generar_assets.py            (todos los labs)
      python scripts/generar_assets.py shaders    (solo ese lab)

Requiere: pip install pillow
"""
from __future__ import annotations

import math
import os
import struct
import sys
import wave

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

#: Los dos proyectos de cada lab, en el orden en que se generan.
PROYECTOS = ("solucion", "inicio")

# Paleta (estilo pixel art plano, alto contraste para buena legibilidad).
PIEL = (255, 205, 160, 255)
PELO = (60, 40, 35, 255)
CAMISA = (60, 120, 216, 255)
PANTALON = (40, 50, 80, 255)
BOTA = (45, 30, 25, 255)
OJO = (25, 25, 30, 255)

HIERBA = (90, 190, 90, 255)
HIERBA_OSC = (60, 150, 65, 255)
TIERRA = (140, 95, 60, 255)
TIERRA_OSC = (110, 72, 45, 255)
PIEDRA = (135, 140, 150, 255)
PIEDRA_OSC = (100, 105, 115, 255)
MADERA = (170, 120, 70, 255)
MADERA_OSC = (130, 90, 50, 255)

ORO = (255, 200, 60, 255)
ORO_OSC = (215, 155, 30, 255)

ENEMIGO = (200, 70, 90, 255)
ENEMIGO_OSC = (160, 45, 65, 255)

VACIO = (0, 0, 0, 0)


# --------------------------------------------------------------------------
# Sprites
# --------------------------------------------------------------------------
def _cuerpo_jugador(d: ImageDraw.ImageDraw, ox: int, oy: int,
                    bob: int = 0, pierna_izq: int = 0, pierna_der: int = 0,
                    brazo: int = 0) -> None:
    """Dibuja un personaje de 32x32 en (ox, oy). Los offsets animan la pose."""
    y = oy + bob
    # Cabeza
    d.rectangle([ox + 11, y + 5, ox + 20, y + 13], fill=PIEL)
    # Pelo
    d.rectangle([ox + 11, y + 4, ox + 20, y + 7], fill=PELO)
    d.rectangle([ox + 10, y + 5, ox + 11, y + 9], fill=PELO)
    # Ojos
    d.rectangle([ox + 14, y + 9, ox + 15, y + 10], fill=OJO)
    d.rectangle([ox + 18, y + 9, ox + 19, y + 10], fill=OJO)
    # Torso
    d.rectangle([ox + 11, y + 14, ox + 20, y + 22], fill=CAMISA)
    # Brazos
    d.rectangle([ox + 8, y + 15 + brazo, ox + 10, y + 21 + brazo], fill=CAMISA)
    d.rectangle([ox + 21, y + 15 - brazo, ox + 23, y + 21 - brazo], fill=CAMISA)
    d.rectangle([ox + 8, y + 21 + brazo, ox + 10, y + 23 + brazo], fill=PIEL)
    d.rectangle([ox + 21, y + 21 - brazo, ox + 23, y + 23 - brazo], fill=PIEL)
    # Piernas
    d.rectangle([ox + 12, y + 23, ox + 15, y + 28 + pierna_izq], fill=PANTALON)
    d.rectangle([ox + 16, y + 23, ox + 19, y + 28 + pierna_der], fill=PANTALON)
    # Botas
    d.rectangle([ox + 12, y + 28 + pierna_izq, ox + 15, y + 30 + pierna_izq], fill=BOTA)
    d.rectangle([ox + 16, y + 28 + pierna_der, ox + 19, y + 30 + pierna_der], fill=BOTA)


def jugador(destino: str) -> None:
    """Spritesheet del jugador: 6 columnas x 4 filas de 32x32 (192x128).

    Fila 0: idle (4 frames) · Fila 1: run (6) · Fila 2: jump (1) · Fila 3: fall (1)
    """
    img = Image.new("RGBA", (192, 128), VACIO)
    d = ImageDraw.Draw(img)

    # Idle: respiración suave.
    for i, bob in enumerate([0, 1, 0, -1][:4]):
        _cuerpo_jugador(d, i * 32, 0, bob=bob)

    # Run: piernas alternando y brazos en contrafase.
    ciclo = [(-3, 3, 2), (-1, 2, 1), (2, 0, -1), (3, -3, -2), (1, -1, -1), (0, 2, 1)]
    for i, (pi, pd, br) in enumerate(ciclo):
        _cuerpo_jugador(d, i * 32, 32, bob=(-1 if i % 3 == 0 else 0),
                        pierna_izq=pi, pierna_der=pd, brazo=br)

    # Jump: piernas recogidas, brazos arriba.
    _cuerpo_jugador(d, 0, 64, bob=-1, pierna_izq=-3, pierna_der=-1, brazo=-3)
    # Fall: piernas estiradas, brazos abajo.
    _cuerpo_jugador(d, 0, 96, bob=1, pierna_izq=1, pierna_der=2, brazo=2)

    img.save(os.path.join(destino, "jugador.png"))


def tileset(destino: str) -> None:
    """Tileset de 4 tiles de 16x16 en una fila (64x16).

    0: hierba (suelo con tapa) · 1: tierra · 2: piedra · 3: plataforma de madera
    """
    img = Image.new("RGBA", (64, 16), VACIO)
    d = ImageDraw.Draw(img)

    # 0 — hierba
    d.rectangle([0, 0, 15, 15], fill=TIERRA)
    d.rectangle([0, 0, 15, 4], fill=HIERBA)
    d.rectangle([0, 5, 15, 5], fill=HIERBA_OSC)
    for x in (2, 7, 12):
        d.rectangle([x, 8, x + 1, 9], fill=TIERRA_OSC)

    # 1 — tierra
    d.rectangle([16, 0, 31, 15], fill=TIERRA)
    for x, y in ((19, 3), (25, 6), (21, 11), (28, 12)):
        d.rectangle([x, y, x + 1, y + 1], fill=TIERRA_OSC)

    # 2 — piedra
    d.rectangle([32, 0, 47, 15], fill=PIEDRA)
    d.rectangle([32, 0, 47, 0], fill=(160, 165, 175, 255))
    for x, y in ((35, 4), (41, 8), (37, 12)):
        d.rectangle([x, y, x + 2, y + 1], fill=PIEDRA_OSC)

    # 3 — plataforma de madera
    d.rectangle([48, 0, 63, 5], fill=MADERA)
    d.rectangle([48, 6, 63, 7], fill=MADERA_OSC)
    for x in (52, 58):
        d.rectangle([x, 0, x, 5], fill=MADERA_OSC)

    img.save(os.path.join(destino, "tileset.png"))


def moneda(destino: str) -> None:
    """Moneda girando: 6 frames de 16x16 (96x16)."""
    img = Image.new("RGBA", (96, 16), VACIO)
    d = ImageDraw.Draw(img)
    anchos = [6, 4, 2, 4, 6, 6]  # semiancho: simula el giro
    for i, w in enumerate(anchos):
        cx = i * 16 + 8
        d.ellipse([cx - w, 3, cx + w - 1, 12], fill=ORO, outline=ORO_OSC)
        if w >= 4:
            d.rectangle([cx - w + 2, 6, cx - w + 3, 9], fill=ORO_OSC)
    img.save(os.path.join(destino, "moneda.png"))


def enemigo(destino: str) -> None:
    """Enemigo tipo babosa: 4 frames de 24x24 (96x24) con squash."""
    img = Image.new("RGBA", (96, 24), VACIO)
    d = ImageDraw.Draw(img)
    for i, squash in enumerate([0, 1, 2, 1]):
        ox = i * 24
        top = 8 + squash
        d.ellipse([ox + 2, top, ox + 21, 22], fill=ENEMIGO, outline=ENEMIGO_OSC)
        d.rectangle([ox + 2, 21, ox + 21, 22], fill=ENEMIGO_OSC)
        # Ojos
        d.rectangle([ox + 7, top + 3, ox + 8, top + 5], fill=(255, 255, 255, 255))
        d.rectangle([ox + 15, top + 3, ox + 16, top + 5], fill=(255, 255, 255, 255))
        d.rectangle([ox + 7, top + 4, ox + 8, top + 5], fill=OJO)
        d.rectangle([ox + 15, top + 4, ox + 16, top + 5], fill=OJO)
    img.save(os.path.join(destino, "enemigo.png"))


# --------------------------------------------------------------------------
# Audio
# --------------------------------------------------------------------------
def _wav(ruta: str, muestras: list[float], sr: int = 44100) -> None:
    with wave.open(ruta, "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes(b"".join(
            struct.pack("<h", max(-32767, min(32767, int(m * 32767)))) for m in muestras))


def _env(i: int, n: int, ataque: float = 0.01, caida: float = 0.6) -> float:
    """Envolvente simple ataque/decaimiento para que no chasquee."""
    t = i / n
    if t < ataque:
        return t / ataque
    return max(0.0, (1.0 - (t - ataque) / (1.0 - ataque)) ** (1.0 / caida))


def _barrido(destino: str, nombre: str, f0: float, f1: float, dur: float,
             sr: int = 44100, vol: float = 0.35, caida: float = 0.6,
             aspereza: float = 1.0) -> None:
    """Barrido de frecuencia de f0 a f1: la base de saltos, golpes y daños.

    `aspereza` mezcla seno y onda cuadrada: 1.0 es cuadrada pura (chirrido de
    consola de 8 bits) y 0.0 es un seno limpio. Los valores intermedios añaden
    armónicos, que es lo que hace que un sonido se perciba "sucio".
    """
    n = int(sr * dur)
    muestras = []
    fase = 0.0
    for i in range(n):
        f = f0 + (f1 - f0) * (i / n)
        fase += 2 * math.pi * f / sr
        s = math.sin(fase)
        s = (1.0 - aspereza) * s + aspereza * math.copysign(1.0, s)
        muestras.append(vol * s * _env(i, n, caida=caida))
    _wav(os.path.join(destino, nombre), muestras)


def _arpegio(destino: str, nombre: str, notas: tuple[float, ...], dur: float,
             sr: int = 44100, vol: float = 0.30) -> None:
    """Notas seguidas en tono puro: suena a 'has cogido algo bueno'."""
    n = int(sr * dur)
    muestras = []
    for f in notas:
        for i in range(n):
            muestras.append(vol * math.sin(2 * math.pi * f * i / sr) * _env(i, n))
    _wav(os.path.join(destino, nombre), muestras)


def sfx(destino: str, sr: int = 44100) -> None:
    # Salto: barrido ascendente (onda cuadrada suave).
    _barrido(destino, "salto.wav", 220.0, 660.0, 0.12, sr)
    # Moneda: dos notas (A5 -> E6), arpegio corto y brillante.
    _arpegio(destino, "moneda.wav", (880.0, 1318.5), 0.10, sr)
    # Daño: barrido descendente y algo sucio (de ahí la aspereza intermedia).
    _barrido(destino, "dano.wav", 400.0, 110.0, 0.22, sr, caida=0.9, aspereza=0.3)


# --------------------------------------------------------------------------
# Texturas (lab de shaders)
# --------------------------------------------------------------------------
def textura_prueba(destino: str) -> None:
    """Textura de 256x256 para probar shaders sobre algo con detalle real.

    Mezcla damero, degradado y una figura: así se ve de un vistazo qué le hace
    un shader a la UV (el damero), al color (el degradado) y a las formas (el
    círculo y las aspas).
    """
    img = Image.new("RGBA", (256, 256), VACIO)
    d = ImageDraw.Draw(img)

    # Degradado vertical de fondo: revela cualquier cambio de brillo o de tono.
    for y in range(256):
        t = y / 255.0
        d.rectangle([0, y, 255, y], fill=(
            int(40 + 60 * t), int(70 + 90 * t), int(130 + 70 * t), 255))

    # Damero de 32px: hace obvias las distorsiones de UV.
    for fy in range(8):
        for fx in range(8):
            if (fx + fy) % 2 == 0:
                continue
            x0, y0 = fx * 32, fy * 32
            d.rectangle([x0, y0, x0 + 31, y0 + 31], fill=(235, 238, 245, 255))

    # Círculo y aspas centrales: referencia de forma para ondas y remolinos.
    d.ellipse([78, 78, 177, 177], fill=ORO, outline=ORO_OSC, width=3)
    d.rectangle([124, 40, 131, 215], fill=ENEMIGO)
    d.rectangle([40, 124, 215, 131], fill=ENEMIGO)

    img.save(os.path.join(destino, "textura_prueba.png"))


def silueta(destino: str) -> None:
    """Figura opaca de 256x256 sobre fondo TRANSPARENTE.

    El canal alfa es el que hace posibles los shaders de contorno y disolución:
    sin transparencia no hay silueta que detectar (clase 095).
    """
    img = Image.new("RGBA", (256, 256), VACIO)
    d = ImageDraw.Draw(img)

    # Cuerpo: un cristal romboidal con facetas, legible a contraluz.
    d.polygon([(128, 18), (214, 128), (128, 238), (42, 128)], fill=(90, 200, 230, 255))
    d.polygon([(128, 18), (128, 238), (42, 128)], fill=(60, 165, 205, 255))
    d.polygon([(128, 18), (170, 128), (128, 238)], fill=(150, 225, 245, 255))
    # Destello: un triángulo claro arriba a la izquierda.
    d.polygon([(128, 46), (100, 118), (128, 118)], fill=(225, 250, 255, 255))

    img.save(os.path.join(destino, "silueta.png"))


# --------------------------------------------------------------------------
# Conjuntos por laboratorio
# --------------------------------------------------------------------------
def generar_plataformas_2d(destino: str) -> None:
    jugador(destino)
    tileset(destino)
    moneda(destino)
    enemigo(destino)
    sfx(destino)


def generar_3d_tercera_persona(destino: str) -> None:
    # El relieve y el personaje son primitivas de Godot (BoxMesh, CapsuleMesh):
    # no hacen falta mallas ni texturas, solo los sonidos.
    _barrido(destino, "salto.wav", 260.0, 720.0, 0.12)
    _arpegio(destino, "cristal.wav", (1046.5, 1568.0), 0.09)
    _arpegio(destino, "portal.wav", (523.3, 659.3, 784.0, 1046.5), 0.13)


def generar_shaders(destino: str) -> None:
    textura_prueba(destino)
    silueta(destino)


#: Registro de laboratorios: nombre de carpeta en labs/ -> qué assets necesita.
#: Añadir un lab con assets es añadir una línea aquí.
LABS = {
    "plataformas-2d": generar_plataformas_2d,
    "3d-tercera-persona": generar_3d_tercera_persona,
    "shaders": generar_shaders,
}


def destinos_de(lab: str) -> list[str]:
    """Los directorios assets/ de los dos proyectos de un lab."""
    return [os.path.join(ROOT, "labs", lab, p, "assets") for p in PROYECTOS]


def generar_en(lab: str, destino: str) -> None:
    """Genera el conjunto de assets de `lab` dentro de `destino`."""
    os.makedirs(destino, exist_ok=True)
    LABS[lab](destino)


def generar(lab: str) -> None:
    """Genera los assets de `lab` en sus dos proyectos (inicio y solucion)."""
    for destino in destinos_de(lab):
        generar_en(lab, destino)
        print(f"  assets generados en {os.path.relpath(destino, ROOT)}")


def main(argv: list[str]) -> int:
    labs = argv[1:] or list(LABS)
    desconocidos = [x for x in labs if x not in LABS]
    if desconocidos:
        print(f"Lab desconocido: {', '.join(desconocidos)}")
        print(f"Labs disponibles: {', '.join(LABS)}")
        return 2

    print("Generando assets CC0 (obra original por código)...")
    for lab in labs:
        print(f"[{lab}]")
        generar(lab)
    print("Listo.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
