extends AudioStreamPlayer

func _ready() -> void:
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)

func _on_resource_count_finished():
	var original_volume = volume_db
	volume_db = -50
	play()
	var tween = create_tween()
	tween.tween_property(self, "volume_db", original_volume, 2)
