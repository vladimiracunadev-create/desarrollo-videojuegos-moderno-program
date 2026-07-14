# Clase 186 — Pipeline de assets: nomenclatura, LODs y optimización

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Godot 4 (Importing 3D scenes & LOD)*
> ⏱️ Duración estimada: **105 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Un juego no falla solo por arte feo: falla por **arte desordenado**. Cientos de mallas, texturas, materiales y animaciones que nadie sabe nombrar, presupuestos que se disparan sin que nadie mire, y assets que llegan al motor con la escala mal o pesando diez veces lo necesario. El **pipeline de assets** es el conjunto de convenciones y pasos que lleva un modelo desde la herramienta de arte (DCC) hasta el motor de forma **predecible, ligera y buscable**.

En esta clase definirás una **convención de nomenclatura y carpetas**, fijarás **presupuestos** de polígonos y texturas, y entenderás los **LODs** (niveles de detalle) y los **ajustes de importación**. Es la clase con más "sistema" y algo más de código —para automatizar el naming— porque el objetivo es que el flujo escale. El laboratorio consiste en aplicar una convención a un set de assets y configurar su importación y LOD en Godot 4; el entregable es un pequeño set ordenado, importado y con presupuesto documentado.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diseñar una **convención de nomenclatura** y estructura de carpetas para assets.
2. Definir **presupuestos** de polígonos y texturas por categoría de asset.
3. Explicar qué son los **LODs** y cómo Godot los genera y usa automáticamente.
4. Configurar **ajustes de importación** (escala, materiales, compresión) al llevar del DCC al motor.
5. Automatizar el **renombrado** de un lote de archivos con un script sencillo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Por qué existe el pipeline | Sin orden, el proyecto se vuelve inmanejable al crecer. |
| 2 | Nomenclatura y carpetas | Nombres consistentes hacen todo buscable y automatizable. |
| 3 | Presupuestos (poly/textura) | Fijan límites antes de que el rendimiento se degrade. |
| 4 | LODs | Bajan el detalle con la distancia y salvan frames. |
| 5 | Ajustes de importación | Escala, ejes y materiales correctos evitan sorpresas. |
| 6 | Compresión de texturas | Reduce memoria de VRAM sin perder calidad perceptible. |
| 7 | Del DCC al motor (formatos) | glTF/GLB es el estándar para un intercambio fiable. |
| 8 | Automatización del naming | Un script evita errores humanos en lotes grandes. |

## 📖 Definiciones y características

