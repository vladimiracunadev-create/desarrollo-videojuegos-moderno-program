shader_type canvas_item;
// 4 · Contorno por canal alfa (clase 095). — EJERCICIO
//
// El contorno de "objeto seleccionado" de todos los juegos. Truco: mirar los
// píxeles VECINOS. Si yo soy transparente pero alguno de mis vecinos es opaco,
// entonces estoy en el borde de la silueta y me pinto del color del contorno.
//
// Este es el primer shader en el que lees la textura MÁS DE UNA VEZ. Que quede
// claro el coste: 8 lecturas extra por píxel (clase 105).

uniform vec4 color_contorno : source_color = vec4(1.0, 0.25, 0.35, 1.0);
uniform float grosor : hint_range(0.0, 8.0) = 2.5;
uniform float parpadeo : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// TODO 1: calcula cuánto es un píxel en espacio UV:
	//         vec2 px = grosor / vec2(textureSize(TEXTURE, 0));
	//         textureSize da la resolución real, así el grosor va en PÍXELES y
	//         no depende de lo estirada que esté la textura en pantalla.

	// TODO 2: coge el alfa MÁS ALTO de tus vecinos. Los 4 de al lado:
	//         float a = 0.0;
	//         a = max(a, texture(TEXTURE, UV + vec2(px.x, 0.0)).a);
	//         a = max(a, texture(TEXTURE, UV + vec2(-px.x, 0.0)).a);
	//         a = max(a, texture(TEXTURE, UV + vec2(0.0, px.y)).a);
	//         a = max(a, texture(TEXTURE, UV + vec2(0.0, -px.y)).a);
	//         Pruébalo así primero: verás el contorno, pero con esquinas feas.

	// TODO 3: añade las 4 diagonales para que las esquinas queden redondas
	//         (multiplica el offset por 0.7071 ≈ 1/√2 para que la distancia
	//         sea la misma que en los rectos).

	// TODO 4 (juice): un pulso lento con el tiempo:
	//         float pulso = 1.0 - parpadeo * (0.5 + 0.5 * sin(TIME * 4.0));

	// TODO 5: donde la figura es opaca mandan sus píxeles; donde no, el contorno:
	//         vec4 linea = vec4(color_contorno.rgb, a * color_contorno.a * pulso);
	//         COLOR = mix(linea, tex, tex.a);

	COLOR = tex;
}
