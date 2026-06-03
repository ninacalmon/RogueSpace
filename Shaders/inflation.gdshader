shader_type canvas_item;

uniform float puff_amount : hint_range(0.0, 2.0) = 0.0;
uniform float wobble_strength : hint_range(0.0, 0.2) = 0.05;
uniform float wobble_speed : hint_range(0.0, 10.0) = 4.0;

void fragment() {
	vec2 uv = UV;

	// Center UV (-0.5 to 0.5)
	vec2 centered = uv - 0.5;

	float dist = length(centered);

	// Radial expansion (core of the puff)
	float inflate = 1.0 + puff_amount;

	// Wobble (organic motion)
	float wobble = sin(dist * 20.0 - TIME * wobble_speed) * wobble_strength * puff_amount;

	// Apply deformation
	vec2 new_uv = centered / (inflate + wobble) + 0.5;

	COLOR = texture(TEXTURE, new_uv);
}