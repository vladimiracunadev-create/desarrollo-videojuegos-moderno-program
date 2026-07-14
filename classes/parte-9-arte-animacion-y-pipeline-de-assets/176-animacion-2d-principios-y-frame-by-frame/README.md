# Clase 176 — Animación 2D: principios y frame-by-frame

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Thomas & Johnston "The Illusion of Life"; Williams "The Animator's Survival Kit"; docs Aseprite*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

La animación no es "dibujar muchos cuadros", sino aplicar principios que engañan al ojo para crear la ilusión de vida y peso. Los **12 principios de la animación** de Disney siguen siendo la base, incluso en un ciclo pixelado de cuatro cuadros. Entender **timing** y **spacing** es lo que separa un movimiento creíble de uno robótico.

Al terminar habrás animado un **ciclo simple** (una bola que rebota o un idle de 4 frames) en Aseprite usando **onion skin**, y lo habrás exportado como **spritesheet** listo para un motor. Aprenderás a leer y ajustar el ritmo de una animación, no solo a dibujarla.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar timing y spacing y su efecto en la sensación de peso y velocidad.

2. Aplicar squash & stretch, anticipación y follow-through en un movimiento simple.

3. Usar la línea de tiempo, los frames y el onion skin de Aseprite.

4. Construir un ciclo que "engrane" (loop) sin saltos perceptibles.

5. Exportar la animación como spritesheet con sus metadatos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Los 12 principios (visión general) | Marco común de toda animación creíble. |
| 2 | Timing | Define velocidad y peso del movimiento. |
| 3 | Spacing | Controla aceleración y desaceleración. |
| 4 | Squash & stretch | Da flexibilidad, peso y vida. |
| 5 | Anticipación | Prepara al ojo para la acción principal. |
| 6 | Frame-by-frame | Máximo control cuadro a cuadro. |
| 7 | Ciclos (idle, walk) | La base reutilizable de la animación de juegos. |
| 8 | Onion skin | Permite dibujar en relación al cuadro anterior. |

## 📖 Definiciones y características

- **Frame (cuadro)**: cada imagen individual de la secuencia. Clave: la suma de frames a cierta velocidad produce el movimiento.

- **Timing**: cuántos frames dura una acción. Clave: pocos frames = rápido/ligero; muchos = lento/pesado.

- **Spacing**: distancia que recorre el objeto entre frames. Clave: espaciado creciente acelera; decreciente desacelera.

- **Squash & stretch**: deformar el objeto al comprimir o estirar, conservando su volumen. Clave: transmite peso y material.

- **Anticipación**: pequeño movimiento contrario previo a la acción. Clave: hace legible y creíble el gesto principal.

- **Follow-through**: partes que siguen moviéndose tras detenerse el cuerpo. Clave: evita frenados artificiales.

- **Ciclo (loop)**: animación cuyo último frame conecta con el primero. Clave: idle y walk se reproducen en bucle infinito.

- **Onion skin**: visualización translúcida de frames vecinos. Clave: guía la posición del dibujo actual respecto a los adyacentes.

## 🧰 Herramientas y preparación

