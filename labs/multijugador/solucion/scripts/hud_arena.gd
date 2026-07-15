extends CanvasLayer
## HUD de la arena: quién eres y cuánta gente hay. Infraestructura del lab.

@onready var lbl_rol: Label = $Datos/Rol
@onready var lbl_conectados: Label = $Datos/Conectados

var _jugadores: Node2D


func _ready() -> void:
	_jugadores = get_parent().get_node("Jugadores")
	lbl_rol.text = "SERVIDOR (autoritativo)" if multiplayer.is_server() \
		else "CLIENTE · id %d" % multiplayer.get_unique_id()


func _process(_delta: float) -> void:
	lbl_conectados.text = "Jugadores en la arena: %d" % _jugadores.get_child_count()
