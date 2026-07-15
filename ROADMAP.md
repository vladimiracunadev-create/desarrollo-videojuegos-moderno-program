# 🗺️ Roadmap

El programa se construye por fases. El **currículo escrito** (README completo por cada clase)
es la base y el primer entregable.

## Fase 1 — Currículo escrito ✅ (completa)

- [x] Diseño del currículo: 18 partes, 292 clases, numeración secuencial 001–292.
- [x] Estructura de carpetas + índice maestro y manifest generados (`scripts/generar_indice.py`).
- [x] README rico por parte (18) + README rico por clase (292): objetivo, temas, definiciones, laboratorio guiado, ejercicios, reto verificable, errores comunes, FAQ y referencias.
- [x] **Partes 0–7** (clases 001–155): fundamentos, 2D, 3D, física, shaders, IA, audio y multijugador.
- [x] **Partes 8–17** (clases 156–292): game design, arte, UI/UX, plataformas, web, VR/AR, optimización, tooling, producción y preparación profesional.

**Las 18 partes del currículo escrito están completas.**

## Fase 2 — Laboratorios ejecutables (en curso)

- [ ] Proyecto base de Godot por parte, versionado y clonable.
- [x] Lab **[plataformas 2D](labs/plataformas-2d/README.md)** completo (Parte 1) como repositorio jugable.
- [x] Lab **[3D third-person controller](labs/3d-tercera-persona/README.md)** (Parte 2).
- [x] Lab **[shaders](labs/shaders/README.md)** con ejemplos ejecutables (Parte 4).
- [ ] Lab **multijugador** cliente-servidor mínimo (Parte 7).

Cada lab viene en versión `inicio/` (con `TODO`) y `solucion/`, y las dos se verifican en
CI con Godot headless. Ver **[labs/](labs/README.md)**.

## Fase 3 — Material complementario (en curso)

- [x] Guías **PDF** imprimibles por clase (`scripts/generar_material.py`, en B/N para imprimir).
- [ ] Presentaciones **PPTX** por clase.
- [x] Assets de práctica (sprites, tilesets, texturas y sonidos **CC0 generados por código**:
      `scripts/generar_assets.py`).

## Fase 4 — Portal y evaluación ✅ (completa)

- [x] Sitio web navegable del currículo (GitHub Pages: `scripts/generar_sitio.py` + `deploy-pages.yml`).
- [x] Autoevaluaciones interactivas por parte (`autoevaluaciones/quiz.html`).
- [x] Seguimiento de progreso de las clases (localStorage: `autoevaluaciones/progreso.html`).
- [x] Rutas guiadas por rol (`rutas/README.md`).

---

**Prioridad actual:** cerrar la Fase 2 con el lab de **multijugador** (Parte 7), el único que
queda por construir.
¿Ideas o mejoras? Abre un *issue*.
