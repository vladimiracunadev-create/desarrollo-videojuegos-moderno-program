# Clase 249 — Optimización de assets: texturas, mallas y audio

> Parte: **14 — Optimización, profiling y rendimiento** · Fuente: *Godot Docs — Importing images y Optimizing 3D performance*
> ⏱️ Duración estimada: **65 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Los assets son, en muchos juegos, el mayor consumidor de memoria y ancho de banda: texturas que ocupan cientos de megabytes en VRAM, mallas con más polígonos de los necesarios y clips de audio cargados enteros en memoria. Un asset mal importado no se nota en el editor de un PC potente, pero hunde el rendimiento en móviles o dispositivos modestos. La buena noticia es que Godot expone en el diálogo de importación casi todo lo necesario para presupuestar cada tipo de asset.

En esta clase aprendes a decidir con criterio: **compresión de texturas** (VRAM vs disco, cuándo usar VRAM Compressed y cuándo Lossless), **tamaño y mipmaps** para texturas 3D, **conteo de polígonos y LODs de malla** generados en importación, y la elección crucial en audio entre **WAV** (descomprimido, cargado en RAM, ideal para efectos cortos) y **OGG streaming** (comprimido, leído desde disco, ideal para música larga). Medirás la **memoria de vídeo** con `Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)` antes y después de reimportar.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Elegir el modo de compresión de textura adecuado según el uso (UI, 3D, pixel art).
2. Explicar el compromiso entre VRAM y espacio en disco de cada modo.
3. Configurar mipmaps y tamaño de textura para reducir memoria de vídeo.
4. Reducir polígonos y generar LODs de malla en la importación.
5. Decidir entre WAV y OGG streaming según la duración y el uso del audio.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | VRAM vs disco | Comprimir para VRAM ahorra memoria de vídeo, no siempre disco. |
| 2 | Modos de compresión | VRAM Compressed, Lossless y Lossy tienen usos distintos. |
| 3 | Tamaño de textura | La VRAM crece con el cuadrado del tamaño; reducir importa mucho. |
| 4 | Mipmaps | Evitan aliasing en 3D y mejoran caché de textura, a coste de memoria. |
| 5 | Polígonos y LOD de malla | Menos triángulos lejanos = menos trabajo de GPU. |
| 6 | WAV vs OGG | Efectos cortos en RAM; música larga en streaming. |
| 7 | Presupuestos de assets | Fijar límites por plataforma evita sorpresas. |
| 8 | Medición de VRAM | `RENDER_VIDEO_MEM_USED` valida cada reimportación. |

## 📖 Definiciones y características

- **VRAM (memoria de vídeo)**: memoria de la GPU donde residen texturas y buffers. Clave: es limitada, sobre todo en móviles.
- **VRAM Compressed**: compresión que la GPU descomprime al vuelo (S3TC/BPTC en escritorio, ETC2/ASTC en móvil). Clave: reduce VRAM drásticamente; ideal para 3D.
- **Lossless / Lossy**: compresión de la imagen en disco sin/con pérdida, descomprimida a RGBA en VRAM. Clave: buena para UI y pixel art donde la calidad importa.
- **Mipmaps**: versiones progresivamente más pequeñas de una textura. Clave: reducen aliasing en objetos lejanos; suman ~33% de memoria.
- **LOD de malla**: versiones simplificadas de un modelo generadas en importación. Clave: Godot 4 las crea automáticamente y las usa por distancia.
- **WAV**: audio sin comprimir cargado entero en RAM. Clave: latencia mínima, ideal para efectos cortos y repetidos.
- **OGG Vorbis (streaming)**: audio comprimido leído desde disco por trozos. Clave: memoria baja, ideal para música y ambientes largos.
- **Presupuesto de assets**: límite acordado de VRAM/RAM/tamaño por categoría. Clave: convierte "optimizar" en un objetivo verificable.

## 🧰 Herramientas y preparación

Trabaja en Godot 4.x con una escena que mezcle assets pesados: varias texturas grandes (2K o 4K), un par de modelos 3D con muchos polígonos y clips de audio (un efecto corto y una pista de música larga). El diálogo de **Importar** (pestaña junto al inspector, o doble clic sobre el archivo en el sistema de archivos) es tu herramienta central: ahí eliges compresión, mipmaps, tamaño y opciones de malla y audio. Tras cambiar opciones, pulsa **Reimportar**.

Consulta las guías de importación de imágenes (<https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>) y de audio (<https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html>). Prepara un `Label` que muestre la VRAM en uso; será tu métrica principal:

```gdscript
extends Label

func _process(_delta: float) -> void:
	var vram := Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	var tex := Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
	text = "VRAM: %.1f MB | texturas: %.1f MB" % [vram / 1048576.0, tex / 1048576.0]
```

## 🧪 Laboratorio guiado

Reimportarás cada tipo de asset y medirás el efecto sobre la VRAM.

**Paso 1 — Línea base.** Con todas las texturas importadas como *Lossless* sin compresión VRAM y a tamaño completo, anota la VRAM total y la de texturas con la escena cargada.

**Paso 2 — Compresión de textura para 3D.** Selecciona las texturas de modelos 3D en el sistema de archivos, abre **Importar** y cambia **Compress → Mode** a *VRAM Compressed*. Activa **Mipmaps** para texturas 3D. Reimporta y compara la VRAM: la compresión VRAM suele reducir la memoria de textura a una fracción.

