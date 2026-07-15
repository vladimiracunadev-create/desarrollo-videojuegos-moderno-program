extends CompuestoBT
class_name Secuencia
## Secuencia: el "Y" del árbol (clase 111).
##
## Ejecuta sus hijos EN ORDEN mientras vayan saliendo bien. Si uno falla, corta:
## los siguientes ya no tienen sentido. Es "haz esto, Y luego esto, Y luego esto".
##
## Ejemplo: [¿veo al jugador?] → [acércate] → [ataca]. Si no lo veo, no hay nada
## que acercarse ni que atacar.


func tick(agente: Node, bb: Dictionary) -> int:
	for h in hijos:
		var r: int = h.tick(agente, bb)
		# Ojo con EN_CURSO: no es éxito. Si un hijo sigue trabajando, la
		# secuencia entera sigue trabajando y NO pasa al siguiente.
		if r != Estado.EXITO:
			return r
	return Estado.EXITO
