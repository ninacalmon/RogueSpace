extends Path2D

@onready var path_follow = $IndicatorPathFollow2D

func _process(_delta):
	var ship = get_tree().current_scene.find_child("Mothership", true, false)
	var player = get_tree().current_scene.find_child("Player", true, false)
	var indicator_path = get_tree().current_scene.find_child("IndicatorPath2D", true, false)
	if not ship or not player or not indicator_path:
		print("Got out")
		return
	
	var ship_position = ship.global_position
	var local_pos = indicator_path.to_local(ship_position)
	var closest_point = indicator_path.curve.get_closest_point(local_pos)
	var global_closest_point = indicator_path.to_global(closest_point)
	
	var angle = player.global_position.angle_to_point(ship.global_position)
	

	var sprite = get_tree().current_scene.find_child("IndicatorSprite", true, false)
	if not sprite:
		return
	print(angle)
	sprite.rotation = angle
	
