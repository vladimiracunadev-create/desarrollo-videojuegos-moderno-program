# Clase 175 — Arte 2D vectorial y digital painting

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Krita e Inkscape; conceptos de raster vs vectorial*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

No todo el arte 2D es pixel art. Muchos juegos usan **digital painting** (raster) para lograr texturas ricas, o **arte vectorial** para assets nítidos que escalan sin perder calidad. Entender la diferencia y saber cuándo usar cada uno te evita elegir la herramienta equivocada y repetir trabajo. En esta clase manejas las dos vías con software libre.

Al terminar habrás pintado un **asset raster por capas** en Krita (lineart, color y sombra separados) o creado un **asset vectorial** en Inkscape, y comprenderás cuándo conviene cada enfoque. El flujo por capas que practicarás es la base profesional de casi todo arte 2D no pixelado.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar las diferencias prácticas entre raster y vectorial y cuándo usar cada uno.

2. Organizar un asset por capas (lineart, color base, sombras, luces).

3. Usar pinceles y modos de fusión (blending) en Krita de forma intencional.

4. Trazar y editar formas vectoriales con nodos y curvas en Inkscape.

5. Exportar assets escalables o de resolución adecuada al motor.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Raster vs vectorial | Determina escalabilidad, peso y flujo de trabajo. |
| 2 | Capas y su orden | Permite editar color sin dañar el lineart. |
| 3 | Pinceles en Krita | Cada pincel aporta una textura y sensación distinta. |
| 4 | Modos de fusión (blending) | Combinan capas para sombras y luces realistas. |
| 5 | Flat vs shaded | Define el nivel de acabado del asset. |
| 6 | Nodos y curvas Bézier | Base del control preciso en vectorial. |
| 7 | Assets escalables | Nitidez a cualquier tamaño en UI e iconografía. |
| 8 | Exportación | Ajustar formato y resolución al destino. |

## 📖 Definiciones y características

- **Raster**: imagen formada por píxeles (Krita, Photoshop). Clave: rica en textura, pero pierde calidad al ampliarse.

- **Vectorial**: imagen definida por curvas y puntos matemáticos (Inkscape). Clave: escala infinitamente sin perder nitidez.

- **Capa**: nivel independiente donde pintas sin afectar a los demás. Clave: separar lineart/color/sombra permite corregir sin rehacer.

- **Lineart**: la línea limpia que define el contorno y detalles. Clave: suele ir en la capa superior y guía el color.

- **Modo de fusión (blending)**: forma en que una capa se mezcla con la inferior (Multiply, Screen…). Clave: Multiply oscurece para sombras, Screen aclara para luces.

- **Flat**: acabado de colores planos sin sombreado. Clave: rápido, legible y coherente para estilos limpios.

- **Shaded**: acabado con volumen mediante sombras y luces. Clave: aporta profundidad a costa de más tiempo.

- **Nodo**: punto de control de una curva vectorial. Clave: moverlo o ajustar sus tiradores cambia la forma con precisión.

## 🧰 Herramientas y preparación

