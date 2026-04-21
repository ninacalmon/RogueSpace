extends Node

var player_linear_velocity: Vector2

var is_cutscene: bool

func _ready() -> void:
	EventBus.cutscene_on.connect(func():
		is_cutscene = true
)

	EventBus.cutscene_off.connect(func():
		is_cutscene = false
)
