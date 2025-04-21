shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float amplitude : hint_range(0.0, 1.0) = 0.4;
uniform float frequency : hint_range(0.0, 20.0) = 6.0;
uniform float thickness : hint_range(0.001, 0.1) = 0.02;
uniform float speed = 1.0;
uniform vec4 color : source_color = vec4(0.8, 1.0, 0.3, 1.0);

uniform bool speech_sim = true;
uniform float speech_intensity : hint_range(0.0, 2.0) = 0.8;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x) +
	       (c - a) * u.y * (1.0 - u.x) +
	       (d - b) * u.x * u.y;
}

float fbm(vec2 uv) {
	float value = 0.0;
	float amp = 0.5;
	float freq = 1.0;

	for (int i = 0; i < 4; i++) {
		value += amp * noise(uv * freq);
		freq *= 2.0;
		amp *= 0.5;
	}
	return value;
}

void fragment() {
	float t = TIME * speed;
	float x = UV.x;

	float y_base = 0.5;
	float waveform = sin(x * frequency * 6.2831 + t) * amplitude;

	if (speech_sim) {
		waveform += (fbm(vec2(x * 3.0, t)) - 0.5) * speech_intensity * 0.3;
	}

	float y = y_base + waveform;
	float dist = abs(UV.y - y);
	float line = smoothstep(thickness, 0.0, dist);

	COLOR = line * color;
}