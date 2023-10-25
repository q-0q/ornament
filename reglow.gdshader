shader_type canvas_item;

void fragment() {
    vec2 ps = SCREEN_PIXEL_SIZE;
    vec4 col0 = texture(hint_screen_texture, SCREEN_UV + vec2(-ps.x, 0));
    vec4 col1 = texture(hint_screen_texture, SCREEN_UV + vec2(ps.x, 0));
    vec4 col2 = texture(hint_screen_texture, SCREEN_UV + vec2(0, -ps.y));
    vec4 col3 = texture(hint_screen_texture, SCREEN_UV + vec2(0, ps.y));
    COLOR = 0.25 * (col0 + col1 + col2 + col3);
}