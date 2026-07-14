# Clase 212 — Steam Deck y compatibilidad PC

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Steam Deck (Valve) y GodotSteam*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Preparar un juego de Godot 4 para la **Steam Deck**, la consola portátil de Valve que ejecuta un Linux (SteamOS) y corre juegos de Windows mediante la capa de compatibilidad **Proton**. Steam otorga a los juegos el sello **Steam Deck Verified** cuando cumplen criterios de **entrada (controles por defecto configurados)**, **legibilidad del texto**, **compatibilidad general** (funciona sin dependencias externas) y **rendimiento** aceptable en el hardware de la Deck.

También veremos la compatibilidad PC en general: soportar a la vez **teclado+ratón y gamepad**, y adaptarse a distintas **resoluciones**. Para la capa Steam (logros, nube, overlay) se usa **GodotSteam**, una GDExtension que integra la Steamworks API en Godot 4. Al terminar tendrás una checklist de verificación de Steam Deck y habrás ajustado un juego (control por defecto y tamaño de texto) para acercarlo a superarla.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar qué es Steam Deck, SteamOS y Proton, y qué implican para un juego de Godot.
2. Enumerar los criterios de Steam Deck Verified y clasificarlos por categoría.
3. Configurar un control por defecto de gamepad y soportar teclado+gamepad simultáneos.
4. Ajustar el tamaño de texto y la UI para la legibilidad en la pantalla de la Deck.
5. Describir el papel de GodotSteam para logros, nube y overlay en Steam.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Steam Deck, SteamOS y Proton | Definen cómo corre tu juego en el dispositivo. |
| 2 | Steam Deck Verified | Sello que mejora visibilidad y confianza. |
| 3 | Control por defecto | La Deck es primero un gamepad; debe jugarse sin teclado. |
| 4 | Legibilidad del texto | Pantalla pequeña: texto minúsculo suspende la verificación. |
| 5 | Teclado + gamepad simultáneos | El jugador alterna entre ambos sin fricción. |
| 6 | Resoluciones y escalado | La Deck es 1280×800; el juego debe adaptarse. |
| 7 | GodotSteam (GDExtension) | Integra logros, nube y overlay de Steam. |
| 8 | Rendimiento en hardware modesto | La Deck no es una torre gaming. |

## 📖 Definiciones y características

- **Steam Deck**: consola portátil de Valve con SteamOS (Linux). Clave: su pantalla es 1280×800 y su control principal es el gamepad integrado.
- **SteamOS**: sistema operativo Linux de la Deck. Clave: tu build de Windows corre traducido, no nativo (salvo build Linux).
- **Proton**: capa de compatibilidad que ejecuta juegos de Windows sobre Linux. Clave: la mayoría de juegos Godot funcionan bien bajo Proton.
- **Steam Deck Verified**: sello de Valve por cumplir entrada, legibilidad, compatibilidad y rendimiento. Clave: mejora la visibilidad en la tienda.
- **Control por defecto**: el juego debe ser jugable con el gamepad de la Deck sin configuración manual. Clave: requisito de entrada.
- **Legibilidad**: el texto debe leerse cómodamente en la pantalla de la Deck. Clave: causa frecuente de "Playable" en vez de "Verified".
- **GodotSteam**: GDExtension que expone la Steamworks API en Godot 4. Clave: da logros, cloud, overlay y datos del usuario de Steam.
- **Overlay de Steam**: capa que Steam superpone al juego (Shift+Tab). Clave: debe convivir bien con la entrada del juego.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y una cuenta de **Steamworks** (registro de partner con coste por app) si quieres integrar la API real. Para la capa Steam, instala **GodotSteam** como GDExtension en `res://addons/`. Lo ideal es probar en una **Steam Deck física**, pero muchos criterios (control por defecto, tamaño de texto, teclado+gamepad, resolución) se pueden validar en PC redimensionando la ventana a 1280×800.

Documentación: Steam Deck para desarrolladores <https://partner.steamgames.com/doc/steamdeck> y **GodotSteam** <https://godotsteam.com>. Revisa también el sistema de input de Godot para el soporte simultáneo de dispositivos.

## 🧪 Laboratorio guiado

Crearemos una checklist de verificación y ajustaremos el juego: control por defecto y tamaño de texto para la Deck.

1. Simula la pantalla de la Deck: en **Project → Project Settings → Display → Window**, prueba una resolución base **1280×800** y un **Stretch Mode: canvas_items** con **Aspect: keep** para escalar la UI.

2. Redacta la **checklist de verificación de Steam Deck**:

```text
ENTRADA
[ ] El juego es jugable de principio a fin solo con el gamepad
[ ] Existe una configuración de controles por defecto (no hay que mapear a mano)
[ ] Se muestran glifos de botones (no solo teclas de teclado)
[ ] Aparece el teclado en pantalla cuando se necesita texto

LEGIBILIDAD
[ ] El texto es legible a la distancia de uso de la Deck (>= ~9px equivalentes)
[ ] La UI no se recorta a 1280x800

COMPATIBILIDAD
[ ] Funciona bajo Proton sin dependencias externas ni instaladores extra
[ ] No requiere permisos de administrador ni pasos manuales

RENDIMIENTO
[ ] Framerate estable en el hardware de la Deck
[ ] Consumo/temperatura razonables (no full 3D innecesario)
```

