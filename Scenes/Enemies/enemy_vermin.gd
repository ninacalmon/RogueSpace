extends Enemy
class_name EnemyVermin

enum State { IDLE, CHASE, FLEE }

@export var stun_time: float = 6

@export var flee_speed_multiplier: float = 1.0
@export var safe_distance: float = 180
@export var fleeing_time: Vector2 = Vector2(1, 1.5)

var state: State = State.IDLE

var can_attack: bool = true
var chase_timer: float = 0.0


func _ready():
	hurt_box.damage_taken.connect(_on_damage_taken)
	aggro_area.body_entered.connect(_on_aggro_entered)

func _process(delta):
	if not is_instance_valid(player):
		return

	# Timer that controls when we can go back to chasing
	if state == State.FLEE and chase_timer > 0:
		chase_timer -= delta

	# Transition: FLEE -> CHASE
	if state == State.FLEE:
		var dist = global_position.distance_to(player.global_position)

		## If enemy still isnt on a safe distance from player when
		## flee timer reaches zero, reset timer and keep fleeing
		if dist <= safe_distance:
			start_flee_timer()

		if dist >= safe_distance and chase_timer <= 0:
			state = State.CHASE
			can_attack = true


func _integrate_forces(_state: PhysicsDirectBodyState2D):
	match state:
		State.IDLE:
			pass

		State.CHASE:
			var dir_to_player = global_position.direction_to(player.global_position)
			apply_movement(_state, dir_to_player, speed)

			var dist = global_position.distance_to(player.global_position)

			if dist <= attack_distance and can_attack:
				perform_attack()
				state = State.FLEE
				start_flee_timer()

		State.FLEE:
			var dir = player.global_position.direction_to(global_position)
			apply_movement(_state, dir, speed * flee_speed_multiplier)

			# If player gets close again → reset timer (keep fleeing)
			var dist = global_position.distance_to(player.global_position)
			if dist < safe_distance:
				start_flee_timer()

	# Clamp velocity
	if _state.linear_velocity.length() > max_velocity:
		_state.linear_velocity = _state.linear_velocity.normalized() * max_velocity

	# Snake rotation
	if _state.linear_velocity.length() > 5:
		rotation = _state.linear_velocity.angle()


# -----------------------
# Core behavior
# -----------------------

func perform_attack():
	print("PERFORMED ATTACK!")
	can_attack = false

	# Apply stun
	if player.has_method("apply_stun"):
		player.apply_stun(stun_time)

	# Optional small damage
	if player.has_method("take_damage"):
		player.take_damage(1, self)


func start_flee_timer():
	chase_timer = randf_range(fleeing_time.x, fleeing_time.y)

# -----------------------
# Movement
# -----------------------

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

	var max_turn = 0.05
	angle = clamp(angle, -max_turn, max_turn)

	_state.linear_velocity = vel.rotated(angle)


# -----------------------
# Signals
# -----------------------

func _on_aggro_entered(body):
	print("aggro entered")
	if body is Player and state == State.IDLE:
		state = State.FLEE
		print("fleeeeeeeing ", body, " AND CHASE TIMER -----------------------------------------------------------------------------------------------------------------", chase_timer)
		player = body
		start_flee_timer()
		sleeping = false

func _on_damage_taken(amount: float, _causer: Node2D):
	life -= amount
	flash()

	if life <= 0:
		queue_free()


func flash():
	sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)

#extends Enemy
#
## Unique states for this specific enemy behavior
#enum RamState { INIT_FLEE, STALK, CHARGE, STUN_PLAYER, COOLDOWN_FLEE }
#
#var current_ram_state: RamState = RamState.INIT_FLEE
#var action_timer: float = 0.0
#
#@export var safe_distance: float = 400.0   # Distance it tries to maintain while fleeing/stalking
#@export var charge_speed: float = 1000.0   # High speed for the fast dash
#@export var charge_distance: float = 100.0 # How close it needs to be to trigger the charge
#@export var stun_duration: float = 1.5     # How long the player is stunned
#
#func _ready() -> void:
	#hurt_box.damage_taken.connect(_on_damage_taken)
#
	#aggro_area.body_entered.connect(_on_aggro_entered)
	#aggro_area.body_exited.connect(_on_aggro_exited)
