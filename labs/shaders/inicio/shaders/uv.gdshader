shader_type canvas_item;
// 1 · UV y color por píxel (clase 090). — EJERCICIO
//
// Lo primero que hay que interiorizar: un fragment shader se ejecuta UNA VEZ POR
// PÍXEL, y UV es "en qué punto de la imagen estoy" (0,0 arriba-izquierda a 1,1
// abajo-derecha). Pintar la UV como color es el "hola mundo" de los shaders.
//
// Ahora mismo este shader no hace nada: devuelve la textura tal cual. Empieza
// por aquí, que es el más fácil. Los uniforms ya están declarados: la galería
// te genera un slider por cada uno, así que podrás moverlos en marcha.

uniform float mezcla : hint_range(0.0, 1.0) = 0.75;
uniform vec4 tinte : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Rejilla que se dibuja encima: hace visible el espacio UV.
uniform float rejilla : hint_range(0.0, 64.0) = 8.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// TODO 1: pinta la coordenada como color. El color ES la coordenada:
	//         vec3 color_uv = vec3(UV.x, UV.y, 0.5);
	//         Deberías ver el rojo crecer hacia la derecha y el verde hacia abajo.

	// TODO 2: mézclalo con la textura según el uniform 'mezcla':
	//         vec3 rgb = mix(tex.rgb, color_uv, mezcla);
	//         Mueve el slider 'mezcla' de 0 a 1 y observa la transición.

	// TODO 3 (rejilla): dibuja una línea cada 1/rejilla de UV:
	//         vec2 celda = fract(UV * rejilla);
	//         float linea = step(0.94, max(celda.x, celda.y));
	//         rgb = mix(rgb, vec3(1.0), linea * 0.5);
	//         fract() da la parte decimal: es LA herramienta para repetir algo.

	// TODO 4: aplica el tinte y devuelve el color:
	//         COLOR = vec4(rgb * tinte.rgb, tex.a);

	COLOR = tex;
}
