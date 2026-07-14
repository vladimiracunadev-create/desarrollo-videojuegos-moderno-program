# Clase 184 — Efectos visuales (VFX) y partículas artísticas

> Parte: **9 — Arte, animación y pipeline de assets** · Fuente: *Documentación de Godot 4 (GPUParticles3D & Materials)*
> ⏱️ Duración estimada: **105 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Los efectos visuales de juego —fuego, humo, magia, chispas, impactos— son en gran parte **arte**, no solo simulación. Un buen VFX comunica algo (peligro, poder, recompensa) en una fracción de segundo, se lee con claridad incluso en el caos de una batalla y respeta un **timing** que se siente satisfactorio. Detrás de esa lectura hay decisiones artísticas: silueta, contraste, ritmo de aparición y desaparición, y curvas de color y tamaño que evolucionan en el tiempo.

En esta clase construirás un efecto (una **explosión** o una **estela**) en Godot 4 usando **GPUParticles** con una textura o **flipbook**, y afinarás sus **curvas de color y tamaño** para lograr legibilidad y buen timing. Verás cómo los flipbooks, las mallas animadas y los shaders se combinan para lograr efectos ricos con bajo coste. Escribirás poco código: el trabajo está en el editor de partículas y en el diseño visual del efecto, y el entregable es un VFX reutilizable.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir las técnicas de VFX de juego: **partículas**, **flipbooks**, **mallas animadas** y **shaders**.
2. Crear un efecto one-shot con **GPUParticles** y su **ParticleProcessMaterial**.
3. Aplicar una **textura o flipbook** a las partículas y animar sus fotogramas.
4. Diseñar **curvas de color, alpha y escala** para controlar timing y legibilidad.
5. Evaluar un efecto por su **lectura** (silueta, contraste, duración) y ajustarlo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Rol del VFX en el juego | Comunica estados y refuerza el feedback en un instante. |
| 2 | Partículas vs flipbook vs malla vs shader | Cada técnica cuesta y luce distinto; se combinan. |
| 3 | GPUParticles y su material de proceso | Es el sistema base para emitir cientos de partículas. |
| 4 | Flipbooks (spritesheets animados) | Aportan movimiento de humo/fuego sin simular física. |
| 5 | Curvas de color y gradientes | Un fuego pasa de blanco a naranja a humo gris. |
| 6 | Curvas de escala y alpha | Controlan crecer, mantener y desvanecer (timing). |
| 7 | Legibilidad y silueta | El efecto debe leerse sobre cualquier fondo. |
| 8 | Blend modes (Add vs Mix) | Additive para luz/fuego, Mix para humo opaco. |

## 📖 Definiciones y características

- **VFX**: efectos visuales no permanentes que refuerzan acciones (impacto, magia). Clave: son feedback, deben leerse rápido.
- **GPUParticles**: emisor procesado en GPU mediante un `ParticleProcessMaterial`. Clave: barato para muchas partículas simultáneas.
- **Flipbook**: textura en cuadrícula cuyos fotogramas se reproducen en secuencia. Clave: da animación a cada partícula sin simular.
- **ParticleProcessMaterial**: material que define emisión, velocidad, gravedad, color y escala en el tiempo. Clave: es el "cerebro" del efecto.
- **Gradient / Color Ramp**: rampa de color aplicada a lo largo de la vida de la partícula. Clave: define la evolución cromática del efecto.
- **Curva de escala**: función que cambia el tamaño según el tiempo de vida. Clave: crear el "puff" (crece rápido, se desvanece).
- **Blend mode aditivo**: suma el color al fondo, ideal para luz y fuego. Clave: nunca oscurece, siempre ilumina.
- **Legibilidad**: capacidad del efecto de entenderse sobre cualquier escena. Clave: prioriza silueta y contraste sobre el detalle.

## 🧰 Herramientas y preparación

