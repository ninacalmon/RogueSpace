extends ProgressBar

@export var max_hp: float = 100

var emitted: bool = false

func _ready() -> void:
	EventBus.damage_taken.connect(_on_damage_taken)
	max_value = max_hp
	value = max_hp

func _on_damage_taken(damaged: RigidBody2D, amount: float):
	pass
	if damaged is Player:
		value -= amount
		if value <= 0: get_tree().reload_current_scene()
