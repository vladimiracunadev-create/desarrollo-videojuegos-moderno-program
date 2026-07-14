# Clase 206 — Monetización móvil: anuncios y compras in-app

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Android plugins) · developers.google.com (AdMob, Play Billing)*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Ganar dinero en móvil se apoya en dos modelos: **anuncios** (banner, interstitial, rewarded) y **compras in-app** (IAP: consumibles, no consumibles, suscripciones). Aquí hay que ser claros con la arquitectura: Godot **no trae AdMob ni billing nativos**. Se integran como **plugins de Android** (GDExtension / Android plugins externos) que envuelven los SDK nativos de Google. Tú los añades al proyecto, activas el build de Gradle, y llamas a su API desde GDScript.

En esta clase vemos los modelos de monetización, cómo se integra un plugin de anuncios o IAP paso a paso, y mostramos un **rewarded ad** con el patrón típico de señales. Cerramos con ética y UX: dónde poner (y dónde no) los anuncios, cómo diseñar recompensas justas y qué exige la tienda. El código de la API del plugin es ilustrativo del patrón real; el nombre exacto de métodos depende del plugin concreto que instales.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir los formatos de anuncios (banner, interstitial, rewarded) y sus usos.
2. Clasificar las compras in-app (consumible, no consumible, suscripción).
3. Explicar por qué anuncios e IAP se integran como plugins de Android, no como API nativa de Godot.
4. Integrar un plugin de monetización y mostrar un rewarded ad con el patrón de señales.
5. Aplicar buenas prácticas éticas y de UX en la monetización.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Banner | Ingreso pasivo, poco intrusivo. |
| 2 | Interstitial | Pantalla completa entre niveles. |
| 3 | Rewarded | El jugador ve un ad a cambio de premio. |
| 4 | IAP consumible | Se compra y se gasta (monedas). |
| 5 | IAP no consumible | Compra permanente (quitar ads). |
| 6 | Suscripción | Pago recurrente por beneficios. |
| 7 | Plugins de Android | Cómo Godot accede a los SDK nativos. |
| 8 | Ética y UX | Monetizar sin dañar la experiencia. |

## 📖 Definiciones y características

- **Banner**: anuncio pequeño y persistente en un borde. Clave: bajo ingreso pero baja fricción.
- **Interstitial**: anuncio a pantalla completa en pausas naturales. Clave: mayor ingreso; molesta si es frecuente.
- **Rewarded ad**: vídeo opcional que da una recompensa al completarlo. Clave: el formato mejor valorado por los jugadores porque es voluntario.
- **Consumible**: ítem que se compra y se consume (gemas). Clave: se puede recomprar; el estado lo lleva tu juego/servidor.
- **No consumible**: compra única permanente (versión "sin anuncios"). Clave: debe poder **restaurarse** en otro dispositivo.
- **Suscripción**: acceso recurrente con renovación automática. Clave: la gestiona la tienda (Play/App Store).
- **Plugin de Android (GDExtension/Android plugin)**: módulo externo que expone el SDK nativo a GDScript. Clave: es la vía real para AdMob y billing; requiere build de Gradle.
- **Test ad units**: identificadores de prueba de AdMob. Clave: se usan en desarrollo para no violar políticas con clics propios.

## 🧰 Herramientas y preparación

Necesitas el proyecto con **export de Android funcionando** (clase 201) y el **custom Gradle build** activado en el preset (los plugins nativos lo requieren). Elige un plugin de la comunidad para AdMob o Play Billing compatible con tu versión de Godot 4 (por ejemplo, integraciones GDExtension de AdMob mantenidas por la comunidad) y sigue su README para copiar el `.aar`/addon a `res://addons/` y activarlo en Project Settings → Plugins. Usa siempre **ad units de prueba** durante el desarrollo.

Consulta cómo crear/usar plugins de Android en Godot en <https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html>, la documentación de AdMob en <https://developers.google.com/admob/android/quick-start> y Play Billing en <https://developer.android.com/google/play/billing>. Revisa las políticas de anuncios de la tienda antes de publicar.

## 🧪 Laboratorio guiado

Integraremos un plugin de anuncios y mostraremos un **rewarded ad**. Los nombres de métodos siguen el patrón habitual de estos plugins; ajusta según el que instales.

1. Activa el **build de Gradle**: en **Project → Export → Android**, marca **Use Gradle Build** e instala la plantilla de build de Android si te la pide.

2. Instala el plugin: copia su carpeta a `res://addons/<plugin>/` según su README, y actívalo en **Project Settings → Plugins**. Añade tu **App ID de AdMob** al `AndroidManifest`/config que indique el plugin.

3. Crea un autoload `Anuncios.gd` que inicialice el plugin y cargue un rewarded de prueba:

```gdscript
extends Node

var _ads                       # instancia del singleton del plugin
var rewarded_listo: bool = false

signal recompensa_ganada(monto: int)

func _ready() -> void:
	if Engine.has_singleton("AdMob"):          # nombre según el plugin
		_ads = Engine.get_singleton("AdMob")
		_ads.initialize()
		_conectar_senales()
		_cargar_rewarded()
	else:
		push_warning("Plugin de ads no disponible (¿estás en escritorio?)")

func _cargar_rewarded() -> void:
	# ID de PRUEBA de AdMob mientras desarrollas.
	_ads.load_rewarded("ca-app-pub-3940256099942544/5224354917")

func mostrar_rewarded() -> void:
	if rewarded_listo and _ads:
		_ads.show_rewarded()
	else:
		push_warning("Rewarded aún no está listo")
```

