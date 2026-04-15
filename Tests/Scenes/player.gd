extends RigidBody2D
class_name Player

var speed: float = 1000

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	## Movement here vvv
	if Input.is_action_pressed("move_down"):
		state.apply_central_force(Vector2(0, speed))

	if Input.is_action_pressed("move_left"):
		state.apply_central_force(Vector2(-speed, 0))

	if Input.is_action_pressed("move_up"):
		state.apply_central_force(Vector2(0.0, -speed))

	if Input.is_action_pressed("move_right"):
		state.apply_central_force(Vector2(speed, 0))
