extends Sprite2D

@export var rigid_body: CollectableResource
@export var palette_options: Array[Texture]
var new_palette: Texture

func _ready() -> void:
	frame = randi_range(0, 3)

	if rigid_body.asteoid_parent == null and palette_options.size() > 0:
		new_palette = palette_options.pick_random()
		material.set_shader_parameter("new_palette", new_palette)
	else:
		new_palette = rigid_body.asteoid_parent.chosen_palette
		material.set_shader_parameter("new_palette", new_palette)
