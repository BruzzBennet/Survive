shader_type canvas_item;

// Controls how strong the red flash is (0.0 = normal, 1.0 = fully red)
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    // Keep the sprite's texture details, but mix its color with pure red based on the modifier
    color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
    COLOR = color;
}
