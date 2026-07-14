# Clase 183 — Sculpting y retopología

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Blender 4 (Sculpting & Retopology)*
> ⏱️ Duración estimada: **110 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El flujo profesional de arte 3D orgánico rara vez empieza modelando polígono a polígono. En su lugar se **esculpe** una malla de alta densidad, casi como si fuera arcilla digital, y luego se construye encima una **malla limpia y ligera** (retopología) que el motor pueda mover en tiempo real. El detalle fino del esculpido no se pierde: se **hornea** (baking) a un **mapa de normales** que la malla baja usa para fingir esa geometría. Este triángulo alta-poli → baja-poli → normal map es la columna vertebral del arte de personajes y props modernos.

En esta clase esculpirás una forma orgánica sencilla en Blender usando **Dynamic Topology** y los pinceles básicos, harás retopología de una zona con las herramientas manuales y automáticas, y hornearás el mapa de normales del modelo alto al bajo. Escribirás muy poco código: casi todo ocurre en herramientas artísticas reales, y el entregable es un asset con su normal map funcional.

Este flujo es transferible: aunque aquí uses Blender, el mismo triángulo alta-poli / baja-poli / normal map aparece en ZBrush, Mudbox, Substance o Marmoset. Lo que aprendes no es una herramienta concreta, sino la **lógica del pipeline orgánico** que sostiene el arte de personajes, criaturas y props detallados en cualquier estudio.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Esculpir una forma orgánica básica con **pinceles** (Draw, Grab, Smooth, Crease) y **Dyntopo**.
2. Explicar la diferencia entre **alta poli** (detalle) y **baja poli** (rendimiento) y por qué coexisten.
3. Retopologizar una superficie de forma **manual** (Poly Build) y **automática** (Quad Remesher / Remesh).
4. Configurar y ejecutar un **bake de normales** de la malla alta a la malla baja.
5. Validar el resultado detectando errores de proyección, artefactos y densidad de UV.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Modo Sculpt y pinceles | Es la forma natural de crear volumen y detalle orgánico. |
| 2 | Dynamic Topology (Dyntopo) | Añade geometría solo donde esculpes, sin planificar la malla. |
| 3 | Alta poli vs baja poli | Separa "detalle visual" de "coste de render" en el motor. |
| 4 | Retopología manual | Da control total sobre el flujo de aristas (edge flow). |
| 5 | Retopología automática | Acelera el paso cuando el flujo perfecto no es crítico. |
| 6 | UV unwrap de la malla baja | Sin UVs no hay dónde guardar el mapa de normales. |
| 7 | Baking de normales (cage/ray distance) | Transfiere el detalle alto a la textura de la baja. |
| 8 | Validación del bake | Los artefactos delatan errores de proyección o UV. |

## 📖 Definiciones y características

- **Sculpting**: modelado tipo arcilla que empuja, estira y talla la superficie. Clave: trabaja sobre densidades altas, ideal para lo orgánico.
- **Dyntopo**: subdivide dinámicamente la malla bajo el pincel. Clave: no necesitas una topología previa, pero genera triángulos irregulares.
- **Multiresolution**: modificador que esculpe en varios niveles de subdivisión reversibles. Clave: alternativa a Dyntopo que preserva UVs.
- **Alta poli (high-poly)**: malla con millones de caras que contiene todo el detalle. Clave: nunca va directa al motor; es la "fuente" del bake.
- **Baja poli (low-poly)**: malla ligera optimizada para tiempo real. Clave: recibe el detalle vía normal map.
- **Retopología**: reconstruir una malla limpia de quads sobre la alta. Clave: buen edge flow = mejores deformaciones al animar.
- **Normal map**: textura RGB que codifica direcciones de normal por píxel. Clave: simula relieve sin geometría real.
- **Cage / ray distance**: volumen de proyección que decide desde dónde se lanzan los rayos del bake. Clave: mal ajustado produce huecos o solapes.
- **Edge flow**: dirección en que fluyen los bucles de aristas de una malla. Clave: un buen flujo hace que codos, bocas y articulaciones se deformen bien al animar.
- **Padding / margin**: píxeles extra alrededor de cada isla UV en la textura horneada. Clave: evita costuras visibles al aplicar mipmaps o filtrado.

## 🧰 Herramientas y preparación

Trabajarás con **Blender 4.x** (gratuito y de código abierto), suficiente para todo el flujo: esculpido, retopología y baking. Descárgalo desde <https://www.blender.org/download/>. Activa el add-on **F2** y familiarízate con el **modo Sculpt** (tecla de modo en la cabecera). Para el bake usarás el motor **Cycles** (Render Properties → Cycles → Bake). Opcionalmente puedes instalar el add-on gratuito **Quad Remesher** de prueba, pero el **Remesh** nativo y **Poly Build** bastan. Ten a mano un ratón con rueda o tableta; el pincel responde a presión si tienes tablet. Crea una carpeta de proyecto `arte3d/183_sculpt/` para guardar el `.blend` y las texturas horneadas.

