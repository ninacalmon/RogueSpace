extends PathFollow2D
class_name PathFollowOrbit

var speed: float = 50

func _process(delta: float) -> void:
	progress += delta * speed
