# Clase 252 — Optimización por plataforma

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Documentación de Godot 4 (Renderers, Importing images, Optimizing for mobile)*
> ⏱️ Duración estimada: **85 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

El mismo juego se comporta de forma muy distinta en un PC con GPU dedicada, en un teléfono de gama baja, en una consola o en un navegador web. Un fillrate que sobra en PC ahoga a un móvil; una compresión de textura ideal para escritorio ni siquiera se soporta en otro hardware. Optimizar por plataforma significa aceptar que no hay un único ajuste óptimo, sino **presupuestos distintos** y una configuración adaptada a cada objetivo.

En esta clase compararás los tres renderers de Godot 4 (**Forward+**, **Mobile** y **Compatibility**) y aprenderás cuál elegir según la plataforma. Verás cómo la compresión de texturas (VRAM comprimida con BPTC/ASTC/ETC2) cambia por hardware, y montarás un sistema de **perfiles de calidad** (uno "PC alto" y otro "móvil bajo") que ajusta sombras, resolución y calidad, con **detección de plataforma en runtime** mediante `OS.get_name()` para aplicar el perfil adecuado al arrancar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Elegir el renderer adecuado (Forward+, Mobile o Compatibility) según la plataforma objetivo.
2. Explicar por qué la compresión de texturas depende del hardware (ETC2/ASTC/BPTC).
3. Detectar la plataforma en tiempo de ejecución con `OS.get_name()` y `OS.has_feature`.
4. Definir y aplicar perfiles de calidad diferenciados por plataforma.
5. Ajustar sombras, resolución de render y límites de FPS según un presupuesto por dispositivo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Diferencias PC / móvil / consola / web | Cada una tiene presupuesto y límites propios. |
| 2 | Renderer Forward+ | Máxima calidad para PC y consola potente. |
| 3 | Renderer Mobile | Equilibrio pensado para GPU móviles. |
| 4 | Renderer Compatibility | Amplia compatibilidad (web, hardware antiguo). |
| 5 | Compresión de texturas por plataforma | ETC2/ASTC/BPTC ahorran VRAM y ancho de banda. |
| 6 | Detección de plataforma en runtime | Aplicar ajustes correctos sin recompilar. |
| 7 | Perfiles de calidad | Un mismo build sirve a varios dispositivos. |
| 8 | Feature flags por plataforma | Activar o desactivar efectos según el objetivo. |

## 📖 Definiciones y características

- **Forward+**: renderer de mayor calidad de Godot 4, con clustering de luces. Clave: ideal para PC y consola de gama alta; pesado para móviles.
- **Mobile**: renderer optimizado para GPU móviles con tile-based rendering. Clave: menos efectos avanzados a cambio de mucho mejor rendimiento en teléfonos.
- **Compatibility**: renderer basado en OpenGL/WebGL. Clave: obligatorio para exportar a **web** y para hardware antiguo o muy limitado.
- **Compresión VRAM**: la textura vive comprimida en memoria de vídeo y la GPU la descomprime al vuelo. Clave: los formatos soportados (BPTC en escritorio, ASTC/ETC2 en móvil) dependen del hardware.
- **`OS.get_name()`**: devuelve el nombre de la plataforma (`"Windows"`, `"Android"`, `"iOS"`, `"Web"`, etc.). Clave: base de la detección en runtime.
- **`OS.has_feature(nombre)`**: consulta capacidades como `"mobile"`, `"web"` o etiquetas de exportación. Clave: permite decidir sin listar todos los sistemas.
- **Perfil de calidad**: conjunto coherente de ajustes (sombras, resolución, FPS). Clave: se aplica al arrancar según la plataforma detectada.
- **Feature flag**: interruptor que activa o desactiva una característica. Clave: apaga efectos costosos en dispositivos débiles sin duplicar el proyecto.

## 🧰 Herramientas y preparación

Necesitas Godot 4.x. El renderer se elige en **Proyecto → Ajustes del proyecto → Rendering → Renderer → Rendering Method** (hay variantes para escritorio y para móvil). La compresión de texturas se configura por recurso en la pestaña **Importar** al seleccionar una imagen (modo de compresión: Lossless, Lossy o **VRAM Compressed**). Ten a mano el panel **Depurar → Monitores** para comparar tiempos de frame entre perfiles. Si dispones de un dispositivo Android, prepara la exportación para probar en hardware real, aunque el laboratorio funciona simulando plataformas en el editor.

