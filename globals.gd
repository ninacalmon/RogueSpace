extends Node

##Gets changed by power ups:
#var player_burst_speed: float = 1000
#var max_fuel: float = 100
var can_teleport: bool = false

#var player_linear_velocity: Vector2
var is_cutscene: bool

var changing_scene: bool = false

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

func player_died(cause_of_death: String):
	var game_over_scene: GameOverScene = preload("res://Scenes/Levels/game_over.tscn").instantiate()
	game_over_scene.cause_of_death = cause_of_death
	get_tree().paused = true
	get_tree().current_scene.add_child(game_over_scene)
