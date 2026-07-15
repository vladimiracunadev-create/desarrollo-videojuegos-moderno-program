#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera un sitio estático (site/) a partir de los Markdown del repositorio,
para publicarlo en GitHub Pages. Renderiza el README raíz, el índice de
clases, los README de parte y los README de clase a HTML, reescribiendo
los enlaces internos .md -> .html para que la navegación funcione en el sitio.

Uso:  python scripts/generar_sitio.py
Salida: carpeta site/ con index.html y el árbol de clases en HTML.
Requiere: pip install "markdown>=3.6"
"""
from __future__ import annotations
import glob
import html as htmllib
import json
import os
import re
import shutil

import markdown

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "site")

# Markdown de origen del nivel superior que se publican.
INCLUIR_TOP = ["README.md", "ROADMAP.md", "CONTRIBUTING.md", "SECURITY.md",
               "labs/README.md", "labs/plataformas-2d/README.md",
               "labs/3d-tercera-persona/README.md", "labs/shaders/README.md",
               "rutas/README.md", "autoevaluaciones/README.md", "glosario/README.md"]

LINK_MD = re.compile(r"\]\(([^)]+?)\.md((?:#[^)]*)?)\)")

PLANTILLA = """<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title} · Desarrollo de Videojuegos Moderno</title>
<style>
  :root {{ color-scheme: light dark; --acento:#7c5cff; --acento2:#22d3ee; }}
  * {{ box-sizing: border-box; }}
  body {{
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
    line-height: 1.65; max-width: 900px; margin: 0 auto; padding: 2rem 1.2rem 5rem;
    color: #1b1f24; background: #ffffff;
  }}
  @media (prefers-color-scheme: dark) {{
    body {{ color: #e6edf3; background: #0d1117; }}
    a {{ color: #a78bfa; }}
    code, pre {{ background: #161b22 !important; }}
    table, th, td {{ border-color: #30363d !important; }}
    thead th {{ background: #161b22 !important; }}
  }}
  a {{ color: #6d28d9; text-decoration: none; }}
  a:hover {{ text-decoration: underline; }}
  h1, h2, h3 {{ line-height: 1.25; }}
  h1 {{ border-bottom: 1px solid #d0d7de; padding-bottom: .3em; }}
  h2 {{ border-bottom: 1px solid #d0d7de; padding-bottom: .2em; margin-top: 2rem; }}
  code {{ background: #f2f4f6; padding: .15em .35em; border-radius: 5px; font-size: .9em; }}
  pre {{ background: #f2f4f6; padding: 1rem; border-radius: 8px; overflow-x: auto; }}
  pre code {{ background: transparent; padding: 0; }}
  table {{ border-collapse: collapse; width: 100%; overflow-x: auto; display: block; }}
  th, td {{ border: 1px solid #d0d7de; padding: .5em .75em; text-align: left; }}
  thead th {{ background: #f2f4f6; }}
  blockquote {{ border-left: 4px solid var(--acento); margin: 1rem 0; padding: .2rem 1rem; color: inherit; opacity: .9; }}
  .nav {{ font-size: .9rem; margin-bottom: 1.5rem; opacity: .85; }}
</style>
</head>
<body>
<div class="nav"><a href="{home}">🎮 Inicio</a> · <a href="{indice}">📚 Clases</a> · <a href="{buscar}">🔎 Buscar</a> · <a href="{rutas}">🧭 Rutas</a> · <a href="{quiz}">📝 Autoevaluación</a> · <a href="{progreso}">✅ Progreso</a> · <a href="{labs}">🧪 Labs</a></div>
{body}
</body>
</html>
"""


def reescribir_enlaces(texto: str) -> str:
    """Convierte enlaces internos ...algo.md(#anchor) en ...algo.html(#anchor)."""
    return LINK_MD.sub(lambda m: f"]({m.group(1)}.html{m.group(2)})", texto)


def render(md_text: str) -> str:
    return markdown.markdown(
        md_text,
        extensions=["tables", "fenced_code", "toc", "sane_lists", "attr_list"],
    )


def profundidad(rel: str) -> int:
    return rel.replace("\\", "/").count("/")


def escribir(rel_md: str, md_text: str) -> None:
    rel_html = rel_md[:-3] + ".html"
    destino = os.path.join(OUT, rel_html)
    os.makedirs(os.path.dirname(destino) or OUT, exist_ok=True)
    prof = profundidad(rel_html)
    subir = "../" * prof
    title = "Programa de Desarrollo de Videojuegos Moderno"
    m = re.search(r"^#\s+(.+)$", md_text, re.MULTILINE)
    if m:
        title = re.sub(r"[#*`]", "", m.group(1)).strip()
    html = PLANTILLA.format(
        title=title,
        home=f"{subir}index.html",
        indice=f"{subir}classes/README.html",
        buscar=f"{subir}buscar.html",
        rutas=f"{subir}rutas/README.html",
        quiz=f"{subir}autoevaluaciones/quiz.html",
        progreso=f"{subir}autoevaluaciones/progreso.html",
        labs=f"{subir}labs/README.html",
        body=render(reescribir_enlaces(md_text)),
    )
    with open(destino, "w", encoding="utf-8") as f:
        f.write(html)


LANDING_CSS = """
:root{
  --acento:#7c5cff; --acento2:#22d3ee; --acento3:#f472b6;
  --bg:#ffffff; --bg2:#f5f4fb; --txt:#12181d; --muted:#5b6670; --card:#ffffff; --borde:#e6e2f2;
}
@media (prefers-color-scheme:dark){
  :root{ --bg:#0d1117; --bg2:#12111c; --txt:#e6edf3; --muted:#9aa7b2; --card:#161b22; --borde:#272138; }
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0;font-family:system-ui,-apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;
  background:var(--bg);color:var(--txt);line-height:1.6;-webkit-font-smoothing:antialiased}
a{color:inherit;text-decoration:none}
.wrap{max-width:1040px;margin:0 auto;padding:0 1.1rem}
/* Hero */
.hero{position:relative;overflow:hidden;color:#fff;text-align:center;padding:4.5rem 1.1rem 3.2rem;
  background:radial-gradient(1200px 520px at 50% -10%,#8b5cf6 0%,#5b21b6 45%,#1e1b4b 100%)}
.hero::after{content:"";position:absolute;inset:0;opacity:.12;
  background-image:linear-gradient(#fff 1px,transparent 1px),linear-gradient(90deg,#fff 1px,transparent 1px);
  background-size:32px 32px;mask-image:radial-gradient(circle at 50% 0,#000,transparent 72%)}
.hero>*{position:relative;z-index:1}
.hero .escudo{font-size:3.4rem;line-height:1;filter:drop-shadow(0 4px 16px rgba(0,0,0,.35))}
.hero h1{font-size:clamp(1.8rem,4.5vw,3rem);margin:.4rem 0 .3rem;font-weight:800;letter-spacing:-.5px}
.hero .sub{font-size:clamp(1rem,2.2vw,1.25rem);opacity:.94;max-width:660px;margin:0 auto 1.4rem}
.chips{display:flex;flex-wrap:wrap;gap:.5rem;justify-content:center;margin-bottom:1.6rem}
.chip{background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.28);border-radius:999px;
  padding:.28rem .8rem;font-size:.85rem;font-weight:600;backdrop-filter:blur(4px)}
.cta{display:flex;flex-wrap:wrap;gap:.7rem;justify-content:center}
.btn{display:inline-block;padding:.7rem 1.3rem;border-radius:10px;font-weight:700;font-size:1rem;transition:transform .08s ease,box-shadow .2s}
.btn:hover{transform:translateY(-2px)}
.btn-1{background:#fff;color:#5b21b6;box-shadow:0 6px 22px rgba(0,0,0,.28)}
.btn-2{background:rgba(255,255,255,.14);color:#fff;border:1px solid rgba(255,255,255,.55)}
/* Aviso */
.aviso{background:var(--bg2);border-bottom:1px solid var(--borde);font-size:.9rem;color:var(--muted)}
.aviso .wrap{padding:.7rem 1.1rem;text-align:center}
/* Stats */
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:1rem;margin:2.6rem 0}
.stat{background:var(--card);border:1px solid var(--borde);border-radius:14px;padding:1.1rem;text-align:center}
.stat b{display:block;font-size:1.9rem;color:var(--acento);font-weight:800;line-height:1}
.stat span{font-size:.85rem;color:var(--muted)}
/* Secciones */
h2.sec{font-size:1.5rem;margin:2.6rem 0 1.1rem;font-weight:800}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:1rem}
.feat{background:var(--card);border:1px solid var(--borde);border-radius:14px;padding:1.2rem;transition:border-color .2s,transform .08s}
.feat:hover{border-color:var(--acento);transform:translateY(-2px)}
.feat .ic{font-size:1.7rem}
.feat h3{margin:.5rem 0 .3rem;font-size:1.08rem}
.feat p{margin:0;color:var(--muted);font-size:.92rem}
/* Partes */
.parts{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:.8rem}
.part{position:relative;display:flex;gap:.75rem;align-items:center;background:var(--card);border:1px solid var(--borde);
  border-radius:12px;padding:.8rem .9rem;transition:border-color .2s,transform .08s}
.part:hover{border-color:var(--acento);transform:translateY(-2px)}
.part .num{flex:0 0 auto;width:38px;height:38px;border-radius:10px;display:grid;place-items:center;
  font-weight:800;color:#fff;background:linear-gradient(135deg,var(--acento),#5b21b6)}
.part .t{font-size:.92rem;font-weight:600;line-height:1.25}
.part .c{font-size:.78rem;color:var(--muted)}
.part .estado{position:absolute;top:.5rem;right:.6rem;font-size:.7rem}
.part.soon{opacity:.72}
.part.soon .num{background:linear-gradient(135deg,#94a3b8,#475569)}
/* Footer */
footer{margin-top:3rem;border-top:1px solid var(--borde);background:var(--bg2)}
footer .wrap{padding:2rem 1.1rem;text-align:center;color:var(--muted);font-size:.9rem}
footer a{color:var(--acento);font-weight:600}
"""

# Programa completo planificado (para pintar las 18 partes en la portada).
# 'done' marca las partes ya construidas (con carpeta real en classes/).
PLAN = [
    (0, "Fundamentos y prerrequisitos", 25),
    (1, "Motores 2D y tu primer juego jugable", 20),
    (2, "Desarrollo 3D: motores, escenas y transformaciones", 22),
    (3, "Física y matemáticas de juegos aplicadas", 18),
    (4, "Gráficos, shaders y rendering moderno", 22),
    (5, "Inteligencia artificial para juegos", 18),
    (6, "Audio y música interactiva", 12),
    (7, "Multijugador y networking", 18),
    (8, "Game design y diseño de niveles", 16),
    (9, "Arte, animación y pipeline de assets", 16),
    (10, "UI/UX, accesibilidad y localización", 12),
    (11, "Móvil, consolas y plataformas", 14),
    (12, "Juegos web y HTML5", 14),
    (13, "VR, AR y experiencias inmersivas", 12),
    (14, "Optimización, profiling y rendimiento", 15),
    (15, "Herramientas, editores y automatización", 12),
    (16, "Producción, publicación, monetización y LiveOps", 14),
    (17, "Capstones y preparación profesional / portfolio", 12),
]


def partes_construidas() -> dict[int, dict]:
    """Devuelve info real de las partes con carpeta en classes/."""
    out: dict[int, dict] = {}
    for pdir in glob.glob(os.path.join(ROOT, "classes", "parte-*")):
        m = re.search(r"parte-(\d+)", os.path.basename(pdir))
        if not m:
            continue
        idx = int(m.group(1))
        slug = os.path.basename(pdir)
        nums = [int(re.match(r"^(\d{3})", os.path.basename(c)).group(1))
                for c in glob.glob(os.path.join(pdir, "*"))
                if os.path.isdir(c) and re.match(r"^\d{3}", os.path.basename(c))]
        if nums:
            out[idx] = {"slug": slug, "n": len(nums), "ini": min(nums), "fin": max(nums)}
    return out


def escribir_landing() -> None:
    hechas = partes_construidas()
    total_hechas = sum(p["n"] for p in hechas.values())
    total_plan = sum(n for _, _, n in PLAN)
    stats = [
        (str(total_hechas), "clases listas"),
        (str(len(hechas)), "partes construidas"),
        (str(total_plan), "clases planificadas"),
        ("18", "partes en total"),
        ("3+", "motores (Godot/Unity/Unreal)"),
    ]
    stats_html = "".join(f'<div class="stat"><b>{v}</b><span>{k}</span></div>' for v, k in stats)
    feats = [
        ("📚", "Currículo paso a paso", f"{total_hechas} clases, cada una con objetivo, laboratorio guiado, ejercicios y reto verificable.", "classes/README.html"),
        ("🧪", "Laboratorios ejecutables", "Proyectos Godot reales que se abren y se juegan: versión para completar y solución de referencia, verificadas en CI.", "labs/README.html"),
        ("🧭", "Rutas por rol", "Recorridos ordenados para gameplay, gráficos, indie, móvil/web, multijugador, niveles y XR.", "rutas/README.html"),
        ("📝", "Autoevaluación", "90 preguntas (una batería por parte) con explicación de cada respuesta.", "autoevaluaciones/quiz.html"),
        ("✅", "Tu progreso", f"Marca las {total_hechas} clases y sigue tu avance (se guarda en tu navegador).", "autoevaluaciones/progreso.html"),
        ("🔎", "Buscador", "Encuentra cualquier tema entre las 292 clases: shaders, coyote time, navmesh, rollback…", "buscar.html"),
    ]
    feats_html = "".join(
        f'<a class="feat" href="{u}"><div class="ic">{i}</div><h3>{t}</h3><p>{d}</p></a>'
        for i, t, d, u in feats)

    partes_html = []
    for idx, titulo, n_plan in PLAN:
        info = hechas.get(idx)
        if info:
            href = f'classes/{info["slug"]}/README.html'
            meta = f'{info["n"]} clases · {info["ini"]:03d}–{info["fin"]:03d}'
            partes_html.append(
                f'<a class="part" href="{href}"><div class="num">{idx}</div>'
                f'<div><div class="t">{htmllib.escape(titulo)}</div>'
                f'<div class="c">{meta}</div></div><span class="estado">✅</span></a>')
        else:
            partes_html.append(
                f'<div class="part soon"><div class="num">{idx}</div>'
                f'<div><div class="t">{htmllib.escape(titulo)}</div>'
                f'<div class="c">{n_plan} clases · próximamente</div></div>'
                f'<span class="estado">🔜</span></div>')
    parts_html = "".join(partes_html)

    cuerpo = f"""
<header class="hero">
  <div class="escudo">🎮</div>
  <h1>Desarrollo de Videojuegos Moderno</h1>
  <p class="sub">De las matemáticas y el game loop a un juego completo y publicable — con Godot, Unity y Unreal, paso a paso y en español.</p>
  <div class="chips">
    <span class="chip">{total_hechas} clases listas</span><span class="chip">18 partes</span>
    <span class="chip">Fundamentos → Profesional</span><span class="chip">Godot · Unity · Unreal</span><span class="chip">MIT</span>
  </div>
  <div class="cta">
    <a class="btn btn-1" href="classes/README.html">📚 Empezar el curso</a>
    <a class="btn btn-2" href="rutas/README.html">🧭 Elegir mi ruta</a>
    <a class="btn btn-2" href="buscar.html">🔎 Buscar</a>
  </div>
</header>
<div class="aviso"><div class="wrap">🕹️ Curso abierto (MIT) · <b>292 clases en 18 partes</b> · con <a href="labs/README.html">laboratorios Godot ejecutables</a> verificados en CI.</div></div>
<main class="wrap">
  <div class="stats">{stats_html}</div>
  <h2 class="sec">Qué incluye</h2>
  <div class="grid">{feats_html}</div>
  <h2 class="sec">Las 18 partes</h2>
  <div class="parts">{parts_html}</div>
</main>
<footer><div class="wrap">
  Programa de Desarrollo de Videojuegos Moderno · {total_hechas} clases listas · licencia
  <a href="https://github.com/vladimiracunadev-create/modern-gamedev-program">MIT en GitHub</a><br>
  <a href="classes/README.html">Índice de clases</a> · <a href="ROADMAP.html">Roadmap</a>
</div></footer>
"""
    doc = (f"<!doctype html><html lang='es'><head><meta charset='utf-8'>"
           f"<meta name='viewport' content='width=device-width,initial-scale=1'>"
           f"<title>Programa de Desarrollo de Videojuegos Moderno</title>"
           f"<style>{LANDING_CSS}</style></head><body>{cuerpo}</body></html>")
    with open(os.path.join(OUT, "index.html"), "w", encoding="utf-8") as f:
        f.write(doc)


TEMA_RE = re.compile(r"^\|\s*\d+\s*\|\s*([^|]+?)\s*\|", re.MULTILINE)
H1_CLASE_RE = re.compile(r"^#\s+Clase\s+(\d{3})\s*[—-]\s*(.+)$", re.MULTILINE)

BUSCAR_HTML = """<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Buscar · Desarrollo de Videojuegos Moderno</title>
<style>
  :root{--acento:#7c5cff;--bg:#fff;--bg2:#f5f4fb;--txt:#12181d;--muted:#5b6670;--card:#fff;--borde:#e6e2f2}
  @media (prefers-color-scheme:dark){:root{--bg:#0d1117;--bg2:#12111c;--txt:#e6edf3;--muted:#9aa7b2;--card:#161b22;--borde:#272138}}
  *{box-sizing:border-box}
  body{margin:0;font-family:system-ui,-apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;
    background:var(--bg);color:var(--txt);line-height:1.6}
  a{color:var(--acento);text-decoration:none}
  a:hover{text-decoration:underline}
  header{background:linear-gradient(135deg,#7c5cff,#5b21b6);color:#fff;padding:2rem 1.1rem;text-align:center}
  header h1{margin:.2rem 0;font-size:1.6rem}
  .wrap{max-width:820px;margin:0 auto;padding:0 1.1rem 4rem}
  .nav{font-size:.9rem;margin:1rem 0;opacity:.85}
  #q{width:100%;padding:.8rem 1rem;font-size:1.05rem;border:2px solid var(--borde);border-radius:10px;
     background:var(--card);color:var(--txt)}
  #q:focus{outline:none;border-color:var(--acento)}
  .meta{color:var(--muted);font-size:.9rem;margin:.8rem 0}
  .r{background:var(--card);border:1px solid var(--borde);border-radius:10px;padding:.7rem .9rem;margin:.5rem 0}
  .r:hover{border-color:var(--acento)}
  .r .t{font-weight:600}
  .r .p{font-size:.82rem;color:var(--muted)}
  .r .tm{font-size:.82rem;color:var(--muted);margin-top:.2rem}
  mark{background:color-mix(in srgb,var(--acento) 30%,transparent);color:inherit;border-radius:3px}
  footer{text-align:center;color:var(--muted);font-size:.85rem;padding:2rem 1rem}
</style>
</head>
<body>
<header>
  <div style="font-size:2rem">🔎</div>
  <h1>Buscar en el curso</h1>
</header>
<div class="wrap">
  <div class="nav"><a href="index.html">🎮 Inicio</a> · <a href="classes/README.html">📚 Clases</a> · <a href="rutas/README.html">🧭 Rutas</a> · <a href="autoevaluaciones/quiz.html">📝 Autoevaluación</a></div>
  <input id="q" type="search" placeholder="Escribe: shader, coyote time, navmesh, rollback, wishlists…" autofocus autocomplete="off">
  <div class="meta" id="meta">Cargando índice…</div>
  <div id="res"></div>
</div>
<footer>Busca por título de clase o por tema. Todo ocurre en tu navegador.</footer>
<script>
let IDX = [];
const $ = i => document.getElementById(i);
const norm = s => String(s).normalize('NFD').replace(/[\\u0300-\\u036f]/g, '').toLowerCase();

fetch('busqueda.json').then(r => r.json()).then(d => {
  IDX = d.map(c => ({...c, _b: norm(c.t + ' ' + c.p + ' ' + c.tm)}));
  $('meta').textContent = IDX.length + ' clases indexadas. Escribe para buscar.';
}).catch(() => { $('meta').textContent = 'No se pudo cargar el índice.'; });

$('q').oninput = () => {
  const t = $('q').value.trim();
  if (!t) { $('res').innerHTML = ''; $('meta').textContent = IDX.length + ' clases indexadas. Escribe para buscar.'; return; }
  const términos = norm(t).split(/\\s+/).filter(Boolean);
  const hits = IDX.filter(c => términos.every(w => c._b.includes(w))).slice(0, 60);
  $('meta').textContent = hits.length ? hits.length + ' resultado(s)' : 'Sin resultados para "' + t + '"';
  $('res').innerHTML = hits.map(c => `
    <div class="r">
      <div class="t"><a href="${c.u}">${String(c.n).padStart(3,'0')} — ${res(c.t, términos)}</a></div>
      <div class="p">Parte ${c.pi} · ${esc(c.p)}</div>
      ${c.tm ? `<div class="tm">${res(c.tm.slice(0, 160), términos)}…</div>` : ''}
    </div>`).join('');
};

function esc(s){return String(s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}
function res(txt, ws){
  let h = esc(txt);
  ws.forEach(w => {
    const n = norm(h);
    let i = n.indexOf(w), out = '', last = 0;
    while (i !== -1) { out += h.slice(last, i) + '<mark>' + h.slice(i, i + w.length) + '</mark>'; last = i + w.length; i = n.indexOf(w, last); }
    h = out + h.slice(last);
  });
  return h;
}
</script>
</body>
</html>
"""


def construir_busqueda() -> int:
    """Índice de búsqueda: número, título, parte y temas de cada clase."""
    entradas = []
    for pdir in sorted(glob.glob(os.path.join(ROOT, "classes", "parte-*")),
                       key=lambda p: int(re.search(r"parte-(\d+)", p).group(1))):
        pidx = int(re.search(r"parte-(\d+)", os.path.basename(pdir)).group(1))
        pslug = os.path.basename(pdir)
        ptitulo = pslug
        prm = os.path.join(pdir, "README.md")
        if os.path.isfile(prm):
            m = re.search(r"^#\s+Parte\s+\d+\s*[—-]\s*(.+)$",
                          open(prm, encoding="utf-8").read(), re.MULTILINE)
            if m:
                ptitulo = m.group(1).strip()

        for cdir in sorted(glob.glob(os.path.join(pdir, "*"))):
            base = os.path.basename(cdir)
            rm = os.path.join(cdir, "README.md")
            if not (os.path.isdir(cdir) and re.match(r"^\d{3}-", base) and os.path.isfile(rm)):
                continue
            txt = open(rm, encoding="utf-8").read()
            m = H1_CLASE_RE.search(txt)
            if not m:
                continue
            # Temas: primera columna de la tabla "🗺️ Temas".
            temas = ""
            sec = txt.split("## 🗺️ Temas", 1)
            if len(sec) == 2:
                tabla = sec[1].split("##", 1)[0]
                temas = " · ".join(t.strip() for t in TEMA_RE.findall(tabla))
            entradas.append({
                "n": int(m.group(1)),
                "t": m.group(2).strip(),
                "p": ptitulo,
                "pi": pidx,
                "tm": temas,
                "u": f"classes/{pslug}/{base}/README.html",
            })

    entradas.sort(key=lambda e: e["n"])
    with open(os.path.join(OUT, "busqueda.json"), "w", encoding="utf-8") as f:
        json.dump(entradas, f, ensure_ascii=False, separators=(",", ":"))
    with open(os.path.join(OUT, "buscar.html"), "w", encoding="utf-8") as f:
        f.write(BUSCAR_HTML)
    return len(entradas)


def copiar_interactivos() -> int:
    """Copia las páginas que ya son HTML autocontenido y los datos que consumen."""
    n = 0
    destino = os.path.join(OUT, "autoevaluaciones")
    os.makedirs(destino, exist_ok=True)
    for nombre in ("quiz.html", "progreso.html", "preguntas.json"):
        origen = os.path.join(ROOT, "autoevaluaciones", nombre)
        if os.path.isfile(origen):
            shutil.copyfile(origen, os.path.join(destino, nombre))
            n += 1
    # progreso.html lee el manifest para listar las 292 clases.
    manifest = os.path.join(ROOT, "classes", "_manifest.json")
    if os.path.isfile(manifest):
        os.makedirs(os.path.join(OUT, "classes"), exist_ok=True)
        shutil.copyfile(manifest, os.path.join(OUT, "classes", "_manifest.json"))
        n += 1
    return n


def main() -> int:
    if os.path.isdir(OUT):
        shutil.rmtree(OUT)
    os.makedirs(OUT, exist_ok=True)

    generados = 0

    # Documentos del nivel superior.
    for rel in INCLUIR_TOP:
        p = os.path.join(ROOT, rel)
        if os.path.isfile(p):
            escribir(rel, open(p, encoding="utf-8").read())
            generados += 1

    # Todo el árbol de classes/.
    for cur, _, files in os.walk(os.path.join(ROOT, "classes")):
        for fn in files:
            if fn.endswith(".md"):
                p = os.path.join(cur, fn)
                rel = os.path.relpath(p, ROOT).replace("\\", "/")
                escribir(rel, open(p, encoding="utf-8").read())
                generados += 1

    # Portada diseñada (el README raíz abre con <div align=center> + badges,
    # que no se renderiza bien como landing; usamos una portada propia).
    escribir_landing()

    n_busqueda = construir_busqueda()
    n_copias = copiar_interactivos()

    # .nojekyll para que Pages no ignore archivos con nombres especiales.
    open(os.path.join(OUT, ".nojekyll"), "w").close()

    print(f"Sitio generado en site/  ({generados} páginas HTML + index.html + "
          f"buscador con {n_busqueda} clases + {n_copias} archivos interactivos)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
