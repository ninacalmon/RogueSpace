shader_type canvas_item;

instance uniform bool enabled = true;
instance uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
instance uniform int outline_width = 1;
uniform bool rounded = true;
uniform float alpha_threshold = 0.1;

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	if (!enabled) {
		COLOR = base;
	} else {


	vec2 pixel = TEXTURE_PIXEL_SIZE;

	bool is_base = base.a > alpha_threshold;
	bool found = false;

	if (!is_base) {
		for (int x = -10; x <= 10; x++) {
			if (x < -outline_width || x > outline_width) continue;

			for (int y = -10; y <= 10; y++) {
				if (y < -outline_width || y > outline_width) continue;
				if (rounded && length(vec2(float(x), float(y))) > float(outline_width)) continue;

				vec2 offset = vec2(float(x), float(y)) * pixel;

				if (texture(TEXTURE, UV + offset).a > alpha_threshold) {
					found = true;
					break;
				}
			}
			if (found) break;
		}
	}

	if (is_base) {
		COLOR = base;
	} else if (found) {
		COLOR = outline_color;
	} else {
		COLOR = vec4(0.0);
	}
	}
}