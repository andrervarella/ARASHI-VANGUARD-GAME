shader_type canvas_item;
uniform float flash = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float rim = 1.0;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
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
