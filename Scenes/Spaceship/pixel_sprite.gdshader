shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 64.0) = 4.0;

void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));

    vec2 snapped_uv =
        floor(UV * tex_size / pixel_size) *
        pixel_size / tex_size;

    vec4 tex = texture(TEXTURE, snapped_uv);

    COLOR.rgb *= tex.rgb;
    COLOR.a *= tex.a;
}