#
	##randomize_wander()
	#
	## Scans the area immediately upon spawning to see if a Player is already sitting inside
	#for body in aggro_area.get_overlapping_bodies():
		#if body is Player:
			#player = body
			#start_init_flee()
			#break
			#
	## If spawned empty, default to stalking posture until a player walks in
	#if not is_instance_valid(player):
		#current_ram_state = RamState.STALK
#
#func _process(delta: float) -> void:
	#if not is_instance_valid(player):
		#return
#
	## Match your base visual flip logic
	#sprite_2d.flip_h = global_position.x > player.global_position.x
#
	## Track active state clocks
	#if action_timer > 0:
		#action_timer -= delta
		#if action_timer <= 0:
			#_on_timer_timeout()
#
#func _integrate_forces(state_physics: PhysicsDirectBodyState2D) -> void:
	#if not is_instance_valid(player):
		#return
#
	#var to_player = player.global_position - global_position
	#var dir_to_player = to_player.normalized()
	#var dist_to_player = to_player.length()
#
	#match current_ram_state:
		#RamState.INIT_FLEE, RamState.COOLDOWN_FLEE:
			## Push backward away from player position
			#apply_movement(state_physics, -dir_to_player, speed * 1.5)
#
		#RamState.STALK:
			## Zero-g loose positioning: float inward or retro-thrust back to maintain a spacing buffer
			#if dist_to_player > safe_distance:
				#apply_movement(state_physics, dir_to_player, speed)
			#elif dist_to_player < safe_distance - 50:
				#apply_movement(state_physics, -dir_to_player, speed)
			#
			## Engage charge sequence if closing into interception distance
			#if dist_to_player <= charge_distance:
				#current_ram_state = RamState.CHARGE
#
		#RamState.CHARGE:
			## Deliver massive central force vector directly at target
			#apply_movement(state_physics, dir_to_player, charge_speed)
			#
			## Check impact threshold to deploy the stun effect
			#if dist_to_player <= attack_distance:
				#current_ram_state = RamState.STUN_PLAYER
				#action_timer = 0.05 # Tiny physics frame skip to process hit impact cleanly
#
		#RamState.STUN_PLAYER:
			## Break momentum completely on hit impact so it doesn't cleanly drift straight past
			#state_physics.linear_velocity *= 0.1
#
	## Handle independent speed limits for charge versus base tracking
	#var max_vel = max_velocity * (1.8 if current_ram_state == RamState.CHARGE else 1.0)
	#if state_physics.linear_velocity.length() > max_vel:
		#state_physics.linear_velocity = state_physics.linear_velocity.normalized() * max_vel
#
#func apply_movement(state_physics: PhysicsDirectBodyState2D, direction: Vector2, move_speed: float):
	#if direction == Vector2.ZERO:
		#return
#
	#state_physics.apply_central_force(direction * move_speed)
	#steer_enemy_velocity(state_physics, direction)
#
#func steer_enemy_velocity(_state: PhysicsDirectBodyState2D, target_dir: Vector2):
	#var vel = _state.linear_velocity
	#var magnitude = vel.length()
#
	#if magnitude < 50:
		#return
#
	#var target_vel = target_dir * magnitude
	#var angle = vel.angle_to(target_vel)
#
	#var max_turn = 0.02
	#angle = clamp(angle, -max_turn, max_turn)
#
	#_state.linear_velocity = vel.rotated(angle)
#
#func start_init_flee() -> void:
	#current_ram_state = RamState.INIT_FLEE
	#action_timer = randf_range(3.0, 8.0)
#
#func _on_timer_timeout() -> void:
	#match current_ram_state:
		#RamState.INIT_FLEE, RamState.COOLDOWN_FLEE:
			#current_ram_state = RamState.STALK
			#
		#RamState.STUN_PLAYER:
			## Execute stun sequence via method detection or variable toggling
			#if player.has_method("apply_stun"):
				#player.apply_stun(stun_duration)
			#elif "is_stunned" in player:
				#player.is_stunned = true
			#
			#if attack_sfx: 
				#SFXManager.play_sound(attack_sfx)
			#
			## Immediately rebound away into space cooldown loop
			#current_ram_state = RamState.COOLDOWN_FLEE
			#action_timer = randf_range(3.0, 8.0)
#
## Overriding base aggro signals to safely store/clear the explicit Player class
#func _on_aggro_entered(body: Node2D) -> void:
	#if body is Player:
		#player = body
		#if current_ram_state == RamState.STALK:
			#start_init_flee()
#
#func _on_aggro_exited(body: Node2D) -> void:
	#if body == player:
		#player = null
		#current_ram_state = RamState.STALK
