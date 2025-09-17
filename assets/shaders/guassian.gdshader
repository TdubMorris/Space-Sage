shader_type canvas_item;

uniform bool verticle;
uniform int radius : hint_range(0, 100, 1);
uniform float stdev : hint_range(0.0, 20.0, 0.1);

float guassian(float x, float sig) {
	return (1.0/sqrt(6.28*pow(sig, 2.0))) * exp(-(pow(x,2.0)/(2.0*pow(sig,2.0))));
}


void fragment() {
	vec3 col = vec3(0.0, 0.0, 0.0);
	for(int i = -radius; i <= radius; i++) {
		if(verticle && 0.0 < SCREEN_UV.y + SCREEN_PIXEL_SIZE.y * float(i) && SCREEN_UV.y + SCREEN_PIXEL_SIZE.y * float(i) < 1.0) {
			col += guassian(float(i), stdev) * texture(TEXTURE, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y * float(i))).rgb;
		} else if(0.0 < SCREEN_UV.x + SCREEN_PIXEL_SIZE.x * float(i) && SCREEN_UV.x + SCREEN_PIXEL_SIZE.y * float(i) < 1.0) {
			col += guassian(float(i), stdev) * texture(TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x * float(i), 0.0)).rgb;
		}
	}
	COLOR = vec4(col, 1.0);
}
