shader_type canvas_item;
// 3 · Disolución con borde ardiente (clase 095).
//
// El efecto de "desintegrarse" de medio mundo. La idea: generar ruido, y borrar
// el píxel si su ruido está por debajo de un umbral. Como el ruido es continuo,
// el resultado no son píxeles sueltos sino manchas que crecen. El borde se pinta
// en el margen justo por encima del umbral: ahí es donde "arde".

uniform float borde : hint_range(0.0, 0.3) = 0.06;
uniform vec4 color_borde : source_color = vec4(1.0, 0.55, 0.1, 1.0);
uniform float escala_ruido : hint_range(1.0, 50.0) = 9.0;
// El umbral va y viene solo para que se vea el ciclo completo sin tocar nada.
uniform float velocidad : hint_range(0.0, 2.0) = 0.35;

// Ruido por hash: barato y sin textura. Para producción se usa una NoiseTexture2D
// (mejor calidad y más control), pero esto se lee de un vistazo.
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float ruido(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	// Suavizado de Hermite: sin esto se ve la rejilla del hash.
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float n = ruido(UV * escala_ruido);

	// Umbral animado: 0 -> 1 -> 0.
	float umbral = 0.5 + 0.5 * sin(TIME * velocidad * PI);

	// Por debajo del umbral: desaparece. Justo encima: arde.
	float visible = step(umbral, n);
	float ardiendo = 1.0 - smoothstep(umbral, umbral + borde, n);

	vec3 rgb = mix(tex.rgb, color_borde.rgb, ardiendo * visible);
	COLOR = vec4(rgb, tex.a * visible);
}
