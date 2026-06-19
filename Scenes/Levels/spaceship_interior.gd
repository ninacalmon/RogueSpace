extends Node2D

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	if StatsManager.day != 3:
		PopUpSystem.show_text("A nave está sem energia... Precisa de mais fragmentos... De novo.", 3)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
