shader_type canvas_item;
// 7 · Post-procesado: CRT (clase 097).
//
// Los seis anteriores pintan UN objeto. Este pinta LO QUE YA HAY EN PANTALLA:
// lee SCREEN_TEXTURE, o sea el resultado de todo lo dibujado antes. Por eso vive
// en un ColorRect a pantalla completa, por encima de todo lo demás.
//
// Junta los tres clásicos de la clase 097: aberración cromática, scanlines y
// viñeta. Ninguno es "realista" — son defectos de un monitor de tubo — y por eso
// mismo funcionan: el ojo asocia esos defectos a "esto es una pantalla vieja".

uniform sampler2D pantalla : hint_screen_texture, filter_linear_mipmap;

uniform float aberracion : hint_range(0.0, 10.0) = 1.6;
uniform float scanlines : hint_range(0.0, 1.0) = 0.25;
uniform float densidad_scanlines : hint_range(50.0, 1200.0) = 480.0;
uniform float vineta : hint_range(0.0, 2.0) = 0.9;
uniform float curvatura : hint_range(0.0, 0.3) = 0.06;

// Curva la UV como si la pantalla fuese un tubo abombado.
vec2 curvar(vec2 uv) {
	vec2 c = uv * 2.0 - 1.0;
	c *= 1.0 + curvatura * dot(c.yx, c.yx);
	return c * 0.5 + 0.5;
}

void fragment() {
	vec2 uv = curvar(SCREEN_UV);

	// Fuera del tubo no hay imagen: negro.
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		// Aberración: cada canal se lee desplazado, más cuanto más lejos del
		// centro (igual que una lente real).
		vec2 desde_centro = uv - vec2(0.5);
		vec2 off = desde_centro * aberracion * 0.004;
		vec3 rgb;
		rgb.r = texture(pantalla, uv + off).r;
		rgb.g = texture(pantalla, uv).g;
		rgb.b = texture(pantalla, uv - off).b;

		// Scanlines: oscurecer una línea horizontal de cada dos.
		float linea = sin(uv.y * densidad_scanlines * PI);
		rgb *= 1.0 - scanlines * (0.5 + 0.5 * linea);

		// Viñeta: oscurecer las esquinas.
		float v = 1.0 - vineta * dot(desde_centro, desde_centro);
		rgb *= clamp(v, 0.0, 1.0);

		COLOR = vec4(rgb, 1.0);
	}
}