Documentación de apoyo: renderers en <https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html>, optimización para móvil en <https://docs.godotengine.org/en/stable/tutorials/performance/index.html> e importación de imágenes en <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>.

## 🧪 Laboratorio guiado

Montaremos un autoload de calidad que detecta la plataforma y aplica un perfil "PC alto" o "móvil bajo", ajustando sombras, resolución de render y límite de FPS.

1. Crea un script `gestor_calidad.gd` y regístralo como **autoload** (singleton) en **Proyecto → Ajustes del proyecto → Autoload** con el nombre `Calidad`. Empezamos definiendo los perfiles como diccionarios:

```gdscript
extends Node

# Dos perfiles coherentes: cada uno es un presupuesto distinto.
const PERFIL_PC_ALTO := {
	"escala_render": 1.0,      # 100% de resolucion interna
	"sombras_activas": true,
	"tamano_sombra": 4096,
	"max_fps": 0,              # 0 = sin limite (que mande el vsync)
}

const PERFIL_MOVIL_BAJO := {
	"escala_render": 0.75,     # render a 75% y escalado -> menos fillrate
	"sombras_activas": false,  # las sombras son caras en GPU movil
	"tamano_sombra": 1024,
	"max_fps": 60,             # limitar FPS ahorra bateria y calor
}
```

2. Detecta la plataforma en `_ready` y elige el perfil. Usamos `OS.get_name()` y `OS.has_feature("mobile")`:

```gdscript
var perfil_actual: Dictionary = {}

func _ready() -> void:
	if _es_plataforma_movil():
		perfil_actual = PERFIL_MOVIL_BAJO
		print("Plataforma movil detectada -> perfil BAJO")
	else:
		perfil_actual = PERFIL_PC_ALTO
		print("Plataforma de escritorio detectada -> perfil ALTO")
	aplicar_perfil(perfil_actual)

func _es_plataforma_movil() -> bool:
	# has_feature("mobile") cubre Android e iOS de forma robusta.
	return OS.has_feature("mobile") or OS.get_name() in ["Android", "iOS"]
```

3. Aplica el perfil tocando las propiedades reales del render. La escala de render y el límite de FPS son ajustes globales:

```gdscript
func aplicar_perfil(perfil: Dictionary) -> void:
	# Escala de resolucion interna: bajarla reduce muchisimo el fillrate.
	get_viewport().scaling_3d_scale = perfil["escala_render"]
	# Limite de FPS del motor: 0 significa sin tope.
	Engine.max_fps = perfil["max_fps"]
	# Activar o desactivar sombras direccionales de la luz principal.
	_configurar_sombras(perfil["sombras_activas"], perfil["tamano_sombra"])
```

4. Ajusta las sombras. Buscamos la luz direccional de la escena por grupo y activamos o no su sombra:

```gdscript
func _configurar_sombras(activas: bool, tamano: int) -> void:
	# Calidad global de las sombras direccionales (RenderingServer).
	RenderingServer.directional_shadow_atlas_set_size(tamano, true)
	# Cada luz del grupo "luces_sombra" respeta el perfil.
	for luz in get_tree().get_nodes_in_group("luces_sombra"):
		if luz is Light3D:
			luz.shadow_enabled = activas
```

5. En tu escena de prueba, añade una `DirectionalLight3D` y agrégala al grupo `luces_sombra` (pestaña **Nodo → Grupos**). Coloca geometría suficiente para notar el coste (varios `MeshInstance3D` con sombras).

6. Ejecuta con F5 en escritorio: verás el perfil ALTO con sombras nítidas y resolución completa. Observa el tiempo de frame en Monitores.

7. Simula el móvil sin dispositivo. Fuerza temporalmente el perfil bajo cambiando la condición, o mejor, exporta con la etiqueta `mobile`. Para una prueba rápida en el editor:

```gdscript
func _forzar_perfil_movil_para_probar() -> void:
	# Solo para pruebas: aplica el perfil bajo aunque estemos en PC.
	perfil_actual = PERFIL_MOVIL_BAJO
	aplicar_perfil(perfil_actual)
	print("FORZADO perfil movil. Escala: %.2f | FPS max: %d" % [
		perfil_actual["escala_render"], perfil_actual["max_fps"]])
```