Usarás **Godot 4.x** (<https://godotengine.org/download>), que incluye editores completos de partículas 2D y 3D. Para el flipbook o la textura del efecto puedes crear un spritesheet sencillo en cualquier editor de imagen (**Krita** o **GIMP**, ambos gratuitos) o usar una textura de humo/chispa de un pack **CC0** como los de <https://kenney.nl/assets>. Trabaja en un proyecto nuevo `vfx_curso/` con una escena 3D simple (un suelo y una cámara) para observar el efecto en contexto. Ten a mano la documentación de partículas de Godot y el panel **Gradient** del inspector, donde ajustarás las curvas de color.

## 🧪 Laboratorio guiado

Crearás un efecto de **explosión** (o estela) con GPUParticles y una textura/flipbook, ajustando curvas de color y tamaño.

1. **Escena base.** Crea `explosion.tscn` con raíz `Node3D`. Añade un **GPUParticles3D** llamado `Fuego`. En el inspector, crea un **ParticleProcessMaterial** y un **QuadMesh** (Draw Pass) como forma de cada partícula.

2. **Emisión one-shot.** En GPUParticles3D: **One Shot** activado, **Amount** `48`, **Lifetime** `0.8`, **Explosiveness** `1.0` (todas salen a la vez, típico de explosión).

   > `Explosiveness` es el parámetro que define el carácter del efecto: en `1.0` todas las partículas nacen a la vez (estallido); en `0.0` se emiten repartidas en el tiempo (llama continua). Ajústalo según si buscas un golpe seco o un flujo sostenido.

3. **Forma de emisión.** En el material: **Emission Shape** = *Sphere*, radio pequeño (0.2). **Direction** radial, **Spread** `180`, **Initial Velocity** entre `2` y `5`, algo de **Gravity** negativa para que el fuego suba.

   > La **variación** es lo que hace vivo un efecto: da un rango a la velocidad, al tamaño inicial y al ángulo en lugar de valores fijos. Si todas las partículas salen idénticas, el efecto se ve mecánico. Un poco de aleatoriedad en cada parámetro imita el caos natural del fuego y el humo.

4. **Textura o flipbook.** En el material del Draw Pass (un `StandardMaterial3D` o `ShaderMaterial`), asigna tu textura de humo/chispa. Si es un **flipbook**, activa **Billboard → Particle Billboard** y en *Particles Anim* define **H Frames / V Frames** según tu cuadrícula, con *Loop* apropiado.

5. **Curva de color.** En **Color → Color Ramp** define la evolución: blanco cálido → naranja → rojo → gris humo con alpha bajando a 0 al final. Esta rampa es el corazón artístico del efecto.

   > El truco del fuego convincente está en el arranque: el primer instante casi blanco (parte más caliente) da la sensación de energía. Si empiezas directamente en naranja, el fuego parece apagado. Reserva el blanco para el nacimiento de la partícula y deja que se enfríe hacia el humo.

6. **Curva de escala.** En **Scale → Scale Curve** dibuja: empieza pequeño, crece rápido en el primer 20 % y decrece hacia el final. Así el efecto "estalla" y se disipa.

7. **Blend mode.** Para el fuego usa material **aditivo** (Blend Mode = Add) y desactiva sombras. Para el humo, crea un segundo GPUParticles3D con blend **Mix**, más lento y con alpha suave.

   > Separar fuego (aditivo) y humo (mix) en dos emisores no es un capricho: son fenómenos ópticos distintos. El fuego emite luz (suma al fondo), el humo bloquea luz (opaco). Mezclarlos en un solo emisor obliga a un compromiso que empeora ambos; en capas separadas cada uno luce como debe.

8. **Disparar por código.** Un script mínimo para reiniciar y autolimpiar:

```gdscript
extends Node3D

func _ready() -> void:
    $Fuego.restart()
    $Humo.restart()
    # Se libera cuando termina la vida más larga.
    await get_tree().create_timer(1.5).timeout
    queue_free()
```

9. **Iterar por legibilidad.** Ejecuta sobre fondos claro y oscuro. Ajusta contraste, duración y tamaño hasta que el efecto se lea en ambos. **Entregable**: `explosion.tscn` reutilizable con fuego + humo, curvas afinadas y timing satisfactorio.

   > Prueba clave del VFX de juego: reprodúcelo a velocidad normal, no a cámara lenta. En combate el efecto dura una fracción de segundo, así que si solo se entiende ralentizado, no sirve. Un buen VFX comunica su intención en el primer fotograma visible.

## ✍️ Ejercicios

1. Convierte la explosión en una **estela**: emisión continua desde un objeto en movimiento en vez de one-shot.
2. Sustituye la textura por un **flipbook de humo** de 4×4 y anima sus fotogramas.
3. Añade **chispas**: un tercer emisor pequeño, aditivo, con partículas rápidas y vida corta.
4. Crea una variante "mágica" cambiando solo la **Color Ramp** (azul-violeta) sin tocar el resto.
5. Ajusta la **Explosiveness** a 0.3 y describe cómo cambia la sensación del efecto.
6. Añade una **luz** (OmniLight3D) que parpadee brevemente sincronizada con el flash del impacto.

## 📝 Reto verificable

Diseña un efecto de impacto completo formado por al menos **tres capas** (flash/luz, fuego aditivo y humo con alpha), con curvas de color y escala propias, empaquetado en una sola escena que se instancie y se autolimpie. Debe leerse con claridad sobre fondo claro y oscuro.

**Criterio de aceptación**: al instanciar la escena, el efecto aparece, evoluciona (crece → mantiene → se desvanece) y desaparece sin dejar nodos huérfanos; sus tres capas son distinguibles y el efecto se entiende en menos de un segundo sobre cualquier fondo.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Las partículas no aparecen | Falta asignar un **Draw Pass** (mesh) o `Amount`/`Lifetime` a 0. Revisa el material de proceso. |
| El fuego se ve como cuadros negros | Textura sin alpha o blend incorrecto. Usa material **aditivo** y textura con transparencia. |
| El flipbook no anima | *H/V Frames* mal configurados o *Particles Anim* desactivado. Ajusta la cuadrícula real de la textura. |
| El efecto dura demasiado / se corta | `Lifetime` y el timer de autolimpieza no coinciden. Sincronízalos. |
| Todo se ve plano y no mira a cámara | Falta **Billboard**. Actívalo en el material (Particle Billboard). |
| El humo tapa el fuego | Orden de dibujo/blend. Pon el humo en Mix detrás y el fuego aditivo delante. |

## ❓ Preguntas frecuentes

**❓ ¿Partículas o flipbook para el humo?** Ambos: las partículas dan movimiento y dispersión, el flipbook da vida interna a cada una. Combinar pocas partículas con un buen flipbook suele lucir mejor y más barato que muchas partículas planas.

**❓ ¿Por qué mi efecto no se lee en combate?** Probablemente le falta contraste o silueta. En el caos, el jugador solo capta forma general y brillo; recorta detalle y refuerza el flash inicial y el color dominante.

**❓ ¿Additive siempre para VFX?** No. Additive es para cosas que emiten luz (fuego, magia, chispas). El humo y el polvo son opacos y necesitan blend **Mix** con alpha, si no parecerán fantasmales.

**❓ ¿Cómo consigo buen timing?** Con las curvas: un efecto satisfactorio suele "atacar" fuerte y rápido y "soltar" lento. Piensa en anticipación-impacto-disipación, igual que en animación.

## 🔗 Referencias

- Godot Docs — Particle systems (3D): <https://docs.godotengine.org/en/stable/tutorials/3d/particles/index.html>
- Godot Docs — Process material: <https://docs.godotengine.org/en/stable/tutorials/3d/particles/process_material_properties.html>
- Godot Docs — GPUParticles3D: <https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html>
- Kenney — Assets CC0 (partículas y texturas): <https://kenney.nl/assets>
- Godot Docs — StandardMaterial3D (blend modes): <https://docs.godotengine.org/en/stable/classes/class_standardmaterial3d.html>

## ➡️ Siguiente clase

[Clase 185 - Iluminación como arte y mood](../185-iluminacion-como-arte-y-mood/README.md)
