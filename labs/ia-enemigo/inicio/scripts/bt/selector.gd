extends CompuestoBT
class_name Selector
## EJERCICIO (clase 111) — Selector: el "O" del árbol, y donde vive la PRIORIDAD.
##
## Prueba sus hijos en orden hasta que uno no falle. El primero que puede, manda.
## Es "intenta esto; si no puedes, esto otro; y si no, esto".
##
## Aquí está la idea más importante de los behavior trees: **el orden de los
## hijos ES el diseño de la IA**. El selector raíz de este lab lleva
## [combatir, buscar, patrullar], y ese orden es lo único que hace que perseguir
## al jugador gane a seguir patrullando. Cambia el orden y tendrás un enemigo
## que patrulla tan tranquilo con el jugador delante.


func tick(agente: Node, bb: Dictionary) -> int:
	# TODO 2: recorre `hijos` en orden llamando a h.tick(agente, bb).
	#   - Si un hijo NO falla (EXITO o EN_CURSO), devuelve tú lo mismo y corta:
	#     ese hijo se ha hecho cargo y los demás no deben ejecutarse.
	#   - Si fallan todos, devuelve Estado.FALLO.
	#
	# Fíjate en la simetría con la Secuencia: una corta cuando algo NO sale bien,
	# la otra corta cuando algo SÍ sale bien. Con esas dos y unas hojas se
	# construye cualquier IA de este estilo.
	return Estado.FALLO
