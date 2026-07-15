extends CompuestoBT
class_name Selector
## Selector: el "O" del árbol, y donde vive la PRIORIDAD (clase 111).
##
## Prueba sus hijos en orden hasta que uno no falle. El primero que puede,
## manda. Es "intenta esto; si no puedes, esto otro; y si no, esto".
##
## Por eso el orden de los hijos ES el diseño de la IA: el selector raíz de este
## lab lleva [combatir, buscar, patrullar], y ese orden es lo que hace que
## perseguir al jugador gane siempre a seguir patrullando.


func tick(agente: Node, bb: Dictionary) -> int:
	for h in hijos:
		var r: int = h.tick(agente, bb)
		# EXITO o EN_CURSO: este hijo se hace cargo, no seguimos probando.
		if r != Estado.FALLO:
			return r
	return Estado.FALLO
