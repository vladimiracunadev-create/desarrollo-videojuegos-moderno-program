extends Control
## Opciones: idioma, tamaño de texto, subtítulos y remapeo (clases 195-197).
##
## Todo cambia EN RUNTIME. Un ajuste de accesibilidad que exige reiniciar el
## juego para verse es un ajuste que la mitad de la gente no llega a usar.

@onready var sel_idioma: OptionButton = $Centro/Caja/FilaIdioma/Selector
@onready var sld_escala: HSlider = $Centro/Caja/FilaEscala/Slider
@onready var lbl_escala: Label = $Centro/Caja/FilaEscala/Valor
@onready var chk_subs: CheckButton = $Centro/Caja/FilaSubs/Check
@onready var btn_remapeo: Button = $Centro/Caja/FilaRemapeo/Tecla
@onready var btn_volver: Button = $Centro/Caja/BtnVolver

var _esperando_tecla: bool = false


func _ready() -> void:
	for codigo in Ajustes.IDIOMAS:
		sel_idioma.add_item(codigo.to_upper())
	sel_idioma.selected = Ajustes.IDIOMAS.find(Ajustes.idioma)
	sel_idioma.item_selected.connect(_on_idioma)

	sld_escala.min_value = Ajustes.ESCALA_MIN
	sld_escala.max_value = Ajustes.ESCALA_MAX
	sld_escala.step = 0.25
	sld_escala.value = Ajustes.escala_texto
	sld_escala.value_changed.connect(_on_escala)

	chk_subs.button_pressed = Ajustes.subtitulos
	chk_subs.toggled.connect(Ajustes.poner_subtitulos)

	btn_remapeo.pressed.connect(_on_remapear)
	btn_volver.pressed.connect(_on_volver)

	Ajustes.cambiaron.connect(_refrescar)
	_refrescar()
	sel_idioma.grab_focus()


func _refrescar() -> void:
	lbl_escala.text = "%d%%" % roundi(Ajustes.escala_texto * 100.0)
	btn_remapeo.text = Ajustes.tecla_de("accion_principal") if not _esperando_tecla else "..."


func _on_idioma(indice: int) -> void:
	Ajustes.poner_idioma(Ajustes.IDIOMAS[indice])


func _on_escala(valor: float) -> void:
	Ajustes.poner_escala(valor)


func _on_remapear() -> void:
	_esperando_tecla = true
	_refrescar()


func _unhandled_input(event: InputEvent) -> void:
	if not _esperando_tecla or not event is InputEventKey or not event.pressed:
		return
	_esperando_tecla = false
	Ajustes.remapear("accion_principal", event)
	_refrescar()
	# Si no lo marcas como usado, la misma pulsación activaría el botón que
	# acabas de reasignar.
	get_viewport().set_input_as_handled()


func _on_volver() -> void:
	get_tree().change_scene_to_file("res://escenas/menu.tscn")
