extends RichTextLabel

func _ready() -> void:
	text = "[b]%d recursos[/b]" %StatsManager.current_resources
	SpaceshipEventBus.resources_spent.connect(_on_resources_spent)

func _on_resources_spent():
	flash(self)
	text = "[b]%d recursos[/b]" %StatsManager.current_resources

func flash(what: Control):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "self_modulate", Color(0, 0, 0, 1), 0.02)
	tween.tween_property(what, "self_modulate", Color(0.31, 1.825, 0.0), 0.05)
	tween.tween_property(what, "self_modulate", Color(1, 1, 1, 1), 0.2)
