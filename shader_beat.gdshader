shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float bass_amp : hint_range(0.0, 1.0) = 0.0;
uniform float mid_bass_amp : hint_range(0.0, 1.0) = 0.0;
uniform float mid_amp : hint_range(0.0, 1.0) = 0.0;
uniform float upper_mid_amp : hint_range(0.0, 1.0) = 0.0;
uniform float treble_amp : hint_range(0.0, 1.0) = 0.0;
uniform float high_treble_amp : hint_range(0.0, 1.0) = 0.0;

uniform float base_frequency = 8.0;
uniform float line_thickness = 0.015;

uniform vec4 bass_color : source_color = vec4(0.9, 0.3, 0.3, 1.0);
uniform vec4 mid_bass_color : source_color = vec4(0.8, 0.6, 0.3, 1.0);
uniform vec4 mid_color : source_color = vec4(0.3, 0.9, 0.3, 1.0);
uniform vec4 upper_mid_color : source_color = vec4(0.3, 0.8, 0.9, 1.0);
uniform vec4 treble_color : source_color = vec4(0.3, 0.6, 0.9, 1.0);
uniform vec4 high_treble_color : source_color = vec4(0.9, 0.8, 0.3, 1.0);

uniform int shape_sides : hint_range(3, 64) = 64;

float polygon_dist(vec2 p, float sides) {
    float a = atan(p.y, p.x);
    float radius = cos(PI / sides) / cos(mod(a, 2.0 * PI / sides) - PI / sides);
    return length(p) / radius;
}

float waveform(float angle, float radius_offset, float amp, float time_mod) {
    float wave = sin(angle * base_frequency + TIME * time_mod);
    wave += sin(angle * base_frequency * 2.0 + TIME * time_mod * 1.5) * 0.3;
    return radius_offset + wave * amp;
}

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float angle = atan(uv.y, uv.x);
    float dist = polygon_dist(uv, float(shape_sides));

    float bass_r = waveform(angle, 0.75, bass_amp, 1.0);
    float mid_bass_r = waveform(angle, 0.65, mid_bass_amp, 1.2);
    float mid_r = waveform(angle, 0.55, mid_amp, 1.4);
    float upper_mid_r = waveform(angle, 0.45, upper_mid_amp, 1.6);
    float treble_r = waveform(angle, 0.35, treble_amp, 1.8);
    float high_treble_r = waveform(angle, 0.25, high_treble_amp, 2.0);

    float bass_line = smoothstep(line_thickness, 0.0, abs(dist - bass_r));
    float mid_bass_line = smoothstep(line_thickness, 0.0, abs(dist - mid_bass_r));
    float mid_line = smoothstep(line_thickness, 0.0, abs(dist - mid_r));
    float upper_mid_line = smoothstep(line_thickness, 0.0, abs(dist - upper_mid_r));
    float treble_line = smoothstep(line_thickness, 0.0, abs(dist - treble_r));
    float high_treble_line = smoothstep(line_thickness, 0.0, abs(dist - high_treble_r));

    vec4 color = bass_line * bass_color +
                 mid_bass_line * mid_bass_color +
                 mid_line * mid_color +
                 upper_mid_line * upper_mid_color +
                 treble_line * treble_color +
                 high_treble_line * high_treble_color;

    COLOR = color;
}