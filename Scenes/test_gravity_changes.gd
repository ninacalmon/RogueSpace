extends Node

@export var gravity_module: GravityModule

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_i"):
		change_gravity(Vector2.UP)
	elif event.is_action_pressed("test_j"):
		change_gravity(Vector2.LEFT)
	elif event.is_action_pressed("test_k"):
		change_gravity(Vector2.DOWN)
	elif event.is_action_pressed("test_l"):
		change_gravity(Vector2.RIGHT)
	elif event.is_action_pressed("test_n"):
		change_gravity(Vector2.ZERO)

func change_gravity(direction: Vector2):
	gravity_module.gravity_direction = direction
