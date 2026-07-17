#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Corre en local lo mismo que la CI. Úsalo ANTES de pushear a main.

En este repo se sube directo a main, así que main es lo que ve la gente: no hay
una rama intermedia donde descubrir que algo se ha roto. Esto lo comprueba antes,
en tu máquina, en un par de minutos.

Qué corre
---------
1. Estructura y enlaces  (validar_estructura.py)
2. Índice y manifest sincronizados  (generar_indice.py, y que no cambie nada)
3. Assets deterministas  (verificar_assets.py)
4. Markdown  (markdownlint-cli2, si hay npx)
5. Build del sitio  (generar_sitio.py)
6. YAML de los workflows
7. Los laboratorios con Godot headless: la matriz entera (cada lab × inicio y
   solución) más las pruebas de comportamiento (red, IA y UI).

Lo de Godot solo corre si le dices dónde está: aquí no viene instalado.

    python scripts/verificar_todo.py --godot /ruta/a/godot
    python scripts/verificar_todo.py --rapido          # sin los labs

La matriz de labs NO está copiada aquí: se lee de .github/workflows/labs.yml. Si
se copiara, el día que alguien añada un lab al workflow este script seguiría
comprobando los de antes y diría que todo va bien.

Salida: 0 si todo está verde; 1 si algo falla (y entonces no pushees).
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import shutil
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORKFLOW = os.path.join(ROOT, ".github", "workflows", "labs.yml")

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

VERDE = "OK  "
ROJO = "FALLA"

#: Errores que se ignoran en los logs de Godot, con su motivo. Cada entrada aquí
#: es una promesa de que se ha investigado y no es culpa del lab.
RUIDO = [
    # ENet se queja si un peer se desconecta con algo en vuelo hacia él. Es una
    # carrera del motor: pasa igual desactivando todos los RPC del lab.
    "Unable to send packet on channel",
]

PATRON_ERROR = re.compile(
    r"SCRIPT ERROR|Parse Error|ERROR:|SHADER ERROR|Failed loading resource|Cannot call method")


class Resultado:
    def __init__(self) -> None:
        self.fallos: list[str] = []
        self.hechas: int = 0

    def check(self, ok: bool, titulo: str, detalle: str = "") -> bool:
        self.hechas += 1
        print(f"  {VERDE if ok else ROJO}  {titulo}")
        if not ok:
            self.fallos.append(titulo)
            if detalle:
                for linea in detalle.strip().splitlines()[:6]:
                    print(f"          {linea}")
        return ok


def correr(cmd: list[str], cwd: str = ROOT, timeout: int = 900) -> tuple[int, str]:
    try:
        p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True,
                           encoding="utf-8", errors="replace", timeout=timeout)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except FileNotFoundError:
        return 127, f"no se encontró el ejecutable: {cmd[0]}"
    except subprocess.TimeoutExpired:
        return 124, f"se pasó del tiempo ({timeout}s)"


def limpio(log: str) -> str:
    """El log sin el ruido conocido del motor."""
    return "\n".join(l for l in log.splitlines()
                     if not any(r in l for r in RUIDO))


def hay_errores(log: str) -> str:
    for linea in limpio(log).splitlines():
        if PATRON_ERROR.search(linea):
            return linea
    return ""


# --------------------------------------------------------------------------
# 1-6: lo que no necesita Godot
# --------------------------------------------------------------------------
def verificar_repo(r: Resultado) -> None:
    print("\n[1/7] Estructura y enlaces")
    cod, out = correr([sys.executable, "scripts/validar_estructura.py"])
    r.check(cod == 0, "estructura y enlaces íntegros", out)

    print("\n[2/7] Índice, navegación y manual sincronizados")
    correr([sys.executable, "scripts/generar_indice.py"])
    cod, out = correr(["git", "status", "--porcelain",
                       "classes/_manifest.json", "classes/README.md"])
    r.check(out.strip() == "", "el índice y el manifest ya estaban sincronizados",
            "regenerarlos cambia archivos: haz commit de ellos\n" + out)

    cod, out = correr([sys.executable, "scripts/generar_navegacion.py", "--check"])
    r.check(cod == 0, "la navegación entre clases está al día", out)

    cod, out = correr([sys.executable, "scripts/generar_manual.py", "--check"])
    r.check(cod == 0, "el manual completo está al día", out)

    print("\n[3/7] Assets")
    cod, out = correr([sys.executable, "scripts/verificar_assets.py"])
    r.check(cod == 0, "los assets coinciden con el generador", out)

    print("\n[4/7] Markdown")
    npx = shutil.which("npx") or shutil.which("npx.cmd")
    if npx is None:
        print("  ....  markdownlint omitido (no hay npx)")
    else:
        cod, out = correr([npx, "markdownlint-cli2", "**/*.md", "#node_modules"])
        r.check(cod == 0, "markdownlint sin errores", out)

    print("\n[5/7] Sitio")
    cod, out = correr([sys.executable, "scripts/generar_sitio.py"])
    r.check(cod == 0, "el sitio se genera", out)

    print("\n[6/7] YAML de los workflows")
    try:
        import yaml  # noqa: F401
    except ImportError:
        print("  ....  omitido (falta pyyaml)")
        return
    malos: list[str] = []
    for f in sorted(glob.glob(os.path.join(ROOT, ".github", "workflows", "*.yml"))):
        cod, out = correr([sys.executable, "-c",
                           "import sys,yaml;yaml.safe_load(open(sys.argv[1],encoding='utf-8'))", f])
        if cod != 0:
            malos.append(f"{os.path.basename(f)}: {out.strip().splitlines()[-1] if out.strip() else 'error'}")
    r.check(not malos, f"los {len(glob.glob(os.path.join(ROOT, '.github', 'workflows', '*.yml')))} workflows parsean",
            "\n".join(malos))


