# Clase 259 — Generación y validación de datos (data-driven)

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de Godot 4 (FileAccess, JSON, ResourceSaver) y patrón de diseño data-driven*
> ⏱️ Duración estimada: **75 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Cuando las estadísticas de cada enemigo viven en el código, cambiar el daño de un goblin obliga a tocar y recompilar lógica. El diseño **data-driven** separa los datos del comportamiento: el código lee tablas (CSV, JSON, recursos) y **cualquiera** puede ajustar el balance editando una hoja de cálculo. Pero datos externos significan datos potencialmente erróneos, así que la validación deja de ser opcional.

En esta clase construimos una **herramienta de importación**: leemos un catálogo de enemigos desde CSV/JSON con `FileAccess`, **validamos** cada registro (campos presentes, tipos correctos, rangos razonables, referencias que existen), acumulamos un informe legible de errores, y solo con los datos limpios **generamos recursos** `.tres` con `ResourceSaver.save()`. El principio rector: fallar temprano y ruidosamente en la importación, nunca en silencio durante el juego.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Justificar el diseño data-driven y qué separa exactamente de la lógica.
2. Leer datos externos con `FileAccess` y parsear CSV y JSON en Godot 4.
3. Validar registros comprobando campos obligatorios, tipos y rangos.
4. Acumular y reportar errores de forma legible en lugar de fallar en runtime.
5. Generar recursos `.tres` a partir de los datos validados con `ResourceSaver.save()`.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Qué es el diseño data-driven | Permite iterar el balance sin tocar código. |
| 2 | Separar datos de comportamiento | Diseñadores editan datos; programadores, lógica. |
| 3 | Leer archivos con `FileAccess` | Puerta de entrada a CSV/JSON externos. |
| 4 | Parsear CSV (`get_csv_line`) | Formato cómodo desde hojas de cálculo. |
| 5 | Parsear JSON (`JSON.parse_string`) | Formato para datos anidados. |
| 6 | Validación de campos y rangos | Atrapa errores antes de que lleguen al juego. |
| 7 | Informe de errores acumulado | Reporta todos los fallos, no solo el primero. |
| 8 | Generar `.tres` validados | Convierte datos crudos en recursos usables. |

## 📖 Definiciones y características

- **Diseño data-driven**: arquitectura donde el comportamiento se dirige por datos externos y no por código embebido. Clave: cambiar datos no exige recompilar ni reescribir lógica.
- **`FileAccess`**: clase para leer y escribir archivos. Clave: se abre con `FileAccess.open(ruta, modo)` y devuelve `null` si falla.
- **`get_csv_line()`**: lee una línea CSV y la devuelve como `PackedStringArray`. Clave: respeta comillas y separadores estándar.
- **`JSON.parse_string()`**: convierte texto JSON en tipos nativos (`Dictionary`, `Array`). Clave: devuelve `null` si el JSON es inválido.
- **Validación**: comprobación de que cada registro cumple contrato (campos, tipos, rangos, referencias). Clave: separa datos confiables de basura.
- **Informe de errores**: colección de mensajes que describe cada fallo con su fila y campo. Clave: acumular todos ahorra ciclos de corrección.
- **`ResourceSaver.save()`**: escribe un `Resource` a disco como `.tres` o `.res`. Clave: materializa los datos validados en recursos del proyecto.
- **Referencia rota**: un dato que apunta a algo inexistente (una `escena` o `id` que no está). Clave: se detecta comprobando contra el conjunto de ids conocidos.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x**. Prepara un archivo de datos de ejemplo; usaremos JSON por su claridad, pero el CSV se menciona en paralelo. Crea `res://datos/enemigos.json` con varios registros, incluyendo **al menos uno inválido a propósito** (un campo faltante o un valor fuera de rango) para ver la validación en acción.

Consulta la referencia de `FileAccess` para los modos de apertura: <https://docs.godotengine.org/en/stable/classes/class_fileaccess.html>. Para el parseo, la clase `JSON`: <https://docs.godotengine.org/en/stable/classes/class_json.html>. Y para guardar recursos, `ResourceSaver`: <https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html>.

