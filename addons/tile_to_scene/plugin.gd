@tool ### AI vvvvvvvvvvvvvvvvvv
extends EditorPlugin

var last_cells: Dictionary = {}
var last_tilemap = null

var cell_instances: Dictionary = {}

var deactivate: bool = false

func _enter_tree():
	set_process(true)

func _process(_delta):
	if deactivate:
		return

	var selection = get_editor_interface().get_selection()
	var nodes = selection.get_selected_nodes()

	if nodes.is_empty():
		return

	var node = nodes[0]

	if !(node is TileMapLayer):
		return

	if node != last_tilemap:
		last_cells.clear()
		last_tilemap = node

	_process_tilemap(node)


func _process_tilemap(tilemap: TileMapLayer):
	if deactivate:
		return

	var current_cells = tilemap.get_used_cells()
	var current_set := {}

	# Mark current cells
	for cell in current_cells:
		current_set[cell] = true

		# Spawn if new
		if !cell_instances.has(cell):
			var instance = _spawn_from_cell(tilemap, cell)
			if instance:
				cell_instances[cell] = instance

	# Detect removed cells
	for cell in cell_instances.keys():
		if !current_set.has(cell):
			var instance = cell_instances[cell]
			if is_instance_valid(instance):
				instance.queue_free()
			cell_instances.erase(cell)


func _spawn_from_cell(tilemap: TileMapLayer, cell: Vector2i):
	if deactivate:
		return

	var atlas = tilemap.get_cell_atlas_coords(cell)
	var scene: PackedScene = _get_scene_from_atlas(atlas)

	if scene == null:
		return null

	var instance = scene.instantiate()
	instance.position = tilemap.map_to_local(cell)

	tilemap.add_child(instance)
	instance.owner = get_editor_interface().get_edited_scene_root()


	return instance

func _get_scene_from_atlas(atlas: Vector2i) -> PackedScene:
	if deactivate:
		return

	match atlas:
		Vector2i(0, 0):
			return preload("res://Scenes/asteroid_pieces.tscn")
		Vector2i(1, 0):
			return preload("res://Scenes/SpaceBodies/asteroid_medium.tscn")
		Vector2i(2, 0):
			return preload("res://Scenes/SpaceBodies/asteroid_bigger.tscn")
		Vector2i(3, 0):
			return preload("res://Scenes/black_hole.tscn")
		Vector2i(4, 0):
			return preload("res://Scenes/supermassive_black_hole.tscn")
		Vector2i(5, 0):
			return preload("res://Scenes/planet.tscn")
	
	return null

func _ready() -> void:
	deactivate = true
