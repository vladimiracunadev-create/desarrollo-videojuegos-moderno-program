# Clase 174 — Pixel art: fundamentos y Aseprite

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación oficial de Aseprite; convenciones clásicas de pixel art*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

El pixel art no es "dibujar en baja resolución": es una disciplina con reglas propias donde cada píxel es una decisión deliberada. Dominar resolución, grid, paletas limitadas y control manual de bordes te permite producir sprites nítidos y con identidad, incluso sin ser ilustrador. **Aseprite** es la herramienta estándar de la industria indie para este trabajo.

Al terminar habrás dibujado un **sprite propio** (ícono u objeto en 16×16 o 32×32) con una paleta limitada, aplicando pixel-perfect, anti-aliasing manual y un toque de dithering, y lo habrás exportado listo para usar en un motor. Aprenderás por qué "menos píxeles bien puestos" supera a "muchos píxeles al azar".

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Configurar un lienzo de pixel art con la resolución y el grid adecuados en Aseprite.

2. Trabajar con una paleta limitada y justificar el número de colores.

3. Dibujar líneas y curvas limpias evitando "jaggies" con la técnica pixel-perfect.

4. Aplicar anti-aliasing manual y dithering donde aportan y no donde ensucian.

5. Exportar un sprite a PNG con escala entera para su uso en motor.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Resolución y canvas | Define el "presupuesto" de píxeles del sprite. |
| 2 | Grid y pixel-perfect | Mantiene líneas limpias sin dobles píxeles. |
| 3 | Paleta limitada | Fuerza coherencia y estilo reconocible. |
| 4 | Valor sobre color | Legibilidad incluso en sprites diminutos. |
| 5 | Anti-aliasing manual | Suaviza bordes sin difuminar. |
| 6 | Dithering | Simula degradados con paletas cortas. |
| 7 | Clusters y bandas | Evita píxeles sueltos y ruido. |
| 8 | Exportación con escala entera | Preserva la nitidez en el juego. |

## 📖 Definiciones y características

- **Resolución del sprite**: dimensiones en píxeles (16×16, 32×32…). Clave: menos píxeles obliga a síntesis y a mejores decisiones.

- **Pixel-perfect**: modo del lápiz que evita colocar dos píxeles en diagonal formando "L". Clave: produce líneas de un píxel de grosor uniforme.

- **Paleta limitada**: conjunto reducido y fijo de colores (p. ej. 8–16). Clave: da estilo y evita el "arcoíris" incoherente.

- **Jaggies**: escalones antiestéticos en líneas diagonales o curvas. Clave: se corrigen con longitudes de segmento consistentes.

- **Anti-aliasing manual**: colocar píxeles intermedios a mano para suavizar un borde. Clave: en pixel art se hace pixel a pixel, no con filtros.

- **Dithering**: patrón alternado de dos colores que simula un tercero. Clave: útil para degradados con paletas cortas; en exceso ensucia.

- **Cluster**: grupo compacto de píxeles del mismo color. Clave: mantener clusters limpios evita el ruido de píxeles sueltos.

- **Escala entera**: ampliar el sprite ×2, ×3, ×4 sin interpolar. Clave: preserva los bordes duros al mostrarlo grande.

## 🧰 Herramientas y preparación

Usaremos **Aseprite**, editor especializado en pixel art y animación; su página oficial es <https://www.aseprite.org/>. Es de pago, pero puede compilarse gratis desde su código fuente en GitHub, y **LibreSprite** (<https://libresprite.github.io/>) es un fork libre casi idéntico si prefieres una opción gratuita. La documentación oficial está en <https://www.aseprite.org/docs/>.

Antes de empezar, en Aseprite activa el grid (**View → Grid → Grid Settings**, tamaño 1×1 visible al hacer zoom) y localiza el modo **Pixel-Perfect** en las opciones del **Pencil**. Trabaja siempre con **mucho zoom** (400–800 %).

## 🧪 Laboratorio guiado

Dibujaremos un sprite pequeño con paleta limitada y lo exportaremos.

1. Crea un lienzo con **File → New**: ancho y alto **32×32 px**, color mode RGBA, fondo transparente. Guarda el archivo como `sprite.aseprite`.

2. Define la **paleta limitada**: en el panel de paleta, reduce a ~12 colores. Crea una rampa de 3 valores (oscuro, medio, claro) para el color principal, otra para un secundario, más un color de acento y un contorno oscuro.

