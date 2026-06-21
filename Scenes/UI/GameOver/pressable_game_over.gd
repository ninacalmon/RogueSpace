extends VBoxContainer

@onready var try_again: Button = $TryAgain
@onready var menu: Button = $Menu

var have_pressed: bool = false

func _ready() -> void:
	try_again.pressed.connect(_on_try_again_pressed)
	menu.pressed.connect(_on_menu_pressed)
	try_again.grab_focus()


func _on_try_again_pressed():
	if have_pressed:
		return
	have_pressed = true
	LevelTransition.change_scene_to(Globals.last_level_path)
	print("chamei o level trans, passei a cena: ", Globals.last_level_path)

func _on_menu_pressed():
	if have_pressed:
		return
	have_pressed = true
	LevelTransition.change_scene_to("res://Scenes/Levels/menu.tscn")
