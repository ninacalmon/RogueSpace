extends Node2D
class_name MapControl

########## IMPORTANT!!!!
## this code is temporary!! later this code will be changed so that the player
## move freely around the map, and new stuff (including parallax bg) will pop
## close to him, and be despawned if too far away.

## this also implies that we will estabilish a distance from mothership in which
## player looses contact with it... (because he went so far away that we will have
## despawn it. this will basically mean insta fail. I MUCH PREFER THAT APPROACH!

## if we change our minds, other idea would be that if you go too far away,
## mothership teleports you back, and you loose half or all the resources you
## had got (prevent the player from exploying it)!

## !! the code, as it stands now, gives off a very ugly and noticiable transition
## when teleporting.

@export var player: Player
@export var camera: Camera2D
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

var player_init_pos: Vector2

func _ready() -> void:
	player_init_pos = player.global_position
	var viewport_rect_size: Vector2 = get_viewport_rect().size
	map_size = Vector2.ONE * viewport_rect_size.x * 5
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
	if player.global_position.x > end_offseted_right or\
	player.global_position.x < end_offseted_left or\
	player.global_position.y < end_offseted_top or\
	player.global_position.y > end_offseted_bottom:
		execute_teletransport()


func execute_teletransport():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", camera.zoom + Vector2.ONE * 0.3, 0.2)
	tween.tween_property(player, "modulate", Color(18.892, 18.892, 18.892), 0.1)
	tween.set_parallel(false)
	tween.tween_property(player, "modulate", Color(1, 1, 1), 0.1)
	await tween.finished
	player.linear_velocity = Vector2.ZERO
	player.global_position = player_init_pos

	#if player.global_position > Vector2(end_offseted_right, end_offseted_bottom) or \
	#player.global_position < Vector2(end_offseted_left, end_offseted_top):
		#print("hehehehe")
		#player.global_position = player_init_pos

#func _process(_delta: float) -> void:
	### right and left
	#if is_within(end_offseted_right, end_edge_right, player.global_position.x):
		#print("dir")
		#player.global_position.x = end_offseted_left + sanity_offset
#
	#if is_within(end_edge_left, end_offseted_left, player.global_position.x):
		#player.global_position.x = end_offseted_right - sanity_offset
		#print("esq", player.global_position.x)
#
	### top and bottom
	#if is_within(end_edge_top, end_offseted_top, player.global_position.y):
		#print("cim")
		#player.global_position.y = end_offseted_bottom - sanity_offset
#
	#if is_within(end_offseted_bottom, end_edge_bottom, player.global_position.y):
		#print("baix")
		#player.global_position.y = end_offseted_top + sanity_offset
#
#func is_within(start: float, end: float, value: float) -> bool:
	#return value >= start and value <= end
