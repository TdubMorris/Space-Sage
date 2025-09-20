shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0, 0.1) = 4.0;

void fragment() {
	vec4 orig_tex = texture(TEXTURE,UV);
	vec4 blurred_texture = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod);
	COLOR = mix(blurred_texture, COLOR, COLOR.a);
	COLOR.a = orig_tex.a;
	//COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 5.0);
}