## 🧪 Laboratorio guiado

Construiremos un **importador-validador** que lee enemigos desde JSON, valida, reporta y genera un `.tres` por cada enemigo correcto. Lo haremos como script `@tool` para poder ejecutarlo en el editor.

1. Define primero el recurso destino `enemigo_data.gd`, para saber qué campos esperamos:

```gdscript
@tool
class_name EnemigoData
extends Resource

@export var id: StringName = &""
@export var nombre: String = ""
@export var vida: int = 1
@export var velocidad: float = 0.0
```

2. Crea el importador `importar_enemigos.gd`. Lee el archivo con `FileAccess` y parsea el JSON, controlando los fallos de apertura y de formato:

```gdscript
@tool
extends Node

const RUTA_ENTRADA := "res://datos/enemigos.json"
const DIR_SALIDA := "res://datos/enemigos/"

func importar() -> void:
	var f := FileAccess.open(RUTA_ENTRADA, FileAccess.READ)
	if f == null:
		push_error("No se pudo abrir %s (error %d)" % [RUTA_ENTRADA, FileAccess.get_open_error()])
		return
	var texto := f.get_as_text()
	f.close()

	var datos = JSON.parse_string(texto)
	if typeof(datos) != TYPE_ARRAY:
		push_error("El JSON raíz debe ser un Array de enemigos.")
		return

	_procesar(datos)
```

3. Valida cada registro y **acumula** los errores en lugar de abortar al primero. Comprobamos campos, tipos, rangos e ids duplicados:

```gdscript
func _procesar(filas: Array) -> void:
	var errores: Array[String] = []
	var validos: Array[EnemigoData] = []
	var ids_vistos := {}

	for i in filas.size():
		var fila = filas[i]
		var prefijo := "Fila %d" % i
		if typeof(fila) != TYPE_DICTIONARY:
			errores.append("%s: no es un objeto." % prefijo)
			continue

		# Campos obligatorios.
		for campo in ["id", "nombre", "vida", "velocidad"]:
			if not fila.has(campo):
				errores.append("%s: falta el campo '%s'." % [prefijo, campo])

		if not fila.has("id"):
			continue

		var id := StringName(str(fila.get("id", "")))
		if id in ids_vistos:
			errores.append("%s: id duplicado '%s'." % [prefijo, id])
		ids_vistos[id] = true

		# Rangos razonables.
		var vida := int(fila.get("vida", 0))
		if vida < 1 or vida > 9999:
			errores.append("%s: vida %d fuera de rango [1, 9999]." % [prefijo, vida])
		var vel := float(fila.get("velocidad", -1.0))
		if vel < 0.0:
			errores.append("%s: velocidad %.2f no puede ser negativa." % [prefijo, vel])

		# Si esta fila no acumuló errores nuevos, se construye.
		var rec := EnemigoData.new()
		rec.id = id
		rec.nombre = str(fila.get("nombre", ""))
		rec.vida = vida
		rec.velocidad = vel
		validos.append(rec)

	_reportar_y_guardar(errores, validos)
```

4. Emite el informe y **genera los `.tres`** solo si no hubo errores. Fallar temprano evita meter datos corruptos al proyecto:

```gdscript
func _reportar_y_guardar(errores: Array[String], validos: Array[EnemigoData]) -> void:
	if errores.size() > 0:
		push_warning("Importación con %d errores:" % errores.size())
		for e in errores:
			print("  - " + e)
		push_error("Corrige los errores antes de generar recursos.")
		return

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR_SALIDA))
	for rec in validos:
		var ruta := DIR_SALIDA + str(rec.id) + ".tres"
		var err := ResourceSaver.save(rec, ruta)
		if err == OK:
			print("Generado: " + ruta)
		else:
			push_error("Fallo al guardar %s (error %d)" % [ruta, err])
```

5. Para lanzarlo desde el editor sin ejecutar el juego, añade un disparador `@export` tipo botón que llame a `importar()`:

```gdscript
@export var lanzar_importacion: bool = false:
	set(v):
		if v:
			importar()
```

