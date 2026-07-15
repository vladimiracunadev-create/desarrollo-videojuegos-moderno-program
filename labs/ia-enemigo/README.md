# 🧠 Lab — IA de enemigos

> [⬅️ Volver a los labs](../README.md) · [📚 Parte 5 del curso](../../classes/parte-5-inteligencia-artificial-para-juegos/README.md)

El proyecto que acompaña a la **Parte 5** (clases 108–125) y a su [capstone (clase 125)](../../classes/parte-5-inteligencia-artificial-para-juegos/125-capstone-parte-5-enemigo-con-behavior-tree-y-percepcion/README.md).

## 🧠 Qué es

Un enemigo que te busca. Tiene **behavior tree**, **cono de visión**, **memoria** y **pathfinding con A\***, y con eso solo ya recorre el ciclo entero:

```text
patrulla → te ve → persigue → te pierde → busca donde te vio → vuelve a patrullar
```

- **Behavior tree** con Secuencia, Selector y hojas, y un **blackboard** como memoria compartida (clases 111–112).
- **Percepción** en tres filtros: distancia, cono de visión por producto punto, y línea de visión con `RayCast2D` (clase 116).
- **Memoria**: al perderte de vista no se olvida de ti; va a mirar dónde te vio por última vez (clase 116).
- **Pathfinding** con `AStarGrid2D` sobre el mapa (clase 113).

**Controles:** `WASD` o flechas para moverte. Escóndete tras un muro y mira qué hace.

## 📁 Estructura

```text
ia-enemigo/
├── inicio/      ← empieza aquí: completa los TODO
│   ├── project.godot
│   ├── escenas/         (mundo, enemigo, jugador)
│   └── scripts/
│       ├── mundo.gd         (nivel ASCII y reparto de dependencias — resuelto)
│       ├── navegador.gd     (el servicio de A* — resuelto)
│       ├── jugador.gd       (control y bot de pruebas — resuelto)
│       ├── enemigo.gd       ← TU TRABAJO: percepción, memoria y acciones
│       └── bt/
│           ├── nodo_bt.gd   (el contrato: EXITO / FALLO / EN_CURSO — resuelto)
│           ├── compuesto.gd (base de los nodos con hijos — resuelto)
│           ├── hoja.gd      (Condicion y AccionBT — resuelto)
│           ├── secuencia.gd ← TU TRABAJO (TODO 1)
│           └── selector.gd  ← TU TRABAJO (TODO 2)
└── solucion/    ← referencia completa
```

## 🚀 Cómo empezar

1. Instala **Godot 4.3+** desde <https://godotengine.org/download>.
2. Godot → *Import* → `labs/ia-enemigo/inicio/project.godot` → **F5**.
3. Verás el mapa, tu personaje y un enemigo rojo… plantado. Ese es tu punto de partida.
4. Completa los `TODO` **en orden**:

| TODO | Dónde | Qué consigues | Clase |
|---|---|---|---|
| 1 | `bt/secuencia.gd` | El "Y" del árbol | 111 |
| 2 | `bt/selector.gd` | El "O", y con él la **prioridad** | 111 |
| 3 | `enemigo.gd` | Que te vea (distancia + cono + muros) | 116 |
| 4 | `enemigo.gd` | Que te recuerde al perderte | 116 |
| 5 | `enemigo.gd` | Que te persiga con A\* | 113 |
| 6 | `enemigo.gd` | Que patrulle entre los puntos | 125 |

Con 1 y 2 el árbol ya decide, pero el enemigo sigue ciego: verás `IA: patrulla` y poco más. Con 3 y 4 empieza a verte. Con 5 y 6 se mueve.

> ¿Atascado? Abre el archivo equivalente en `solucion/` y compara. No es hacer trampa: leer código bueno es parte de aprender.

## 🌳 Por qué un árbol y no una máquina de estados

Con una FSM (clase 109), cada comportamiento nuevo te obliga a repasar **todas** las transiciones que ya tenías: cinco estados son veinte flechas posibles, y todas hay que pensarlas. Con un árbol, añadir un comportamiento es **añadir una rama**.

Todo el árbol se sostiene sobre dos ideas y nada más:

- **Cada nodo devuelve una de tres cosas**: `EXITO`, `FALLO` o `EN_CURSO`.
- **Secuencia** corta cuando algo *no* sale bien; **Selector** corta cuando algo *sí* sale bien.

