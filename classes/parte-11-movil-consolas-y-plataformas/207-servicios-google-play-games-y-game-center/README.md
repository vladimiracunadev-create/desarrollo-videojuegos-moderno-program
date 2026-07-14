# Clase 207 — Servicios: Google Play Games y Game Center

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Google Play Games Services y Apple Game Center*
> ⏱️ Duración estimada: **80 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Integrar en un juego de Godot 4 los servicios sociales de las dos grandes plataformas móviles: **Google Play Games Services (PGS)** en Android y **Game Center** en iOS. Estos servicios aportan inicio de sesión con la cuenta de la plataforma, **logros**, **tablas de clasificación (leaderboards)** y **guardado en la nube**, y son los que dan a un juego móvil su capa social y de progreso persistente.

Un punto clave que debes interiorizar: **estos servicios no son API nativa de Godot**. El motor no incluye PGS ni Game Center de fábrica. Se integran mediante **plugins externos** (por ejemplo, plugins de la comunidad para Android/iOS) que exponen las funciones nativas a GDScript. Al terminar, sabrás diseñar un catálogo de logros, configurar una tabla de clasificación y desbloquear un logro desde tu código a través del plugin.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir qué ofrece PGS frente a Game Center y por qué ambos requieren un plugin externo en Godot 4.
2. Registrar un juego en Google Play Console y App Store Connect para habilitar sus servicios sociales.
3. Diseñar un catálogo de logros incremental y de desbloqueo, con identificadores estables.
4. Configurar una tabla de clasificación (leaderboard) y enviar puntuaciones desde el juego.
5. Invocar desde GDScript, a través del plugin, el inicio de sesión y el desbloqueo de un logro.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Panorama PGS vs Game Center | Cada tienda tiene su propio ecosistema social. |
| 2 | Plugins como puente nativo | Godot no trae estos servicios; el plugin los expone. |
| 3 | Sign-in con la cuenta de plataforma | Es la puerta a logros, leaderboards y nube. |
| 4 | Diseño de logros | Un buen catálogo motiva y guía al jugador. |
| 5 | Leaderboards | Comparación social que alarga la vida del juego. |
| 6 | Cloud save | Continuidad entre dispositivos del mismo usuario. |
| 7 | Identificadores estables | Cambiar un ID rompe datos ya publicados. |
| 8 | Manejo de errores y estados sin conexión | El móvil pierde red constantemente. |

## 📖 Definiciones y características

- **Google Play Games Services (PGS)**: conjunto de servicios de Google para juegos Android (login, logros, leaderboards, saved games). Clave: se configura en la consola de Play y se consulta vía plugin.
- **Game Center**: equivalente de Apple en iOS/macOS. Clave: se configura en App Store Connect y usa el framework GameKit por debajo del plugin.
- **Plugin externo**: extensión Android (AAR) o iOS que añade código nativo al export de Godot. Clave: sin él, GDScript no puede llamar a PGS ni Game Center.
- **Logro (achievement)**: recompensa por cumplir una condición. Clave: puede ser de **desbloqueo** (uno o cero) o **incremental** (progreso por pasos).
- **Leaderboard**: ranking ordenado de puntuaciones. Clave: cada tabla tiene un ID y un criterio (mayor o menor es mejor).
- **Cloud save / Saved Games**: almacenamiento del progreso ligado a la cuenta. Clave: hay que resolver conflictos cuando dos dispositivos guardan.
- **Sign-in**: autenticación con la cuenta de Google/Apple. Clave: muchas operaciones fallan si el usuario no ha iniciado sesión.
- **Identificador de logro/tabla**: cadena única definida en la consola. Clave: se referencia desde el código y no debe cambiarse tras publicar.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**, una cuenta de **Google Play Console** (pago único de registro) y/o una cuenta de **Apple Developer Program** (suscripción anual). Para Android se usa un plugin de PGS instalado en `res://addons/` que añade su `.gdap` y su AAR al export. Para iOS se usa un plugin equivalente de Game Center. Estos plugins los mantiene la comunidad; verifica siempre que la versión sea compatible con tu versión de Godot.

Consulta la documentación oficial de servicios: PGS <https://developers.google.com/games/services> y Game Center <https://developer.apple.com/game-center/>. Para el flujo de plugins Android en Godot 4, revisa <https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html>.

## 🧪 Laboratorio guiado

Integraremos un logro y una tabla de clasificación, y desbloquearemos el logro desde el juego. Los nombres de método del plugin varían según su versión; aquí se muestra un patrón representativo que envolveremos en un **autoload** para aislar la dependencia.

1. En **Google Play Console**, entra en tu app → **Play Games Services → Configuración y gestión → Configuración**. Crea la credencial y vincula el juego.

2. En **Logros**, crea uno nuevo: nombre visible "Primer salto", tipo **standard (desbloqueo)**. Copia su **ID** (algo como `CgkI...`).

3. En **Tablas de clasificación**, crea una: nombre "Mejor puntuación", orden **mayor es mejor**. Copia su ID.

