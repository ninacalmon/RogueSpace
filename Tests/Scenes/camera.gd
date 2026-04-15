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
