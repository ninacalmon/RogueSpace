extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
var color_rect_tween: Tween

func change_scene_to(scene_path: String, time_to_fade_in: float = 0.2, time_to_fade_out: float = 0.4) -> void:
	if self.color_rect_tween:
		self.color_rect_tween.kill()

	get_tree().paused = true

	color_rect_tween = create_tween().set_trans(Tween.TRANS_SINE)
	color_rect_tween.tween_property(color_rect, "modulate:a", 1.0, time_to_fade_in).finished.connect(_load_new_scene.bind(scene_path))
	color_rect_tween.chain().tween_property(color_rect, "modulate:a", 0.0, time_to_fade_out)

func _load_new_scene(scene_to_load: String):
	var tree = get_tree()
	tree.paused = false
	tree.call_deferred("change_scene_to_file", scene_to_load)