**Paso 3 — Tamaño y límites.** Para texturas que nunca se ven de cerca, reduce su resolución en origen o usa **Process → Size Limit** en la importación. Recuerda que pasar de 4K a 2K reduce la memoria a la cuarta parte (el área escala al cuadrado). Reimporta y mide.

**Paso 4 — UI y pixel art.** Para texturas de interfaz y sprites de pixel art, NO uses VRAM Compressed (introduce artefactos en bordes nítidos): mantenlas en *Lossless* y desactiva mipmaps y el filtro si buscas píxeles nítidos. Verifica visualmente que la UI se ve limpia.

**Paso 5 — Polígonos y LOD de malla.** Al importar un modelo `.glb`/`.gltf`, en el diálogo de importación de la escena, en las opciones de malla, deja activada la **generación de LOD** (Godot crea niveles simplificados automáticamente). Para modelos innecesariamente densos, reduce polígonos en el software de modelado antes de exportar. Comprueba que el modelo lejano usa menos primitivas (`RENDER_TOTAL_PRIMITIVES_IN_FRAME`).

**Paso 6 — Audio: WAV vs OGG.** Aplica el criterio por uso:

```gdscript
extends Node

# Efecto corto y repetido -> WAV cargado en RAM (baja latencia).
@onready var _sfx: AudioStreamPlayer = $SfxPlayer     # stream = disparo.wav
# Música larga -> OGG en streaming (poca memoria).
@onready var _music: AudioStreamPlayer = $MusicPlayer # stream = tema.ogg

func _ready() -> void:
	_music.play()   # el OGG se lee desde disco por trozos, no ocupa RAM entera

func disparar() -> void:
	_sfx.play()     # el WAV ya está en memoria: respuesta inmediata
```

En el archivo `.ogg`, verifica en **Importar** que **Loop** esté configurado si es música en bucle. Para el WAV, un efecto corto no necesita streaming.

**Paso 7 — Presupuesto y tabla.** Consolida en una tabla ANTES/DESPUÉS la VRAM total, la VRAM de texturas y las primitivas del modelo, para la versión sin optimizar y la optimizada. Fija un presupuesto (por ejemplo, "texturas < 128 MB en VRAM") y verifica que lo cumples.

## ✍️ Ejercicios

1. Reimporta una textura 4K a 1K y calcula la reducción teórica y real de VRAM.
2. Compara visualmente una textura de UI en VRAM Compressed vs Lossless.
3. Mide la RAM de un clip de 3 minutos como WAV vs como OGG streaming.
4. Activa y desactiva mipmaps en una textura 3D y observa el aliasing a distancia.
5. Importa un `.glb` con y sin generación de LOD y compara primitivas a distancia.
6. Define un presupuesto de assets por categoría para un juego móvil y justifícalo.

## 📝 Reto verificable

Toma una escena con assets sin optimizar (texturas grandes en Lossless, modelos densos, música en WAV) y aplícale un plan de optimización: compresión VRAM para 3D, tamaños reducidos donde no se aprecie, LOD de malla en importación y OGG streaming para la música. Entrega una tabla ANTES/DESPUÉS con VRAM total, VRAM de texturas y RAM de audio, más el presupuesto objetivo cumplido.

**Criterio de aceptación**: la VRAM de texturas se reduce de forma medible tras aplicar compresión y límites de tamaño, la música se sirve como OGG streaming (RAM de audio baja), los efectos cortos siguen como WAV, y la tabla documenta las tres métricas cumpliendo el presupuesto declarado.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| UI con bordes sucios o borrosos | Usaste VRAM Compressed en interfaz. Cámbiala a Lossless. |
| VRAM altísima con pocas texturas | Texturas a resolución excesiva. Reduce tamaño o usa Size Limit. |
| RAM disparada al cargar la música | Cargaste una pista larga como WAV. Impórtala como OGG streaming. |
| Pixel art borroso | Filtro y mipmaps activos. Desactívalos para nitidez de píxel. |
| Aliasing centelleante en 3D lejano | Sin mipmaps. Actívalos en la importación de texturas 3D. |

## ❓ Preguntas frecuentes

**❓ ¿VRAM Compressed reduce también el tamaño en disco?** Reduce sobre todo la VRAM, que suele ser el cuello de botella. El tamaño en disco depende del formato; a veces un WebP Lossy pesa menos en disco pero ocupa más en VRAM al descomprimirse.

**❓ ¿Por qué el pixel art se ve mal con compresión VRAM?** Los algoritmos de bloque (S3TC/ETC) promedian píxeles vecinos, lo que emborrona bordes nítidos. Para pixel art, Lossless sin filtro conserva cada píxel exacto.

**❓ ¿Cuándo es un WAV la opción correcta si pesa más?** Para efectos cortos y muy repetidos (disparos, pasos): el WAV ya está en RAM y suena sin latencia de decodificación. Reservar streaming para clips largos.

**❓ ¿El LOD de malla lo genera Godot solo?** Sí, Godot 4 genera niveles de detalle automáticamente al importar modelos y los usa por distancia. Puedes ajustar el umbral, pero el trabajo pesado es automático.

## 🔗 Referencias

- Godot Docs — Importing images: <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html>
- Godot Docs — Importing audio samples: <https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html>
- Godot Docs — Optimizing 3D performance (LOD): <https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html>
- Godot Docs — Performance (video memory monitors): <https://docs.godotengine.org/en/stable/classes/class_performance.html>

## ➡️ Siguiente clase

[Clase 250 - Multithreading y trabajos en paralelo](../250-multithreading-y-trabajos-en-paralelo/README.md)
