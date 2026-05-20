extends CanvasModulate

@export var lights_on_color: Color

func _ready() -> void:
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)

func _on_resource_count_finished():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "color", lights_on_color, 0.3)
