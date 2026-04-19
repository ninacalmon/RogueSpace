extends Camera2D


@export var zoom_speed: float = 0.2
@export var zoom_smoothness: float = 3.0

const default_zoom: Vector2 = Vector2(1, 1)

var min_zoom = 0.6
var max_zoom = 4.5
var target_zoom: Vector2 = default_zoom

func _ready():
	target_zoom = zoom

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		target_zoom += Vector2.ONE * zoom_speed

	if event.is_action_pressed("scroll_down"):
		target_zoom -= Vector2.ONE * zoom_speed

	if event.is_action_pressed("middle_mouse"):
		target_zoom = default_zoom

	target_zoom = target_zoom.clamp(
		Vector2(min_zoom, min_zoom),
		Vector2(max_zoom, max_zoom)
	)

func _process(delta):
	zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)
	
	## Controller logic vvvvvv
	if Input.is_action_pressed("shoulderL"):
		simulate_zoom_out_input()
	if Input.is_action_pressed("shoulderR"):
		simulate_zoom_in_input()
	if Input.is_action_pressed("shoulderR") and Input.is_action_pressed("shoulderL"):
		simulate_camera_reset_input()

func simulate_zoom_out_input():
	var zoom_out_camera_event = InputEventAction.new()
	zoom_out_camera_event.action = "scroll_down"
	zoom_out_camera_event.pressed = true
	Input.parse_input_event(zoom_out_camera_event)

func simulate_zoom_in_input():
	var zoom_in_camera_event = InputEventAction.new()
	zoom_in_camera_event.action = "scroll_up"
	zoom_in_camera_event.pressed = true
	Input.parse_input_event(zoom_in_camera_event)

func simulate_camera_reset_input():
	var reset_camera_event = InputEventAction.new()
	reset_camera_event.action = "middle_mouse"
	reset_camera_event.pressed = true
	Input.parse_input_event(reset_camera_event)
