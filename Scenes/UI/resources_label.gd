extends RichTextLabel
class_name ResourcesLabel

@onready var warning_label: RichTextLabel = $"../WarningLabel"

func _ready() -> void:
	text = "[b]%d/%d[/b]
	fragmentos" %[StatsManager.current_resources, StatsManager.resources_needed]
	EventBus.space_resource_collected.connect(_on_resource_collected)
	EventBus.player_out_of_bounds.connect(_on_player_out_off_bounds)

func _on_resource_collected():
	StatsManager.current_resources += 1
	text = "fragmentos: [b]%d/%d[/b]" %[StatsManager.current_resources, StatsManager.resources_needed]
	if StatsManager.current_resources >= StatsManager.resources_needed:
		warning_label.show()
		flash(warning_label)

func _on_player_out_off_bounds():
	StatsManager.current_resources = floor(StatsManager.current_resources / 2.0)
	text = "fragmentos: [b]%d/%d[/b]" %[StatsManager.current_resources, StatsManager.resources_needed]
	if StatsManager.current_resources < StatsManager.resources_needed:
		warning_label.hide()

func flash(what: Control):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "self_modulate", Color(0, 0, 0, 1), 0.02)
	tween.tween_property(what, "self_modulate", Color(10, 10, 10, 10), 0.05)
	tween.tween_property(what, "self_modulate", Color(1, 1, 1, 1), 0.2)
