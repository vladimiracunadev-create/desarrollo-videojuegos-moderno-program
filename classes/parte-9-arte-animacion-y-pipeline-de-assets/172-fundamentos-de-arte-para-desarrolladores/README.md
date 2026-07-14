# Clase 172 — Fundamentos de arte para desarrolladores

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Itten "The Art of Color"; docs Krita (color y composición)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Muchos desarrolladores construyen mecánicas sólidas pero sus juegos "se ven raros" sin saber por qué. La causa casi siempre no es falta de talento para dibujar, sino desconocer los tres pilares que sostienen cualquier imagen legible: **color**, **forma** y **composición**. Esta clase te da el vocabulario y las reglas prácticas para tomar decisiones visuales conscientes, aunque no sepas dibujar aún.

Al terminar habrás construido, con software libre, una **paleta armónica** y una **silueta de personaje legible**, y habrás resuelto un ejercicio de valor que demuestra por qué un buen contraste de tono importa más que el color. Estas herramientas son transversales: te servirán tanto para pixel art como para 3D o UI.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir tono (hue), valor y saturación, y explicar el rol de cada uno.

2. Construir una paleta con una armonía cromática concreta (análoga, complementaria o triádica).

3. Evaluar la legibilidad de un diseño mediante su silueta y su lenguaje de formas.

4. Componer una escena aplicando regla de tercios, punto focal y jerarquía visual.

5. Verificar el contraste de un diseño convirtiéndolo a escala de grises.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Rueda de color y armonías | Da un método para elegir colores que "combinan". |
| 2 | Valor (claro/oscuro) | Es lo que hace legible una imagen incluso sin color. |
| 3 | Saturación e intensidad | Controla dónde cae la atención del jugador. |
| 4 | Silueta y lectura de formas | Un personaje debe reconocerse por su contorno. |
| 5 | Lenguaje de formas | Círculo, cuadrado y triángulo comunican personalidad. |
| 6 | Regla de tercios y foco | Ordena la escena y dirige la mirada. |
| 7 | Jerarquía visual | Define qué se ve primero, segundo y tercero. |
| 8 | Contraste como herramienta | Separa figura de fondo y evita el "ruido". |

## 📖 Definiciones y características

- **Tono (hue)**: la posición del color en la rueda (rojo, verde, azul…). Clave: es la propiedad que menos afecta la legibilidad.

- **Valor**: qué tan claro u oscuro es un color, sin importar su tono. Clave: si el valor no contrasta, el diseño se "aplana".

- **Saturación**: intensidad o pureza del color. Clave: reservar la alta saturación para lo importante crea foco.

- **Armonía cromática**: relación ordenada entre colores (análoga, complementaria, triádica). Clave: da coherencia sin ensayo y error.

- **Silueta**: contorno macizo del objeto en un solo color. Clave: si la silueta no se reconoce, el diseño falla aunque tenga buen detalle.

- **Lenguaje de formas**: uso intencional de formas base para transmitir carácter. Clave: triángulos = agresivo/peligro, círculos = amable, cuadrados = estable.

- **Regla de tercios**: dividir el lienzo en 3×3 y ubicar lo importante en las líneas o cruces. Clave: evita composiciones centradas y estáticas.

- **Jerarquía visual**: orden en que la vista recorre los elementos. Clave: se logra con tamaño, contraste y posición.

## 🧰 Herramientas y preparación

Usaremos **Krita** (gratuito y open source) por su motor de color y sus herramientas de mezcla; descárgalo desde <https://krita.org/>. Como referencia opcional para paletas puedes apoyarte en la documentación de color de Krita y en cualquier editor de imágenes. No necesitas tableta gráfica: todo el laboratorio se hace con el ratón usando figuras y rellenos.

Crea un lienzo nuevo de **1280×720 px** a 72 ppp, con fondo transparente. Ten a mano el selector de color avanzado de Krita (menú **Settings → Dockers → Advanced Color Selector**), que muestra tono, valor y saturación por separado.

## 🧪 Laboratorio guiado

Construiremos una paleta armónica y una silueta legible, y validaremos el diseño por valor.

1. En Krita, abre el **Advanced Color Selector**. Elige un tono base, por ejemplo un azul (hue ~210). Este será el color dominante del personaje.

2. Genera una **armonía complementaria**: anota el tono opuesto en la rueda (~30, un naranja). Usarás el azul como color principal y el naranja como acento para el punto focal.

