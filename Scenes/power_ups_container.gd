extends HBoxContainer

@export var texts: TextsControl

@onready var impulse_power_up: TextureButton = $ImpulsePowerUp
@onready var fuel_power_up: TextureButton = $FuelPowerUp
@onready var teleport_power_up: TextureButton = $TeleportPowerUp

var power_up_options_array: Array[TextureButton] 

func _ready() -> void:
	texts.count_finished.connect(_on_count_finished)
	power_up_options_array = [impulse_power_up, fuel_power_up, teleport_power_up]

func _on_count_finished(enough: bool):
	if !enough:
		return
	for p in power_up_options_array:
		p.show()
		p.disabled = false
		await flash(p)

func flash(what: Control):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "modulate", Color(0, 0, 0, 1), 0.04)
	tween.tween_property(what, "modulate", Color(10, 10, 10, 10), 0.1)
	tween.tween_property(what, "modulate", Color(1, 1, 1, 1), 0.4)
	await tween.finished