Para digital painting usaremos **Krita** (<https://krita.org/>), fuerte en pinceles y capas; para vectorial, **Inkscape** (<https://inkscape.org/>), editor SVG libre. Ambos son gratuitos y multiplataforma. Una tableta gráfica ayuda en el raster, pero el laboratorio puede completarse con ratón si eres cuidadoso.

En Krita, abre los dockers **Layers** y **Brush Presets** (menú **Settings → Dockers**). En Inkscape, familiarízate con la herramienta **Bézier/pluma (B)** y la de **edición de nodos (N)**. Crea un lienzo raster de **1024×1024 px** y un documento vectorial del mismo tamaño.

## 🧪 Laboratorio guiado

Elige una de las dos vías (o haz ambas si te alcanza el tiempo). El entregable pide al menos una completa.

**Vía A — Digital painting por capas en Krita**

1. Crea el lienzo 1024×1024. Añade cuatro capas en este orden (de abajo a arriba): `fondo`, `color`, `sombra`, `lineart`.

2. En `lineart`, con un pincel de tinta (preset "Ink"), traza el contorno limpio de un asset simple (una fruta, un escudo, una seta). Trabaja el trazo con calma; corrige con la goma.

3. En `color`, bajo el lineart, pinta los **colores planos** (flat) de cada zona. Usa la selección por rango o pinta a mano dentro del contorno.

4. Convierte `sombra` a modo de fusión **Multiply**. Con un color grisáceo, pinta las zonas en sombra según una fuente de luz definida; al ser Multiply, oscurecerá el color de abajo de forma natural.

5. Añade una capa `luz` en modo **Screen** o **Add** y pinta con moderación los brillos donde pega la luz. Ya tienes un asset shaded.

6. Ajusta el `fondo` con un color neutro para juzgar el contraste. Exporta con **File → Export** a PNG con transparencia (oculta el fondo si el asset va sobre el juego).

**Vía B — Asset vectorial en Inkscape**

1. Con la herramienta **Bézier (B)**, traza la silueta del asset colocando nodos; cierra la forma volviendo al primer nodo.

2. Con **edición de nodos (N)**, suaviza las curvas arrastrando los tiradores; convierte esquinas en curvas donde haga falta.

3. Rellena la forma con color plano (panel **Fill & Stroke**, `Shift+Ctrl+F`) y ajusta o quita el trazo.

4. Duplica la forma (`Ctrl+D`), recórtala y pinta una **zona de sombra** con un tono más oscuro para dar volumen sin dejar de ser vectorial.

5. Agrupa (`Ctrl+G`) las piezas y exporta con **File → Export** a PNG a la resolución deseada, o guarda el **SVG** para conservar la escalabilidad.

**Entregable visual**: un PNG (y el archivo fuente) de un asset 2D terminado —con capas lineart/color/sombra si es raster, o formas vectoriales con relleno y sombra si es vectorial.

## ✍️ Ejercicios

1. Reexporta tu asset vectorial a ×4 tamaño y comprueba que sigue nítido; hazlo con el raster y compara.

2. Cambia el modo de fusión de la sombra de Multiply a Normal con opacidad y compara el resultado.

3. Crea una versión **flat** de tu asset shaded eliminando las capas de sombra y luz.

4. Prueba tres pinceles distintos en el lineart y describe qué sensación aporta cada uno.

5. En Inkscape, edita los nodos para generar una variante de la silueta.

6. Combina ambos mundos: exporta el vectorial e impórtalo en Krita para añadirle textura raster.

## 📝 Reto verificable

Produce un asset 2D original terminado, ya sea raster por capas en Krita (lineart, color, sombra y luz en capas separadas) o vectorial en Inkscape (formas con relleno y una zona de sombra), y entrégalo como PNG más su archivo fuente (`.kra` o `.svg`).

**Criterio de aceptación**: en la vía raster, el archivo fuente conserva al menos tres capas separadas y editables; en la vía vectorial, el SVG escala a ×4 sin pixelarse. En ambos casos el asset muestra volumen (al menos una zona de sombra) y contorno limpio.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Todo pintado en una sola capa | No se separó lineart/color/sombra. Rehaz con capas para poder editar sin dañar el resto. |
| El asset raster se pixela al ampliar | Se necesitaba vectorial o mayor resolución base. Usa Inkscape o parte de un lienzo mayor. |
| Las sombras se ven "sucias" | Sombra en modo Normal sobre el color. Usa Multiply con un tono neutro. |
| Curvas vectoriales con picos | Nodos tipo esquina donde debía haber curva. Convierte a "smooth" y ajusta tiradores. |
| El fondo blanco arruina el asset en el juego | Se exportó sin transparencia. Oculta el fondo y exporta PNG con alfa. |

## ❓ Preguntas frecuentes

**❓ ¿Cuándo elijo vectorial y cuándo raster?** Vectorial para iconos, UI y arte plano que debe escalar; raster para texturas ricas y pintura detallada.

**❓ ¿Necesito tableta gráfica?** Ayuda mucho en raster por la presión, pero el laboratorio puede hacerse con ratón, sobre todo en vectorial.

**❓ ¿Por qué separar en tantas capas?** Porque te permite recolorear, rehacer sombras o ajustar el lineart sin empezar de cero.

**❓ ¿Un SVG sirve directo en cualquier motor?** No siempre; muchos motores prefieren PNG, pero mantener el SVG te deja exportar a cualquier resolución sin pérdida.

## 🔗 Referencias

- Krita — Manual (capas y blending): <https://docs.krita.org/en/user_manual/layers_and_masks.html>

- Krita — Pinceles: <https://docs.krita.org/en/user_manual/loading_saving_brushes.html>

- Inkscape — Tutoriales oficiales: <https://inkscape.org/learn/tutorials/>

- Inkscape — Manual (herramienta Bézier): <https://inkscape-manuals.readthedocs.io/>

## ➡️ Siguiente clase

[Clase 176 - Animación 2D: principios y frame-by-frame](../176-animacion-2d-principios-y-frame-by-frame/README.md)
