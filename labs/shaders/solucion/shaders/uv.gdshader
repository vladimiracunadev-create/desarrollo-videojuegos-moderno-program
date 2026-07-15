shader_type canvas_item;
// 1 · UV y color por píxel (clase 090).
//
// Lo primero que hay que interiorizar: un fragment shader se ejecuta UNA VEZ POR
// PÍXEL, y UV es "en qué punto de la imagen estoy" (0,0 arriba-izquierda a 1,1
// abajo-derecha). Pintar la UV como color es el "hola mundo" de los shaders:
// ves el rojo crecer hacia la derecha (UV.x) y el verde hacia abajo (UV.y).

uniform float mezcla : hint_range(0.0, 1.0) = 0.75;
uniform vec4 tinte : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Rejilla que se dibuja encima: hace visible el espacio UV.
uniform float rejilla : hint_range(0.0, 64.0) = 8.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// El color ES la coordenada. Nada más.
	vec3 color_uv = vec3(UV.x, UV.y, 0.5);

	// Líneas allí donde la UV cruza un múltiplo de 1/rejilla.
	vec2 celda = fract(UV * rejilla);
	float linea = step(0.94, max(celda.x, celda.y));

	vec3 rgb = mix(tex.rgb, color_uv, mezcla);
	rgb = mix(rgb, vec3(1.0), linea * 0.5);
	COLOR = vec4(rgb * tinte.rgb, tex.a);
}
