extends Node
## Los ajustes del jugador (Autoload): idioma, tamaño del texto y remapeo.
##
## Aquí se junta lo que la Parte 10 quiere que convivas: accesibilidad (clase
## 196), localización (197) y persistencia (199). Y todo pasa por aquí a
## propósito — si cada pantalla tocara el TranslationServer por su cuenta,
## cambiar de idioma dejaría media UI en el idioma anterior.

signal cambiaron

const RUTA: String = "user://ajustes.cfg"
const IDIOMAS: Array[String] = ["es", "en"]
## De 1.0 a 2.0. El 2.0 no es un capricho: es el caso que rompe los layouts, y
## por eso es justo el que hay que probar (clase 199).
const ESCALA_MIN: float = 1.0
const ESCALA_MAX: float = 2.0
## Tamaño base de fuente del tema. La escala multiplica esto.
const FUENTE_BASE: int = 16

var idioma: String = "es"
var escala_texto: float = 1.0
var subtitulos: bool = true

var _tema: Theme


func _ready() -> void:
	# El tema del proyecto: tocarlo aquí cambia TODA la UI de golpe, que es de lo
	# que va el theming (clase 190). La alternativa —ir Label por Label con
	# add_theme_font_size_override()— es la forma segura de olvidarte de uno.
	_tema = ThemeDB.get_project_theme()
	cargar()
	aplicar()

	# Resumen: dice de un vistazo si el CSV se importó de verdad.
	#
	# Se comprueba traduciendo una clave conocida, y no contando claves, por un
	# motivo que sorprende: el importador de CSV no genera un Translation normal
	# sino un OptimizedTranslation (una tabla hash comprimida), y ese NO
	# implementa get_message_list() — devuelve una lista vacía aunque las
	# traducciones funcionen. Contar habría dado siempre 0.
	#
	# Traducir sí funciona, y además es la prueba que importa: si el import
	# falla, tr() devuelve la propia clave y la UI se llena de "MENU_JUGAR". Ese
	# es el síntoma clásico, y así la CI lo caza.
	var prueba: String = tr("MENU_JUGAR")
	print("UI construida: %d idiomas, traducción %s ('MENU_JUGAR' -> '%s'), fuente %dpx, tema %s"
		% [IDIOMAS.size(), "OK" if prueba != "MENU_JUGAR" else "ROTA", prueba,
		   tamano_fuente(), "cargado" if _tema != null else "AUSENTE"])


# --- API ----------------------------------------------------------------------
func poner_idioma(codigo: String) -> void:
	if codigo not in IDIOMAS:
		push_warning("Idioma desconocido: %s" % codigo)
		return
	idioma = codigo
	aplicar()
	guardar()


func poner_escala(valor: float) -> void:
	escala_texto = clampf(valor, ESCALA_MIN, ESCALA_MAX)
	aplicar()
	guardar()


func poner_subtitulos(activos: bool) -> void:
	subtitulos = activos
	aplicar()
	guardar()


func aplicar() -> void:
	TranslationServer.set_locale(idioma)
	if _tema != null:
		_tema.default_font_size = int(round(FUENTE_BASE * escala_texto))
	# Los Control con texto traducible se refrescan solos al cambiar el locale;
	# los textos construidos por código NO (ver hud.gd). De ahí esta señal.
	cambiaron.emit()


func tamano_fuente() -> int:
	return int(round(FUENTE_BASE * escala_texto))


# --- Remapeo (clase 195) ------------------------------------------------------
func remapear(accion: String, evento: InputEventKey) -> void:
	if not InputMap.has_action(accion):
		push_warning("Acción desconocida: %s" % accion)
		return
	InputMap.action_erase_events(accion)
	InputMap.action_add_event(accion, evento)
	guardar()


func tecla_de(accion: String) -> String:
	## El nombre legible de la tecla asignada a una acción.
	if not InputMap.has_action(accion):
		return "—"
	for e in InputMap.action_get_events(accion):
		if e is InputEventKey:
			# physical_keycode y no keycode: así la tecla es la MISMA posición en
			# un teclado QWERTY que en uno AZERTY (clase 195).
			return OS.get_keycode_string(e.physical_keycode)
	return "—"


# --- Persistencia (clase 199) -------------------------------------------------
func guardar() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("ui", "idioma", idioma)
	cfg.set_value("ui", "escala_texto", escala_texto)
	cfg.set_value("ui", "subtitulos", subtitulos)
	cfg.set_value("input", "accion_principal", tecla_de("accion_principal"))
	var err: int = cfg.save(RUTA)
	if err != OK:
		push_warning("No se pudieron guardar los ajustes (error %d)" % err)


func cargar() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(RUTA) != OK:
		return  # primera vez: nos quedamos con los valores por defecto
	idioma = str(cfg.get_value("ui", "idioma", idioma))
	escala_texto = float(cfg.get_value("ui", "escala_texto", escala_texto))
	subtitulos = bool(cfg.get_value("ui", "subtitulos", subtitulos))
