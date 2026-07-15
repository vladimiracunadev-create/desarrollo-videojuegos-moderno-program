extends RefCounted
class_name NodoBT
## El contrato de todo el árbol (clase 111).
##
## Un behavior tree entero se sostiene sobre una idea: **cada nodo devuelve una
## de tres cosas**. Nada más. La complejidad de la IA sale de cómo se combinan,
## no de lo que sabe cada uno.
##
## Fíjate en que esto es RefCounted, no Node: el árbol es lógica pura, no vive en
## la escena. Por eso se puede probar sin abrir una ventana — y por eso la CI de
## este lab puede comprobar la IA de verdad, y no solo que arranca.

enum Estado {
	EXITO,     ## He terminado bien.
	FALLO,     ## No he podido.
	EN_CURSO,  ## Sigo en ello: vuelve a preguntarme el próximo tick.
}

## Nombre para depurar: lo usa el volcado del árbol.
var nombre: String = "nodo"


func _init(p_nombre: String = "nodo") -> void:
	nombre = p_nombre


func tick(_agente: Node, _bb: Dictionary) -> int:
	## Un tick es "¿qué haces AHORA?". El agente es quien actúa; el blackboard
	## (`bb`) es la memoria compartida del árbol: lo que sabe el enemigo.
	return Estado.FALLO


func describir(nivel: int = 0) -> String:
	return "  ".repeat(nivel) + "- " + nombre + "\n"


func contar() -> int:
	return 1
