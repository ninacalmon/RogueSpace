shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float pixel_size : hint_range(1.0, 64.0) = 4.0;
const vec2 TARGET_RES = vec2(1920.0, 1080.0); 

void fragment() {
	vec2 grid_uv = floor(SCREEN_UV * (TARGET_RES / pixel_size)) / (TARGET_RES / pixel_size);
	COLOR = texture(screen_texture, grid_uv);
}









