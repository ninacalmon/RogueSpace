extends Node

#region Consts
const INIT_CAN_TELEPORT: bool = false
const INIT_IS_CUTSCENE: bool = false
const INIT_CHANGING_SCENE: bool = false
const INIT_FAKE_MOUSE_INPUT: bool = false
const INIT_IS_SHOWING_CONFIRMATION: bool = false
const INIT_NEXT_SCENE_PATH: String = "res://Scenes/Levels/menu.tscn"
const INIT_HAS_ENERGY_IN_SPACESHIP: bool = false
#endregion

##Gets changed by power ups:
#var player_burst_speed: float = 1000
#var max_fuel: float = 100
var can_teleport: bool = false

#var player_linear_velocity: Vector2
var is_cutscene: bool

var changing_scene: bool = false

var fake_mouse_input: bool

var is_showing_confirmation: bool

var next_scene_path: String = "res://Scenes/Levels/menu.tscn"

var last_level_path: String

var has_energy_in_spaceship: bool = false:
	set (value):
		if value == true:
			fragments_value_to_sum = StatsManager.resources_needed
			has_energy_in_spaceship = false
var fragments_value_to_sum: int = 0

func add_frag_sum():
	StatsManager.current_resources += fragments_value_to_sum


#var level: int = 1
#
#var resources_gathered: int = 110
#var resources_needed: int = 100

func _ready() -> void:
	EventBus.cutscene_on.connect(func(): is_cutscene = true)
	EventBus.cutscene_off.connect(func(): is_cutscene = false)
	#EventBus.level_pass.connect(func(): resources_needed *= level)

func reload_current_scene():
	get_tree().reload_current_scene()

func player_died():
	last_level_path = get_tree().current_scene.scene_file_path
	LevelTransition.change_scene_to("res://Scenes/Levels/game_over.tscn")
	StatsManager.current_resources = 0

func update_resources_goal():
	match StatsManager.day:
		0: StatsManager.resources_needed = 50
		1: StatsManager.resources_needed = 100
		2: StatsManager.resources_needed = 200
		3: StatsManager.resources_needed = 0

func reset_game_state() -> void:
	can_teleport = INIT_CAN_TELEPORT
	is_cutscene = INIT_IS_CUTSCENE
	changing_scene = INIT_CHANGING_SCENE
	fake_mouse_input = INIT_FAKE_MOUSE_INPUT
	is_showing_confirmation = INIT_IS_SHOWING_CONFIRMATION
	next_scene_path = INIT_NEXT_SCENE_PATH
	has_energy_in_spaceship = INIT_HAS_ENERGY_IN_SPACESHIP
