extends Control

@onready var day_label: RichTextLabel = $DayLabel

var original_text: String

func _ready() -> void:
	original_text = day_label.text
	day_label.text = original_text.replace("#", str(StatsManager.day))