Antes de empezar conviene conocer los atajos que más usarás: `F` ajusta el tamaño del pincel, `Shift+F` su fuerza, `Shift` mantiene el suavizado temporal y `Ctrl` invierte el efecto del pincel (por ejemplo, hunde en vez de sobresalir). Trabaja siempre con **Auto Save** activado: el esculpido con Dyntopo genera mucha geometría y un cuelgue sin guardar duele. Guarda versiones incrementales (`_v01`, `_v02`) para poder retroceder a un bloqueo anterior si una decisión no funciona.

## 🧪 Laboratorio guiado

Esculpirás una forma orgánica simple (una roca-criatura o un guijarro con detalle), retopologizarás una zona y hornearás su normal map.

1. **Base para esculpir.** Nueva escena, borra el cubo por defecto y añade una **UV Sphere** o un **Cube** con subdivisiones. Entra en **modo Sculpt**. Activa **Dyntopo** (cabecera → Dyntopo, Detail Size ~12 px).

2. **Bloqueo de formas.** Con el pincel **Grab (G)** define la silueta general: estira protuberancias, marca una zona más gruesa. No busques detalle todavía, solo el volumen. Usa **Smooth (Shift)** para suavizar.

   > Regla de oro: trabaja de lo general a lo particular. Si empiezas por los poros y las grietas antes de tener bien la silueta, tendrás que rehacerlo todo cuando muevas el volumen. La silueta es lo primero que el jugador reconoce.

3. **Detalle medio.** Con **Draw** y **Crease** talla grietas, pliegues o vetas. Baja el Detail Size a ~6 px para refinar. Este es tu **modelo alto**. Guárdalo y duplica el objeto (`Shift+D`) para conservar el original intacto; renómbralos `Roca_High` y `Roca_Low`.

   > Consejo de composición: el detalle debe tener **jerarquía**. Alterna formas grandes, medianas y pequeñas (grietas amplias, vetas medias, poros finos) en lugar de un ruido uniforme. Una superficie con detalle jerárquico se lee como natural; una con ruido parejo se ve artificial y "sucia".

4. **Retopología automática.** Sobre `Roca_Low`, aplica el modificador **Remesh** (modo *Voxel*, Voxel Size ~0.05) para obtener una malla uniforme y ligera. Aplícalo. Comprueba el conteo de caras (debe caer de cientos de miles a unos pocos miles).

   > El Remesh por voxels es ideal para props orgánicos rígidos (rocas, troncos, corales) donde no importa el edge flow. Para todo lo que se **deforme** al animar (un rostro, un brazo) el voxel remesh no basta: ahí necesitas retopología manual que dirija los bucles de aristas. Elige la técnica según si el asset se moverá o no.
   >
   > Antes de hornear (paso 8), verifica que ambas mallas **comparten origen y transform**: si `Roca_High` y `Roca_Low` no están alineadas en el espacio, el bake proyectará mal y saldrán huecos. Aplica todas las transformaciones (*Ctrl+A → All Transforms*) a las dos antes de lanzar el bake.

5. **Retopología manual de una zona.** Entra en `Roca_Low` en modo Edit. Activa **Poly Build** y, con *Snap to Face* apuntando a `Roca_High`, redibuja a mano una banda de quads sobre una zona clave (p. ej. un pliegue) para practicar el edge flow.

   > Para snap, activa el imán (*Snap*) en modo *Face* con *Project Individual Elements*. Así cada vértice que colocas se pega a la superficie de la alta, y la retopología abraza la forma en vez de flotar sobre ella.

6. **UV unwrap de la baja.** En `Roca_Low`, marca *seams* discretos y haz **U → Smart UV Project** o **Unwrap**. Verifica en el editor UV que no haya islas superpuestas.

   > Coloca los *seams* en zonas poco visibles (partes traseras, hendiduras) para que las costuras del normal map no salten a la vista. Deja un margen (*margin*) generoso entre islas al empaquetar: sin ese padding, el filtrado de la textura mezclará islas vecinas y verás líneas raras en el bake.

7. **Preparar el bake.** Crea una **imagen** nueva 2048×2048 llamada `Roca_Normal`. En `Roca_Low` crea un material con un nodo **Image Texture** apuntando a esa imagen (déjalo seleccionado, sin conectar aún).

8. **Hornear normales.** Selecciona primero `Roca_High`, luego con `Shift` `Roca_Low` (el activo). En **Render → Bake**: Bake Type = **Normal**, activa **Selected to Active**, ajusta **Extrusion / Max Ray Distance** hasta que no queden huecos, y pulsa **Bake**. Guarda la imagen como `Roca_Normal.png` (formato **Non-Color**).

   > El orden de selección importa: el objeto **activo** (seleccionado en último lugar, borde más claro) es el que **recibe** el bake, es decir, la malla baja. Si inviertes el orden hornearás al revés. Empieza con una `Max Ray Distance` pequeña y súbela poco a poco: es más fácil corregir huecos subiendo que corregir solapes bajando.