Usaremos **Aseprite** por su línea de tiempo integrada y su onion skin (<https://www.aseprite.org/>); **LibreSprite** (<https://libresprite.github.io/>) sirve igual si buscas una opción libre. La documentación de animación está en <https://www.aseprite.org/docs/>. Como base conceptual, esta clase se apoya en "The Animator's Survival Kit" de Richard Williams.

En Aseprite, abre la **Timeline** (menú **View → Timeline** o tecla `Tab`) y localiza el botón de **Onion Skin** y el de **Play**. Ajusta la duración de frame en milisegundos desde la propia timeline (doble clic en un frame).

## 🧪 Laboratorio guiado

Animaremos una bola que rebota, el ejercicio clásico para dominar timing, spacing y squash & stretch.

1. Crea un lienzo **64×64 px** (o 128×128 para más aire). Activa la **Timeline**. Dibuja en el frame 1 una bola redonda en la parte alta del lienzo.

2. Añade frames con el botón **New Frame** (o `Alt+N`). Crea unos **8 frames** para un rebote completo. Activa el **Onion Skin** para ver el frame anterior mientras dibujas.

3. Trabaja el **spacing** de la caída: entre los frames superiores la bola se mueve poco (arriba va lenta), y hacia el suelo se separa cada vez más (acelera por gravedad). Usa el onion skin para medir esas distancias.

4. En el frame de contacto con el suelo, aplica **squash**: aplasta la bola horizontalmente conservando su área (más ancha, menos alta). Es el instante que da sensación de impacto.

5. En el frame inmediatamente posterior, aplica un ligero **stretch** vertical al despegar, para reforzar el rebote. Luego invierte el spacing en la subida (se separa mucho al inicio, poco al llegar arriba), porque desacelera.

6. Ajusta el **timing**: da menos duración a los frames rápidos (cerca del suelo) y más a los lentos (en lo alto). Pulsa **Play** y afina hasta que el rebote se sienta con peso, no flotante.

7. Cierra el **ciclo**: haz que el último frame conecte con el primero para que el loop sea continuo. Verifica reproduciéndolo en bucle.

8. Exporta como spritesheet con **File → Export Sprite Sheet**: elige disposición horizontal, marca **JSON Data** para los metadatos de frames y guarda el PNG. Tendrás la hoja lista para importar en un motor.

**Entregable visual**: un GIF o preview del ciclo reproducible más el spritesheet PNG (con su JSON) de una bola que rebota o un idle de 4 frames, con timing y spacing trabajados.

## ✍️ Ejercicios

1. Duplica el ejercicio con una "bola de bolos" (pesada) y una "pelota de playa" (ligera); ajusta timing y squash a cada material.

2. Crea un idle de 4 frames de un personaje: respiración sutil con squash & stretch mínimo.

3. Añade anticipación a un salto: un frame de agacharse antes de despegar.

4. Exagera y luego reduce el spacing de la caída y describe cómo cambia la sensación de gravedad.

5. Introduce follow-through en un apéndice (una antena o coleta) que siga al cuerpo.

6. Reexporta el spritesheet en disposición vertical y en grid, y compara los metadatos.

## 📝 Reto verificable

Anima un ciclo en Aseprite (bola que rebota de al menos 6 frames o idle de personaje de 4 frames) aplicando timing y spacing variables y al menos un principio adicional (squash & stretch, anticipación o follow-through), y expórtalo como spritesheet PNG con metadatos JSON, más un GIF de vista previa.

**Criterio de aceptación**: el ciclo reproduce en bucle sin salto perceptible entre el último y el primer frame, el movimiento transmite peso (spacing no uniforme) y el spritesheet exportado tiene los frames alineados y correctamente descritos en el JSON.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El movimiento se ve "flotante" | Spacing uniforme y sin gravedad. Aumenta la separación al caer y redúcela al subir. |
| El loop da un salto brusco | El último frame no conecta con el primero. Ajusta posiciones para cerrar el ciclo. |
| La bola parece rígida al golpear | Falta squash & stretch. Aplasta en el contacto y estira al despegar. |
| Todo va a la misma velocidad | Duración de frame igual en todos. Da menos ms a los frames rápidos. |
| No veo el frame anterior al dibujar | Onion skin desactivado. Actívalo en la timeline. |

## ❓ Preguntas frecuentes

**❓ ¿Cuántos frames necesita un buen ciclo?** Depende: un idle puede vivir con 4, un walk suele usar 6–8. Más frames no es mejor por sí solo.

**❓ ¿Qué diferencia hay entre timing y spacing?** Timing es cuánto dura la acción; spacing es cuánto se mueve el objeto entre cuadros. Juntos definen peso y velocidad.

**❓ ¿Debo animar a 12, 24 o 60 fps?** En juegos 2D, ciclos de 8–12 fps efectivos son comunes; lo importante es la coherencia del timing, no un número fijo.

**❓ ¿Para qué el JSON del spritesheet?** Describe la posición y duración de cada frame para que el motor recorte y reproduzca la animación correctamente.

## 🔗 Referencias

- Aseprite — Documentación (animación y export): <https://www.aseprite.org/docs/>

- Aseprite — Tutorial de Onion Skin: <https://www.aseprite.org/docs/onion-skin/>

- Williams, "The Animator's Survival Kit" (referencia clásica): <https://theanimatorssurvivalkit.com/>

- 12 principios de la animación (resumen): <https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation>

## ➡️ Siguiente clase

[Clase 177 - Animación 2D esqueletal (cutout) y rigging](../177-animacion-2d-esqueletal-cutout-y-rigging/README.md)
