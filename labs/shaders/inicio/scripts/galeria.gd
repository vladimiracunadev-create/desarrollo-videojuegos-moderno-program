extends Control
## Galería de shaders: muestra uno a uno los shaders de shaders/ sobre una
## textura de prueba, con sus uniforms editables en vivo.
##
## Esto es infraestructura: lo que se aprende está en los .gdshader. Aquí solo
## se cargan, se aplican a un TextureRect y se generan sliders para sus uniforms
## (clase 088: todo uniform es, literalmente, un mando que expones al motor).

const TEX_PRUEBA: Texture2D = preload("res://assets/textura_prueba.png")
const TEX_SILUETA: Texture2D = preload("res://assets/silueta.png")

## El orden es el del recorrido didáctico de la Parte 4.
const CATALOGO: Array[Dictionary] = [
	{
		"nombre": "UV y color por píxel",
		"ruta": "res://shaders/uv.gdshader",
		"clase": "090",
		"silueta": false,
		"idea": "Un fragment shader se ejecuta una vez por píxel. UV es dónde estás.",
	},
	{
		"nombre": "Distorsión de UV (ondas)",
		"ruta": "res://shaders/ondas.gdshader",
		"clase": "090",
		"silueta": false,
		"idea": "No cambies el color: cambia DÓNDE lees la textura.",
	},
	{
		"nombre": "Disolución con borde",
		"ruta": "res://shaders/disolucion.gdshader",
		"clase": "095",
		"silueta": true,
		"idea": "Ruido + umbral = desintegración. El borde arde justo en el umbral.",
	},
	{
		"nombre": "Contorno (outline)",
		"ruta": "res://shaders/outline.gdshader",
		"clase": "095",
		"silueta": true,
		"idea": "Mira a tus vecinos: si tú eres transparente y ellos no, eres borde.",
	},
	{
		"nombre": "Agua",
		"ruta": "res://shaders/agua.gdshader",
		"clase": "100",
		"silueta": false,
		"idea": "Varias ondas desfasadas. Una sola siempre se ve falsa.",
	},
	{
		"nombre": "Cel shading",
		"ruta": "res://shaders/toon.gdshader",
		"clase": "103",
		"silueta": false,
		"idea": "Parece dibujado porque QUITA tonos: floor(luz * n) / n.",
	},
]

const RUTA_POST: String = "res://shaders/post_crt.gdshader"

var _indice: int = 0
var _materiales: Array[ShaderMaterial] = []

@onready var lienzo: TextureRect = $Centro/Marco/Lienzo
@onready var lbl_titulo: Label = $Datos/Titulo
@onready var lbl_idea: Label = $Datos/Idea
@onready var lbl_ayuda: Label = $Datos/Ayuda
@onready var mandos: VBoxContainer = $Mandos/Lista
@onready var post: ColorRect = $Post/Pantalla


