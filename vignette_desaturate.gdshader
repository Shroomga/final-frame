shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float desaturation : hint_range(0.0, 1.0) = 0.85;
uniform float vignette_strength : hint_range(0.0, 2.0) = 1.2;
uniform float vignette_softness : hint_range(0.01, 1.0) = 0.45;

void fragment() {
	vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
	
	// Desaturate using luminance
	float lum = dot(screen, vec3(0.299, 0.587, 0.114));
	vec3 desat = mix(screen, vec3(lum), desaturation);
	
	// Vignette: distance from screen center
	vec2 uv = SCREEN_UV - 0.5;
	float dist = length(uv);
	float vig = smoothstep(vignette_softness, 0.5 * vignette_strength, dist);
	vig = 1.0 - vig;
	
	COLOR = vec4(desat * vig, 1.0);
}