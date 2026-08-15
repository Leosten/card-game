// wipe_transition.gdshader
shader_type canvas_item;

// Progress range:
// 0.0 = completely clear (waiting off-screen right)
// 1.0 = screen fully covered in black
// 2.0 = completely clear (exited off-screen left)
uniform float progress : hint_range(0.0, 2.0) = 0.0;
uniform float trail_width : hint_range(0.0, 0.5) = 0.15;
uniform float slant : hint_range(-0.5, 0.5) = 0.2;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
    float screen_x = 1.0 - UV.x;
    float slanted_x = screen_x + (UV.y - 0.5) * slant;
    
    vec2 noise_uv = vec2(UV.x * 20.0, UV.y * 80.0);
    float streaks = noise(noise_uv) * 0.7 + noise(noise_uv * 2.0) * 0.3;
    
    // Map progress range 0.0 -> 2.0 cleanly across screen bounds
    float offset = trail_width + abs(slant);
    float leading_edge = mix(-offset, 1.0 + offset, progress);
    float trailing_edge = leading_edge - (1.0 + offset);
    
    // Calculate alpha mask so black box enters from right and exits left
    float alpha_in = 1.0 - smoothstep(leading_edge - offset, leading_edge, slanted_x);
    float alpha_out = smoothstep(trailing_edge - offset, trailing_edge, slanted_x);
    
    float final_alpha = alpha_in * alpha_out;
    
    COLOR = vec4(0.0, 0.0, 0.0, clamp(final_alpha, 0.0, 1.0));
}