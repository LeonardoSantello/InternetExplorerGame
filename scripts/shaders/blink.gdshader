shader_type canvas_item;

// Uniform for the blend progress (0 = original, 1 = white)
uniform float flash_progress : hint_range(0,1) = 0.0;

void fragment() {
    // Get the original color from the texture
    vec4 original_color = texture(TEXTURE, UV);

    // Mix the original color with white based on flash_progress
    // COLOR.a sets the alpha channel to maintain transparency
    COLOR.rgb = mix(original_color.rgb, vec3(1.0), flash_progress);
    COLOR.a = original_color.a;
}
