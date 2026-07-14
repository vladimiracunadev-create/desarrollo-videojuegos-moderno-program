# Clase 251 — Tiempos de carga y arranque

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Background loading, ResourceLoader)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

El tiempo de carga es lo primero que percibe el jugador, y una pantalla congelada durante tres segundos comunica "esto está roto" aunque el juego funcione perfectamente. En esta clase separarás dos problemas distintos: el **tiempo real** de carga (cuántos milisegundos tarda leer y construir los recursos) y la **percepción** de ese tiempo (qué ve y siente el jugador mientras espera). Un juego pulido ataca ambos.

Aprenderás a cargar escenas y recursos pesados en segundo plano con `ResourceLoader.load_threaded_request`, a consultar el progreso con `load_threaded_get_status` sin bloquear el hilo principal, y a recoger el resultado con `load_threaded_get`. Construirás una pantalla de carga con barra de progreso que cambia de escena sin que la aplicación se congele ni un frame. También verás cuándo conviene `preload` frente a `load` y cómo lograr un arranque rápido.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Distinguir el tiempo de carga real de la percepción del tiempo de carga.
2. Cargar recursos en segundo plano con `load_threaded_request` sin congelar el juego.
3. Consultar el estado y el progreso con `load_threaded_get_status` y actualizar una barra.
4. Recoger la escena cargada con `load_threaded_get` y cambiar a ella con `change_scene_to_packed`.
5. Elegir entre `preload` y `load` según el momento y el peso del recurso.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Percepción del tiempo de carga | Un jugador entretenido percibe la espera más corta. |
| 2 | Carga bloqueante vs. en background | La carga síncrona congela el frame; la de fondo no. |
| 3 | `load_threaded_request` | Lanza la carga en un hilo aparte sin bloquear. |
| 4 | `load_threaded_get_status` | Da el progreso para animar una barra fiel. |
| 5 | `load_threaded_get` | Recoge el recurso ya construido cuando termina. |
| 6 | `preload` vs. `load` | Compromiso entre memoria y latencia. |
| 7 | Escenas empaquetadas (`PackedScene`) | Unidad de carga y cambio de escena. |
| 8 | Arranque rápido | Diferir lo no esencial para llegar antes al menú. |

## 📖 Definiciones y características

- **Tiempo de carga percibido**: la duración que el jugador *cree* que esperó. Clave: una barra que avanza y una animación lo reducen sin tocar el tiempo real.
- **Carga bloqueante**: `load()` o `preload` construyen el recurso en el hilo principal y detienen el juego hasta terminar. Clave: aceptable para lo pequeño, fatal para lo grande.
- **`load_threaded_request(path)`**: pide al motor que cargue un recurso en un hilo de fondo. Clave: retorna de inmediato; la carga sigue en paralelo.
- **`load_threaded_get_status(path, progress)`**: devuelve el estado y llena un array con el progreso de 0.0 a 1.0. Clave: llamar cada frame para animar la barra.
- **`load_threaded_get(path)`**: recupera el recurso terminado; bloquea brevemente si aún no acabó. Clave: llamarlo solo cuando el estado sea `LOADED`.
- **`PackedScene`**: escena serializada lista para instanciar. Clave: es lo que se carga y lo que consume `change_scene_to_packed`.
- **`preload(path)`**: carga en tiempo de compilación del script, disponible antes de `_ready`. Clave: sube el tiempo de arranque a cambio de latencia cero en uso.
- **`load(path)`**: carga en tiempo de ejecución, cuando se ejecuta la línea. Clave: no penaliza el arranque pero puede causar un tirón puntual.

## 🧰 Herramientas y preparación

Trabajaremos en un proyecto Godot 4.x con dos escenas: una `pantalla_carga.tscn` (con un `ProgressBar` y un `Label`) y una escena "pesada" de destino, por ejemplo `nivel_grande.tscn` con muchos nodos, luces o texturas grandes para que la carga sea observable. Configura la pantalla de carga como escena principal en **Proyecto → Ajustes del proyecto → Application → Run → Main Scene**. Ten abierto el panel **Depurar → Monitores** para observar el uso de memoria mientras cargas.