3. Asegura el **soporte simultáneo teclado+gamepad**. En el Input Map, cada acción debe tener asignadas teclas **y** botones de mando. La lógica usa acciones:

```gdscript
func _physics_process(_delta: float) -> void:
	var dir := Input.get_axis("mover_izq", "mover_der")  # tecla o stick
	velocity.x = dir * VELOCIDAD
	if Input.is_action_just_pressed("saltar"):  # espacio o botón sur
		_saltar()
	move_and_slide()
```

4. Ajusta el **tamaño de texto** para legibilidad. En lugar de tamaños fijos pequeños, usa un `Theme` con una fuente de tamaño cómodo y escálalo con la resolución:

```gdscript
extends Label

# Garantiza un tamaño mínimo legible en la pantalla de la Deck.
const TAMANO_MINIMO := 22

func _ready() -> void:
	var actual: int = get_theme_font_size("font_size")
	if actual < TAMANO_MINIMO:
		add_theme_font_size_override("font_size", TAMANO_MINIMO)
```

5. Muestra **glifos de botón** en los tutoriales/HUD cuando hay mando conectado (reutiliza el autoload `Glifos` de la clase 211), y detecta el mando con:

```gdscript
func _ready() -> void:
	if not Input.get_connected_joypads().is_empty():
		var nombre := Input.get_joy_name(Input.get_connected_joypads()[0])
		print("Mando detectado: ", nombre)  # p. ej. en la Deck aparece su gamepad
```

6. (Opcional) Integra **GodotSteam**: instala la GDExtension, inicializa Steam al arrancar y usa sus métodos para desbloquear logros y guardar en Steam Cloud:

```gdscript
func _ready() -> void:
	if Engine.has_singleton("Steam"):
		Steam.steamInit()
		# Ejemplo de logro y guardado en nube tras iniciar Steamworks.
		# Steam.setAchievement("PRIMER_NIVEL")
		# Steam.storeStats()
```

7. Redimensiona la ventana del juego a 1280×800 en PC y recorre todos los menús: confirma que se juega solo con mando, que el texto se lee y que nada se recorta. Marca la checklist.

## ✍️ Ejercicios

1. Añade un teclado en pantalla (o invoca el nativo de Steam) cuando el jugador deba introducir un nombre con el gamepad.
2. Crea un `Theme` global con tamaños de fuente escalables y aplícalo a toda la UI.
3. Verifica que el juego arranca y se completa sin usar teclado en absoluto.
4. Comprueba tu juego a 1280×800 y corrige cualquier recorte de UI con anclas/contenedores.
5. Con GodotSteam, desbloquea un logro real de prueba y guárdalo en Steam Cloud.
6. Redacta un informe indicando, por cada criterio de la checklist, si tu juego lo cumple.

## 📝 Reto verificable

Elabora la **checklist de verificación de Steam Deck** (entrada, legibilidad, compatibilidad, rendimiento) y ajusta tu juego para acercarlo al sello: configura **controles por defecto de gamepad** de modo que sea jugable sin teclado, y garantiza un **tamaño de texto legible** a 1280×800 sin recortes de UI. Auto-evalúa el juego marcando cada criterio.

**Criterio de aceptación**: a resolución 1280×800, el juego se completa usando solo el gamepad, todo el texto es legible y ninguna pantalla de UI queda recortada; la checklist entregada refleja el estado real de cada criterio.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| No se puede jugar sin teclado | Faltan controles por defecto de gamepad. Asigna botones a todas las acciones. |
| El texto es ilegible en la Deck | Fuentes demasiado pequeñas. Usa un Theme con tamaño mínimo y escalado. |
| La UI se recorta a 1280×800 | Layout fijo en píxeles. Usa contenedores, anclas y Stretch Mode adecuado. |
| Solo se ven teclas de teclado en los tips | No detectas el mando ni muestras glifos. Usa `get_joy_name()` y un set de iconos. |
| Steam no inicializa | Falta GodotSteam o el `steam_appid.txt`/registro de app. Revisa la instalación. |

## ❓ Preguntas frecuentes

**❓ ¿Necesito una Steam Deck física para verificar?** Ayuda mucho, pero gran parte de los criterios (control por defecto, texto legible, teclado+gamepad, resolución) se validan en PC a 1280×800.

**❓ ¿Godot corre nativo en la Deck?** Corre bien bajo **Proton** con tu build de Windows; también puedes exportar un build Linux nativo. Ambos suelen funcionar.

**❓ ¿Qué es GodotSteam?** Una **GDExtension** que integra la Steamworks API en Godot 4: logros, Steam Cloud, overlay y datos del usuario. No viene con el motor.

**❓ ¿Qué diferencia hay entre "Verified" y "Playable"?** "Verified" cumple todos los criterios; "Playable" funciona pero con alguna fricción (texto pequeño, requiere tocar el touchpad, etc.).

## 🔗 Referencias

- Steam Deck para desarrolladores (Valve): <https://partner.steamgames.com/doc/steamdeck>
- GodotSteam (documentación): <https://godotsteam.com>
- Godot Docs — Multiple resolutions: <https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html>
- Godot Docs — Input examples: <https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html>

## ➡️ Siguiente clase

[Clase 213 - Capstone Parte 11: exportar y pulir para una plataforma](../213-capstone-parte-11-exportar-y-pulir-para-una-plataforma/README.md)
