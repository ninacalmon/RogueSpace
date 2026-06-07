extends VBoxContainer

@onready var try_again: Button = $TryAgain
@onready var menu: Button = $Menu

func _ready() -> void:
	try_again.pressed.connect(_on_try_again_pressed)
	menu.pressed.connect(_on_menu_pressed)
	try_again.grab_focus()

func _on_try_again_pressed():
	LevelTransition.change_scene_to("res://Scenes/Levels/LevelFinal2.tscn")

func _on_menu_pressed():
	LevelTransition.change_scene_to("res://Scenes/Levels/menu.tscn")
