extends Control

var hear_input: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.next_scene_path = "res://Scenes/Levels/Tutorial.tscn"


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		LevelTransition.change_scene_to(Globals.next_scene_path)
