shader_type canvas_item;

uniform float value : hint_range(0.0, 1.0) = 1; // Total progress fill
uniform int segments = 3;                         // Total number of gaps/segments
uniform float segment_gap : hint_range(0.0, 0.1) = 0.075; // Thickness of the gaps
uniform float inner_radius : hint_range(0.0, 0.5) = 0.30; // Center hole size
uniform float outer_radius : hint_range(0.0, 0.5) = 0.5; // Edge thickness
uniform vec4 bar_color : source_color = vec4(0.0, 0.8, 0.3, 1.0);
uniform vec4 bg_color : source_color = vec4(0, 0, 0, 1.0);
uniform float edge_softness : hint_range(0.0, 0.05) = 0.05;


void fragment() {
    // Center coordinates to range from -0.5 to 0.5
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);

    // Create base ring geometry
    float inner = smoothstep(
    inner_radius - edge_softness,
    inner_radius + edge_softness,
    dist
    );

    float outer = 1.0 - smoothstep(
        outer_radius - edge_softness,
        outer_radius + edge_softness,
        dist
    );

    float ring_mask = inner * outer;
    
    // Calculate angle from center (-PI to PI) and normalize to (0.0 to 1.0)
    float angle = atan(uv.y, uv.x) / (2.0 * 3.14159265) + 0.5;
    
    // Invert or rotate angle so progress starts at 12 o'clock instead of 3 o'clock
    angle = mod(angle + 0.25, 1.0);
    
    // Progress Mask
    float progress_mask = step(angle, value);
    
    // Segment Mask (Creates gaps)
    float segment_fraction = mod(angle * float(segments), 1.0);
    float gap_start = smoothstep(
        segment_gap - edge_softness,
        segment_gap + edge_softness,
        segment_fraction
    );

    float gap_end = 1.0 - smoothstep(
        1.0 - segment_gap - edge_softness,
        1.0 - segment_gap + edge_softness,
        segment_fraction
    );

    float gap_mask = gap_start * gap_end;
    
   // Entire circle background
   if (dist > outer_radius) {
    discard;
   }

   vec4 final_color = bg_color;

   final_color.rgb = mix(
    final_color.rgb,
    bar_color.rgb,
    ring_mask * gap_mask * progress_mask
    );

   COLOR = final_color;
}
