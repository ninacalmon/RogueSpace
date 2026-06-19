extends Node

##Gets changed by power ups:
#var player_burst_speed: float = 1000
#var max_fuel: float = 100
var can_teleport: bool = false

#var player_linear_velocity: Vector2
var is_cutscene: bool

var changing_scene: bool = false

var fake_mouse_input: bool

var is_showing_confirmation: bool

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
	LevelTransition.change_scene_to("res://Scenes/Levels/game_over.tscn")
	StatsManager.current_resources = 0

func update_resources_goal():
	match StatsManager.day:
		0: StatsManager.resources_needed = 0
		1: StatsManager.resources_needed = 100
		2: StatsManager.resources_needed = 200
		3: StatsManager.resources_needed = 0
