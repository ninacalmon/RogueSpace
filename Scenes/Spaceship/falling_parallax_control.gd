extends Node2D


@onready var falling_animation: AnimationPlayer = $FallingAnimation

func _ready() -> void:
	SpaceshipEventBus.resource_count_started.connect(start_animation)

func start_animation(duration):
	show()
	print("coco")
	if duration < 6:
		print("medium")
		falling_animation.play("Medium")
	else:
		falling_animation.play("Maximum")
		print("maxi")