Documentación de apoyo: carga en segundo plano en <https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html> y la clase `ResourceLoader` en <https://docs.godotengine.org/en/stable/classes/class_resourceloader.html>.

## 🧪 Laboratorio guiado

Construiremos una pantalla de carga con barra de progreso que carga un nivel pesado en segundo plano y cambia a él sin congelar la aplicación.

1. Crea `pantalla_carga.tscn` con esta jerarquía: un `Control` raíz llamado `PantallaCarga`, con un hijo `ProgressBar` llamado `Barra` y un `Label` llamado `Estado`. Coloca la barra centrada.

2. Asigna este script `pantalla_carga.gd` al nodo raíz:

```gdscript
extends Control

# Ruta de la escena pesada que queremos cargar en segundo plano.
const RUTA_NIVEL: String = "res://escenas/nivel_grande.tscn"

@onready var barra: ProgressBar = $Barra
@onready var estado: Label = $Estado

func _ready() -> void:
	barra.min_value = 0.0
	barra.max_value = 100.0
	estado.text = "Cargando..."
	# Lanzamos la peticion de carga: retorna al instante, el motor trabaja aparte.
	var error := ResourceLoader.load_threaded_request(RUTA_NIVEL)
	if error != OK:
		estado.text = "Error al iniciar la carga"
		push_error("No se pudo solicitar la carga de %s" % RUTA_NIVEL)
```

3. Ahora consulta el progreso cada frame en `_process`. Godot llena un array con un valor entre 0.0 y 1.0:

```gdscript
func _process(_delta: float) -> void:
	var progreso: Array = []  # el motor escribira aqui el avance (0.0 a 1.0)
	var estado_carga := ResourceLoader.load_threaded_get_status(RUTA_NIVEL, progreso)

	match estado_carga:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# progreso[0] va de 0.0 a 1.0; lo mostramos como porcentaje.
			barra.value = progreso[0] * 100.0
			estado.text = "Cargando... %d%%" % int(barra.value)
		ResourceLoader.THREAD_LOAD_LOADED:
			barra.value = 100.0
			estado.text = "Listo"
			_cambiar_a_nivel()
		ResourceLoader.THREAD_LOAD_FAILED:
			estado.text = "Fallo la carga"
			set_process(false)
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			estado.text = "Recurso invalido"
			set_process(false)
```

4. Cuando el estado sea `LOADED`, recoge el `PackedScene` ya construido y cambia a él. Detén el `_process` para no seguir consultando:

```gdscript
func _cambiar_a_nivel() -> void:
	set_process(false)  # ya no necesitamos seguir consultando el estado
	var escena: PackedScene = ResourceLoader.load_threaded_get(RUTA_NIVEL)
	# change_scene_to_packed recibe un PackedScene ya cargado en memoria.
	get_tree().change_scene_to_packed(escena)
```

5. Ejecuta con F5. Verás la barra avanzar de 0 a 100 % de forma fluida y, al llegar, el juego salta al nivel pesado. En ningún momento la ventana se congela: puedes moverla mientras carga.

6. Para *comprobar* la diferencia, prueba la versión bloqueante de forma temporal. Comenta el flujo anterior y usa `get_tree().change_scene_to_file(RUTA_NIVEL)` directamente en `_ready`. Notarás un tirón o congelación proporcional al peso del nivel: ese es exactamente el problema que la carga en background elimina.

7. Mide el tiempo real de la carga para tener un número, no una sensación. Envuelve la petición y la recogida con marcas de tiempo:

```gdscript
var _inicio_usec: int = 0

func _iniciar_medicion() -> void:
	_inicio_usec = Time.get_ticks_usec()

func _reportar_medicion() -> void:
	var ms := (Time.get_ticks_usec() - _inicio_usec) / 1000.0
	print("Carga completada en %.1f ms" % ms)
```

Llama a `_iniciar_medicion()` justo antes de `load_threaded_request` y a `_reportar_medicion()` dentro del caso `THREAD_LOAD_LOADED`. Ya tienes una pantalla de carga real y un número para optimizar.

