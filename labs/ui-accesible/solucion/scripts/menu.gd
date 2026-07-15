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
	# Navegación cíclica: desde el último, abajo vuelve al primero. Sin esto, el
	# foco se queda atascado en los extremos y parece que el menú se ha colgado.
	btn_jugar.focus_neighbor_bottom = btn_opciones.get_path()
	btn_opciones.focus_neighbor_bottom = btn_salir.get_path()
	btn_salir.focus_neighbor_bottom = btn_jugar.get_path()
	btn_jugar.focus_neighbor_top = btn_salir.get_path()
	btn_opciones.focus_neighbor_top = btn_jugar.get_path()
	btn_salir.focus_neighbor_top = btn_opciones.get_path()

	btn_opciones.pressed.connect(_on_opciones)
	btn_salir.pressed.connect(_on_salir)

	# Que haya foco desde el primer frame.
	btn_jugar.grab_focus()


func _on_opciones() -> void:
	get_tree().change_scene_to_file("res://escenas/opciones.tscn")


func _on_salir() -> void:
	get_tree().quit()
