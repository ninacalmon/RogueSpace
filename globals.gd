extends Node

##Gets changed by power ups:
var player_burst_speed: float = 1000
var max_fuel: float = 100
var can_teleport: bool = false

var player_linear_velocity: Vector2
var is_cutscene: bool

var changing_scene: bool = false

var level: int = 1

var resources_gathered: int
var resources_needed: int = 100 * level

func _ready() -> void:
	EventBus.cutscene_on.connect(func(): is_cutscene = true)

	EventBus.cutscene_off.connect(func(): is_cutscene = false)