4. Conecta las señales del plugin (los nombres varían) para saber cuándo el ad cargó, se cerró o entregó recompensa:

```gdscript
func _conectar_senales() -> void:
	_ads.rewarded_loaded.connect(func(): rewarded_listo = true)
	_ads.rewarded_closed.connect(func():
		rewarded_listo = false
		_cargar_rewarded())          # precarga el siguiente
	_ads.rewarded_earned.connect(func(tipo, monto):
		recompensa_ganada.emit(int(monto)))
```

5. En tu juego, ofrece el rewarded como **opción voluntaria**: por ejemplo un botón "Ver anuncio y ganar 50 monedas". Al pulsarlo llamas a `Anuncios.mostrar_rewarded()` y escuchas la recompensa:

```gdscript
func _ready() -> void:
	Anuncios.recompensa_ganada.connect(_on_recompensa)

func _on_boton_ver_ad() -> void:
	Anuncios.mostrar_rewarded()

func _on_recompensa(monto: int) -> void:
	Jugador.monedas += monto           # solo tras completar el vídeo
	print("Recompensa entregada: ", monto)
```

6. Prueba en un **dispositivo Android** (los ads no funcionan en escritorio): exporta, abre el juego, pulsa el botón y verifica que aparece el ad de prueba y que la recompensa se entrega **solo al completarlo**. Nunca hagas clic en ads reales durante pruebas.

7. Para **IAP**, el patrón es análogo con un plugin de billing: consultas productos, lanzas la compra, y en el callback de compra confirmada entregas el ítem (y para consumibles lo "consumes" para poder recomprar). Deja los no consumibles con un botón **Restaurar compras**.

8. Discute la UX: coloca el rewarded como bonus opcional, evita interstitials en mitad de la acción, y no escondas la "X" para cerrar. La monetización agresiva sube ingresos a corto plazo pero hunde retención y reseñas.

Con esto tienes el patrón real de integración de monetización y un rewarded funcionando de forma ética.

## ✍️ Ejercicios

1. Explica con tus palabras por qué AdMob no es API nativa de Godot y qué habilita el plugin.
2. Diseña dónde pondrías un banner, un interstitial y un rewarded en tu juego, justificando cada uno.
3. Añade un botón "Quitar anuncios" y descríbelo como IAP no consumible con opción de restaurar.
4. Implementa un cooldown para que el rewarded no se pueda pedir más de N veces por partida.
5. Registra en un `print`/HUD cuándo el rewarded carga, se muestra y entrega recompensa.
6. Redacta 3 reglas de "monetización ética" para tu juego y contrástalas con las políticas de la tienda.

## 📝 Reto verificable

Integra un plugin de monetización en tu build de Android y muestra un **rewarded ad de prueba** que, **solo al completarse**, entregue una recompensa in-game (por ejemplo monedas), ofrecido como acción **voluntaria** desde un botón claro. Acompaña la entrega con una breve nota de buenas prácticas de UX.

**Criterio de aceptación**: el proyecto usa Gradle build con el plugin activo; el rewarded se carga y se muestra en un dispositivo real usando ad unit de prueba; la recompensa se entrega únicamente tras la señal de "earned/completed" (no si el usuario cierra antes); el ad es opcional y no bloquea el juego; y la nota de UX explica por qué el rewarded se ofrece de forma voluntaria y sin patrones oscuros.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "Singleton 'AdMob' not found" | Falta el plugin o el Gradle build. Activa Use Gradle Build e instala/activa el addon. |
| Los ads no aparecen en el PC | Los SDK de ads solo corren en el dispositivo. Prueba en Android exportado. |
| Cuenta de AdMob suspendida | Clics propios en ads reales durante pruebas. Usa siempre ad units de prueba. |
| La recompensa se entrega aunque cierren el ad | Escuchaste "closed" en vez de "earned". Entrega solo en la señal de recompensa. |
| IAP no consumible no reaparece en otro móvil | Falta "Restaurar compras". Implementa la restauración con el plugin de billing. |
| La tienda rechaza la app por ads | Anuncios intrusivos o mal declarados. Sigue las políticas de anuncios de la tienda. |

## ❓ Preguntas frecuentes

**❓ ¿Godot tiene AdMob o billing incorporados?** No. Se integran mediante **plugins de Android** (GDExtension / Android plugins) que envuelven los SDK nativos de Google. Por eso necesitas el build de Gradle y activar el addon.

**❓ ¿Puedo probar anuncios en el editor de escritorio?** No; los SDK nativos solo funcionan en el dispositivo. En escritorio el plugin no está disponible, así que protege las llamadas con `Engine.has_singleton(...)` y prueba exportando a Android.

**❓ ¿Cuál es el formato de anuncio más aceptado?** El **rewarded**, porque es voluntario: el jugador elige verlo a cambio de un premio. Los interstitials mal ubicados y los banners intrusivos dañan la retención.

**❓ ¿Qué diferencia hay entre consumible y no consumible?** El consumible se gasta y se puede recomprar (monedas); el no consumible es permanente (quitar anuncios, desbloquear un nivel) y debe poder restaurarse en otros dispositivos del usuario.

## 🔗 Referencias

- Godot Docs — Creating Android plugins: <https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html>
- Google — AdMob for Android (quick start): <https://developers.google.com/admob/android/quick-start>
- Android — Google Play Billing: <https://developer.android.com/google/play/billing>
- Google Play — Políticas de monetización y anuncios: <https://support.google.com/googleplay/android-developer/answer/9857753>

## ➡️ Siguiente clase

[Clase 207 - Servicios: Google Play Games y Game Center](../207-servicios-google-play-games-y-game-center/README.md)