# --------------------------------------------------------------------------
# 7: los labs
# --------------------------------------------------------------------------
def leer_matriz() -> list[tuple[str, str, str]]:
    """(lab, proyecto, marcador) leídos del workflow, para no duplicarlo aquí."""
    import yaml
    with open(WORKFLOW, encoding="utf-8") as f:
        wf = yaml.safe_load(f)
    m = wf["jobs"]["godot"]["strategy"]["matrix"]
    marcadores = {inc["lab"]: inc["marcador"] for inc in m.get("include", [])
                  if "lab" in inc and "marcador" in inc}
    combos: list[tuple[str, str, str]] = []
    for lab in m["lab"]:
        for proy in m["proyecto"]:
            combos.append((lab, proy, marcadores.get(lab, "")))
    return combos


def verificar_labs(r: Resultado, godot: str) -> None:
    print("\n[7/7] Laboratorios (Godot headless)")
    for lab, proy, marcador in leer_matriz():
        etiqueta = f"{lab}/{proy}"
        if not marcador:
            r.check(False, f"{etiqueta}: sin marcador en la matriz de labs.yml")
            continue

        proyecto = os.path.join(ROOT, "labs", lab, proy)
        if not os.path.isdir(proyecto):
            r.check(False, f"{etiqueta}: no existe {proyecto}")
            continue

        # Doble import: el primero genera los derivados que el project.godot ya
        # referencia (las traducciones del lab de UI); el segundo es el que vale.
        correr([godot, "--headless", "--path", proyecto, "--import"])
        _, imp = correr([godot, "--headless", "--path", proyecto, "--import"])
        err = hay_errores(imp)
        if not r.check(not err, f"{etiqueta}: importa limpio", err):
            continue

        _, run = correr([godot, "--headless", "--path", proyecto, "--quit-after", "300"])
        err = hay_errores(run)
        if not r.check(not err, f"{etiqueta}: arranca sin errores", err):
            continue
        r.check(marcador in run, f"{etiqueta}: imprime «{marcador}»", run)


def prueba_ia(r: Resultado, godot: str) -> None:
    proyecto = os.path.join(ROOT, "labs", "ia-enemigo", "solucion")
    if not os.path.isdir(proyecto):
        return
    print("\n      · prueba de comportamiento (IA)")
    _, log = correr([godot, "--headless", "--path", proyecto,
                     "--quit-after", "1500", "--", "--bot"])
    estados = re.findall(r"^IA: (\w+)$", log, re.M)
    secuencia = " ".join(estados)
    ok = (estados[:1] == ["patrulla"] and "persecucion" in estados
          and "busqueda" in estados and estados[-1:] == ["patrulla"])
    r.check(ok, f"la IA decide: {secuencia or '(nada)'}", log)


def prueba_ui(r: Resultado, godot: str) -> None:
    proyecto = os.path.join(ROOT, "labs", "ui-accesible", "solucion")
    if not os.path.isdir(proyecto):
        return
    print("\n      · prueba de la interfaz (UI)")
    _, log = correr([godot, "--headless", "--path", proyecto,
                     "res://escenas/verificar.tscn"])
    m = re.search(r"== (\d+) comprobaciones, (\d+) fallo", log)
    if not m:
        r.check(False, "la prueba de UI llega al final", log)
        return
    hechas, fallos = int(m.group(1)), int(m.group(2))
    r.check(hechas >= 15 and fallos == 0,
            f"la UI aguanta: {hechas} comprobaciones, {fallos} fallo(s)", log)


