extends CanvasModulate

@onready var main_light: PointLight2D = $MainLight
@export var deactivate: bool

func _ready() -> void:
	if !deactivate: show()
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)

func _on_resource_count_finished():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(main_light, "energy", 1.4, 0.4)
