extends Area2D
class_name SubArea

@export var clickable_highlight: ClickableHighlight

var can_exit_sub_area: bool = true

func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)

func _on_clicked():
	pass

func deactivate():
	pass
