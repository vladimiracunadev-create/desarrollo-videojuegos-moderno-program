# 🎨 Lab — Shaders

> [⬅️ Volver a los labs](../README.md) · [📚 Parte 4 del curso](../../classes/parte-4-graficos-shaders-y-rendering-moderno/README.md)

El proyecto que acompaña a la **Parte 4** (clases 086–107) y a su [capstone (clase 107)](../../classes/parte-4-graficos-shaders-y-rendering-moderno/107-capstone-parte-4-set-de-shaders-y-post-procesado/README.md).

## 🎨 Qué es

Una **galería de shaders**: siete shaders que se pasan uno a uno con las flechas, cada uno sobre una textura de prueba y **con un slider por cada `uniform`**, para que puedas tocarlos en marcha y ver qué hace cada línea.

| # | Shader | Qué enseña | Clase |
|---|---|---|---|
| 1 | **UV y color por píxel** | Un fragment shader corre una vez por píxel; UV es dónde estás | 090 |
| 2 | **Distorsión de UV** | No cambies el color: cambia *dónde* lees la textura | 090 |
| 3 | **Disolución** | Ruido + umbral = desintegración, con el borde ardiendo | 095 |
| 4 | **Contorno (outline)** | Mira a tus vecinos: si tú eres transparente y ellos no, eres borde | 095 |
| 5 | **Agua** | Varias ondas desfasadas; una sola siempre se ve falsa | 100 |
| 6 | **Cel shading** | Parece dibujado porque *quita* tonos: `floor(luz * n) / n` | 103 |
| 7 | **CRT (post-procesado)** | Reprocesar la pantalla entera: aberración, scanlines y viñeta | 097 |

**Controles:** `←`/`→` o `A`/`D` para cambiar de shader · `Espacio` para activar el post-procesado CRT sobre lo que estés viendo · `R` para reiniciar.

## 📁 Estructura

```text
shaders/
├── inicio/      ← empieza aquí: completa los TODO
│   ├── project.godot
│   ├── assets/          (textura de prueba y silueta, CC0)
│   ├── escenas/         (galeria.tscn)
│   ├── scripts/         (galeria.gd — infraestructura, ya resuelta)
│   └── shaders/         (los 7 .gdshader con TODO)  ← aquí trabajas tú
└── solucion/    ← referencia completa
```

Aquí la separación es aún más nítida que en los otros labs: **todo lo que hay fuera de `shaders/` es infraestructura ya resuelta**. La galería carga los `.gdshader`, los aplica y te genera los sliders sola. Tú solo escribes GLSL.

En `inicio/` los `uniform` **ya están declarados** (son la interfaz del ejercicio: definen qué mandos vas a tener) y lo que está vacío es el cuerpo de `fragment()`. Al arrancar verás los siete shaders… sin hacer nada: cada uno devuelve la textura tal cual. Ese es tu punto de partida.

## 🚀 Cómo empezar

1. Instala **Godot 4.3+** desde <https://godotengine.org/download>.
2. Godot → *Import* → `labs/shaders/inicio/project.godot` → **F5**.
3. Verás la textura de prueba sin ningún efecto. Ve pasando shaders con `→`: los siete están planos.
4. Abre `shaders/uv.gdshader` y completa los `TODO` **en orden**. Guarda y mira la ventana: **los shaders se recompilan al guardar, sin reiniciar el juego**. Ese bucle de iteración instantáneo es la razón por la que los shaders enganchan.

Sigue el orden del catálogo: cada shader usa algo del anterior. `uv` te enseña qué es UV; `ondas` la mueve; `agua` combina varias ondas; `disolucion` y `outline` introducen ruido y vecinos; `toon` cuantiza; y `post_crt` aplica todo eso a la pantalla entera.

> ¿Atascado? Abre el mismo archivo en `solucion/shaders/` y compara. No es hacer trampa: leer código bueno es parte de aprender.

### Los dos hábitos que valen por toda la Parte 4

1. **Visualiza los valores intermedios.** ¿No entiendes qué hace `ruido(UV * 9.0)`? Píntalo: `COLOR = vec4(vec3(n), 1.0)`. Un shader no se depura con *breakpoints*; se depura **pintando en pantalla** la variable que no entiendes. Es la técnica, no un truco.
2. **Quita cosas para entenderlas.** En `agua`, deja una sola ola en vez de tres y mira lo falso que se ve. En `toon`, pon `bandas` a 12. Casi todos estos efectos se entienden mejor rompiéndolos que leyéndolos.

## 🖼️ Sobre las texturas

Son dos, generadas por código con [`scripts/generar_assets.py`](../../scripts/generar_assets.py) y en dominio público (CC0):

- **`textura_prueba.png`** — damero, degradado y una figura. Cada parte revela una cosa distinta: el damero hace obvias las distorsiones de UV, el degradado los cambios de brillo, y la figura las deformaciones.
- **`silueta.png`** — un cristal opaco sobre fondo **transparente**. El canal alfa es lo que hace posibles el contorno y la disolución: sin transparencia no hay silueta que detectar.

## ✅ Retos para ampliarlo

1. **Un shader 3D**: pasa `toon` a `shader_type spatial` y aplícalo al personaje del [lab 3D](../3d-tercera-persona/README.md) (clase 092).
2. **Ruido de verdad**: cambia el hash de `disolucion` por una `NoiseTexture2D` y compara calidad y coste (clase 091).
3. **Vertex shader**: deforma la geometría en vez de la textura, con `vertex()` (clase 089).
4. **Bloom**: añade un extractor de brillo y un desenfoque al post-procesado (clase 097).
5. **Mide el coste**: activa varios shaders a la vez y mira el tiempo de GPU en el *profiler* (clase 105).
6. **VisualShader**: rehaz `ondas` con el editor de nodos y compara los dos flujos (clase 106).
7. **Tu propio shader**: añade un `.gdshader` nuevo y regístralo en `CATALOGO` (en `scripts/galeria.gd`). La galería le generará los sliders sola.

## 🔍 Verificación

Este proyecto se comprueba automáticamente en CI con **Godot headless**. Aunque no hay GPU, Godot **sí compila el GLSL**: un shader roto suelta `SHADER ERROR` y, además, `get_shader_uniform_list()` le devuelve la lista vacía. La galería aprovecha eso — cuenta los uniforms de cada shader al arrancar y protesta si alguno viene vacío — así que la CI detecta un shader que no compila aunque no pueda dibujar ni un píxel.

```bash
godot --headless --path labs/shaders/solucion --import
godot --headless --path labs/shaders/solucion --quit-after 120
# Debe imprimir: Galería construida: 6 shaders, 23 uniforms
```
