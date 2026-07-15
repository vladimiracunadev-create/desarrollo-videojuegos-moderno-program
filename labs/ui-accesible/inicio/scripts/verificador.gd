extends Node
## Comprueba la UI sin que nadie mire la pantalla.
##
## Infraestructura del lab, no ejercicio. Existe porque la UI de Godot **se
## calcula en la CPU**: el layout, el foco y el ancho que ocupa un texto se
## resuelven sin GPU. Solo el dibujado necesita tarjeta gráfica. Así que un
## servidor de CI, que no tiene pantalla, sí puede responder a las preguntas que
## de verdad importan:
##
##   ¿hay algo enfocado al abrir el menú?
##   ¿la navegación da la vuelta al llegar al final?
##   ¿cambia el idioma de TODA la UI, incluidos los textos hechos por código?
##   ¿el texto al 200 % sigue cabiendo?
##
## Esa última es la que el capstone (clase 199) llama su corazón, y es un
## assert: comparar lo que el texto necesita con lo que tiene.
##
## Lo que NO puede comprobar, y conviene decirlo: si la UI se ve BONITA. Eso lo
## juzgas tú.

const ESC_MENU: PackedScene = preload("res://escenas/menu.tscn")
const ESC_HUD: PackedScene = preload("res://escenas/hud.tscn")

var _fallos: int = 0
var _hechas: int = 0


func _comprobar(ok: bool, desc: String) -> void:
	_hechas += 1
	if ok:
		print("  OK   %s" % desc)
	else:
		print("  FALLO %s" % desc)
		_fallos += 1


func _ready() -> void:
	print("== Verificación de la UI ==")
	await get_tree().process_frame

	await _probar_foco()
	await _probar_idioma()
	await _probar_escala_texto()
	await _probar_resoluciones()

	print("== %d comprobaciones, %d fallo(s) ==" % [_hechas, _fallos])
	get_tree().quit(1 if _fallos > 0 else 0)


# --- Foco y navegación (clases 192 y 195) -------------------------------------
func _probar_foco() -> void:
	var menu: Control = ESC_MENU.instantiate()
	add_child(menu)
	await get_tree().process_frame

	var foco: Control = get_viewport().gui_get_focus_owner()
	_comprobar(foco != null, "al abrir el menú hay algo enfocado (%s)"
		% (foco.name if foco else "nada"))
	_comprobar(foco != null and foco.name == "BtnJugar", "el foco empieza en BtnJugar")

	# Bajar tres veces desde el primero tiene que dar la vuelta al ciclo. Se
	# comprueba con find_valid_focus_neighbor, que es geometría pura: no hace
	# falta un teclado de verdad, y por eso esto corre en CI.
	var recorrido: Array[String] = []
	var actual: Control = foco
	for i in 3:
		var siguiente: Control = actual.find_valid_focus_neighbor(SIDE_BOTTOM)
		if siguiente == null:
			break
		recorrido.append(str(siguiente.name))
		actual = siguiente

	var esperado: Array[String] = ["BtnOpciones", "BtnSalir", "BtnJugar"]
	_comprobar(recorrido == esperado,
		"bajando desde el primero se recorre el menú y vuelve al inicio: %s" % str(recorrido))

	menu.queue_free()
	await get_tree().process_frame


