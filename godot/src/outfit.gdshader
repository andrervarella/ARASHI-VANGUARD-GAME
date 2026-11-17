shader_type canvas_item;
// Troca de roupa estilo Mega Man: recolore os detalhes vermelhos da roupa do Ren
// e tinge levemente o tecido escuro com a cor do poder equipado.
uniform vec3 accent = vec3(0.70, 0.05, 0.12);
uniform float amount = 0.0;
uniform float cloth = 0.0;
uniform float flash = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float rim = 1.0;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float mx = max(c.r, max(c.g, c.b));
	float is_red = step(0.18, c.r) * step(c.g * 2.6, c.r) * step(c.b * 2.0, c.r);
	vec3 swapped = accent * (c.r / 0.62);
	c.rgb = mix(c.rgb, swapped, is_red * amount);
	float dark = 1.0 - smoothstep(0.08, 0.28, mx);
	c.rgb = mix(c.rgb, c.rgb + accent * 0.22, dark * cloth * (1.0 - is_red));
	// contorno escuro + luz de recorte: o personagem se destaca do cenário pintado (leitura da tela)
	vec2 o = TEXTURE_PIXEL_SIZE * 1.6;
	float n = texture(TEXTURE, UV + vec2(o.x, 0.0)).a + texture(TEXTURE, UV - vec2(o.x, 0.0)).a
		+ texture(TEXTURE, UV + vec2(0.0, o.y)).a + texture(TEXTURE, UV - vec2(0.0, o.y)).a;
	float base_a = c.a;
	if (rim > 0.0) {
		if (c.a < 0.2 && n > 0.4) {
			c = vec4(0.03, 0.01, 0.04, 0.82 * rim);
		} else if (c.a >= 0.2) {
			float up = texture(TEXTURE, UV - vec2(0.0, TEXTURE_PIXEL_SIZE.y * 2.5)).a;
			c.rgb += vec3(1.0, 0.86, 0.7) * (1.0 - up) * 0.16 * rim;
		}
	}
	c.rgb = mix(c.rgb, flash_color.rgb, flash * step(0.5, base_a));
	COLOR = c;
}