9. **Validar.** Conecta el normal map (con un nodo **Normal Map**) a la baja, oculta la alta y observa: la malla ligera debe mostrar el detalle de la alta. Gira la vista y mueve la luz: el relieve debe reaccionar a la iluminación como si fuera geometría real. Si aparecen huecos negros o costuras, vuelve al paso 8 y ajusta la extrusión, el cage o el margen de las UVs. **Entregable**: `.blend` con `Roca_Low` + `Roca_High` y el archivo `Roca_Normal.png` funcional.

## ✍️ Ejercicios

1. Esculpe una segunda forma (fruta, hongo o piedra) usando solo tres pinceles y compárala en tiempo con la primera.
2. Prueba **Multiresolution** en lugar de Dyntopo y anota qué cambia respecto a las UVs.
3. Reduce el Voxel Size del Remesh a la mitad y observa el impacto en el conteo de polígonos y el detalle.
4. Retopologiza a mano una segunda zona buscando quads regulares y bordes que sigan la forma.
5. Hornea también un **Ambient Occlusion** además del normal y compara qué aporta cada mapa.
6. Repite el bake con una `Max Ray Distance` demasiado grande y describe los artefactos que aparecen.

## 📝 Reto verificable

Produce un asset orgánico completo: un modelo **alto** esculpido, una malla **baja** por debajo de **5.000 triángulos**, UVs sin solapes y un **normal map de 2K** horneado correctamente. Entrega el `.blend` y el PNG del normal map.

**Criterio de aceptación**: al aplicar el normal map sobre la malla baja y ocultar la alta, se percibe el detalle esculpido (grietas/pliegues) sin huecos ni costuras evidentes; el conteo de la baja es ≤ 5.000 tris y ninguna isla UV se superpone.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El normal map sale con manchas o "quemado" | La Ray Distance/Extrusion es excesiva. Redúcela o usa un **cage** ajustado. |
| Zonas del bake quedan planas/sin detalle | La baja está demasiado lejos de la alta o falta geometría. Acerca la malla o sube la extrusión. |
| El detalle se ve invertido (huecos por bultos) | El normal map se importó como **Color** en vez de **Non-Color**. Cámbialo a Non-Color. |
| Dyntopo se ralentiza y cuelga Blender | Detail Size demasiado bajo genera millones de caras. Súbelo o usa Multires. |
| Costuras visibles en la textura | Islas UV con poco margen. Añade *padding* y separa mejor los seams. |
| La malla baja se deforma feo al animar | Edge flow pobre. Retopologiza siguiendo la forma con bucles de aristas coherentes. |

## ❓ Preguntas frecuentes

**❓ ¿Dyntopo o Multiresolution?** Dyntopo es libre y rápido para explorar formas, pero descarta UVs y da triángulos irregulares. Multires preserva la malla base y sus UVs, ideal si ya tienes topología. Para esta clase, Dyntopo para explorar y luego retopología.

**❓ ¿Cuántos polígonos debe tener la baja?** Depende del uso: un prop de fondo puede bastar con cientos; un personaje jugable, decenas de miles. La regla es "los mínimos que mantengan la silueta", el resto lo finge el normal map.

**❓ ¿Por qué mi retopología automática no sirve para animar?** El Remesh da una malla uniforme pero sin edge flow pensado para deformar. Para personajes que se doblan (codos, boca) conviene retopología manual en esas zonas.

**❓ ¿El normal map reemplaza a la geometría real?** Solo simula relieve en la iluminación; la silueta sigue siendo la de la baja. Por eso el detalle que afecta al contorno debe existir como geometría, y el fino (poros, arañazos) va al mapa.

## 🔗 Referencias

- Blender Manual — Sculpting: <https://docs.blender.org/manual/en/latest/sculpt_paint/sculpting/index.html>
- Blender Manual — Retopology tools: <https://docs.blender.org/manual/en/latest/modeling/meshes/retopology.html>
- Blender Manual — Bake (Cycles): <https://docs.blender.org/manual/en/latest/render/cycles/baking.html>
- Blender Manual — Normal Map node: <https://docs.blender.org/manual/en/latest/render/shader_nodes/vector/normal_map.html>
- Blender Manual — Dynamic Topology: <https://docs.blender.org/manual/en/latest/sculpt_paint/sculpting/tools/dyntopo.html>

## ➡️ Siguiente clase

[Clase 184 - Efectos visuales (VFX) y partículas artísticas](../184-efectos-visuales-vfx-y-particulas-artisticas/README.md)
