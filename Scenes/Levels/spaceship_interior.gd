extends Node2D

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	PopUpSystem.show_text("A nave está sem energia... Precisa de recursos... De novo.", 3)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
