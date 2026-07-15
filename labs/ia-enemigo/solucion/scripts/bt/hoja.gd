extends NodoBT
class_name HojaBT
## Las hojas: donde el árbol deja de decidir y empieza a hacer (clase 111).
##
## Hay dos tipos y conviene no mezclarlos:
##   Condicion → PREGUNTA. No cambia el mundo. Devuelve EXITO o FALLO.
##   AccionBT  → HACE. Puede tardar varios ticks, y por eso puede EN_CURSO.
##
## Las dos reciben un Callable, así que las hojas de este lab son una línea:
## toda la lógica concreta vive en enemigo.gd, y el árbol solo la orquesta.

var _fn: Callable


func _init(p_nombre: String, p_fn: Callable) -> void:
	super(p_nombre)
	_fn = p_fn


class Condicion extends HojaBT:
	## Pregunta al agente. La función devuelve bool.
	func tick(agente: Node, bb: Dictionary) -> int:
		return Estado.EXITO if bool(_fn.call(agente, bb)) else Estado.FALLO


class AccionBT extends HojaBT:
	## Hace algo. La función devuelve un Estado (puede ser EN_CURSO).
	func tick(agente: Node, bb: Dictionary) -> int:
		return int(_fn.call(agente, bb))
