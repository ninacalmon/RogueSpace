extends Node2D
class_name ClickableHighlight

@export var area: Area2D
@export var sprite: Sprite2D
@export var active: bool = true

var is_mouse_over_area: bool

signal was_clicked
signal clicked_outside()

func _ready() -> void:
	if !sprite.material:
		print("you missed the sprite's outline shader")
		return
	
	area.input_pickable = true
	area.monitoring = true
	sprite.set_instance_shader_parameter("enabled", false)
	
	area.mouse_entered.connect(_on_area_mouse_entered)
	area.mouse_exited.connect(_on_area_mouse_exited)
	
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)

func _on_area_mouse_entered():
	if active:
		is_mouse_over_area = true
		sprite.set_instance_shader_parameter("enabled", true)
		ControllerVibration.vibrate_controller()

func _on_area_mouse_exited():
	if active:
		is_mouse_over_area = false
		sprite.set_instance_shader_parameter("enabled", false)
		ControllerVibration.vibrate_controller()

func _input(event: InputEvent) -> void:
	if !active:
		return
	
	if !is_mouse_over_area:
		if event.is_action_pressed("left_click"):
			clicked_outside.emit()
			return
	if event.is_action_pressed("left_click"):
		print("clicando")
		was_clicked.emit()
		sprite.set_instance_shader_parameter("outline_color", Color(1.0, 0.0, 0.0))
	if event.is_action_released("left_click"):
		print("parei")
		sprite.set_instance_shader_parameter("outline_color", Color(1.0, 1.0, 1.0))

func _on_focus_changed(_focus: bool, _subject: Node2D):
	# ClickableModule always deactivate everything because Main Area is responsible to activate as needed.
	active = false
	sprite.set_instance_shader_parameter("enabled", false)
