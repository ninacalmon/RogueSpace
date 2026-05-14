extends Node2D
class_name ClickableHighlight

@export var area: Area2D
@export var sprite: Sprite2D

var is_mouse_over_area: bool

func _ready() -> void:
	if !sprite.material:
		print("you missed the sprite's outline shader")
		return
	
	area.input_pickable = true
	area.monitoring = true
	sprite.set_instance_shader_parameter("enabled", false)
	
	area.mouse_entered.connect(_on_area_mouse_entered)
	area.mouse_exited.connect(_on_area_mouse_exited)

func _on_area_mouse_entered():
	is_mouse_over_area = true
	sprite.set_instance_shader_parameter("enabled", true)

func _on_area_mouse_exited():
	is_mouse_over_area = false
	sprite.set_instance_shader_parameter("enabled", false)

func _input(event: InputEvent) -> void:
	if !is_mouse_over_area:
		return
	if event.is_action_pressed("left_click"):
		sprite.set_instance_shader_parameter("outline_color", Color(1.0, 0.0, 0.0))
	if event.is_action_released("left_click"):
		sprite.set_instance_shader_parameter("outline_color", Color(1.0, 1.0, 1.0))
