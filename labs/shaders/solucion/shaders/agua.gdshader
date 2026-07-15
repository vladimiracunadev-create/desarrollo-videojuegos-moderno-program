shader_type canvas_item;
// 5 · Agua: olas, cáusticas y espuma (clase 100).
//
// Aquí ya no hay un truco, hay una RECETA: varias ondas de distinta frecuencia y
// dirección sumadas. Una sola onda se ve artificial de inmediato porque el ojo
// le pilla el patrón; tres desfasadas y con periodos que no encajan entre sí ya
// parecen agua. Es el mismo principio que el ruido por octavas.

uniform vec4 color_agua : source_color = vec4(0.1, 0.45, 0.7, 1.0);
uniform vec4 color_espuma : source_color = vec4(0.85, 0.95, 1.0, 1.0);
uniform float distorsion : hint_range(0.0, 0.1) = 0.02;
uniform float velocidad : hint_range(0.0, 4.0) = 1.0;
uniform float mezcla_agua : hint_range(0.0, 1.0) = 0.45;

float ola(vec2 uv, vec2 dir, float frec, float fase) {
	return sin(dot(uv, dir) * frec + TIME * velocidad * fase);
}

void fragment() {
	// Tres ondas en direcciones distintas: ninguna domina el patrón.
	float o = ola(UV, vec2(1.0, 0.35), 18.0, 1.0)
		+ ola(UV, vec2(-0.4, 1.0), 11.0, 1.6)
		+ ola(UV, vec2(0.8, -0.7), 26.0, 0.7);
	o /= 3.0;

	// La suma de ondas distorsiona la lectura de la textura (como en 'ondas',
	// pero con un patrón mucho más rico).
	vec2 uv = UV + vec2(o, o * 0.5) * distorsion;
	vec4 tex = texture(TEXTURE, uv);

	// Tintamos de azul y añadimos brillo donde las olas coinciden en cresta.
	vec3 rgb = mix(tex.rgb, color_agua.rgb, mezcla_agua);
	float cresta = smoothstep(0.55, 0.95, o);
	rgb = mix(rgb, color_espuma.rgb, cresta * 0.6);

	COLOR = vec4(rgb, tex.a);
}
