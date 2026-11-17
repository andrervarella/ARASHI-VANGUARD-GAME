shader_type canvas_item;
// Morte de chefe: o corpo se desfaz em brasas, de baixo para cima, com borda incandescente.
uniform float progress : hint_range(0.0, 1.2) = 0.0;
uniform vec4 edge_color : source_color = vec4(1.0, 0.45, 0.1, 1.0);
uniform float block = 3.0;
uniform float flash = 0.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec2 px = floor(UV / TEXTURE_PIXEL_SIZE / block);
	float n = hash(px) * 0.55 + (1.0 - UV.y) * 0.45;
	float t = progress;
	if (n < t) {
		discard;
	}
	float edge = smoothstep(t + 0.08, t, n);
	c.rgb = mix(c.rgb, edge_color.rgb * 1.6, edge);
	c.rgb = mix(c.rgb, vec3(1.0), flash);
	COLOR = c;
}
