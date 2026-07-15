extends Node
## Estado global de la partida (Autoload / singleton).
##
## Igual que en el lab de plataformas 2D: todo se comunica por SEÑALES. El HUD
## escucha y reacciona; nadie consulta este nodo cada frame. Ver clases 039 y 043.

signal cristales_cambiados(recogidos: int, total: int)
signal partida_terminada(victoria: bool)

const RUTA_GUARDADO: String = "user://save.json"

var cristales: int = 0
var cristales_total: int = 0
var mejor_tiempo: float = 0.0
var tiempo: float = 0.0

var _terminada: bool = false


func _ready() -> void:
	cargar()


func _process(delta: float) -> void:
	if not _terminada and cristales_total > 0:
		tiempo += delta


func reiniciar_partida(total: int) -> void:
	cristales = 0
	cristales_total = total
	tiempo = 0.0
	_terminada = false
	cristales_cambiados.emit(cristales, cristales_total)


func recoger_cristal() -> void:
	cristales += 1
	cristales_cambiados.emit(cristales, cristales_total)


func puede_terminar() -> bool:
	return cristales >= cristales_total


func terminar(victoria: bool) -> void:
	if _terminada:
		return
	_terminada = true
	if victoria and (mejor_tiempo == 0.0 or tiempo < mejor_tiempo):
		mejor_tiempo = tiempo
		guardar()
	partida_terminada.emit(victoria)


func esta_terminada() -> bool:
	return _terminada


# --- Persistencia (clase 043) -------------------------------------------------
func guardar() -> void:
	var f := FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	if f == null:
		push_warning("No se pudo guardar (error %d)" % FileAccess.get_open_error())
		return
	f.store_string(JSON.stringify({"mejor_tiempo": mejor_tiempo}))


func cargar() -> void:
	if not FileAccess.file_exists(RUTA_GUARDADO):
		return
	var f := FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
	if f == null:
		return
	# JSON.parse_string devuelve null si el archivo está corrupto: lo toleramos.
	var datos: Variant = JSON.parse_string(f.get_as_text())
	if typeof(datos) == TYPE_DICTIONARY and datos.has("mejor_tiempo"):
		mejor_tiempo = float(datos["mejor_tiempo"])
