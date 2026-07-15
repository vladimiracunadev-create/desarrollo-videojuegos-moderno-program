shader_type canvas_item;
// 2 · Distorsión de UV (clase 090). — EJERCICIO
//
// El truco más rentable de todos: no cambiar el color, cambiar DÓNDE se lee la
// textura. Con esto se hacen banderas, calor, cristal, agua, teletransportes...
//
// Fíjate en que aquí NO se toca COLOR: se toca la UV ANTES de leer la textura.

uniform float amplitud : hint_range(0.0, 0.2) = 0.025;
uniform float frecuencia : hint_range(0.0, 40.0) = 14.0;
uniform float velocidad : hint_range(0.0, 10.0) = 2.5;
// Con 0.0 ondula solo en horizontal; con 1.0, también en vertical.
uniform float vertical : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 uv = UV;

	// TODO 1: desplaza la UV en X con un seno que dependa de la Y y del tiempo:
	//         uv.x += sin(uv.y * frecuencia + TIME * velocidad) * amplitud;
	//         Cada fila se desplaza distinto → la imagen ondula.
	//         TIME es el reloj del shader: si no lo metes, la onda se queda quieta.

	// TODO 2: haz lo mismo en Y con un coseno, atenuado por 'vertical':
	//         uv.y += cos(uv.x * frecuencia + TIME * velocidad) * amplitud * vertical;

	// TODO 3: lee la textura con la UV YA distorsionada:
	//         COLOR = texture(TEXTURE, uv);
	//         Ojo: 'uv' (la modificada), no 'UV' (la original).

	COLOR = texture(TEXTURE, UV);
}
