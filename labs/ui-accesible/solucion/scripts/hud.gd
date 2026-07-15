extends CanvasLayer
## HUD: los textos que se construyen por código (clase 197).
##
## Aquí está la trampa favorita de la localización. Un `Label` con la clave
## puesta desde el editor se retraduce solo al cambiar el idioma: Godot lo hace
## por ti. Pero en cuanto el texto se arma en código —"Vidas: 3"— pasa a ser
## una cadena normal y corriente, y **ya no se entera de nada**. Cambias a
## inglés y ese Label se queda en español, él solo, para siempre.
##
## Por eso el HUD escucha a Ajustes.cambiaron y se repinta. Y por eso los textos
## con datos van con tr() + format() y NUNCA concatenando: el orden de las
## palabras cambia entre idiomas, así que el hueco {0} tiene que poder moverse.

@onready var lbl_vidas: Label = $Margen/Datos/Vidas
@onready var lbl_puntos: Label = $Margen/Datos/Puntos
@onready var lbl_objetivo: Label = $Margen/Datos/Objetivo
@onready var subtitulo: Label = $Subtitulo

var vidas: int = 3
var puntos: int = 1250


func _ready() -> void:
	Ajustes.cambiaron.connect(refrescar)
	refrescar()


func refrescar() -> void:
	# tr() busca la clave en el idioma actual; format() mete el dato en su hueco.
	lbl_vidas.text = tr("HUD_VIDAS").format([vidas])
	lbl_puntos.text = tr("HUD_PUNTOS").format([puntos])
	# Este no lleva datos, así que bastaría con poner la clave en el editor; va
	# por código para que se vea que las dos vías conviven.
	lbl_objetivo.text = tr("HUD_OBJETIVO")

	subtitulo.text = tr("SUB_EJEMPLO")
	subtitulo.visible = Ajustes.subtitulos