## ✍️ Ejercicios

1. Sustituye el porcentaje numérico por una animación de puntos suspensivos ("Cargando", "Cargando.", "Cargando..") para mejorar la percepción sin tocar el tiempo real.
2. Añade un tiempo mínimo de 1 segundo en pantalla aunque la carga sea instantánea, para evitar un parpadeo brusco de la barra.
3. Carga **dos** recursos en paralelo (nivel + música) y muestra el progreso promedio de ambos en la barra.
4. Reemplaza el `Label` de estado por un texto rotatorio de consejos de juego (tips) que cambie cada 2 segundos.
5. Convierte un `preload` de un recurso grande a `load` en background y compara el tiempo de arranque con los monitores.
6. Añade un botón "Cancelar" que use `ResourceLoader.load_threaded_get` con un modo de descarte para volver al menú.

## 📝 Reto verificable

Crea un flujo Menú → Pantalla de carga → Nivel donde la pantalla de carga reciba por variable la ruta del nivel a cargar (para reutilizarla con cualquier nivel), muestre una barra de progreso fiel basada en `load_threaded_get_status`, imprima en consola el tiempo real de carga en milisegundos y cambie a la escena solo cuando el estado sea `THREAD_LOAD_LOADED`.

**Criterio de aceptación**: al ejecutar, la ventana nunca se congela (se puede arrastrar durante la carga), la barra avanza de 0 a 100 % reflejando el progreso real, la consola imprime el tiempo en ms y el juego entra al nivel correcto. Cambiar la ruta objetivo carga otro nivel sin modificar el resto del código.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| La barra salta de 0 a 100 sin pasos | Consultas el estado una sola vez en `_ready` en vez de cada frame en `_process`. |
| La ventana se congela igual | Usaste `load()` o `change_scene_to_file` en lugar de la carga en hilo. |
| "Can't load resource... use load_threaded_request first" | Llamaste a `load_threaded_get` sin haber pedido antes `load_threaded_request`. |
| `progreso[0]` da un error de índice | El array debe pasarse vacío; el motor lo rellena. No accedas antes de `THREAD_LOAD_IN_PROGRESS`. |
| El progreso se queda en 0.0 siempre | La escena no tiene subrecursos que reportar; es normal en escenas ligeras. Usa una escena pesada real. |
| El juego cambia de escena varias veces | No detuviste `_process` con `set_process(false)` tras cargar. |

## ❓ Preguntas frecuentes

**❓ ¿`load_threaded_request` usa hilos aunque yo no cree ninguno?** Sí. El motor gestiona el hilo de fondo internamente; tú solo pides, consultas y recoges. No manipulas `Thread` a mano.

**❓ ¿Cuándo uso `preload` y cuándo `load`?** `preload` para recursos pequeños y siempre necesarios (se resuelven al compilar el script y no dan latencia en uso); `load` o carga en background para lo grande o condicional, para no penalizar el arranque.

**❓ ¿Qué pasa si llamo a `load_threaded_get` antes de que termine?** Bloquea el hilo principal hasta que la carga acabe, perdiendo la ventaja. Llámalo solo cuando el estado sea `THREAD_LOAD_LOADED`.

**❓ ¿La barra de progreso es exacta?** Es una estimación basada en los subrecursos de la escena. Es fiel para escenas con muchas dependencias, pero puede avanzar a saltos en escenas simples.

## 🔗 Referencias

- Godot Docs — Background loading: <https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html>
- Godot Docs — ResourceLoader: <https://docs.godotengine.org/en/stable/classes/class_resourceloader.html>
- Godot Docs — SceneTree (change_scene_to_packed): <https://docs.godotengine.org/en/stable/classes/class_scenetree.html>
- Godot Docs — PackedScene: <https://docs.godotengine.org/en/stable/classes/class_packedscene.html>

## ➡️ Siguiente clase

[Clase 252 - Optimización por plataforma](../252-optimizacion-por-plataforma/README.md)