3. Selecciona el **Pencil**, tamaño 1 px, y activa **Pixel-Perfect**. Dibuja el contorno de un objeto simple (una poción, una llave o un hongo) usando el color de contorno. Deja que pixel-perfect evite los dobles píxeles en las diagonales.

4. Revisa las **curvas**: si ves jaggies, corrige a mano para que los segmentos de la diagonal tengan longitudes consistentes (p. ej. 2-2-2 en vez de 3-1-3). Esto es lo que da la sensación de curva suave.

5. Rellena las zonas con el **Bucket** (Paint Bucket) usando el valor medio de cada rampa. Luego pinta **sombras** con el valor oscuro en el lado opuesto a tu fuente de luz imaginaria, y **luces** con el valor claro donde la luz pega.

6. Aplica **anti-aliasing manual** en unos pocos bordes clave: coloca a mano píxeles de un tono intermedio en los escalones más visibles del contorno para suavizarlos, sin difuminar todo.

7. Añade un **dithering** discreto en una transición de sombra: alterna dos colores en patrón de tablero solo en una banda, para simular un degradado. No abuses: una o dos zonas bastan.

8. Exporta con **File → Export Sprite Sheet** o **Export As**: PNG, con **escala ×1** para el motor y opcionalmente una copia ×4 para presentación (sin suavizado/interpolación). Verifica que el fondo quede transparente.

**Entregable visual**: un sprite de 32×32 (o 16×16) en PNG con paleta limitada, contorno pixel-perfect, sombreado por valor, algo de anti-aliasing manual y una zona de dithering, más una versión ampliada ×4 nítida.

## ✍️ Ejercicios

1. Redibuja el mismo objeto en 16×16 y compara qué detalles tuviste que sacrificar.

2. Cambia la fuente de luz al lado contrario y reubica sombras y brillos.

3. Reduce la paleta a 6 colores y observa cómo afecta al resultado.

4. Sustituye una banda de dithering por un valor intermedio nuevo y decide cuál se ve mejor.

5. Dibuja una variante de color (paleta alternativa) del mismo sprite usando **Edit → Replace Color**.

6. Crea un contorno "selectivo" (sin línea negra en las zonas de luz) y compara la sensación.

## 📝 Reto verificable

Crea un sprite original de 32×32 px en Aseprite (o LibreSprite) usando una paleta de máximo 12 colores, con contorno limpio pixel-perfect, sombreado en al menos tres valores, anti-aliasing manual en el contorno y una zona de dithering, exportado como PNG con fondo transparente y una copia ampliada ×4.

**Criterio de aceptación**: la paleta no supera 12 colores, no hay dobles píxeles ("L") en las diagonales del contorno, el sprite se lee con claridad a tamaño real, y la versión ×4 conserva bordes duros sin interpolación borrosa.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| Líneas con "escalones" feos | Segmentos de diagonal de longitud irregular. Igualarlos (2-2-2) y activar pixel-perfect. |
| El sprite se ve borroso ampliado | Se exportó con interpolación. Usa escala entera sin suavizado (Nearest). |
| Aspecto "sucio" o ruidoso | Píxeles sueltos y dithering excesivo. Limpia clusters y limita el dithering a una zona. |
| Colores incoherentes | Paleta abierta e improvisada. Fija una paleta limitada antes de pintar. |
| Contornos con dobles píxeles | Pixel-Perfect desactivado. Actívalo en las opciones del Pencil. |

## ❓ Preguntas frecuentes

**❓ ¿Aseprite es obligatorio de pagar?** No: puedes compilarlo gratis desde su código fuente, o usar LibreSprite, que es libre y muy similar.

**❓ ¿Cuántos colores debe tener un sprite?** Depende del estilo; empezar con 8–16 obliga a decisiones claras y da un look cohesionado.

**❓ ¿El dithering siempre mejora el sprite?** No. Bien usado simula degradados; en exceso genera ruido. Úsalo con moderación.

**❓ ¿Por qué exportar en escala entera?** Porque cualquier interpolación difumina los bordes duros que definen el pixel art.

## 🔗 Referencias

- Aseprite — Documentación oficial: <https://www.aseprite.org/docs/>

- Aseprite — Sitio oficial y descarga: <https://www.aseprite.org/>

- LibreSprite — fork libre: <https://libresprite.github.io/>

- Aseprite — Tutoriales (grid, paletas, pixel-perfect): <https://www.aseprite.org/docs/tutorial/>

## ➡️ Siguiente clase

[Clase 175 - Arte 2D vectorial y digital painting](../175-arte-2d-vectorial-y-digital-painting/README.md)
