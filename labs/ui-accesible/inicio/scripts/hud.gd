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
	# TODO 4a: escucha a Ajustes para repintarte cuando cambie el idioma:
	#   Ajustes.cambiaron.connect(refrescar)
	refrescar()


func refrescar() -> void:
	# TODO 4b: arma los textos con tr() + format():
	#   lbl_vidas.text = tr("HUD_VIDAS").format([vidas])
	#   lbl_puntos.text = tr("HUD_PUNTOS").format([puntos])
	#   lbl_objetivo.text = tr("HUD_OBJETIVO")
	#   subtitulo.text = tr("SUB_EJEMPLO")
	#   subtitulo.visible = Ajustes.subtitulos
	#
	# Dos cosas que parecen detalles y no lo son:
	#
	# 1. NUNCA concatenes: tr("HUD_VIDAS") + str(vidas). El orden de las palabras
	#    cambia de un idioma a otro, y con {0} el hueco puede ir donde toque.
	# 2. Sin el TODO 4a esto se pinta UNA vez y se queda. Cambias a inglés y este
	#    HUD sigue en español él solo, mientras los botones del menú sí cambian —
	#    porque a esos los retraduce Godot y a este no.
	pass
