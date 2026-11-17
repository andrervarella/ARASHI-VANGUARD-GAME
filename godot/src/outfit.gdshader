shader_type canvas_item;
// Troca de roupa estilo Mega Man: recolore os detalhes vermelhos da roupa do Ren
// e tinge levemente o tecido escuro com a cor do poder equipado.
uniform vec3 accent = vec3(0.70, 0.05, 0.12);
uniform float amount = 0.0;
uniform float cloth = 0.0;
uniform float flash = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float mx = max(c.r, max(c.g, c.b));
	float is_red = step(0.18, c.r) * step(c.g * 2.6, c.r) * step(c.b * 2.0, c.r);
	vec3 swapped = accent * (c.r / 0.62);
	c.rgb = mix(c.rgb, swapped, is_red * amount);
	float dark = 1.0 - smoothstep(0.08, 0.28, mx);
	c.rgb = mix(c.rgb, c.rgb + accent * 0.22, dark * cloth * (1.0 - is_red));
	c.rgb = mix(c.rgb, flash_color.rgb, flash);
	COLOR = c;
}