4. Instala el plugin de PGS en `res://addons/` según su README y actívalo en **Project → Project Settings → Plugins**. En el export de Android, marca el plugin.

5. Crea un autoload `Social` (`res://autoload/social.gd`) que envuelva el plugin:

```gdscript
extends Node

# Envoltorio del plugin de Google Play Games Services.
# Aísla la dependencia externa: el resto del juego solo llama a este autoload.
var _pgs: Object = null
const ID_LOGRO_PRIMER_SALTO := "CgkI_reemplaza_este_id"
const ID_TABLA_PUNTUACION := "CgkI_reemplaza_esta_tabla"

func _ready() -> void:
	# El singleton lo publica el plugin al iniciarse en Android.
	if Engine.has_singleton("GodotPlayGameServices"):
		_pgs = Engine.get_singleton("GodotPlayGameServices")
		_pgs.signInWithCredentialsManager()  # inicia sesión al arrancar
	else:
		push_warning("PGS no disponible (¿estás en el editor o sin plugin?).")

func desbloquear_primer_salto() -> void:
	if _pgs == null:
		return
	_pgs.unlockAchievement(ID_LOGRO_PRIMER_SALTO)

func enviar_puntuacion(valor: int) -> void:
	if _pgs == null:
		return
	_pgs.submitScore(ID_TABLA_PUNTUACION, valor)
```

6. Desde el juego, llama al envoltorio cuando ocurra el evento. Por ejemplo, en el script del jugador tras el primer salto:

```gdscript
func _al_saltar_por_primera_vez() -> void:
	Social.desbloquear_primer_salto()
	Social.enviar_puntuacion(puntos_actuales)
```

7. Exporta a un dispositivo Android real (los servicios **no funcionan en el editor** ni en muchos emuladores). Inicia el juego, provoca el salto y verifica que aparece la notificación de logro desbloqueado.

Al aislar el plugin en `Social`, el resto del código no depende de nombres nativos y puedes ofrecer una implementación vacía en el editor.

## ✍️ Ejercicios

1. Añade un segundo logro de tipo **incremental** ("Salta 100 veces") y llama a su método de incremento paso a paso.
2. Muestra al jugador la UI nativa de logros con el método correspondiente del plugin y un botón en el menú.
3. Diseña en papel un catálogo de 8 logros que cubra inicio, progreso y maestría del juego.
4. Añade una comprobación de conexión: si no hay sesión iniciada, encola la puntuación y reenvíala al reconectar.
5. Crea un método `mostrar_leaderboard()` que abra la tabla de clasificación nativa.
6. Documenta en un archivo los IDs de logros y tablas para que el equipo no los invente sobre la marcha.

## 📝 Reto verificable

Amplía el autoload `Social` para soportar **tres logros** (uno de desbloqueo y dos incrementales) y **una tabla de clasificación**. Conecta cada logro a un evento real del juego y envía la puntuación al terminar una partida. Provee además una implementación falsa (mock) que registre por consola las llamadas cuando el plugin no esté presente.

**Criterio de aceptación**: en el editor, jugar y terminar una partida imprime en consola las llamadas simuladas sin errores; en un dispositivo Android real, se desbloquea al menos un logro visible y la puntuación aparece en la tabla.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Nada ocurre al desbloquear en el editor | Los servicios solo corren en dispositivo real; usa un mock en editor. |
| "Sign-in failed" o silencio total | La app no está bien vinculada en la consola o falta la huella SHA-1. Revisa la credencial. |
| El logro no aparece | Su ID en código no coincide con el de la consola, o el logro está sin publicar. |
| La tabla rechaza puntuaciones | Enviaste antes de iniciar sesión o el ID de tabla es incorrecto. |
| El plugin no carga en el export | No lo marcaste en el preset de export de Android o la versión es incompatible. |

## ❓ Preguntas frecuentes

**❓ ¿Godot trae PGS o Game Center de serie?** No. Ambos se integran con plugins externos que exponen el código nativo a GDScript; el motor no incluye estos servicios.

**❓ ¿Puedo probar los logros en el editor?** No de forma real. Envuelve el plugin en un autoload y ofrece un mock para el editor; prueba lo real en un dispositivo físico.

**❓ ¿Los IDs de logros se pueden cambiar luego?** Evítalo. Una vez publicado, cambiar un ID rompe los datos ya existentes; trátalos como constantes estables.

**❓ ¿Necesito ambos servicios?** Solo el de cada plataforma en la que publiques: PGS en Android, Game Center en iOS. Conviene abstraerlos tras una interfaz común.

## 🔗 Referencias

- Google Play Games Services: <https://developers.google.com/games/services>
- Apple Game Center: <https://developer.apple.com/game-center/>
- Godot Docs — Android plugins: <https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html>
- Diseño de logros (Play Console): <https://developer.android.com/games/pgs/achievements>

## ➡️ Siguiente clase

[Clase 208 - Publicar en las tiendas móviles](../208-publicar-en-las-tiendas-moviles/README.md)
