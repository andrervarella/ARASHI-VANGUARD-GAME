shader_type canvas_item;
// Memória: tons de sépia avermelhada, vinheta e leve tremor (lembrança da noite do portão)
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += sin(uv.y * 40.0 + TIME * 2.0) * 0.0012;
	vec3 c = texture(screen_texture, uv).rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	vec3 sep = vec3(l * 1.08, l * 0.86, l * 0.68);
	sep = mix(sep, vec3(l * 1.15, l * 0.55, l * 0.45), 0.25);
	float d = distance(SCREEN_UV, vec2(0.5));
	sep *= 1.0 - smoothstep(0.35, 0.85, d) * 0.75;
	COLOR = vec4(sep, 1.0);
}
