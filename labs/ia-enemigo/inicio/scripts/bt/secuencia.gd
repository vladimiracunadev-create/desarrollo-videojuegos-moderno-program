extends CompuestoBT
class_name Secuencia
## EJERCICIO (clase 111) — Secuencia: el "Y" del árbol.
##
## Ejecuta sus hijos EN ORDEN mientras vayan saliendo bien. Si uno falla, corta:
## los siguientes ya no tienen sentido. Es "haz esto, Y luego esto, Y luego esto".
##
## Ejemplo del lab: [¿veo al jugador?] → [persíguelo]. Si no lo veo, no hay nada
## que perseguir.


func tick(agente: Node, bb: Dictionary) -> int:
	# TODO 1: recorre `hijos` en orden llamando a h.tick(agente, bb).
	#   - Si un hijo NO devuelve EXITO, devuelve tú lo mismo que él y corta.
	#   - Si todos salen bien, devuelve Estado.EXITO.
	#
	# El detalle que se escapa siempre: EN_CURSO no es éxito. Si un hijo sigue
	# trabajando, la secuencia entera sigue trabajando y NO debe pasar al
	# siguiente hijo. Por eso la comprobación es `!= Estado.EXITO` y no
	# `== Estado.FALLO`: con la segunda, un hijo a medias dejaría pasar al de
	# después y tendrías dos acciones a la vez.
	return Estado.FALLO
