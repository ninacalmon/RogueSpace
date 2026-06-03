extends Enemy
class_name EnemyLarvae

enum State { CHASE, PUFF, EXPLODE }

@export var stun_time: float = 6

# Movement
@export var puff_speed_multiplier: float = 0.2

# Puff timing (MAIN CONTROL)
@export var time_to_explode: float = 3.5
@export var deflate_speed_multiplier: float = 1.5
@export var no_return_ratio: float = 0.75 # % of time where it commits

# Explosion
@export var explosion_radius: float = 100

var state: State = State.CHASE
var puff_timer: float = 0.0
var player_inside_aggro: bool = false

@onready var mat: ShaderMaterial = sprite_2d.material


func _ready():
	hurt_box.damage_taken.connect(_on_damage_taken)
	aggro_area.body_entered.connect(_on_aggro_entered)
	aggro_area.body_exited.connect(_on_aggro_exited)


func _process(delta):
	if not is_instance_valid(player):
		return

	match state:
		State.CHASE:
			handle_deflate(delta)

		State.PUFF:
			handle_puff(delta)

		State.EXPLODE:
			pass


func _integrate_forces(state_physics: PhysicsDirectBodyState2D):
	if not is_instance_valid(player):
		return

	match state:
		State.CHASE:
			var dir = global_position.direction_to(player.global_position)
			apply_movement(state_physics, dir, speed)

		State.PUFF:
			var dir = global_position.direction_to(player.global_position)
			apply_movement(state_physics, dir, speed * puff_speed_multiplier)

			# 🔥 Explosion trigger (time-based)
			if puff_timer >= time_to_explode:
				state_physics.linear_velocity = Vector2.ZERO
				state = State.EXPLODE
				explode()

		State.EXPLODE:
			state_physics.linear_velocity = Vector2.ZERO

	# Velocity clamp
	var vel = state_physics.linear_velocity
	var current_speed = vel.length()

	if current_speed > max_velocity:
		state_physics.linear_velocity = vel.normalized() * max_velocity

	# Rotation
	if state_physics.linear_velocity.length() > 5:
		rotation = state_physics.linear_velocity.angle()


# -----------------------
# Puff logic (TIME-BASED)
# -----------------------

func handle_puff(delta):
	if player_inside_aggro:
		puff_timer += delta
	else:
		# Only allow deflate if not committed
		if puff_timer < time_to_explode * no_return_ratio:
			puff_timer -= delta * deflate_speed_multiplier
			if puff_timer <= 0:
				puff_timer = 0
				state = State.CHASE

	puff_timer = clamp(puff_timer, 0.0, time_to_explode)

	update_shader()


func handle_deflate(delta):
	if puff_timer > 0:
		puff_timer -= delta * deflate_speed_multiplier
		puff_timer = max(puff_timer, 0.0)

	update_shader()


# -----------------------
# Shader
# -----------------------

func update_shader():
	if mat:
		var normalized := puff_timer / time_to_explode # 0 → 1 (FIXED)

		mat.set_shader_parameter("puff_amount", normalized)

		# Juice near explosion
		if normalized > 0.8:
			mat.set_shader_parameter("wobble_strength", 0.12)
		else:
			mat.set_shader_parameter("wobble_strength", 0.05)


# -----------------------
# Explosion (AoE)
# -----------------------

func explode():
	print("BOOM")

	var space_state = get_world_2d().direct_space_state

	var circle := CircleShape2D.new()
	circle.radius = explosion_radius

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = circle
	query.transform = Transform2D(0, global_position)
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var results = space_state.intersect_shape(query)

	for result in results:
		var collider = result.collider

		if collider == self:
			continue

		if collider.has_method("take_damage"):
			collider.take_damage(damage, self)

		if collider.has_method("apply_stun"):
			collider.apply_stun(stun_time)

	queue_free()


# -----------------------
# Movement
# -----------------------

func apply_movement(state_physics: PhysicsDirectBodyState2D, direction: Vector2, move_speed: float):
	if direction == Vector2.ZERO:
		return

	if state_physics.linear_velocity.length() < max_velocity:
		state_physics.apply_central_force(direction * move_speed)

	steer_enemy_velocity(state_physics, direction)


func steer_enemy_velocity(state_physics: PhysicsDirectBodyState2D, target_dir: Vector2):
	var vel = state_physics.linear_velocity
	var magnitude = vel.length()

	if magnitude < 30:
		return

	var target_vel = target_dir * magnitude
	var angle = vel.angle_to(target_vel)

	var max_turn = 0.05
	angle = clamp(angle, -max_turn, max_turn)

	state_physics.linear_velocity = vel.rotated(angle)


# -----------------------
# Signals
# -----------------------

func _on_aggro_entered(body):
	if body is Player:
		player = body
		player_inside_aggro = true
		state = State.PUFF


