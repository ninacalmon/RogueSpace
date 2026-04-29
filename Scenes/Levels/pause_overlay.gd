extends Control

@onready var color_rect: ColorRect = $ColorRect

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		LevelTransition.change_scene_to("res://Scenes/menu.tscn")
	if Input.is_action_just_pressed("pause"):
		color_rect.visible = !color_rect.visible
		get_tree().paused = !get_tree().paused
