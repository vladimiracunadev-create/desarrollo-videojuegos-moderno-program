shader_type canvas_item;
// 6 · Cel shading: cuantizar el color (clase 103). — EJERCICIO
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

	// TODO 1: saca la luminancia percibida. El ojo NO pesa igual los tres
	//         canales (el verde manda, el azul casi no cuenta):
	//         float luz = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	//         Prueba con vec3(0.333) y compara: se nota, y para mal.

	// TODO 2: EL CORAZÓN DEL EFECTO. De infinitos tonos a 'bandas' tonos:
	//         float n = float(bandas);
	//         float luz_banda = floor(luz * n) / n;
	//         Mueve el slider 'bandas' de 2 a 12 y mira cómo aparece y
	//         desaparece el aspecto de cómic.

	// TODO 3: reconstruye el color con la luz cuantizada y satúralo:
	//         vec3 rgb = tex.rgb * (luz_banda / max(luz, 0.001));
	//         vec3 gris = vec3(dot(rgb, vec3(0.299, 0.587, 0.114)));
	//         rgb = mix(gris, rgb, saturacion);
	//         El max(luz, 0.001) evita dividir por cero en los píxeles negros.

	// TODO 4: tiñe las bandas oscuras (los sombreados de cómic no son grises):
	//         rgb = mix(rgb, sombra.rgb, (1.0 - luz_banda) * fuerza_sombra);
	//         COLOR = vec4(rgb, tex.a);

	COLOR = tex;
}