- **Pipeline de assets**: flujo definido de creación → export → import → uso. Clave: hace el proceso repetible y auditable.
- **Convención de nomenclatura**: reglas de nombres (prefijos, sufijos, separadores). Clave: `SM_`, `T_`, `_D`, `_N` comunican tipo de un vistazo.
- **Presupuesto (budget)**: límite acordado de polígonos, texturas o draw calls. Clave: se decide antes, no cuando el juego ya va lento.
- **LOD (Level of Detail)**: versiones simplificadas de una malla según distancia. Clave: menos polígonos donde no se notan.
- **Import settings**: parámetros con que el motor procesa un archivo. Clave: escala y materiales mal puestos rompen la escena.
- **glTF / GLB**: formato abierto de intercambio 3D (malla, materiales, animación). Clave: el más fiable de DCC a Godot.
- **Compresión VRAM**: formato comprimido de textura en GPU (p. ej. VRAM Compressed). Clave: ahorra memoria a costa de calidad mínima.
- **Draw call**: orden de dibujo que el motor envía a la GPU. Clave: menos llamadas (atlas, instancing) = más rendimiento.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** (<https://godotengine.org/download>) y tu DCC (**Blender 4.x**) para exportar. El puente recomendado es **glTF 2.0 (.glb)**: Blender exporta con *File → Export → glTF 2.0*, y Godot lo importa nativamente con el **Import dock**. Prepara un set pequeño de assets (p. ej. 3 props y un personaje simple de clases previas). Crea la estructura de carpetas del proyecto Godot bajo `res://`. Para el script de renombrado usa cualquier terminal con **Python 3** o **PowerShell**; ambos sirven. Ten a la vista la documentación de importación 3D de Godot y su sección de LOD automático (Godot genera LODs al importar mallas).

## 🧪 Laboratorio guiado

Definirás una convención y un presupuesto, los aplicarás a un set y configurarás import/LOD en Godot.

1. **Define la convención.** Acuerda reglas escritas, por ejemplo:
   - Mallas estáticas: `SM_<Categoria>_<Nombre>` → `SM_Prop_Barril`.
   - Mallas con esqueleto: `SK_<Nombre>` → `SK_Aldeano`.
   - Texturas: `T_<Asset>_<Tipo>` → `T_Barril_D` (Diffuse), `_N` (Normal), `_ORM` (Occlusion/Rough/Metal).
   - Materiales: `M_<Asset>`. Sin espacios, sin acentos, sin mayúsculas mezcladas al azar.

2. **Estructura de carpetas.** Bajo `res://` crea `assets/props/`, `assets/personajes/`, `assets/materiales/`, `assets/texturas/`. Cada asset vive con sus dependencias localizables.

3. **Fija presupuestos.** Documenta límites por categoría, por ejemplo: prop de fondo ≤ 1.500 tris y textura 1K; prop destacado ≤ 8.000 tris y 2K; personaje simple ≤ 20.000 tris y 2K. Anótalos en un `PRESUPUESTO.md` del proyecto.

4. **Exporta desde Blender.** Aplica transformaciones (*Ctrl+A*), verifica **escala 1.0** y export **glTF 2.0 (.glb)** con *+Y up*. Nombra el archivo según la convención (`SM_Prop_Barril.glb`).

5. **Automatiza el renombrado del lote.** Si tus archivos vienen con nombres sucios, normalízalos con un script. Ejemplo en Python:

```python
# renombra a minúsculas, sin espacios ni acentos, con prefijo de tipo.
import unicodedata, re
from pathlib import Path

def limpiar(nombre: str) -> str:
    s = unicodedata.normalize("NFKD", nombre).encode("ascii", "ignore").decode()
    s = re.sub(r"[^\w.-]+", "_", s.strip())  # espacios/símbolos -> _
    return s.lower()

for f in Path("export_bruto").glob("*.glb"):
    nuevo = f.with_name("SM_Prop_" + limpiar(f.stem) + f.suffix)
    print(f.name, "->", nuevo.name)
    f.rename(nuevo)
```

6. **Importa en Godot.** Copia los `.glb` a `res://assets/`. Selecciona uno en el FileSystem y abre el **Import dock**: revisa **escala**, **materiales** (extraer a archivos si quieres editarlos) y **Root Type**. Pulsa **Reimport**.

7. **Configura LOD.** Godot genera LODs automáticamente al importar mallas; en el Import dock ajusta el **Mesh → Generate LOD** y el umbral (Normal/Angular split). Verifica en escena que la malla simplifica con la distancia sin "saltos" bruscos.

8. **Compresión de texturas.** Selecciona las texturas y en su Import elige **VRAM Compressed** para las de color y **Normal Map** para las de normales (marca *Normal Map = Enabled*). Reimporta.

9. **Verifica presupuesto en el motor.** Instancia el set en una escena, abre el **monitor de rendimiento** y comprueba polígonos y draw calls. **Entregable**: proyecto Godot con el set nombrado según la convención, importado con LODs, texturas comprimidas y `PRESUPUESTO.md` cumplido.

## ✍️ Ejercicios

1. Extiende la convención para **animaciones** (`A_<Personaje>_<Accion>`) y aplícala a un clip.
2. Crea un **atlas** que agrupe las texturas de varios props y compara draw calls antes/después.
3. Ajusta el umbral de **LOD** de una malla y observa a qué distancia cambia el nivel.
4. Reduce a la mitad el presupuesto de textura de un prop de fondo y compara memoria y calidad.
5. Amplía el script de renombrado para que además **clasifique** cada archivo en su carpeta por prefijo.
6. Documenta un **checklist de export** de Blender a Godot (escala, ejes, materiales, nombres).

## 📝 Reto verificable

Entrega un set de al menos **4 assets** (3 props + 1 personaje simple) que cumpla una convención de nomenclatura escrita, respete un presupuesto documentado de polígonos y texturas, esté importado en Godot con **LODs** generados y **compresión** adecuada, y cuyo renombrado inicial se haya hecho con un script.

**Criterio de aceptación**: todos los archivos siguen la convención (verificable a simple vista), el `PRESUPUESTO.md` existe y ningún asset lo excede, cada malla tiene LODs activos y las texturas usan la compresión correcta (normales marcadas como Normal Map); el set se instancia en una escena sin errores de importación.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El asset llega gigante o diminuto al motor | Escala no aplicada en Blender. Haz *Ctrl+A → Scale* y verifica escala 1.0 antes de exportar. |
| Los normales se ven raros/planos | Textura de normal importada como color. Marca **Normal Map = Enabled** en su Import. |
| Nombres inconsistentes rompen scripts | Renombrado manual con acentos/espacios. Automatiza con el script de normalización. |
| Los LOD "saltan" de golpe y se notan | Umbral mal ajustado. Afina el LOD threshold en el Import dock. |
| VRAM se dispara con pocas texturas | Texturas sin comprimir (Lossless en todo). Usa **VRAM Compressed** en las de color. |
| Muchos draw calls con pocos objetos | Materiales/texturas sin agrupar. Usa atlas o comparte materiales. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué tanta ceremonia con los nombres?** Porque a escala los nombres son la interfaz entre humanos y scripts. Una convención permite buscar, filtrar y automatizar; sin ella, cada operación en lote es un riesgo de error manual.

**❓ ¿Godot genera LODs solo o hay que modelarlos?** Para mallas importadas Godot puede generarlos automáticamente al importar. Para casos críticos (siluetas complejas) a veces conviene modelar LODs a mano, pero el automático cubre la mayoría.

**❓ ¿glTF/GLB o FBX?** glTF 2.0 es abierto, moderno y el mejor soportado en Godot para malla, materiales PBR y animación. FBX funciona pero añade fricción; usa GLB salvo que un flujo concreto exija otra cosa.

**❓ ¿Cuándo defino el presupuesto?** Antes de producir, no después. El presupuesto es una decisión de diseño técnico que condiciona cómo modelas; descubrir el límite cuando el juego ya va lento obliga a rehacer trabajo.

## 🔗 Referencias

- Godot Docs — Importing 3D scenes: <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html>
- Godot Docs — Mesh level of detail (LOD): <https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html>
- Godot Docs — Importing images (compresión): <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>
- Blender Manual — Exporting glTF 2.0: <https://docs.blender.org/manual/en/latest/addons/import_export/scene_gltf2.html>
- Godot Docs — Optimizing 3D performance: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>

## ➡️ Siguiente clase

[Clase 187 - Capstone Parte 9: un set de assets coherente](../187-capstone-parte-9-un-set-de-assets-coherente/README.md)
