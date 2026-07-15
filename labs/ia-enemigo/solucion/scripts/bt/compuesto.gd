extends NodoBT
class_name CompuestoBT
## Base de los nodos que tienen hijos (Secuencia y Selector).
##
## Solo existe para no repetir dos veces la lista de hijos y el volcado. Lo
## interesante está en cómo cada uno recorre esa lista.

var hijos: Array[NodoBT] = []


func _init(p_nombre: String, p_hijos: Array[NodoBT] = []) -> void:
	super(p_nombre)
	hijos = p_hijos


func agregar(hijo: NodoBT) -> CompuestoBT:
	hijos.append(hijo)
	return self


func describir(nivel: int = 0) -> String:
	var txt: String = "  ".repeat(nivel) + "+ " + nombre + "\n"
	for h in hijos:
		txt += h.describir(nivel + 1)
	return txt


func contar() -> int:
	var n: int = 1
	for h in hijos:
		n += h.contar()
	return n
