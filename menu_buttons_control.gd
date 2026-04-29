extends Control

@onready var start: Button = $Pressable/Start
@onready var controls: Button = $Pressable/Controls
@onready var exit: Button = $Pressable/Exit
@onready var controlers: ColorRect = $Controlers

@onready var control_button: Button = $Controlers/ControlButton



func _ready() -> void:
	start.pressed.connect(_on_start_button_pressed)
	controls.pressed.connect(_on_controls_button_pressed)
	exit.pressed.connect(_on_exit_button_pressed)
	control_button.pressed.connect(_on_control_exit_pressed)
	start.grab_focus()

func _on_start_button_pressed():
	LevelTransition.change_scene_to("res://Scenes/Levels/Level1.tscn")

func _on_controls_button_pressed():
	controlers.show()
	control_button.grab_focus()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_control_exit_pressed():
	controlers.hide()
	controls.grab_focus()
