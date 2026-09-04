shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.4, 0.0, 1.0); // Flame Orange/Red
uniform float intensity : hint_range(0.0, 5.0) = 2.5;
uniform float flame_speed : hint_range(0.0, 10.0) = 3.0;
uniform float flame_scale : hint_range(0.5, 20.0) = 8.0;

// Simple procedural noise function for flame distortion
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // Smooth interpolation
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
    // Center-origin UV (-0.5 to 0.5)
    vec2 uv = UV - vec2(0.5);
    
    // 1. Square Distance Box (Tightens sides, makes glow rectangular)
    // Scale X by 1.4 to pull in the sides and prevent excessive horizontal stretch
    vec2 box_uv = abs(uv);
    box_uv.x *= 1.4; 
    float box_dist = max(box_uv.x, box_uv.y) * 2.0;
    
    // 2. Rising Flame Distortion
    // Animate noise upwards over TIME
    vec2 noise_uv = UV * flame_scale;
    noise_uv.y -= TIME * flame_speed;
    
    float n1 = noise(noise_uv);
    float n2 = noise(noise_uv * 2.0 + vec2(TIME * 0.5));
    float flame_noise = mix(n1, n2, 0.5);
    
    // 3. Flame Shape Mask
    // Modulate the square boundary with noise, stretching noise towards the top (UV.y = 0.0)
    float upward_bias = (0.5 - UV.y); // Higher intensity towards the top
    float distorted_dist = box_dist - (flame_noise * 0.25 * clamp(upward_bias + 0.5, 0.2, 1.0));
    
    // Smooth falloff from center outward
    float alpha = clamp(1.0 - pow(distorted_dist, 2.5), 0.0, 1.0);
    
    // Color gradient: Core is brighter/yellowish, tips match glow_color
    vec3 core_color = mix(glow_color.rgb * intensity, vec3(1.0, 0.9, 0.5) * intensity, alpha * 0.5);
    
    COLOR = vec4(core_color, alpha * glow_color.a);
}