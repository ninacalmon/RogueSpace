extends Control

@onready var start: Button = $Pressable/Start
@onready var controls: Button = $Pressable/Controls
@onready var exit: Button = $Pressable/Exit
@onready var controlers: ColorRect = $Controlers
signal menu_selection_changed(selection_number: int)

@onready var control_button: Button = $Controlers/ControlButton

func _ready() -> void:
	Globals.level = 1
	start.pressed.connect(_on_start_button_pressed)
	controls.pressed.connect(_on_controls_button_pressed)
	exit.pressed.connect(_on_exit_button_pressed)
	control_button.pressed.connect(_on_control_exit_pressed)
	start.grab_focus()
	
	start.mouse_entered.connect(_on_button_hovered.bind(1))
	start.focus_entered.connect(_on_button_hovered.bind(1))
	controls.mouse_entered.connect(_on_button_hovered.bind(2))
	controls.focus_entered.connect(_on_button_hovered.bind(2))
	exit.mouse_entered.connect(_on_button_hovered.bind(3))
	exit.focus_entered.connect(_on_button_hovered.bind(3))

func _on_start_button_pressed():
	LevelTransition.change_scene_to("res://Scenes/Levels/Tutorial.tscn")

func _on_controls_button_pressed():
	controlers.show()
	control_button.grab_focus()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_control_exit_pressed():
	controlers.hide()
	controls.grab_focus()
	
func _on_button_hovered(number: int) -> void:
	menu_selection_changed.emit(number)
