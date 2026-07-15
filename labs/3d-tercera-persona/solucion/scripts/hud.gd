extends CanvasLayer
## HUD (clase 039). Vive en un CanvasLayer, así que es 2D sobre la escena 3D y no
## se mueve con la cámara. Se actualiza SOLO por señales de GameState.

@onready var lbl_cristales: Label = $Margen/Datos/Cristales
@onready var lbl_tiempo: Label = $Margen/Datos/Tiempo
@onready var lbl_pista: Label = $Margen/Datos/Pista
@onready var aviso: Control = $Aviso
@onready var lbl_aviso: Label = $Aviso/Centro/Texto


func _ready() -> void:
	GameState.cristales_cambiados.connect(_on_cristales_cambiados)
	GameState.partida_terminada.connect(_on_partida_terminada)

	aviso.visible = false
	_on_cristales_cambiados(GameState.cristales, GameState.cristales_total)


func _process(_delta: float) -> void:
	if not GameState.esta_terminada():
		lbl_tiempo.text = "Tiempo: %.1f s" % GameState.tiempo


func _on_cristales_cambiados(recogidos: int, total: int) -> void:
	lbl_cristales.text = "Cristales: %d / %d" % [recogidos, total]
	lbl_pista.text = "Ve al portal dorado" if recogidos >= total and total > 0 \
		else "Recoge todos los cristales"

	# Pequeño "pop" de feedback (clase 193).
	var tw := create_tween()
	tw.tween_property(lbl_cristales, "scale", Vector2(1.15, 1.15), 0.06)
	tw.tween_property(lbl_cristales, "scale", Vector2.ONE, 0.10)


func _on_partida_terminada(victoria: bool) -> void:
	var mejor: String = ""
	if GameState.mejor_tiempo > 0.0:
		mejor = "\nMejor tiempo: %.1f s" % GameState.mejor_tiempo
	lbl_aviso.text = "¡Portal alcanzado!\nTiempo: %.1f s%s\n\nPulsa R para jugar otra vez" \
		% [GameState.tiempo, mejor] if victoria else "Fin de la partida\n\nPulsa R para reintentar"
	aviso.modulate.a = 0.0
	aviso.visible = true
	create_tween().tween_property(aviso, "modulate:a", 1.0, 0.4)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