#
#func _on_damage_taken(amount: float, _causer: Node2D):
	#life -= amount
	#flash()
	#if life <= 0:
		#queue_free()
#
#func flash():
	#sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	#await get_tree().create_timer(0.1).timeout
	#sprite_2d.modulate = Color(1, 1, 1)

#enum State { CHASE, STUN, ATTACK, RETREAT }
#
#@export var stun_time: float = 0.6
#@export var retreat_speed_multiplier: float = 1.8
#
#var state: State = State.CHASE
#var stun_timer: float = 0
#var retreat_timer: float = 0
#var has_stunned: bool = false
#
#func _ready() -> void:
	#hurt_box.damage_taken.connect(_on_damage_taken)
#
	#aggro_area.body_entered.connect(_on_aggro_entered)
	#aggro_area.body_exited.connect(_on_aggro_exited)
#
#
#func _process(delta: float) -> void:
	#if not is_instance_valid(player):
		#return
#
	#match state:
		#State.STUN:
			#stun_timer -= delta
			#if stun_timer <= 0:
				#state = State.ATTACK
#
		#State.RETREAT:
			#retreat_timer -= delta
			#if retreat_timer <= 0:
				#queue_free() # serpent runs away and disappears
#
#
#func _integrate_forces(state_physics: PhysicsDirectBodyState2D) -> void:
	#if not is_instance_valid(player):
		#return
#
	#var dir_to_player = global_position.direction_to(player.global_position)
#
	#match state:
		#State.CHASE:
			#apply_movement(state_physics, dir_to_player, speed)
#
			#if global_position.distance_to(player.global_position) <= attack_distance:
				#if not has_stunned:
					#apply_stun()
					#state = State.STUN
				#else:
					#state = State.ATTACK
#
		#State.STUN:
			#player.hurt_box_player.stun(3)
			## slight slow movement while "locking" the player
			#apply_movement(state_physics, dir_to_player, speed * 0.4)
#
		#State.ATTACK:
			#var dir = global_position.direction_to(player.global_position)
			#state_physics.apply_central_impulse(dir * attack_force)
			#if randi_range(1, 5) == 1: SFXManager.play_sound(attack_sfx)
#
			#state = State.RETREAT
			#retreat_timer = retreat_time
#
		#State.RETREAT:
			#var dir = player.global_position.direction_to(global_position)
			#apply_movement(state_physics, dir, speed * retreat_speed_multiplier)
#
	## Clamp velocity
	#if state_physics.linear_velocity.length() > max_velocity:
		#state_physics.linear_velocity = state_physics.linear_velocity.normalized() * max_velocity
#
	## 🐍 Rotate sprite to match movement direction
	#if state_physics.linear_velocity.length() > 5:
		#rotation = state_physics.linear_velocity.angle()
#
#
#func apply_movement(state_physics: PhysicsDirectBodyState2D, direction: Vector2, move_speed: float):
	#if direction == Vector2.ZERO:
		#return
#
	#state_physics.apply_central_force(direction * move_speed)
	#steer_enemy_velocity(state_physics, direction)
#
#
#func steer_enemy_velocity(_state: PhysicsDirectBodyState2D, target_dir: Vector2):
	#var vel = _state.linear_velocity
	#var magnitude = vel.length()
#
	#if magnitude < 30:
		#return
#
	#var target_vel = target_dir * magnitude
	#var angle = vel.angle_to(target_vel)
#
	#var max_turn = 0.05 # sharper turning → snake feel
	#angle = clamp(angle, -max_turn, max_turn)
#
	#_state.linear_velocity = vel.rotated(angle)
#
#
#func apply_stun():
	#has_stunned = true
	#stun_timer = stun_time
#
	## 👇 You need to implement this on Player
	#if player.has_method("apply_stun"):
		#player.apply_stun(stun_time)
#
#
#func _on_aggro_entered(body):
	#if body == player:
		#state = State.CHASE
#
#
#func _on_aggro_exited(body):
	#if body == player:
		#state = State.RETREAT
		#retreat_timer = retreat_time
#
#
#func _on_damage_taken(amount: float, _causer: Node2D):
	#life -= amount
	#flash()
#
	#if life <= 0:
		#queue_free()
#
#
#func flash():
	#sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	#await get_tree().create_timer(0.1).timeout
	#sprite_2d.modulate = Color(1, 1, 1)
