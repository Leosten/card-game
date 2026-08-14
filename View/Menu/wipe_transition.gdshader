// wipe_transition.gdshader
shader_type canvas_item;

// Controls progress from 0.0 (completely clear) to 1.0 (completely covered in black)
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// Width of the jagged trailing slash edge
uniform float trail_width : hint_range(0.0, 0.5) = 0.15;

// Angle/slant of the wipe sweep
uniform float slant : hint_range(-0.5, 0.5) = 0.2;

// Pseudo-noise function to generate organic trail/streak shapes
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
    // Invert UV.x so sweep moves RIGHT -> LEFT (1.0 to 0.0)
    float screen_x = 1.0 - UV.x;
    
    // Add slant based on vertical position (UV.y)
    float slanted_x = screen_x + (UV.y - 0.5) * slant;
    
    // Sample multi-scale noise to create streak/trail patterns along the edge
    vec2 noise_uv = vec2(UV.x * 20.0, UV.y * 80.0); // Stretched horizontally for speed lines
    float streaks = noise(noise_uv) * 0.7 + noise(noise_uv * 2.0) * 0.3;
    
    // Map the sweep threshold
    float threshold = progress * (1.0 + trail_width + abs(slant)) - (trail_width + abs(slant));
    float edge = slanted_x - threshold;
    
    // Smooth trailing alpha blend
    float alpha = 1.0 - smoothstep(0.0, trail_width * (0.5 + streaks * 0.8), edge);
    
    // Output solid black color with calculated trailing alpha
    COLOR = vec4(0.0, 0.0, 0.0, clamp(alpha, 0.0, 1.0));
}