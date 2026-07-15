# Clase 107 — Capstone Parte 4: set de shaders y post-procesado

> Parte: **4 — Gráficos, shaders y rendering moderno** · Fuente: *Documentación de shaders y post-procesado de Godot 4 + síntesis de las clases 086–106*
> ⏱️ Duración estimada: **60 min** · Nivel: **Avanzado**
>
> 🧪 **Proyecto de referencia:** este capstone tiene un laboratorio ejecutable en
> [`labs/shaders`](../../../labs/shaders/README.md): abre `inicio/` para escribir tú los shaders
> (con `TODO` guiados) o `solucion/` para ver el set completo con sus uniforms en vivo.
> Ambos se verifican en CI con Godot headless.

---

## 🎯 Objetivo

Integrar toda la Parte 4 en un **"look" coherente** para una escena de prueba. Vas a combinar un material **PBR o toon**, una superficie de **agua o disolución**, **partículas en GPU** y una **pila de post-procesado** a pantalla completa (vignette + aberración cromática + un guiño a bloom). Al terminar tendrás un pequeño paquete visual reutilizable, controlado por **uniforms globales** desde GDScript, con una especificación, un checklist, una *definition of done* y una guía de rendimiento.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

- Ensamblar varios shaders (superficie + post-proceso) en una sola escena consistente.
- Aplicar post-procesado a pantalla completa con un `MeshInstance3D`/quad y `screen_texture`.
- Controlar uniforms de varios materiales desde un único script coordinador.
- Usar `set_shader_parameter` y uniforms globales para ajustar el look en tiempo real.
- Verificar el resultado contra un checklist y una guía de coste en GPU.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Definir el "look" objetivo | Sin meta visual, el set queda incoherente |
| 2 | Material base PBR/toon | Es la superficie principal de la escena |
| 3 | Agua o disolución | Aporta movimiento y un efecto de superficie |
| 4 | Partículas GPU | Dan vida y atmósfera sin coste de CPU |
| 5 | Post-proceso screen-space | Vignette, aberración y bloom unifican la imagen |
| 6 | Uniforms globales | Un solo punto para afinar todo el set |
| 7 | Script coordinador | Orquesta parámetros desde GDScript |
| 8 | Rendimiento del conjunto | El look no debe hundir el frame rate |

## 📖 Definiciones y características

- **Look**: identidad visual coherente de una escena (paleta, contraste, borde). Clave: guía todas las decisiones de shader.
- **Material PBR**: superficie física con metallic/roughness. Clave: base realista sobre la que montar el resto.
- **Toon shading**: iluminación por bandas y contorno. Clave: alternativa estilizada al PBR.
- **Post-procesado**: efecto aplicado a la imagen ya renderizada. Clave: se implementa con un quad a pantalla completa que lee `screen_texture`.
- **Vignette**: oscurecimiento hacia los bordes. Clave: centra la mirada del jugador.
- **Aberración cromática**: separación de canales RGB. Clave: sugiere lente y tensión.
- **Uniform global**: parámetro compartido por varios shaders. Clave: se declara con `global uniform` y se ajusta una vez para toda la escena.
- **Definition of done**: criterios que cierran el capstone. Clave: evita entregar un look "a medias".

## 🧰 Herramientas y preparación

