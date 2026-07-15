extends Control
## Menú principal: foco y navegación (clases 192 y 195).
##
## La regla que se salta todo el mundo: **siempre tiene que haber algo enfocado**.
## Si abres un menú sin foco, quien juega con teclado o con mando se queda sin
## saber dónde está, y la primera pulsación se pierde en aclararlo.

@onready var btn_jugar: Button = $Centro/Caja/BtnJugar
@onready var btn_opciones: Button = $Centro/Caja/BtnOpciones
@onready var btn_salir: Button = $Centro/Caja/BtnSalir


func _ready() -> void:
	btn_opciones.pressed.connect(_on_opciones)
	btn_salir.pressed.connect(_on_salir)

	# TODO 5a (navegación cíclica): encadena los vecinos de foco para que, desde
	# el último, bajar vuelva al primero:
	#   btn_jugar.focus_neighbor_bottom = btn_opciones.get_path()
	#   btn_opciones.focus_neighbor_bottom = btn_salir.get_path()
	#   btn_salir.focus_neighbor_bottom = btn_jugar.get_path()
	#   ...y lo mismo con focus_neighbor_top, al revés.
	#
	# Sin el ciclo, el foco se atasca en los extremos y parece que el menú se ha
	# colgado.

	# TODO 5b: que haya foco desde el primer frame:
	#   btn_jugar.grab_focus()
	#
	# Un menú sin nada enfocado deja a quien juega con teclado o mando sin saber
	# dónde está, y se come la primera pulsación en averiguarlo.


func _on_opciones() -> void:
	get_tree().change_scene_to_file("res://escenas/opciones.tscn")


func _on_salir() -> void:
	get_tree().quit()
