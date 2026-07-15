shader_type canvas_item;
// 6 · Cel shading: cuantizar el color (clase 103).
//
// Lo que hace que algo parezca dibujado a mano no es añadir, es QUITAR: se
// reduce el número de tonos posibles. Un degradado continuo pasa a ser tres o
// cuatro bandas planas, y el ojo lo lee como ilustración en vez de foto.
//
// La cuenta es siempre la misma: floor(valor * n) / n. Todo lo demás es gusto.

uniform int bandas : hint_range(2, 12) = 4;
uniform float saturacion : hint_range(0.0, 2.0) = 1.25;
uniform vec4 sombra : source_color = vec4(0.15, 0.1, 0.3, 1.0);
uniform float fuerza_sombra : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Luminancia percibida: el ojo no pesa igual el rojo, el verde y el azul.
	float luz = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

	// El corazón del efecto: de infinitos tonos a 'bandas' tonos.
	float n = float(bandas);
	float luz_banda = floor(luz * n) / n;

	// Reconstruimos el color con la luz cuantizada y lo saturamos.
	vec3 rgb = tex.rgb * (luz_banda / max(luz, 0.001));
	vec3 gris = vec3(dot(rgb, vec3(0.299, 0.587, 0.114)));
	rgb = mix(gris, rgb, saturacion);

	// Las bandas más oscuras se tiñen: los sombreados de cómic no son grises.
	rgb = mix(rgb, sombra.rgb, (1.0 - luz_banda) * fuerza_sombra);

	COLOR = vec4(rgb, tex.a);
}