3. Crea 5 muestras en una capa nueva llamada `paleta`: dibuja 5 cuadrados con la herramienta rectángulo. Rellénalos con: azul oscuro (valor bajo), azul medio, azul claro, un gris neutro y el naranja de acento. Mantén la saturación del gris casi en cero.

4. Verifica la **rampa de valor**: selecciona la capa `paleta`, duplícala y aplícale **Filter → Adjust → Desaturate**. Los cinco cuadrados deben verse claramente distintos en gris. Si dos se confunden, ajusta su valor y repite.

5. En una capa `silueta`, dibuja el contorno de un personaje **relleno en negro sólido**, sin detalles internos. Combina formas base: cuerpo cuadrado (estable), cabeza redonda (amable) y un elemento triangular (una capa o sombrero puntiagudo) para dar carácter.

6. Prueba la legibilidad: reduce el zoom hasta ver la silueta pequeña. Debe reconocerse de inmediato como "un personaje" y distinguirse de un rectángulo cualquiera. Si no, exagera las proporciones o separa los apéndices del cuerpo.

7. Compón la escena: crea una capa `fondo` y coloca la silueta sobre una de las **cruces de la regla de tercios** (activa **View → Show Grid** o usa guías en 1/3 y 2/3). Pinta el punto de acento naranja cerca de la silueta para crear foco.

8. Exporta el resultado como PNG con **File → Export**. Tendrás una lámina con la paleta, su versión en gris y la silueta compuesta.

**Entregable visual**: un PNG que muestre la paleta de 5 colores, su rampa de valor en gris y una silueta de personaje legible ubicada según la regla de tercios.

## ✍️ Ejercicios

1. Rehaz la paleta con una **armonía análoga** (tres tonos vecinos) y compárala con la complementaria.

2. Crea tres siluetas distintas usando solo triángulos, solo círculos y solo cuadrados; describe qué personalidad sugiere cada una.

3. Toma una captura de un juego que te guste, desatúrala y analiza dónde está el mayor contraste de valor.

4. Diseña una paleta triádica para un enemigo y explica qué color reservas para el foco.

5. Ajusta una de tus siluetas para que sea reconocible a 32×32 px sin perder identidad.

6. Reubica el punto focal de tu composición a otra cruz de la regla de tercios y comenta cómo cambia la lectura.

## 📝 Reto verificable

Diseña la lámina de un personaje jugable ficticio: una paleta de exactamente 5 colores con una armonía declarada, su rampa de valor en gris y una silueta legible compuesta según la regla de tercios, todo en un único PNG.

**Criterio de aceptación**: al desaturar la imagen, los 5 colores de la paleta se distinguen entre sí, la silueta se reconoce como personaje a tamaño reducido (≤64 px de alto) y el punto de acento saturado cae sobre o cerca de una cruz de tercios.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El diseño "se ve plano" pese a colores bonitos | Poco contraste de valor. Desatura y separa los tonos en claro/medio/oscuro. |
| Todos los colores compiten por atención | Exceso de saturación. Baja la saturación de los secundarios y reserva la alta para el foco. |
| La silueta no se reconoce | Formas demasiado genéricas. Exagera proporciones y separa apéndices del torso. |
| La composición se ve estática | Elemento principal centrado. Muévelo a una línea o cruce de tercios. |
| La paleta parece "sucia" | Mezcla de armonías sin criterio. Elige una sola armonía y limita el número de tonos. |

## ❓ Preguntas frecuentes

**❓ ¿Necesito saber dibujar para esta clase?** No. Trabajamos con formas, rellenos y decisiones de color; el dibujo fino llega en clases posteriores.

**❓ ¿Por qué insistir tanto en el valor?** Porque el ojo humano lee primero el contraste de claro/oscuro; sin él, ningún color salva la imagen.

**❓ ¿Cuántos colores debe tener una paleta?** Para empezar, entre 4 y 6 es manejable; menos fuerza cohesión, más complica la coherencia.

**❓ ¿Estas reglas aplican también a 3D y UI?** Sí. Color, valor y composición son universales; cambian las herramientas, no los principios.

## 🔗 Referencias

- Krita — Documentación de color: <https://docs.krita.org/en/general_concepts/colors.html>

- Krita — Manual de usuario: <https://docs.krita.org/en/user_manual.html>

- Interaction of Color / rueda cromática (Adobe Color como apoyo): <https://color.adobe.com/>

- Composición y regla de tercios (referencia general): <https://en.wikipedia.org/wiki/Rule_of_thirds>

## ➡️ Siguiente clase

[Clase 173 - Dirección de arte y coherencia visual](../173-direccion-de-arte-y-coherencia-visual/README.md)
