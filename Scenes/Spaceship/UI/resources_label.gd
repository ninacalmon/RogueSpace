extends RichTextLabel

func _ready() -> void:
	hide()
	text = "[b]%d[/b]
fragmentos" %StatsManager.current_resources
	SpaceshipEventBus.resources_spent.connect(_on_resources_spent)
	

func _on_resources_spent():
	show()
	await get_tree().create_timer(1.5).timeout
	flash(self)
	text = "[b]%d[/b]
fragmentos" %StatsManager.current_resources

func flash(what: Control):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "self_modulate", Color(0, 0, 0, 1), 0.02)
	tween.tween_property(what, "self_modulate", Color(0.31, 1.825, 0.0), 0.05)
	tween.tween_property(what, "self_modulate", Color(1, 1, 1, 1), 0.2)