Y de ahí sale la idea que más cuesta ver: **el orden de los hijos ES el diseño de la IA**. El selector raíz de este lab es

```text
raíz (Selector)
├── combatir   (Secuencia)  ¿lo veo? → persíguelo
├── buscar     (Secuencia)  ¿me queda memoria? → ve a donde lo vi
└── patrullar  (Secuencia)  recorre los puntos
```

Ese orden es lo único que hace que perseguirte gane a seguir la ronda. Cambia `patrullar` de sitio y tendrás un enemigo que te mira a la cara y se va a hacer su recorrido. Pruébalo: es un cambio de una línea y explica la Parte 5 entera.

> **Un detalle que se escapa siempre.** Perseguir devuelve `EN_CURSO`, no `EXITO`. Si devolviera `EXITO`, la secuencia daría la rama por terminada y el selector bajaría a patrullar en el frame siguiente. `EN_CURSO` es lo que significa "sigo en ello, no me interrumpas".

## 👁️ La percepción, en tres filtros

Ordenados del más barato al más caro, y ese orden importa:

1. **¿Está cerca?** Una resta y una longitud.
2. **¿Está en el cono?** Un producto punto contra el coseno del semiángulo. El `dot` de dos vectores normalizados **ya es** el coseno del ángulo entre ellos: compararlo con `cos(45°)` cuesta una multiplicación, mientras que sacar el ángulo con `acos()` cuesta mucho más y da lo mismo.
3. **¿Hay un muro en medio?** Ahora sí, un raycast — que es lo caro, y por eso va el último.

## 🗺️ El nivel

Se genera desde un **mapa ASCII** en `scripts/mundo.gd`. Edítalo y verás el cambio al instante:

```text
'#' muro   '.' suelo   'P' jugador   'E' enemigo   'o' punto de patrulla
```

Es el mismo truco de los otros labs: legible, editable con cualquier editor y revisable en un diff.

> **Por qué `AStarGrid2D` y no `NavigationAgent2D`.** El agente de navegación es más cómodo en un juego real, pero calcula por detrás y contesta por señal, así que dos partidas iguales no dan exactamente lo mismo. `AStarGrid2D` responde en el acto y siempre igual. Para **aprender** el algoritmo es mejor (lo ves entero, clase 113), y además es lo que permite que la CI compruebe la IA en vez de solo mirar si arranca. Cuando montes un juego 3D con terreno irregular, usa `NavigationAgent3D` — la clase 114 lo enseña.

## ✅ Retos para ampliarlo

1. **Flanqueo** (es el reto del capstone 125): si lo ves pero hay un muro en medio, rodea en vez de quedarte quieto.
2. **Un decorador `Inversor`**: devuelve EXITO donde su hijo da FALLO. Con él, "si NO lo veo" es una rama más.
3. **Oído** (clase 116): que el jugador haga ruido al correr y el enemigo lo investigue.
4. **Dos enemigos** que se avisen entre ellos (clase 119).
5. **Utility AI** (clase 117): que elija entre perseguir, pedir ayuda o huir según su vida.
6. **GOAP** (clase 118): sustituye el árbol por un planificador y compara.
7. **Dibuja el cono y la ruta** en pantalla con `_draw()`: ver lo que la IA "piensa" es la mejor herramienta de depuración que vas a tener.

## 🔍 Verificación

Este lab se comprueba en CI de dos formas:

1. Como los demás: los dos proyectos importan y arrancan headless sin errores.
2. Con una **prueba de comportamiento**: la CI mueve al jugador por un circuito fijo y exige que el árbol **recorra sus ramas** — que patrulle, te vea y persiga, te pierda y busque, y vuelva a patrullar. No se conforma con que arranque: un enemigo plantado también arranca.

Esa prueba es posible porque el lab es **determinista**: `AStarGrid2D` es síncrono y el bot lleva un recorrido fijo, así que la misma partida da siempre la misma secuencia. Puedes repetirla en local:

```bash
godot --headless --path labs/ia-enemigo/solucion --quit-after 1500 -- --bot
# Debe imprimir, en este orden:
#   IA: patrulla
#   IA: persecucion
#   IA: busqueda
#   IA: patrulla
```
