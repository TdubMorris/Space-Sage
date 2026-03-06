shader_type canvas_item;

uniform sampler2D screen_text : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_amount;

void fragment() {
	vec4 orig_tex = texture(TEXTURE,UV);
	COLOR = mix(textureLod(screen_text,SCREEN_UV,blur_amount), COLOR, COLOR.a);
	COLOR.a = orig_tex.a;
	//COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 5.0);
}