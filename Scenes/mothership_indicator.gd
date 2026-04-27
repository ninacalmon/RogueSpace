extends Node2D


func _ready() -> void:
	pass 


#func _process(_delta):
	#var ship = get_tree().current_scene.find_child("Mothership", true, false)
	#var indicator_path = get_tree().current_scene.find_child("Path2D", true, false)
	#if not ship or not indicator_path:
		#return
	#
	#var ship_position = ship.global_position
	#var local_pos = indicator_path.to_local(ship_position)
	#var closest_point = indicator_path.curve.get_closest_point(local_pos)
	#var global_closest_point = indicator_path.to_global(closest_point)
	#
	#indicator_path/PathFollow2D.progress = closest_point
	#indicator_path/PathFollow2D.look_at(ship.global_position)
