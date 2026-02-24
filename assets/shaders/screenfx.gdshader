shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap_anisotropic;
uniform bool invert;
uniform float chrome_ab;
uniform float scanline_height;
uniform bool bulge;
uniform bool vignette;

void fragment() {
	//screen bend
	vec2 sample_pos;
	if(bulge) { sample_pos = SCREEN_UV - 0.3 * vec2(pow((SCREEN_UV.x - 0.5), 2.0) * sign(SCREEN_UV.x - 0.5), 0.0); }
	else { sample_pos = SCREEN_UV; }

	// chromatic aberation
	float ABamount = clamp(chrome_ab * distance(SCREEN_UV, vec2(0.5, 0.5)) - 0.3, 0.0, 1.0);
	vec3 col = 1.0 * vec3(
		texture(screen_texture, sample_pos + ABamount * vec2(-0.01, 0), 0.0).r,
		texture(screen_texture, sample_pos, 0.0).g,
		texture(screen_texture, sample_pos + ABamount * vec2(0.01, 0), 0.0).b
	);

	if(invert) {
		col = 1.0 - col;
	}

	//crt lines
	if(scanline_height > 0.0 && mod(FRAGCOORD.y, scanline_height) < scanline_height/4.0) {
		col *= 0.9;
	}
	
	if(vignette) {
		float dist = distance(UV, vec2(0.5));
		float dither = fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453123) * 0.1;
		col = mix(col, vec3(0,0,0), dist+dither);
	}
	
	
	COLOR = vec4(col, 1.0);
}