func _ready() -> void:
	_cargar_catalogo()
	_preparar_post()
	_mostrar(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("siguiente"):
		_mostrar(_indice + 1)
	elif event.is_action_pressed("anterior"):
		_mostrar(_indice - 1)
	elif event.is_action_pressed("alternar_post"):
		post.visible = not post.visible
		_actualizar_ayuda()
	elif event.is_action_pressed("reiniciar"):
		get_tree().reload_current_scene()


# --- Carga --------------------------------------------------------------------
func _cargar_catalogo() -> void:
	var uniforms_total: int = 0

	for entrada in CATALOGO:
		var sh: Shader = load(entrada["ruta"])
		var mat := ShaderMaterial.new()
		mat.shader = sh
		_materiales.append(mat)

		# get_shader_uniform_list() obliga a Godot a PARSEAR el shader: si el
		# código no compila, la lista vuelve vacía. Por eso sirve de prueba de
		# verdad y no solo de curiosidad (la CI se apoya en este recuento).
		var uniforms: Array = sh.get_shader_uniform_list()
		if uniforms.is_empty():
			push_error("El shader %s no expone uniforms: ¿no compila?" % entrada["ruta"])
		uniforms_total += uniforms.size()

	# Resumen de la galería: te dice de un vistazo si todo cargó y compiló.
	# La CI también lo usa como prueba de que la galería se construyó de verdad.
	print("Galería construida: %d shaders, %d uniforms" % [_materiales.size(), uniforms_total])


func _preparar_post() -> void:
	var sh: Shader = load(RUTA_POST)
	var mat := ShaderMaterial.new()
	mat.shader = sh
	post.material = mat
	post.visible = false
	print("Post-procesado cargado: %d uniforms" % sh.get_shader_uniform_list().size())


# --- Navegación ---------------------------------------------------------------
func _mostrar(indice: int) -> void:
	_indice = wrapi(indice, 0, CATALOGO.size())
	var entrada: Dictionary = CATALOGO[_indice]

	lienzo.texture = TEX_SILUETA if entrada["silueta"] else TEX_PRUEBA
	lienzo.material = _materiales[_indice]

	lbl_titulo.text = "%d/%d · %s  (clase %s)" % [
		_indice + 1, CATALOGO.size(), entrada["nombre"], entrada["clase"]]
	lbl_idea.text = entrada["idea"]
	_actualizar_ayuda()
	_generar_mandos()


func _actualizar_ayuda() -> void:
	lbl_ayuda.text = "← / → cambiar shader · Espacio: post-procesado CRT [%s] · R: reiniciar" \
		% ("ON" if post.visible else "OFF")


# --- Mandos en vivo -----------------------------------------------------------
func _generar_mandos() -> void:
	## Un slider por uniform numérico: tocarlos en marcha es la mejor forma de
	## entender qué hace cada línea del shader.
	for hijo in mandos.get_children():
		hijo.queue_free()

	var mat: ShaderMaterial = _materiales[_indice]
	for u in mat.shader.get_shader_uniform_list():
		var tipo: int = u["type"]
		if tipo != TYPE_FLOAT and tipo != TYPE_INT:
			continue

		var fila := HBoxContainer.new()
		var etiqueta := Label.new()
		etiqueta.text = str(u["name"])
		etiqueta.custom_minimum_size.x = 150
		fila.add_child(etiqueta)

		var slider := HSlider.new()
		slider.custom_minimum_size.x = 180
		# hint_range viaja en la propiedad: si el shader lo declaró, lo usamos.
		var rango: Dictionary = _rango_de(u)
		slider.min_value = rango["min"]
		slider.max_value = rango["max"]
		slider.step = 1.0 if tipo == TYPE_INT else (rango["max"] - rango["min"]) / 100.0
		slider.value = _valor_actual(mat, str(u["name"]), rango)

		var lbl_valor := Label.new()
		lbl_valor.custom_minimum_size.x = 56
		lbl_valor.text = "%.2f" % slider.value

		var nombre: String = str(u["name"])
		slider.value_changed.connect(func(v: float) -> void:
			mat.set_shader_parameter(nombre, int(v) if tipo == TYPE_INT else v)
			lbl_valor.text = "%.2f" % v)

		fila.add_child(slider)
		fila.add_child(lbl_valor)
		mandos.add_child(fila)


func _valor_actual(mat: ShaderMaterial, nombre: String, rango: Dictionary) -> float:
	## De dónde sale el valor que enseña el slider, en orden de preferencia:
	## lo que ya tenga puesto el material, el valor por defecto que declaró el
	## shader, y si no, el mínimo del rango. El del medio es null en headless
	## (el servidor de render 'dummy' no guarda los shaders), de ahí la cadena.
	var valor: Variant = mat.get_shader_parameter(nombre)
	if valor == null:
		valor = RenderingServer.shader_get_parameter_default(mat.shader.get_rid(), nombre)
	if valor == null:
		return float(rango["min"])
	return float(valor)


func _rango_de(u: Dictionary) -> Dictionary:
	if u["hint"] == PROPERTY_HINT_RANGE:
		var partes: PackedStringArray = str(u["hint_string"]).split(",")
		if partes.size() >= 2:
			return {"min": float(partes[0]), "max": float(partes[1])}
	return {"min": 0.0, "max": 1.0}
