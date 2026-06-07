extends Area2D

@onready var sun_burn: AudioStreamPlayer = $SunBurn

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: PhysicsBody2D):
	if body is Player:
		sun_burn.play()
		EventBus.player_death.emit(false)
	else: body.call_deferred("queue_free")