func _on_aggro_exited(body):
	if body is Player:
		player_inside_aggro = false


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
#class_name EnemyLarvae
#
#enum State { CHASE, PUFF, EXPLODE }
#
#@export var stun_time: float = 6
#
## Movement
#@export var puff_speed_multiplier: float = 0.4
#
## Puff behavior
#@export var inflate_speed: float = 1.3
#@export var deflate_speed: float = 1.6
#@export var max_puff: float = 1.8
#@export var no_return_puff: float = 1.8
#
## Explosion
#@export var explosion_radius: float = 100
#
#var state: State = State.CHASE
#var puff_amount: float = 0.0
#var player_inside_aggro: bool = false
#
#@onready var mat: ShaderMaterial = sprite_2d.material
#
#
#func _ready():
	#hurt_box.damage_taken.connect(_on_damage_taken)
	#aggro_area.body_entered.connect(_on_aggro_entered)
	#aggro_area.body_exited.connect(_on_aggro_exited)
#
#
#func _process(delta):
	#if not is_instance_valid(player):
		#return
#
	#match state:
		#State.CHASE:
			#handle_deflate(delta)
#
		#State.PUFF:
			#handle_puff(delta)
#
		#State.EXPLODE:
			#pass
#
#
#func _integrate_forces(state_physics: PhysicsDirectBodyState2D):
	#if not is_instance_valid(player):
		#return
#
	#match state:
		#State.CHASE:
			#var dir = global_position.direction_to(player.global_position)
			#apply_movement(state_physics, dir, speed)
#
		#State.PUFF:
			#var dir = global_position.direction_to(player.global_position)
			#apply_movement(state_physics, dir, speed * puff_speed_multiplier)
#
			## Reached point of no-return → explode
			#if puff_amount >= no_return_puff:
				#state_physics.linear_velocity = Vector2.ZERO
				#state = State.EXPLODE
				#explode()
#
		#State.EXPLODE:
			#state_physics.linear_velocity = Vector2.ZERO
#
	## ✅ Proper velocity clamp
	#var vel = state_physics.linear_velocity
	#var current_speed = vel.length()
#
	#if current_speed > max_velocity:
		#state_physics.linear_velocity = vel.normalized() * max_velocity
#
	## Rotate to movement
	#if state_physics.linear_velocity.length() > 5:
		#rotation = state_physics.linear_velocity.angle()
#
#
## -----------------------
## Puff logic
## -----------------------
#
#func handle_puff(delta):
	#if player_inside_aggro:
		#puff_amount += inflate_speed * delta
	#else:
		## Deflate if player escaped BEFORE no-return
		#if puff_amount < no_return_puff:
			#puff_amount -= deflate_speed * delta
			#if puff_amount <= 0:
				#puff_amount = 0
				#state = State.CHASE
#
	#puff_amount = clamp(puff_amount, 0.0, max_puff)
#
	#update_shader()
#
#
#func handle_deflate(delta):
	#if puff_amount > 0:
		#puff_amount -= deflate_speed * delta
		#puff_amount = max(puff_amount, 0.0)
#
	#update_shader()
#
#
#func update_shader():
	#if mat:
		#mat.set_shader_parameter("puff_amount", puff_amount)
#
		## Optional juice: stronger wobble near explosion
		#if puff_amount > no_return_puff * 0.8:
			#mat.set_shader_parameter("wobble_strength", 0.12)
		#else:
			#mat.set_shader_parameter("wobble_strength", 0.05)
#
#
## -----------------------
## Explosion
## -----------------------
#
#func explode():
	#print("BOOM")
#
	#var space_state = get_world_2d().direct_space_state
#
	#var circle := CircleShape2D.new()
	#circle.radius = explosion_radius
#
	#var query := PhysicsShapeQueryParameters2D.new()
	#query.shape = circle
	#query.transform = Transform2D(0, global_position)
	#query.collide_with_bodies = true
	##query.collide_with_areas = true
#
	#var results = space_state.intersect_shape(query)
#
	#for result in results:
		#var collider = result.collider
#
		#if collider == self:
			#continue
#
		#if collider.has_method("take_damage"):
			#collider.take_damage(damage, self)
#
		#if collider.has_method("apply_stun"):
			#collider.apply_stun(stun_time)
#
	#queue_free()
#
#
## -----------------------
## Movement
## -----------------------
#
#func apply_movement(state_physics: PhysicsDirectBodyState2D, direction: Vector2, move_speed: float):
	#if direction == Vector2.ZERO:
		#return
#
	## ✅ Only accelerate if under max velocity
	#if state_physics.linear_velocity.length() < max_velocity:
		#state_physics.apply_central_force(direction * move_speed)
#
	#steer_enemy_velocity(state_physics, direction)
#
#
#func steer_enemy_velocity(state_physics: PhysicsDirectBodyState2D, target_dir: Vector2):
	#var vel = state_physics.linear_velocity
	#var magnitude = vel.length()
#
	#if magnitude < 30:
		#return
#
	#var target_vel = target_dir * magnitude
	#var angle = vel.angle_to(target_vel)
#
	#var max_turn = 0.05
	#angle = clamp(angle, -max_turn, max_turn)
#
	#state_physics.linear_velocity = vel.rotated(angle)
#
#
## -----------------------
## Signals
## -----------------------
#
#func _on_aggro_entered(body):
	#if body is Player:
		#player = body
		#player_inside_aggro = true
		#state = State.PUFF
#
#
#func _on_aggro_exited(body):
	#if body is Player:
		#player_inside_aggro = false
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
