shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	col.r = 1.0/5.0 * (pow(6.0, col.r) - 1.0);
	col.g = 1.0/5.0 * (pow(6.0, col.g) - 1.0);
	col.b = 1.0/5.0 * (pow(6.0, col.b) - 1.0);
	COLOR = vec4(col, 1.0);
}


