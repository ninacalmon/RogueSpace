extends TileMapLayer

@export var small_asteroid_scene: PackedScene
@export var medium_asteroid_scene: PackedScene
@export var large_asteroid_scene: PackedScene
@export var black_hole_scene: PackedScene
@export var planet_scene: PackedScene

var small_asteroid_atlas: Vector2i = Vector2i(1, 0)
var medium_asteroid_atlas: Vector2i = Vector2i(0, 0)
var large_asteroid_atlas: Vector2i = Vector2i(4, 0)
var black_hole_atlas: Vector2i = Vector2i(0, 1)
var planet_atlas: Vector2i = Vector2i(8, 0)

func _ready() -> void:
	spawn_asteroids()

func spawn_asteroids():
	for cell in get_used_cells():
		var atlas_coords = get_cell_atlas_coords(cell)

		var scene_to_spawn: PackedScene = null
		
		match atlas_coords:
			small_asteroid_atlas: scene_to_spawn = small_asteroid_scene
			medium_asteroid_atlas: scene_to_spawn = medium_asteroid_scene
			large_asteroid_atlas: scene_to_spawn = large_asteroid_scene
			black_hole_atlas: scene_to_spawn = black_hole_scene
			planet_atlas: scene_to_spawn = planet_scene

		if scene_to_spawn:
			var new_instance: RigidBody2D = scene_to_spawn.instantiate()

			new_instance.global_position = map_to_local(cell)
			#new_instance.scale *= randi_range(1, 5)
			#new_instance.rotation = randf() * TAU
			#new_instance.linear_velocity = Vector2(randf_range(-50, 50), randf_range(-50, 50))
			#new_instance.angular_velocity = randf_range(-1.0, 1.0)
			
			add_child(new_instance)

			# remove the tile
			set_cell(cell, -1)
