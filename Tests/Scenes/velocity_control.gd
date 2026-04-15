extends Control

@export var player: Player
@onready var arrow: Node2D = $Arrow

var arrow_colors: Array[Color] = [
	Color(1.0, 1.0, 1.0),
	Color(1.0, 0.7, 0.0),
	Color(0.7, 0.0, 0.0),
	Color(0.2, 0.0, 0.4)
]

@export var max_speed: float = 1000.0

func _process(_delta: float) -> void:
	var speed = player.linear_velocity.length()
	var t = clamp(speed / max_speed, 0.0, 1.0)

	arrow.look_at(player.linear_velocity)

	arrow.modulate = get_gradient_color(t)

func get_gradient_color(t: float) -> Color:
	var count = arrow_colors.size() - 1
	var scaled = t * count
	
	var index = int(floor(scaled))
	var next_index = min(index + 1, count)
	
	var local_t = scaled - index
	
	return arrow_colors[index].lerp(arrow_colors[next_index], local_t)
