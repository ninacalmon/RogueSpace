extends CanvasLayer

@export var original_bottom_text: RichTextLabel
@export var bottom_control: Control
@export var flash_color: Color

func _ready() -> void:
	original_bottom_text.hide()

func show_text(new_text: String, duration: float = 3.0):
	var bottom_text: RichTextLabel = original_bottom_text.duplicate()
	bottom_control.add_child(bottom_text)
	bottom_text.text = new_text
	bottom_text.show()
	await flash(bottom_text, false)
	await get_tree().create_timer(duration).timeout
	await flash(bottom_text, true)
	bottom_text.hide()
	bottom_text.call_deferred("queue_free")

func flash(subject: CanvasItem, invisible: bool):
	var original_modulate: Color = subject.modulate
	subject.modulate = flash_color
	await get_tree().create_timer(0.1).timeout
	var tween = create_tween()
	var final_color: Color
	if invisible: 
		final_color = Color(0, 0, 0, 0)
	else:
		final_color = original_modulate
	tween.tween_property(subject, "modulate", final_color, 0.2)
	await tween.finished