# --- Localización (clase 197) -------------------------------------------------
func _probar_idioma() -> void:
	var hud: CanvasLayer = ESC_HUD.instantiate()
	add_child(hud)
	await get_tree().process_frame

	var lbl_vidas: Label = hud.get_node("Margen/Datos/Vidas")

	Ajustes.poner_idioma("es")
	await get_tree().process_frame
	var es: String = lbl_vidas.text
	_comprobar(es == "Vidas: 3", "en español el HUD dice 'Vidas: 3' (dice '%s')" % es)

	Ajustes.poner_idioma("en")
	await get_tree().process_frame
	var en: String = lbl_vidas.text
	# Este es EL caso: un texto construido por código no se retraduce solo. Si
	# el HUD no escuchara el cambio, aquí seguiría poniendo "Vidas: 3".
	_comprobar(en == "Lives: 3",
		"al cambiar a inglés, el texto hecho por código también cambia (dice '%s')" % en)
	_comprobar(es != en, "el idioma cambia de verdad los textos del HUD")

	# Y los Control con la clave puesta en el editor se retraducen solos.
	#
	# Ojo con cómo se comprueba: btn.text devuelve "MENU_JUGAR", la CLAVE. Un
	# Control guarda la clave y traduce al dibujar, así que leer .text no dice
	# lo que el jugador ve. Lo que se ve es atr(text) — el mismo atajo que usa
	# el propio Control por dentro.
	var menu: Control = ESC_MENU.instantiate()
	add_child(menu)
	await get_tree().process_frame
	var btn: Button = menu.get_node("Centro/Caja/BtnJugar")
	_comprobar(btn.atr(btn.text) == "Play",
		"el botón del menú se traduce solo (se ve '%s')" % btn.atr(btn.text))

	Ajustes.poner_idioma("es")
	await get_tree().process_frame
	_comprobar(btn.atr(btn.text) == "Jugar",
		"y vuelve al español (se ve '%s')" % btn.atr(btn.text))

	menu.queue_free()
	hud.queue_free()
	await get_tree().process_frame


# --- Escala de texto: el corazón del capstone (clases 196 y 199) --------------
func _probar_escala_texto() -> void:
	var menu: Control = ESC_MENU.instantiate()
	add_child(menu)
	await get_tree().process_frame

	for escala in [1.0, 1.5, 2.0]:
		Ajustes.poner_escala(escala)
		# Dos frames: uno para que el tema avise, otro para que los contenedores
		# recoloquen. Con uno solo se leen tamaños a medio calcular.
		await get_tree().process_frame
		await get_tree().process_frame

		_comprobar(Ajustes.tamano_fuente() == int(round(16 * escala)),
			"al %d%% la fuente del tema es de %dpx" % [escala * 100, Ajustes.tamano_fuente()])

		var recortados: Array[String] = []
		for c in _todos_los_textos(menu):
			# Lo que el texto NECESITA contra lo que TIENE. Si necesita más, se
			# está recortando: exactamente lo que el capstone dice que no puede
			# pasar al subir la escala.
			if c.get_minimum_size().x > c.size.x + 0.5:
				recortados.append("%s (necesita %.0fpx, tiene %.0fpx)"
					% [c.name, c.get_minimum_size().x, c.size.x])
		_comprobar(recortados.is_empty(),
			"al %d%% ningún texto se recorta%s"
			% [escala * 100, "" if recortados.is_empty() else ": " + str(recortados)])

	Ajustes.poner_escala(1.0)
	menu.queue_free()
	await get_tree().process_frame


# --- Responsive (clase 194) ---------------------------------------------------
func _probar_resoluciones() -> void:
	var menu: Control = ESC_MENU.instantiate()
	add_child(menu)
	await get_tree().process_frame

	# 16:9, 21:9 y 4:3 — los tres del capstone. Con el DisplayServer headless no
	# hay ventana que arrastrar, pero el layout sí se recalcula: es lo mismo que
	# el juego hace al redimensionar.
	for tam in [Vector2i(1280, 720), Vector2i(2560, 1080), Vector2i(1024, 768)]:
		get_tree().root.size = tam
		await get_tree().process_frame
		await get_tree().process_frame

		var caja: Control = menu.get_node("Centro/Caja")
		var dentro: bool = caja.get_rect().size.x <= tam.x and caja.get_rect().size.y <= tam.y
		_comprobar(dentro, "en %dx%d el menú cabe en pantalla (ocupa %s)"
			% [tam.x, tam.y, str(caja.get_rect().size)])

	get_tree().root.size = Vector2i(1280, 720)
	menu.queue_free()
	await get_tree().process_frame


func _todos_los_textos(raiz: Node) -> Array[Control]:
	var lista: Array[Control] = []
	for n in raiz.find_children("*", "Control", true, false):
		if n is Label or n is Button:
			lista.append(n)
	return lista
