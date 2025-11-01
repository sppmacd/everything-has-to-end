shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float amount;
uniform float grayscale_fac;
uniform float line_height;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 grayscale(vec3 sample) {
	float g = 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
	return vec3(g,g,g);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += rand(vec2(floor(uv.y / SCREEN_PIXEL_SIZE.y / line_height), TIME / 1000.0)) * amount - amount/2.0;
	vec4 color = textureLod(screen_texture, uv, 0.0);
	float grain_fac = rand(floor(uv / SCREEN_PIXEL_SIZE / 3.0) + vec2(TIME*100.0, -TIME*100.0));
	vec3 rnd = vec3(pow(grain_fac, 3.0)) * 0.2 * grayscale_fac;
    COLOR = vec4(mix(color.rgb, grayscale(color.rgb), grayscale_fac) + rnd, 1.0);
}