extends RichTextLabel

var current_resources: int = 0
@onready var warning_label: RichTextLabel = $WarningLabel

func _ready() -> void:
	Globals.resources_gathered = 0
	text = "[b]%d/%d[/b]
	recursos" %[current_resources, Globals.resources_needed]
	EventBus.space_resource_collected.connect(_on_resource_collected)
	EventBus.player_out_of_bounds.connect(_on_player_out_off_bounds)

func _on_resource_collected():
	Globals.resources_gathered += 1
	current_resources = Globals.resources_gathered
	text = "recursos: [b]%d/%d[/b]" %[current_resources, Globals.resources_needed]
	if Globals.resources_gathered >= Globals.resources_needed:
		warning_label.show()
		flash(warning_label)

func _on_player_out_off_bounds():
	Globals.resources_gathered = floor(current_resources / 2.0)
	current_resources = Globals.resources_gathered
	text = "recursos: [b]%d/%d[/b]" %[current_resources, Globals.resources_needed]
	if Globals.resources_gathered < Globals.resources_needed:
		warning_label.hide()

func flash(what: Control):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "self_modulate", Color(0, 0, 0, 1), 0.02)
	tween.tween_property(what, "self_modulate", Color(10, 10, 10, 10), 0.05)
	tween.tween_property(what, "self_modulate", Color(1, 1, 1, 1), 0.2)
