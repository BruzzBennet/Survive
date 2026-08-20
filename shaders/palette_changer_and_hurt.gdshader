shader_type canvas_item;

// --- Uniforms del Cambio de Paleta ---
uniform sampler2D palette_from : source_color;
uniform sampler2D palette_to   : source_color;
uniform int palette_size : hint_range(1, 64) = 8;
uniform float tolerance : hint_range(0.01, 0.5) = 0.01;

// --- Uniforms del Destello de Daño ---
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Rojo por defecto

void fragment() {
    // 1. Obtener el color original del sprite
    vec4 src = texture(TEXTURE, UV);
    vec4 current_color = src;

    // 2. Aplicar la lógica del Cambio de Paleta
    for (int i = 0; i < palette_size; i++) {
        float u = (float(i) + 0.5) / float(palette_size);

        vec3 from_color = texture(palette_from, vec2(u, 0.5)).rgb;
        vec3 to_color   = texture(palette_to,   vec2(u, 0.5)).rgb;

        if (distance(src.rgb, from_color) < tolerance) {
            current_color = vec4(to_color, src.a);
            break;
        }
    }

    // 3. Aplicar la lógica del Destello (sobre la paleta ya cambiada)
    current_color.rgb = mix(current_color.rgb, flash_color.rgb, flash_modifier);

    // 4. Color final enviado a pantalla
    COLOR = current_color;
}
