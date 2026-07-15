shader_type canvas_item;
// 4 · Contorno por canal alfa (clase 095).
//
// El contorno de "objeto seleccionado" de todos los juegos. Truco: mirar los
// píxeles VECINOS. Si yo soy transparente pero alguno de mis vecinos es opaco,
// entonces estoy en el borde de la silueta y me pinto del color del contorno.
//
// Ojo: esto necesita una textura CON transparencia (aquí, silueta.png) y margen
// alrededor de la figura; si la figura toca el borde de la imagen, no hay sitio
// donde dibujar su contorno.

uniform vec4 color_contorno : source_color = vec4(1.0, 0.25, 0.35, 1.0);
uniform float grosor : hint_range(0.0, 8.0) = 2.5;
uniform float parpadeo : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// textureSize da la resolución real: así el grosor va en PÍXELES y no
	// depende de lo estirada que esté la textura en pantalla.
	vec2 px = grosor / vec2(textureSize(TEXTURE, 0));

	// El alfa más alto entre los 8 vecinos.
	float a = 0.0;
	a = max(a, texture(TEXTURE, UV + vec2(px.x, 0.0)).a);
	a = max(a, texture(TEXTURE, UV + vec2(-px.x, 0.0)).a);
	a = max(a, texture(TEXTURE, UV + vec2(0.0, px.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2(0.0, -px.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2(px.x, px.y) * 0.7071).a);
	a = max(a, texture(TEXTURE, UV + vec2(-px.x, px.y) * 0.7071).a);
	a = max(a, texture(TEXTURE, UV + vec2(px.x, -px.y) * 0.7071).a);
	a = max(a, texture(TEXTURE, UV + vec2(-px.x, -px.y) * 0.7071).a);

	float pulso = 1.0 - parpadeo * (0.5 + 0.5 * sin(TIME * 4.0));
	vec4 linea = vec4(color_contorno.rgb, a * color_contorno.a * pulso);

	// Donde la figura es opaca mandan sus píxeles; donde no, manda el contorno.
	COLOR = mix(linea, tex, tex.a);
}
