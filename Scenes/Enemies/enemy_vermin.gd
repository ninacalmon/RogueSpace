extends Enemy

enum State { CHASE, STUN, ATTACK, RETREAT }

@export var stun_time: float = 0.6
@export var retreat_speed_multiplier: float = 1.8

var state: State = State.CHASE
var stun_timer: float = 0
var retreat_timer: float = 0
var has_stunned: bool = false

func _ready() -> void:
	hurt_box.damage_taken.connect(_on_damage_taken)

	aggro_area.body_entered.connect(_on_aggro_entered)
	aggro_area.body_exited.connect(_on_aggro_exited)


func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	match state:
		State.STUN:
			stun_timer -= delta
			if stun_timer <= 0:
				state = State.ATTACK

		State.RETREAT:
			retreat_timer -= delta
			if retreat_timer <= 0:
				queue_free() # serpent runs away and disappears


func _integrate_forces(state_physics: PhysicsDirectBodyState2D) -> void:
	if not is_instance_valid(player):
		return

	var dir_to_player = global_position.direction_to(player.global_position)

	match state:
		State.CHASE:
			apply_movement(state_physics, dir_to_player, speed)

			if global_position.distance_to(player.global_position) <= attack_distance:
				if not has_stunned:
					apply_stun()
					state = State.STUN
				else:
					state = State.ATTACK

		State.STUN:
			player.hurt_box_player.stun(3)
			# slight slow movement while "locking" the player
			apply_movement(state_physics, dir_to_player, speed * 0.4)

		State.ATTACK:
			var dir = global_position.direction_to(player.global_position)
			state_physics.apply_central_impulse(dir * attack_force)
			if randi_range(1, 5) == 1: SFXManager.play_sound(attack_sfx)

			state = State.RETREAT
			retreat_timer = retreat_time

		State.RETREAT:
			var dir = player.global_position.direction_to(global_position)
			apply_movement(state_physics, dir, speed * retreat_speed_multiplier)

	# Clamp velocity
	if state_physics.linear_velocity.length() > max_velocity:
		state_physics.linear_velocity = state_physics.linear_velocity.normalized() * max_velocity

	# 🐍 Rotate sprite to match movement direction
	if state_physics.linear_velocity.length() > 5:
		rotation = state_physics.linear_velocity.angle()


func apply_movement(state_physics: PhysicsDirectBodyState2D, direction: Vector2, move_speed: float):
	if direction == Vector2.ZERO:
		return

	state_physics.apply_central_force(direction * move_speed)
	steer_enemy_velocity(state_physics, direction)


func steer_enemy_velocity(_state: PhysicsDirectBodyState2D, target_dir: Vector2):
	var vel = _state.linear_velocity
	var magnitude = vel.length()

	if magnitude < 30:
		return

	var target_vel = target_dir * magnitude
	var angle = vel.angle_to(target_vel)

	var max_turn = 0.05 # sharper turning → snake feel
	angle = clamp(angle, -max_turn, max_turn)

	_state.linear_velocity = vel.rotated(angle)


func apply_stun():
	has_stunned = true
	stun_timer = stun_time

	# 👇 You need to implement this on Player
	if player.has_method("apply_stun"):
		player.apply_stun(stun_time)


func _on_aggro_entered(body):
	if body == player:
		state = State.CHASE


func _on_aggro_exited(body):
	if body == player:
		state = State.RETREAT
		retreat_timer = retreat_time


func _on_damage_taken(amount: float, _causer: Node2D):
	life -= amount
	flash()

	if life <= 0:
		queue_free()


func flash():
	sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)
