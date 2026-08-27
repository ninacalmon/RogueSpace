extends PathFollow2D
class_name PathFollowOrbit

var speed: float = 50
var reverse: bool

func _process(delta: float) -> void:
	if reverse: progress -= delta * speed
	else: progress += delta * speed
