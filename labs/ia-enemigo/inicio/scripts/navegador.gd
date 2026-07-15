extends RefCounted
class_name Navegador
## El servicio de pathfinding: una grilla de A* y rutas entre dos puntos
## (clase 113).
##
## Vive aparte del mundo por dos razones. La primera es de diseño: el enemigo no
## tiene por qué conocer el nivel entero, solo necesita preguntar "¿cómo llego
## ahí?". La segunda es práctica: si el enemigo dependiera del Mundo y el Mundo
## cargara al enemigo, Godot se mordería la cola al abrir la escena
## ("Parse Error: Busy"). Dependencias en un solo sentido.
##
## Usamos AStarGrid2D y NO NavigationAgent2D a propósito: el agente calcula por
## detrás y contesta por señal, así que dos partidas iguales no dan lo mismo.
## AStarGrid2D responde en el acto y siempre igual — que es lo que hace falta
## para aprender el algoritmo, y para que la CI pueda comprobarlo.

var celda: int
var grilla: AStarGrid2D


func _init(mapa: Array[String], p_celda: int) -> void:
	celda = p_celda
	grilla = AStarGrid2D.new()
	grilla.region = Rect2i(0, 0, mapa[0].length(), mapa.size())
	grilla.cell_size = Vector2(celda, celda)
	# Sin esto, get_point_path() devuelve la ESQUINA de cada celda y no su centro,
	# y el agente nunca llega del todo a su destino: se queda a medio tile,
	# recalcula una ruta de un solo punto y se planta ahí para siempre.
	grilla.offset = Vector2(celda, celda) * 0.5
	# Manhattan y sin cortar esquinas: así el enemigo no atraviesa un muro por el
	# vértice, que es el defecto clásico de A* en grilla.
	grilla.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grilla.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grilla.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grilla.update()

	for y in mapa.size():
		for x in mapa[y].length():
			if mapa[y][x] == "#":
				grilla.set_point_solid(Vector2i(x, y), true)


func ruta(desde: Vector2, hasta: Vector2) -> PackedVector2Array:
	## Ruta en píxeles. Si un extremo cae fuera o en un muro, devuelve vacío:
	## quien pregunta decide qué hacer con eso.
	var a: Vector2i = a_celda(desde)
	var b: Vector2i = a_celda(hasta)
	if not grilla.is_in_boundsv(a) or not grilla.is_in_boundsv(b):
		return PackedVector2Array()
	if grilla.is_point_solid(a) or grilla.is_point_solid(b):
		return PackedVector2Array()
	return grilla.get_point_path(a, b)


func a_celda(p: Vector2) -> Vector2i:
	return Vector2i(int(p.x / celda), int(p.y / celda))


func centro(c: Vector2i) -> Vector2:
	return Vector2(c.x * celda + celda / 2.0, c.y * celda + celda / 2.0)


func muros() -> int:
	var n: int = 0
	for y in grilla.region.size.y:
		for x in grilla.region.size.x:
			if grilla.is_point_solid(Vector2i(x, y)):
				n += 1
	return n
