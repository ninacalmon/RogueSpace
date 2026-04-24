extends ProgressBar

@export var max_fuel: float = 100
@export var use_step: float = 0.02

var emitted: bool = false

func _ready() -> void:
	EventBus.fuel_used.connect(_on_fuel_used)
	max_value = max_fuel
	value = max_fuel

func _on_fuel_used():
	value -= use_step
	if value <= max_fuel/5 and !emitted:
		emitted = true
		EventBus.almost_out_of_fuel.emit()
	if value == 0 and get_tree():
		EventBus.out_of_fuel.emit()
		get_tree().reload_current_scene()
