shader_type canvas_item;
// 2 · Distorsión de UV (clase 090).
//
// El truco más rentable de todos: no cambiamos el color, cambiamos DÓNDE se lee
// la textura. Sumar un seno a la UV antes del texture() ondula la imagen entera.
// Con esto se hacen banderas, calor, cristal, agua, teletransportes...

uniform float amplitud : hint_range(0.0, 0.2) = 0.025;
uniform float frecuencia : hint_range(0.0, 40.0) = 14.0;
uniform float velocidad : hint_range(0.0, 10.0) = 2.5;
// Con 0.0 ondula solo en horizontal; con 1.0, también en vertical.
uniform float vertical : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 uv = UV;
	uv.x += sin(uv.y * frecuencia + TIME * velocidad) * amplitud;
	uv.y += cos(uv.x * frecuencia + TIME * velocidad) * amplitud * vertical;
	COLOR = texture(TEXTURE, uv);
}
