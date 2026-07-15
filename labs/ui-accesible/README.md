# 🖥️ Lab — UI accesible y localizada

> [⬅️ Volver a los labs](../README.md) · [📚 Parte 10 del curso](../../classes/parte-10-ui-ux-accesibilidad-y-localizacion/README.md)

El proyecto que acompaña a la **Parte 10** (clases 188–199) y a su [capstone (clase 199)](../../classes/parte-10-ui-ux-accesibilidad-y-localizacion/199-capstone-parte-10-una-ui-completa-accesible-y-localizada/README.md).

## 🖥️ Qué es

Un menú, un HUD y una pantalla de opciones que **no se rompen**: cambian de idioma en marcha, aguantan el texto al 200 %, se navegan enteros con el teclado y sobreviven a 16:9, 21:9 y 4:3.

- **Localización** con CSV → `es` / `en`, cambiable en runtime (clase 197).
- **Escala de texto** del 100 % al 200 % tocando el tema del proyecto, no Label a Label (clases 190 y 196).
- **Foco y navegación cíclica** con teclado y mando (clases 192 y 195).
- **Remapeo** de una acción, con `physical_keycode` (clase 195).
- **Subtítulos** activables (clase 196).
- **Persistencia** de todo en `user://ajustes.cfg` (clase 199).

## 📁 Estructura

```text
ui-accesible/
├── inicio/      ← empieza aquí: completa los TODO
│   ├── project.godot
│   ├── i18n/textos.csv      (las traducciones: esto se edita a mano)
│   ├── escenas/             (menu, hud, opciones, tema, verificar)
│   └── scripts/
│       ├── ajustes.gd       ← TU TRABAJO (TODO 1-3): idioma, escala, remapeo
│       ├── hud.gd           ← TU TRABAJO (TODO 4): textos hechos por código
│       ├── menu.gd          ← TU TRABAJO (TODO 5): foco y navegación
│       ├── opciones.gd      (los controles de la pantalla — resuelto)
│       └── verificador.gd   (la prueba automática — resuelto)
└── solucion/    ← referencia completa
```

## 🚀 Cómo empezar

1. Instala **Godot 4.3+** desde <https://godotengine.org/download>.
2. Godot → *Import* → `labs/ui-accesible/inicio/project.godot` → **F5**.
3. Verás el menú… **en clave**: botones que ponen `MENU_JUGAR` en vez de `Jugar`. Ese es el síntoma clásico de la localización sin conectar, y tu punto de partida.
4. Completa los `TODO` **en orden**:

| TODO | Dónde | Qué consigues | Clase |
|---|---|---|---|
| 1 | `ajustes.gd` | El idioma y el tamaño del texto se aplican a toda la UI | 190, 196, 197 |
| 2 | `ajustes.gd` | Los ajustes sobreviven al cierre del juego | 199 |
| 3 | `ajustes.gd` | Se puede remapear una tecla | 195 |
| 4 | `hud.gd` | Los textos hechos por código también se traducen | 197 |
| 5 | `menu.gd` | Hay foco, y la navegación da la vuelta | 192, 195 |

> ¿Atascado? Abre el archivo equivalente en `solucion/` y compara. No es hacer trampa: leer código bueno es parte de aprender.

## 🪤 Las tres trampas de la localización

**1. El `.text` de un Control guarda la clave, no la traducción.** Si lees `boton.text` te devuelve `MENU_JUGAR`, no `Jugar`: el Control guarda la clave y traduce al dibujar. Lo que el jugador ve es `atr(boton.text)`. Esto se descubre siempre depurando, y siempre tarde.

**2. Los textos hechos por código no se enteran de nada.** Un `Label` con la clave puesta en el editor se retraduce solo. Pero en cuanto haces `"Vidas: " + str(vidas)` eso es una cadena normal, y al cambiar de idioma **se queda como estaba** — mientras los botones de al lado sí cambian. De ahí que el HUD escuche una señal y se repinte (`TODO 4`).

**3. Nunca concatenes.** `tr("HUD_VIDAS").format([vidas])` y no `tr("VIDAS") + str(vidas)`: el orden de las palabras cambia entre idiomas, y con `{0}` el hueco puede moverse donde el idioma lo pida.

> **Y una del CSV**: si un texto lleva una coma, el campo va entre comillas. Si no, el importador cuenta columnas de más y **falla en silencio**: te quedas con cero traducciones y una UI llena de claves. Míralo en `i18n/textos.csv`, en la línea de los subtítulos.

## ♿ El conflicto que es el corazón del capstone

La clase 199 lo dice: lo difícil no es cada pieza suelta, es **que convivan**. Sube el texto al 200 % y el botón necesita el doble de ancho; cambia a inglés y *"Tamaño del texto"* pasa a *"Text size"* (más corto) pero *"Jugar"* pasa a *"Play"*… y otro texto crecerá. Si la UI está montada con posiciones y tamaños fijos, **se rompe**.

La respuesta no es "probar mucho": es montar la UI con **contenedores que crecen** (`VBoxContainer`, `MarginContainer`, `CenterContainer`) en vez de con coordenadas. Entonces el texto empuja al botón, el botón empuja a la caja, y todo encaja solo. En este lab no hay ni un `offset` a mano en el menú, y por eso aguanta el 200 % sin tocar nada.

Y lo mejor: eso **se puede comprobar sin mirar**. Lo que un texto necesita (`get_minimum_size()`) contra lo que tiene (`size`). Si necesita más, se está recortando. Es el assert que corre en CI.

## ✅ Retos para ampliarlo

1. **Un tercer idioma** con palabras largas de verdad (alemán es el clásico) y mira qué se rompe.
2. **Contraste WCAG**: calcula el ratio entre el color del texto y el del fondo y exige ≥ 4.5:1. Es aritmética pura — y por tanto verificable.
3. **Remapeo completo** de todas las acciones, con detección de teclas ya usadas.
4. **Daltonismo**: una paleta alternativa que no dependa solo del color (clase 196).
5. **Táctil**: áreas de toque de 48×48 px mínimo y `TouchScreenButton` (clase 195).
6. **Fuente con CJK**: añade japonés y descubre por qué la tipografía multiidioma es un tema entero (clase 198).
7. **Juice** (clase 193): anima las transiciones con `Tween`. Ojo: eso ya no es verificable en CI — corre en tiempo real. Es un buen ejemplo de dónde acaba la máquina y empieza tu ojo.

## 🔍 Verificación

Este lab se comprueba en CI de dos formas:

1. Como los demás: los dos proyectos importan y arrancan sin errores, y se exige que las traducciones se hayan compilado de verdad (si el CSV no se importa, `tr()` devuelve la clave y el marcador lo canta).
2. Con una **prueba de la interfaz**: 17 comprobaciones sobre foco, navegación cíclica, cambio de idioma (incluidos los textos por código), escala de texto al 100/150/200 % sin recortes, y tres aspect ratios.

Esto es posible porque **la UI de Godot se calcula en la CPU**: el layout, el foco y lo que ocupa un texto se resuelven sin GPU — solo el *dibujado* necesita tarjeta gráfica. Un runner sin pantalla puede responder a todo lo de arriba.

Lo que la CI **no** comprueba, y conviene decirlo: si la UI se ve bien. Que quepa no es que sea bonito. Eso lo juzgas tú.

```bash
godot --headless --path labs/ui-accesible/solucion --import   # compila el CSV
godot --headless --path labs/ui-accesible/solucion res://escenas/verificar.tscn
# Debe terminar en: == 17 comprobaciones, 0 fallo(s) ==
```
