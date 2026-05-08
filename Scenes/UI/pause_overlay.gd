extends Control

@onready var color_rect: ColorRect = $ColorRect

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		LevelTransition.change_scene_to("res://Scenes/Levels/menu.tscn")
	if event.is_action_pressed("pause"):
		color_rect.visible = !color_rect.visible
		get_tree().paused = !get_tree().paused
