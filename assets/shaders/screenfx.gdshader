shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture;
uniform bool invert;
uniform float chrome_ab;
uniform bool vignette;
uniform bool scanlines;
uniform bool bulge;

void fragment() {

	//screen bend
	vec2 sample_pos;
	if(bulge) { sample_pos = SCREEN_UV - 0.2 * vec2(pow((SCREEN_UV.x - 0.5), 2.0) * sign(SCREEN_UV.x - 0.5), 0.0); }
	else { sample_pos = SCREEN_UV; }

	//chromatic aberation
	float ABamount = clamp(chrome_ab * distance(SCREEN_UV, vec2(0.5, 0.5)) - 0.3, 0.0, 1.0);
	vec3 col = vec3(
		texture(screen_texture, sample_pos + ABamount * vec2(-0.01, 0), 0.0).r,
		texture(screen_texture, sample_pos, 0.0).g,
		texture(screen_texture, sample_pos + ABamount * vec2(0.01, 0), 0.0).b
	);

	if(invert) {
		col = 1.0 - col;
	}

	//crt lines
	if(mod(FRAGCOORD.y, 8.0) < 2.0 && scanlines) {
		col *= 0.9;
	}

	//vignette
	if(vignette) {
		col *= 1.0 - 1.3 * distance(SCREEN_UV, vec2(0.5, 0.5));
	}

	COLOR = vec4(col, 1.0);
}
