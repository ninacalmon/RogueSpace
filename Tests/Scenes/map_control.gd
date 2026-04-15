extends Node2D

@export var player: Player
var map_size: Vector2
var rect: Rect2

var offset_x: float
var offset_y: float

var sanity_offset: float = 1.0

var end_edge_right: float
var end_edge_left: float

var end_offseted_right: float
var end_offseted_left: float

var end_edge_top: float
var end_edge_bottom: float

var end_offseted_top: float
var end_offseted_bottom: float

func _ready() -> void:
	var viewport_rect_size: Vector2 = get_viewport_rect().size
	map_size = Vector2.ONE * viewport_rect_size.x * 8
	offset_x = viewport_rect_size.x * 1.5
	offset_y = viewport_rect_size.y
	
	end_edge_right = map_size.x * 0.5
	end_edge_left = -map_size.x * 0.5
	
	end_offseted_right = end_edge_right -offset_x
	end_offseted_left = end_edge_left +offset_x

	end_edge_top = -map_size.y * 0.5
	end_edge_bottom = map_size.y * 0.5
	
	end_offseted_top = end_edge_top +offset_y
	end_offseted_bottom = end_edge_bottom -offset_y

	#queue_redraw()
#
#func _draw() -> void:
	#rect = Rect2(-map_size * 0.5, map_size)
	#draw_rect(rect, Color(1, 0, 0, 0.2))

func _process(_delta: float) -> void:
	## right and left
	if is_within(end_offseted_right, end_edge_right, player.global_position.x):
		print("dir")
		player.global_position.x = end_offseted_left + sanity_offset

	if is_within(end_edge_left, end_offseted_left, player.global_position.x):
		player.global_position.x = end_offseted_right - sanity_offset
		print("esq", player.global_position.x)

	## top and bottom
	if is_within(end_edge_top, end_offseted_top, player.global_position.y):
		print("cim")
		player.global_position.y = end_offseted_bottom - sanity_offset

	if is_within(end_offseted_bottom, end_edge_bottom, player.global_position.y):
		print("baix")
		player.global_position.y = end_offseted_top + sanity_offset

func is_within(start: float, end: float, value: float) -> bool:
	return value >= start and value <= end