Llámalo desde una tecla de depuración y compara el tiempo de frame: la escala 0.75 y las sombras apagadas deben bajarlo notablemente. Sobre compresión de texturas, selecciona una textura grande en el FileSystem, abre **Importar** y cambia a **VRAM Compressed**: Godot elegirá BPTC o ASTC/ETC2 según la plataforma de exportación, ahorrando VRAM sin que toques nada más.

## ✍️ Ejercicios

1. Añade un tercer perfil "PC medio" (escala 0.9, sombras 2048) y una lógica que lo elija en un rango intermedio.
2. Expón un método `Calidad.set_perfil("bajo")` para que un menú de opciones cambie la calidad en caliente.
3. Detecta si la plataforma es **Web** con `OS.has_feature("web")` y fuerza el perfil bajo automáticamente.
4. Guarda el perfil elegido por el usuario en un `ConfigFile` y recárgalo al arrancar.
5. Añade un feature flag `postproceso_activo` que apague un efecto de pantalla completa (glow) en el perfil bajo.
6. Muestra en pantalla el nombre de la plataforma detectada y el perfil aplicado con un `Label` de depuración.

## 📝 Reto verificable

Implementa un autoload `Calidad` que al arrancar detecte la plataforma con `OS.get_name()`/`OS.has_feature`, seleccione entre al menos dos perfiles diferenciados (alto y bajo), aplique escala de render, estado de sombras y `Engine.max_fps` reales, y permita cambiar de perfil en tiempo de ejecución desde un menú. El perfil elegido debe persistir entre sesiones.

**Criterio de aceptación**: al ejecutar en escritorio se aplica el perfil alto (sombras y resolución completa); al forzar o exportar a móvil se aplica el bajo (escala reducida, sin sombras, FPS limitado a 60), y el cambio se refleja en el tiempo de frame de los Monitores. El perfil seleccionado se conserva tras cerrar y reabrir.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El juego no exporta a web con Forward+ | Web requiere el renderer **Compatibility**. Cámbialo en los ajustes de rendering. |
| Texturas negras o corruptas en móvil | El formato de compresión no lo soporta el hardware. Usa **VRAM Compressed** y reimporta. |
| `scaling_3d_scale` no cambia nada | Estás en un proyecto 2D o el viewport no es 3D; usa la propiedad correcta del viewport. |
| El perfil móvil no se aplica en el dispositivo | `OS.get_name()` no coincide; añade `OS.has_feature("mobile")` como respaldo. |
| Las sombras siguen activas pese al perfil bajo | Las luces no están en el grupo `luces_sombra` o no son `Light3D`. |
| FPS descontrolado y batería caliente | `Engine.max_fps` quedó en 0 en móvil. Limítalo a 60 en el perfil bajo. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo cambiar el renderer en tiempo de ejecución?** No, el Rendering Method se fija al arrancar. Lo que sí ajustas en caliente es la calidad (escala, sombras, efectos) dentro de ese renderer.

**❓ ¿Debo tener un proyecto distinto por plataforma?** No es necesario. Un mismo proyecto con perfiles de calidad y feature flags cubre varias plataformas; solo cambia el preset de exportación.

**❓ ¿Por qué la compresión de texturas depende del hardware?** Cada GPU soporta formatos distintos: BPTC es típico de escritorio, ASTC/ETC2 de móvil. Godot elige el adecuado según la plataforma de exportación al importar.

**❓ ¿Bajar la escala de render se nota mucho?** Reduce el fillrate de forma drástica, que suele ser el cuello en móvil. Con un buen filtro de escalado la pérdida visual es aceptable a cambio de un gran salto de FPS.

## 🔗 Referencias

- Godot Docs — Renderers: <https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html>
- Godot Docs — Performance / optimización: <https://docs.godotengine.org/en/stable/tutorials/performance/index.html>
- Godot Docs — Importing images (compresión): <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>
- Godot Docs — OS (get_name, has_feature): <https://docs.godotengine.org/en/stable/classes/class_os.html>

## ➡️ Siguiente clase

[Clase 253 - Herramientas nativas de profiling (RenderDoc)](../253-herramientas-nativas-de-profiling-renderdoc/README.md)
