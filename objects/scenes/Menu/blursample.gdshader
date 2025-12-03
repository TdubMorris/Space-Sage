shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float lod_strength : hint_range(0.0, 5.0) = 4.0;

void fragment() {
	vec4 blurred = textureLod(screen_tex, SCREEN_UV, lod_strength);
	COLOR = blurred;
}