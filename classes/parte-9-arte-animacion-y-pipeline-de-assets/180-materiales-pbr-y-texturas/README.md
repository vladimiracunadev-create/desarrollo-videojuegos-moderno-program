# Clase 180 — Materiales PBR y texturas

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 (Shading / Bake) y guías glTF PBR*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El **PBR (Physically Based Rendering)** es el estándar por el que un mismo material se ve creíble bajo cualquier iluminación. En esta clase entiendes su lenguaje de mapas: **albedo** (color base sin luz), **metallic** (metal o no), **roughness** (qué tan pulida es la superficie), **normal** (relieve fino falseado) y **AO** (oclusión ambiental). Con esos cinco canales puedes describir desde madera vieja hasta acero pulido.

Vas a construir un material PBR completo para el prop de las clases anteriores, aprenderás a **hornear (bake)** mapas —transferir detalle de una malla de alta densidad o de nodos procedurales a texturas planas— y a comparar el comportamiento de un material **metálico** frente a uno **no metálico**. Terminarás viendo el material tanto en Blender como en Godot para confirmar que el flujo cruza al motor sin sorpresas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Describir la función de cada mapa PBR (albedo, metallic, roughness, normal, AO).
2. Construir un material PBR con nodos en el editor de shading de Blender.
3. Hornear mapas (normal y AO) de una textura o malla de referencia.
4. Distinguir el flujo metallic-roughness del specular-glossiness.
5. Exportar el material con glTF y verlo correctamente en Godot.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es PBR y por qué es estándar | Un material creíble bajo cualquier luz. |
| 2 | Albedo (base color) | El color "real" del material sin sombras. |
| 3 | Metallic y roughness | Definen si es metal y cuán pulido está. |
| 4 | Normal map | Simula relieve sin añadir geometría. |
| 5 | Ambient Occlusion | Añade sombras de contacto sutiles. |
| 6 | Texture sets y baking | Cómo se producen y transfieren los mapas. |
| 7 | Metal vs no-metal | Reglas distintas de albedo y reflexión. |
| 8 | Exportar PBR a motor | Que el material se vea igual fuera de Blender. |

Trabajar en PBR significa dejar de "pintar" cómo se ve algo y empezar a describir de qué está hecho, dejando que el motor calcule la apariencia según la luz. Ese cambio de mentalidad es lo que hace que un mismo asset funcione igual de bien en un nivel diurno y en una mazmorra oscura.

## 📖 Definiciones y características

- **PBR (metallic-roughness)**: modelo de materiales basado en propiedades físicas. Clave: es el flujo que glTF, Godot y Unity usan por defecto.
- **Albedo / Base Color**: color puro del material sin iluminación ni sombras horneadas. Clave: no debe incluir luces ni AO fuertes.
- **Metallic**: valor 0–1 que indica si la superficie es metal (1) o dieléctrica (0). Clave: los intermedios se reservan para transiciones, no para "medio metal".
- **Roughness**: 0 (espejo) a 1 (mate). Clave: es el mapa que más "vende" el material real.
- **Normal map**: textura RGB que altera la orientación de la superficie para fingir relieve. Clave: da detalle sin coste de polígonos.
- **AO (Ambient Occlusion)**: mapa de sombreado en recovecos. Clave: se multiplica sutilmente para dar profundidad.
- **Texture set**: conjunto de mapas de un material que comparten UVs. Clave: se nombran de forma coherente (`_albedo`, `_rough`, `_normal`).
- **Baking**: cocinar información (de nodos o de una malla high-poly) en una imagen 2D. Clave: convierte lo procedural o el detalle alto en texturas ligeras para el motor.

## 🧰 Herramientas y preparación

