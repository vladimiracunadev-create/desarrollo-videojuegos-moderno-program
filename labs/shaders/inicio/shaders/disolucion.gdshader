shader_type canvas_item;
// 3 · Disolución con borde ardiente (clase 095). — EJERCICIO
//
// El efecto de "desintegrarse" de medio mundo. La idea: generar ruido, y borrar
// el píxel si su ruido está por debajo de un umbral. Como el ruido es continuo,
// el resultado no son píxeles sueltos sino manchas que crecen. El borde se pinta
// en el margen justo por encima del umbral: ahí es donde "arde".
//
// El ruido ya viene resuelto (es matemática de apoyo, no el concepto): tú tienes
// que usarlo.

uniform float borde : hint_range(0.0, 0.3) = 0.06;
uniform vec4 color_borde : source_color = vec4(1.0, 0.55, 0.1, 1.0);
uniform float escala_ruido : hint_range(1.0, 50.0) = 9.0;
// El umbral va y viene solo para que se vea el ciclo completo sin tocar nada.
uniform float velocidad : hint_range(0.0, 2.0) = 0.35;

// --- Ya resuelto: ruido por hash, barato y sin textura ------------------------
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
// -----------------------------------------------------------------------------

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// TODO 1: saca el ruido de este píxel:
	//         float n = ruido(UV * escala_ruido);
	//         Pinta COLOR = vec4(vec3(n), 1.0) un momento para VERLO: entender
	//         qué pinta el ruido es media batalla.

	// TODO 2: umbral animado que va de 0 a 1 y vuelve:
	//         float umbral = 0.5 + 0.5 * sin(TIME * velocidad * PI);

	// TODO 3: por debajo del umbral el píxel desaparece:
	//         float visible = step(umbral, n);
	//         step(a, x) devuelve 0 si x < a, y 1 si no. Es un if sin if.

	// TODO 4: la franja justo por encima del umbral "arde":
	//         float ardiendo = 1.0 - smoothstep(umbral, umbral + borde, n);
	//         smoothstep hace la transición suave en vez de un corte seco.

	// TODO 5: junta las tres cosas:
	//         vec3 rgb = mix(tex.rgb, color_borde.rgb, ardiendo * visible);
	//         COLOR = vec4(rgb, tex.a * visible);

	COLOR = tex;
}
