extends HBoxContainer

@export var texts: TextsControl

var power_up_options_array: Array[Node] 

func _ready() -> void:
	texts.count_finished.connect(_on_count_finished)
	power_up_options_array = get_children()

func _on_count_finished():
	for p in power_up_options_array:
		p.show()
		await flash(p, p.modulate)
	power_up_options_array.back().grab_focus()

func flash(what: Control, original_color):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "modulate", Color(0, 0, 0, 1), 0.04)
	tween.tween_property(what, "modulate", Color(10, 10, 10, 10), 0.1)
	tween.tween_property(what, "modulate", original_color, 0.4)
	await tween.finished
