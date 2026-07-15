extends Control
## Lobby: elegir rol y conectar (clase 150).
##
## Infraestructura del lab. Solo se ve cuando arrancas sin argumentos: con
## --server o --conectar, NetworkManager salta directo a la arena.

@onready var campo_ip: LineEdit = $Centro/Caja/FilaIP/IP
@onready var estado: Label = $Centro/Caja/Estado


func _ready() -> void:
	NetworkManager.estado_cambiado.connect(_on_estado)
	$Centro/Caja/BtnServidor.pressed.connect(_on_servidor)
	$Centro/Caja/BtnCliente.pressed.connect(_on_cliente)
	estado.text = "Elige: aloja una partida o únete a una."


func _on_servidor() -> void:
	NetworkManager.iniciar_servidor()


func _on_cliente() -> void:
	var ip: String = campo_ip.text.strip_edges()
	NetworkManager.iniciar_cliente(ip if ip != "" else "127.0.0.1")


func _on_estado(texto: String) -> void:
	estado.text = texto
