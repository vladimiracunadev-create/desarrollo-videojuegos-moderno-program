# 🎮 Lab — 3D en tercera persona

> [⬅️ Volver a los labs](../README.md) · [📚 Parte 2 del curso](../../classes/parte-2-desarrollo-3d-motores-escenas-y-transformaciones/README.md)

El proyecto que acompaña a la **Parte 2** (clases 046–067) y a su [capstone (clase 067)](../../classes/parte-2-desarrollo-3d-motores-escenas-y-transformaciones/067-capstone-parte-2-un-nivel-3d-explorable-en-tercera-persona/README.md).

## 🎮 Qué es

Un nivel 3D explorable con un controlador en tercera persona en Godot 4:

- **Controlador relativo a la cámara**: "adelante" es hacia donde mira la cámara, no hacia un punto fijo del mundo (clase 056).
- **Cámara orbital** en un `SpringArm3D`, que se acerca sola cuando hay una pared de por medio en lugar de meterse dentro del terreno (clase 056).
- **Game feel heredado del 2D**: aceleración/fricción, *coyote time* y *jump buffer* (clase 030) — el tacto se nota igual en 3D.
- **Malla que gira hacia donde corres** con `lerp_angle`, mientras el cuerpo físico se mantiene alineado con el mundo (clase 048).
- **Cristales** flotantes que se recogen al tocarlos, con feedback y sonido (clase 039).
- **Portal de salida** que solo te deja ganar cuando llevas todos los cristales.
- **Mejor tiempo persistente** guardado en `user://save.json` (clase 043).

**Controles:** `W`/`A`/`S`/`D` o las flechas para moverte · el **ratón** para orbitar la cámara · `Espacio` para saltar · `Shift` para correr · `R` para reiniciar · `Esc` para liberar el ratón.

## 📁 Estructura

```text
3d-tercera-persona/
├── inicio/      ← empieza aquí: completa los TODO
│   ├── project.godot
│   ├── assets/          (sonidos CC0)
│   ├── escenas/         (mundo, jugador, cristal, bloque, meta, HUD)
│   └── scripts/         (jugador.gd, camara.gd y cristal.gd con TODO)
└── solucion/    ← referencia completa y jugable
```

Lo que ya viene resuelto en `inicio/` (para que te centres en el control): la generación del relieve, el seguimiento de la cámara, el HUD, el estado global, las escenas, el Input Map, las capas de colisión y los assets.

> **Sin mallas de terceros.** Todo lo que ves son primitivas de Godot (`BoxMesh`, `CapsuleMesh`, `CylinderMesh`) montadas por código: no hay que descargar ningún modelo y no arrastramos licencias ajenas. Los únicos assets son tres sonidos generados con [`scripts/generar_assets.py`](../../scripts/generar_assets.py).

## 🚀 Cómo empezar

1. Instala **Godot 4.3+** desde <https://godotengine.org/download>.
2. Godot → *Import* → `labs/3d-tercera-persona/inicio/project.godot` → **F5**.
3. Verás el nivel y al personaje… flotando quieto. Ese es tu punto de partida.
4. Abre `scripts/jugador.gd` y completa los `TODO` **en orden**. Ejecuta tras cada uno.

| TODO | Qué consigues | Clase |
|---|---|---|
| 1 | El personaje cae (gravedad, y ahora la Y va hacia arriba) | 046, 054 |
| 2 | Coyote time y jump buffer | 030 |
| 3 | **Que "adelante" sea hacia donde mira la cámara** | 048, 056 |
| 4 | Se mueve con aceleración, fricción y sprint | 030, 054 |
| 5 | Salta | 054 |
| 6 | La malla gira hacia donde corres | 048 |

Luego sigue con `camara.gd` (orbitar con el ratón, clase 056) y `cristal.gd` (recolectables, clase 039).

> ¿Atascado? Abre el archivo equivalente en `solucion/scripts/` y compara. No es hacer trampa: leer código bueno es parte de aprender.

### El TODO que de verdad importa

El **TODO 3** es el corazón del laboratorio. En 2D el mando manda en coordenadas del mundo: pulsar derecha es ir hacia +X y ya está. En 3D no: pulsar "adelante" tiene que significar *hacia donde mira la cámara*, así que la entrada hay que **rotarla** con la orientación del brazo de cámara antes de usarla.

Impleméntalo primero sin la rotación (paso 4) y muévete girando la cámara: verás al personaje ignorar por completo hacia dónde estás mirando. Añade entonces la rotación y compara. Esa diferencia es la clase 056 entera.

## 🗺️ El nivel

El nivel se genera desde **dos mapas ASCII** que están en `scripts/mundo.gd`, superpuestos y del mismo tamaño. Edítalos y verás el cambio al instante:

```text
ALTURAS     '.' abismo   '1'..'9' altura de la columna en niveles
ENTIDADES   'P' inicio   'o' cristal   'F' meta   '.' nada
```

Es el mismo truco que el mapa del [lab 2D](../plataformas-2d/README.md): así el nivel es legible, se edita con cualquier editor y se revisa en un diff. `mundo.gd` valida al arrancar que las dos capas están alineadas — un mapa descuadrado produce agujeros fantasma que cuesta muchísimo depurar.

> La [clase 065](../../classes/parte-2-desarrollo-3d-motores-escenas-y-transformaciones/065-nivel-3d-gridmap-kits-modulares-y-blockout/README.md) enseña el flujo real con **GridMap** en el editor. Aquí usamos texto por legibilidad; el resultado en pantalla es equivalente.

**Un detalle de rendimiento** (clase 066): los bloques salen todos de la misma escena de 1×1×1 y se **escalan**. Se escala el nodo, nunca la malla: modificar una `PrimitiveMesh` la reconstruye entera, y aquí hay 181 bloques.

## ✅ Retos para ampliarlo

1. **Doble salto**: permite un salto extra en el aire (resetea al tocar suelo).
2. **Dash** en la dirección de la cámara, con cooldown (clase 024).
3. **Plataformas móviles**: `AnimatableBody3D` con un `Tween` (clase 057).
4. **Invertir el eje Y** de la cámara como opción — media internet lo necesita.
5. **Partículas** al aterrizar y al recoger un cristal (clase 101).
6. **Enemigos** que patrullen el nivel con `NavigationAgent3D` (Parte 6).
7. **Un modelo de verdad**: sustituye la cápsula por un `.glb` animado (clases 050 y 060–061). El `.gitattributes` del repo ya versiona `.glb` con LFS.

## 🔍 Verificación

Este proyecto se comprueba automáticamente en CI con **Godot headless**: se importa y se arranca durante 300 frames buscando errores de script o de carga, y se exige que el nivel llegue a construirse. Puedes hacer lo mismo en local:

```bash
godot --headless --path labs/3d-tercera-persona/solucion --import
godot --headless --path labs/3d-tercera-persona/solucion --quit-after 300
```