def prueba_red(r: Resultado, godot: str) -> None:
    proyecto = os.path.join(ROOT, "labs", "multijugador", "solucion")
    if not os.path.isdir(proyecto):
        return
    print("\n      · prueba de red (multijugador)")

    # Los logs van a ARCHIVO y no a un pipe. Con stdout=PIPE y varios procesos a
    # la vez, nadie lee esos pipes hasta el final: se llenan, el proceso se queda
    # bloqueado escribiendo y deja de atender la red. El resultado es un servidor
    # que nunca ve a nadie conectarse — y parece un fallo del lab cuando es del
    # arnés de pruebas.
    tmp = os.path.join(ROOT, ".verif_red")
    os.makedirs(tmp, exist_ok=True)

    def lanzar(nombre: str, extra: list[str], segundos: str) -> tuple[subprocess.Popen, str]:
        ruta = os.path.join(tmp, f"{nombre}.log")
        fh = open(ruta, "w", encoding="utf-8")
        p = subprocess.Popen(
            [godot, "--headless", "--path", proyecto, "--"] + extra + ["--segundos", segundos],
            stdout=fh, stderr=subprocess.STDOUT)
        p._fh = fh  # type: ignore[attr-defined]
        return p, ruta

    def leer(ruta: str) -> str:
        try:
            with open(ruta, encoding="utf-8", errors="replace") as f:
                return f.read()
        except OSError:
            return ""

    servidor, ruta_srv = lanzar("servidor", ["--server"], "18")

    # Esperar a que escuche de verdad, en vez de dormir a ciegas.
    for _ in range(30):
        if "Servidor escuchando:" in leer(ruta_srv):
            break
        time.sleep(1)

    procesos = []
    rutas = []
    for i, modo in enumerate(("--bot", "--bot", "--tramposo")):
        p, ruta = lanzar(f"cliente{i}", ["--conectar", "127.0.0.1", modo], "7")
        procesos.append(p)
        rutas.append(ruta)

    for p in procesos:
        p.wait(timeout=120)
    servidor.wait(timeout=120)
    for p in list(procesos) + [servidor]:
        p._fh.close()  # type: ignore[attr-defined]

    logs = [leer(x) for x in rutas]
    log_srv = leer(ruta_srv)
    shutil.rmtree(tmp, ignore_errors=True)

    peers = len(re.findall(r"Peer conectado:", log_srv))
    r.check(peers >= 3, f"el servidor ve a los 3 clientes (vio {peers})", log_srv)

    m = re.search(r"\(local\): (\d+) confirmacion\(es\), (\d+) correccion", logs[0])
    if not m:
        r.check(False, "el cliente informa de su predicción", logs[0])
    else:
        conf, corr = int(m.group(1)), int(m.group(2))
        r.check(conf > 20 and corr <= conf // 5,
                f"la predicción acierta: {corr} corrección(es) de {conf} confirmaciones")

    r.check("Input rechazado" in log_srv, "el servidor rechaza al cliente tramposo", log_srv)

    for nombre, log in [("servidor", log_srv), ("cliente", logs[0])]:
        err = hay_errores(log)
        r.check(not err, f"el {nombre} no suelta errores", err)


def limpiar_derivados() -> None:
    for patron in ("**/*.import", "**/*.translation"):
        for f in glob.glob(os.path.join(ROOT, "labs", patron), recursive=True):
            os.remove(f)
    for d in glob.glob(os.path.join(ROOT, "labs", "*", "*", ".godot")):
        shutil.rmtree(d, ignore_errors=True)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--godot", default=os.environ.get("GODOT_BIN", ""),
                    help="ruta al ejecutable de Godot 4.3 (o variable GODOT_BIN)")
    ap.add_argument("--rapido", action="store_true",
                    help="salta los labs (solo validadores: unos segundos)")
    args = ap.parse_args()

    print("== Verificación completa (lo mismo que la CI) ==")
    inicio = time.time()
    r = Resultado()

    verificar_repo(r)

    if args.rapido:
        print("\n[7/7] Laboratorios: OMITIDOS (--rapido)")
    elif not args.godot:
        print("\n[7/7] Laboratorios: OMITIDOS (falta --godot RUTA)")
        print("      Sin esto NO sabes si los labs siguen verdes: la mitad de la CI")
        print("      son ellos. Baja Godot 4.3 y pásaselo, o usa --rapido a sabiendas.")
        r.fallos.append("labs sin verificar (no se indicó --godot)")
    elif not os.path.isfile(args.godot) and shutil.which(args.godot) is None:
        print(f"\n[7/7] Laboratorios: no encuentro Godot en '{args.godot}'")
        r.fallos.append("labs sin verificar (Godot no encontrado)")
    else:
        verificar_labs(r, args.godot)
        prueba_ia(r, args.godot)
        prueba_ui(r, args.godot)
        prueba_red(r, args.godot)
        limpiar_derivados()

    segundos = time.time() - inicio
    print(f"\n== {r.hechas} comprobaciones en {segundos:.0f}s ==")
    if r.fallos:
        print(f"\n{len(r.fallos)} FALLO(S) — NO pushees:")
        for f in r.fallos:
            print(f"  - {f}")
        return 1

    print("\nTodo verde. Puedes pushear a main.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
