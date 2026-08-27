extends CanvasLayer

@onready var custom_tooltip_control: Control = $CustomTooltipControl
@onready var color_rect: ColorRect = $CustomTooltipControl/ColorRect
@onready var rich_text_label: RichTextLabel = $CustomTooltipControl/ColorRect/RichTextLabel



func show_tooltip(text: String, global_pos: Vector2 = Vector2.ZERO):
	if global_pos == Vector2.ZERO:
		custom_tooltip_control.global_position = custom_tooltip_control.get_global_mouse_position()
	else:
		custom_tooltip_control.global_position = global_pos
	rich_text_label.text = text
	color_rect.show()

func hide_tooltip():
	color_rect.hide()