6. Coloca el nodo en una escena, marca la casilla **Lanzar importación** en el Inspector y mira el **Output**. Con tu registro inválido a propósito verás el error acumulado y **ningún `.tres` generado**. Corrige el dato, vuelve a marcar y esta vez aparecerán los recursos en `res://datos/enemigos/`. Para CSV, el patrón es idéntico cambiando el parseo por `f.get_csv_line()` en un bucle con la primera fila como cabecera.

La lección observable: los datos malos se detienen en la importación con un informe claro, y solo los limpios se convierten en recursos.

## ✍️ Ejercicios

1. Añade soporte CSV: lee cabecera con `get_csv_line()` y mapea columnas a los campos.
2. Valida que `nombre` no esté vacío y reporta la fila exacta si lo está.
3. Añade un campo `tipo` con `@export_enum` y valida que su valor esté entre los permitidos.
4. Detecta y reporta referencias rotas: un campo `suelta` que debe apuntar a un id existente.
5. Genera además un `.tres` de "base de datos" que contenga el `Array[EnemigoData]` completo.
6. Cuenta y muestra un resumen final: N válidos, M rechazados, tiempo de importación.

## 📝 Reto verificable

Construye un importador-validador para una categoría de datos de tu juego (objetos, armas, niveles). Debe leer desde CSV o JSON con `FileAccess`, validar al menos cuatro reglas (campo obligatorio, tipo, rango y referencia o unicidad), acumular todos los errores en un informe legible, y generar recursos `.tres` con `ResourceSaver.save()` **solo** si el informe está vacío.

**Criterio de aceptación**: con un archivo que contenga al menos un registro inválido, la herramienta reporta todos los errores por fila y no genera ningún recurso; tras corregir los datos, la reejecución genera los `.tres` correctos y muestra un resumen del conteo.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| `FileAccess.open` devuelve `null` | Ruta incorrecta o archivo inexistente. Comprueba con `FileAccess.get_open_error()` y usa rutas `res://`. |
| El JSON se parsea como `null` | Formato inválido (coma final, comillas). Valida el JSON y comprueba `typeof(datos)`. |
| La validación aborta al primer error | Usaste `return` en vez de acumular. Guarda los mensajes en un array y reporta al final. |
| Se generan `.tres` aun con datos malos | No condicionaste el guardado al informe vacío. Guarda solo si `errores.is_empty()`. |
| Los `.tres` no aparecen en el FileSystem | La carpeta no existe o falta refrescar. Crea el dir con `make_dir_recursive_absolute` y reescanea. |

## ❓ Preguntas frecuentes

**❓ ¿CSV o JSON para datos de juego?** CSV es cómodo si tus datos son tabulares y los editan en una hoja de cálculo. JSON conviene cuando hay estructura anidada (listas dentro de un registro). Ambos se validan igual.

**❓ ¿Por qué validar si los datos los hago yo?** Porque el punto del data-driven es que **otros** los editen, y porque un error tipográfico en una hoja de cálculo es fácil. Validar en la importación evita bugs opacos en runtime.

**❓ ¿Debo generar `.tres` o leer el JSON directamente en el juego?** Generar `.tres` te da recursos tipados, autocompletado y carga rápida. Leer JSON en caliente es útil para modding, a costa de validar cada vez.

**❓ ¿Puedo correr esto en un pipeline automático?** Sí: el mismo script puede invocarse desde un `EditorScript` o desde la línea de comandos con `--headless`, encajando en la automatización de builds de la clase siguiente de la parte.

## 🔗 Referencias

- Godot Docs — `FileAccess`: <https://docs.godotengine.org/en/stable/classes/class_fileaccess.html>
- Godot Docs — `JSON`: <https://docs.godotengine.org/en/stable/classes/class_json.html>
- Godot Docs — `ResourceSaver`: <https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html>
- Godot Docs — Saving games / serialización: <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>

## ➡️ Siguiente clase

[Clase 260 - Recursos personalizados y bases de datos de juego](../260-recursos-personalizados-y-bases-de-datos-de-juego/README.md)
