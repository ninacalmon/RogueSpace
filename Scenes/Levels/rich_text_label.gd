extends RichTextLabel
@onready var timer: Timer = $Timer

var flicker_chances: float = 0.02


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	if randf() < flicker_chances:
		visible = false
	else:
		visible = true
	pass