Necesitas Godot 4.x con **Forward+**. Prepara una escena de prueba con un suelo, uno o dos objetos protagonistas y una `Camera3D`. El post-procesado se hace con un `MeshInstance3D` que usa un `QuadMesh` marcado para dibujarse a pantalla completa (o un nodo con material que lea `hint_screen_texture`). Los uniforms globales se registran en **Project Settings → Shader Globals**. Ten a mano la [guía de post-procesado con shaders de pantalla](https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html) y la referencia de [uniforms globales](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html#global-uniforms). Reutiliza lo aprendido en las clases 093 (PBR), 100 (agua), 101 (partículas) y 096–097 (post-proceso).

## 🧪 Laboratorio guiado

Montaremos el set por capas, de la superficie a la imagen final, y lo controlaremos con un script.

**Paso 1 — Superficie base (PBR o toon).** Sobre el objeto protagonista, asigna un `ShaderMaterial`. Ejemplo de superficie con disolución integrada sobre una base clara:

```glsl
shader_type spatial;

global uniform float look_intensidad; // compartido por todo el set
uniform sampler2D ruido;
uniform float disolucion : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    ALBEDO = vec3(0.65, 0.72, 0.85) * look_intensidad;
    ROUGHNESS = 0.4;
    METALLIC = 0.0;
    // Disolución: descarta según un mapa de ruido.
    float n = texture(ruido, UV).r;
    if (n < disolucion) {
        discard;
    }
    // Borde emisivo en la zona que se disuelve.
    EMISSION = vec3(0.9, 0.4, 0.1) * smoothstep(0.0, 0.08, n - disolucion);
}
```

**Paso 2 — Agua/superficie animada.** Añade un `PlaneMesh` como agua con desplazamiento por seno en `vertex()`:

```glsl
shader_type spatial;

uniform float velocidad = 1.0;
uniform float amplitud = 0.1;

void vertex() {
    // Ola simple sumando dos senos desfasados.
    float onda = sin(VERTEX.x * 3.0 + TIME * velocidad)
               + cos(VERTEX.z * 2.0 + TIME * velocidad * 0.7);
    VERTEX.y += onda * amplitud;
}

void fragment() {
    ALBEDO = vec3(0.1, 0.4, 0.7);
    ROUGHNESS = 0.1;
    METALLIC = 0.0;
}
```

**Paso 3 — Partículas GPU.** Añade un `GPUParticles3D` con un `ProcessMaterial` (o un `ShaderMaterial` de partículas) para polvo o chispas flotantes. Ajusta cantidad moderada (por ejemplo 200) y una malla pequeña como *draw pass*. Esto da atmósfera sin tocar la CPU.

**Paso 4 — Post-procesado a pantalla completa.** Crea un `MeshInstance3D` con un `QuadMesh` que cubra la pantalla y un `ShaderMaterial` que lea la imagen renderizada. Aquí van vignette + aberración cromática:

```glsl
shader_type spatial;
render_mode unshaded, cull_disabled, depth_test_disabled;

uniform sampler2D pantalla : hint_screen_texture, filter_linear;
global uniform float look_intensidad;
uniform float vignette_fuerza : hint_range(0.0, 2.0) = 0.6;
uniform float aberracion : hint_range(0.0, 0.01) = 0.003;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Aberración cromática: desplaza R y B respecto al centro.
    vec2 dir = uv - vec2(0.5);
    float r = texture(pantalla, uv - dir * aberracion).r;
    float g = texture(pantalla, uv).g;
    float b = texture(pantalla, uv + dir * aberracion).b;
    vec3 color = vec3(r, g, b);

    // Vignette: oscurece según distancia al centro.
    float d = length(dir);
    float vig = smoothstep(0.8, 0.2, d * vignette_fuerza);
    color *= vig;

    ALBEDO = color * look_intensidad;
}
```

**Paso 5 — Uniforms globales.** En **Project Settings → Shader Globals**, registra `look_intensidad` (tipo float, por ejemplo 1.0). Todos los shaders que lo declaren como `global uniform` lo comparten: cambiar uno cambia el look completo.

**Paso 6 — Script coordinador.** Un único script ajusta todos los uniforms del set:

```gdscript
extends Node3D

@export var mat_superficie: ShaderMaterial
@export var mat_post: ShaderMaterial

func _ready() -> void:
    # Uniform global: afecta a superficie y post-proceso a la vez.
    RenderingServer.global_shader_parameter_set("look_intensidad", 1.1)

func _process(delta: float) -> void:
    # Anima la disolución de la superficie protagonista.
    var t: float = fmod(Time.get_ticks_msec() / 1000.0, 1.0)
    mat_superficie.set_shader_parameter("disolucion", t)
    # Pulso sutil de aberración para dar tensión.
    mat_post.set_shader_parameter("aberracion", 0.002 + 0.001 * sin(t * TAU))
```

**Resultado observable:** una escena con superficie que se disuelve con borde incandescente, agua ondulando, partículas flotando y una imagen final con viñeteado y bordes de color; al cambiar `look_intensidad` toda la escena se aclara u oscurece de golpe.

### Especificación del set

| Shader | Tipo | Efecto | Uniforms clave |
|--------|------|--------|----------------|
| Superficie | `spatial` | PBR/toon + disolución con borde emisivo | `disolucion`, `look_intensidad` |
| Agua | `spatial` | Olas por seno en vertex | `velocidad`, `amplitud` |
| Partículas | `GPUParticles3D` | Polvo/chispas en GPU | cantidad, vida |
| Post-proceso | `spatial` (quad) | Vignette + aberración cromática | `vignette_fuerza`, `aberracion`, `look_intensidad` |

### Checklist

- [ ] Superficie protagonista con material PBR o toon aplicado.
- [ ] Un efecto de agua **o** disolución animado en la escena.
- [ ] `GPUParticles3D` activo con cantidad razonable.
- [ ] Quad de post-proceso leyendo `hint_screen_texture`.
- [ ] Al menos vignette **y** aberración cromática en el post-proceso.
- [ ] Un `global uniform` compartido por dos o más shaders.
- [ ] Script único que controla los uniforms del set.

### Definition of done

El capstone está terminado cuando la escena corre a frame rate estable, los cuatro elementos (superficie, agua/disolución, partículas, post-proceso) son visibles a la vez, el uniform global modifica el look de forma coordinada y el script anima al menos un parámetro sin errores en consola.

### Guía de rendimiento

Mide el **tiempo de GPU** en el monitor antes y después de añadir el post-proceso. El quad a pantalla completa hace lookups por píxel: mantén la aberración a pocos samples y evita branches por píxel. Limita el número de partículas y el overdraw del agua transparente. Si el tiempo de GPU sube demasiado, reduce primero el post-proceso, que es lo que corre en cada píxel de la pantalla.

## ✍️ Ejercicios

1. Cambia la superficie de PBR a toon (bandas de luz en `light()`) y compara el look.
2. Sustituye la disolución por un segundo plano de agua con otra frecuencia de olas.
3. Añade un uniform global `look_saturacion` y aplícalo en el post-proceso.
4. Sube las partículas a 2000 y mide el impacto en el tiempo de GPU.
5. Suma un tercer efecto de post-proceso (por ejemplo, tinte por zonas) al quad.
6. Expón todos los uniforms del set en un panel de depuración editable en runtime.

## 📝 Reto verificable

Entrega la escena de prueba con el **set visual completo**: superficie PBR/toon, agua o disolución, partículas GPU y una pila de post-proceso con vignette + aberración cromática, todo coordinado por un uniform global y un script único. Incluye la tabla de shaders creados y una medición de tiempo de GPU.

**Criterio de aceptación**: los cuatro elementos se ven simultáneamente en una captura; cambiar el `global uniform` altera el look de superficie y post-proceso a la vez; el script anima al menos un parámetro con `set_shader_parameter` sin errores; y aportas el tiempo de GPU por frame de la escena final.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| El post-proceso no ve la escena | Falta `hint_screen_texture` o el quad no está a pantalla completa |
| El quad tapa todo en negro | `depth_test_disabled`/`unshaded` no configurados, o el quad no cubre `SCREEN_UV` |
| El uniform global no afecta a nadie | No lo registraste en **Shader Globals** o no lo declaraste `global uniform` |
| Frame rate se hunde | Post-proceso con muchos lookups o miles de partículas; recorta y remide |
| La disolución no aparece | El mapa de ruido no está asignado o el `discard` nunca se cumple |
| Colores lavados | `look_intensidad` demasiado alto; ajústalo desde el script coordinador |

## ❓ Preguntas frecuentes

**¿El post-proceso va antes o después de todo lo demás?**
Después: lee la imagen ya renderizada (`screen_texture`) y la reprocesa. Por eso el quad debe dibujarse encima de la escena.

**¿Puedo tener bloom "de verdad"?**
Godot ofrece bloom vía el entorno (WorldEnvironment → Glow). En un shader de pantalla puedes emular un resplandor sencillo, pero el bloom físico conviene dejarlo al post-proceso integrado.

**¿Por qué usar uniforms globales y no ajustar cada material?**
Para coherencia y control central: un parámetro compartido evita desincronizar el look entre superficie, agua y post-proceso.

**¿Cuánto post-proceso es demasiado?**
El que haga subir el tiempo de GPU por encima de tu presupuesto de frame. Mídelo: cada efecto a pantalla completa corre en todos los píxeles.

## 🔗 Referencias

- [Post-procesado avanzado con shaders de pantalla — Godot Docs](https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html)
- [Uniforms globales en el lenguaje de shaders — Godot Docs](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html)
- [Partículas GPU 3D — Godot Docs](https://docs.godotengine.org/en/stable/tutorials/3d/particles/index.html)
- [Glow y entorno (bloom) — Godot Docs](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html)

## ➡️ Siguiente clase

[Clase 108 - Panorama de la IA de juegos: qué es y qué no](../../parte-5-inteligencia-artificial-para-juegos/108-panorama-de-la-ia-de-juegos-que-es-y-que-no/README.md)