Trabajaremos en **Blender 4.x** con el motor **Cycles** activado para poder hornear (**Render Properties → Render Engine → Cycles**). Para ver el resultado en un motor usaremos **Godot 4** (<https://godotengine.org/download>), que importa glTF con materiales PBR de forma nativa. El prop con UVs de la clase 179 es el punto de partida.

Puedes crear texturas de forma **procedural** con nodos (Noise, Musgrave, Voronoi) sin descargar nada, o mencionamos que herramientas como **Substance 3D Painter** o **Adobe Substance** son el estándar profesional para pintar sets PBR. Documentación clave: shading y materiales (<https://docs.blender.org/manual/en/latest/render/shader_nodes/index.html>) y baking (<https://docs.blender.org/manual/en/latest/render/cycles/baking.html>).

Ten claro el orden mental del flujo PBR: primero decides si el material es metal o no (metallic), luego lo pulido que está (roughness), después su color puro (albedo) y por último el detalle fino (normal y AO). Este orden evita el error clásico de "pintar" sombras dentro del color base.

## 🧪 Laboratorio guiado

Crearemos un material PBR de madera para el barril, hornearemos un AO y lo veremos en Godot. Todo el material vivirá en el editor de nodos alrededor de un único **Principled BSDF**, que concentra los cinco canales que estudiamos.

1. Abre el barril con UVs y ve a la pestaña **Shading**. Con el objeto seleccionado, crea un material nuevo en el editor de nodos inferior. Ya trae un **Principled BSDF**, el nodo que concentra todos los canales PBR.

2. Construye el albedo procedural. Añade `Shift+A` → **Texture → Wave Texture** (vetas de madera), pásalo por un **ColorRamp** para darle dos tonos marrones y conéctalo a **Base Color** del Principled. Ajusta la escala de la Wave para el grano.

3. Define metálico y rugosidad. La madera es **no metálica**: deja **Metallic = 0**. En **Roughness**, conecta un **Noise Texture** suave (valores 0.6–0.85) para que unas zonas brillen algo más que otras, como madera desgastada.

4. Añade relieve con normal. Crea un **Bump** (o un **Normal Map** si tienes textura) alimentado por otro **Noise** de escala alta y conéctalo a **Normal** del Principled. Verás poros y vetas en relieve sin tocar la geometría.

> 💡 **Bump vs Normal**: el nodo Bump calcula el relieve al vuelo a partir de una altura; un normal map guarda la información de relieve ya cocida en RGB. Para el motor exportarás siempre un **normal map**, así que si usas Bump aquí, hornéalo a textura en el paso siguiente.

5. Prepara el bake de AO. Crea una imagen nueva `barril_ao` (`1024x1024`) en un nodo **Image Texture**, déjalo **seleccionado pero sin conectar**. En **Render Properties (Cycles) → Bake**, elige **Bake Type: Ambient Occlusion** y pulsa **Bake**. El AO queda cocido en `barril_ao`.

> 💡 **Requisito del bake**: el nodo de imagen destino debe estar seleccionado (recuadro blanco) y la malla necesita UVs. Si el bake sale negro, casi siempre es porque olvidaste seleccionar el nodo o el modelo no tiene despliegue UV de la clase 179.

6. Integra el AO. Multiplica el albedo por el mapa `barril_ao` con un nodo **MixRGB → Multiply** (factor bajo, 0.3–0.5) hacia Base Color. Da sombras de contacto sutiles en las juntas de las duelas.

7. Compara metal vs no-metal. Duplica el material, sube **Metallic = 1** y baja **Roughness ≈ 0.2**: el barril se vuelve un tanque metálico reflectante. Observa que en metal el albedo actúa como color del reflejo, no como color difuso.

> 💡 **La regla de oro del PBR**: metallic es prácticamente binario. En metal, el color difuso desaparece y el albedo tiñe el reflejo; en dieléctrico (madera, plástico, piedra), el albedo es el color difuso y el reflejo es blanquecino y tenue. Entender esta dualidad es el 80 % de dominar PBR.

8. Exporta a glTF. **File → Export → glTF 2.0**, marca **Materials** y, si horneaste, **Export Textures**. Como glTF empaqueta metallic-roughness en un solo mapa, Blender combina los canales automáticamente. Guarda `barril_pbr.glb`.

9. Verifícalo en Godot. Crea un proyecto, arrastra `barril_pbr.glb` a **FileSystem**, instáncialo en una escena con un **WorldEnvironment** y una **DirectionalLight3D**. Confirma que la madera y la variante metálica se ven como en Blender.

10. Añade un cielo o HDRI al **WorldEnvironment** para que el metal tenga algo que reflejar. Sin entorno, cualquier superficie metálica se ve negra o plana porque el reflejo no encuentra nada que devolver.

**Entregable**: `barril_pbr.glb` con material PBR (albedo, roughness, normal y AO horneado) importado en Godot, más una captura comparando la versión metálica y la no metálica.

Para autoevaluarte, gira una luz alrededor del prop en Godot: un material PBR correcto responde de forma creíble desde cualquier ángulo, con el brillo especular desplazándose por la superficie según la rugosidad. Si el material se ve plano o "de plástico" sin importar la luz, revisa que roughness tenga variación y que exista un entorno que reflejar.

> 💡 **Verifica en el motor, no solo en Blender**: Cycles y el renderizador de Godot no calculan la luz de forma idéntica. Un material que se ve perfecto en Blender puede necesitar ajustes en el motor. Por eso el laboratorio siempre cierra el ciclo importando el `.glb` y revisándolo en Godot.

## ✍️ Ejercicios

1. Cambia el **ColorRamp** del albedo para convertir la madera en un tono más rojizo o ceniza.
2. Sube la **Roughness** a `1.0` y bájala a `0.1`; describe cómo cambia la lectura del material bajo la misma luz.
3. Hornea también un **Normal** map desde el bump procedural y conéctalo como textura en vez de usar el nodo Bump.
4. Crea un material **metal pintado**: metallic con roughness variable simulando desgaste con una máscara.
5. Renombra los mapas siguiendo la convención `nombre_albedo`, `nombre_rough`, `nombre_normal` y explica por qué ayuda al pipeline.
6. Exporta el `.glb` y ábrelo en el visor glTF web; compara la reflexión con la de Godot.

> 💡 **Nomenclatura del set**: guarda los mapas con nombres predecibles (`barril_albedo`, `barril_orm` para el empaquetado occlusion-roughness-metallic, `barril_normal`). Los pipelines modernos empaquetan AO, roughness y metallic en los tres canales RGB de una sola imagen para ahorrar memoria; glTF lo hace automáticamente al exportar.

## 📝 Reto verificable

Produce un texture set PBR completo para tu prop (albedo, metallic, roughness, normal y AO), con al menos el AO horneado a una imagen, y llévalo a Godot con glTF. Prepara además una variante metálica del mismo prop.

**Criterio de aceptación**: en Godot el prop muestra los cinco canales activos (color, relieve por normal, rugosidad variable y sombras de contacto por AO), la variante no metálica no refleja como espejo y la metálica sí reflejiza el entorno; los mapas siguen una nomenclatura coherente y el `.glb` importa sin advertencias de material.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El bake sale negro o vacío | La imagen destino no está seleccionada o no hay UVs. Selecciona el nodo Image Texture y verifica el unwrap. |
| El normal map se ve invertido (huecos por bultos) | Espacio de normal o canal verde invertido. Usa Tangent space y revisa el flip de Y. |
| El metal se ve plano y sin reflejo | No hay entorno que reflejar. Añade un WorldEnvironment/HDRI en el motor. |
| Los colores del albedo llevan sombras "quemadas" | Metiste AO o luz dentro del base color. El albedo debe ir limpio; el AO va aparte. |
| En Godot el material aparece gris | glTF no exportó texturas. Marca Export Textures y usa formato .glb autocontenido. |
| Roughness uniforme se ve "de plástico" | Falta variación. Alimenta el canal con una textura de ruido en vez de un valor fijo. |

## ❓ Preguntas frecuentes

**❓ ¿Metallic debe ser 0 o 1, nunca intermedio?** En la práctica sí: una superficie es metal o no lo es. Los valores intermedios solo tienen sentido en transiciones (bordes oxidados), no como "medio metálico".

**❓ ¿Qué diferencia hay entre metallic-roughness y specular-glossiness?** Son dos flujos PBR equivalentes; glTF y los motores modernos estandarizaron **metallic-roughness**, así que ese es el que usamos aquí.

**❓ ¿Para qué hornear si puedo usar nodos procedurales?** Los motores en tiempo real no ejecutan tus nodos de Blender; el bake convierte ese detalle en texturas planas que el motor sí puede leer eficientemente.

**❓ ¿El AO va dentro del albedo?** No conviene: el motor suele calcular su propia oclusión. Se exporta como canal AO separado (o se multiplica muy sutil) para no ensuciar el color base.

## 🔗 Referencias

- Blender Manual — Principled BSDF: <https://docs.blender.org/manual/en/latest/render/shader_nodes/shader/principled.html>
- Blender Manual — Baking (Cycles): <https://docs.blender.org/manual/en/latest/render/cycles/baking.html>
- glTF 2.0 — Materials (metallic-roughness): <https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html>
- Godot Docs — Importing 3D scenes (glTF): <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_scenes.html>

## ➡️ Siguiente clase

[Clase 181 - Rigging y skinning 3D](../181-rigging-y-skinning-3d/README.md)
