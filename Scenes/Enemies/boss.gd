extends RigidBody2D
class_name Boss

enum State { IDLE, ATTACKING, DEAD }


var player: Player

@export var life: float = 100

@export var bullet_count: int = 16

@export var attack_wait_time: float = 3
@export var special_attack_wait_time_min: float = 6
@export var special_attack_wait_time_max: float = 9

@export var default_projectile_scene: PackedScene
@export var targeted_projectile_scene: PackedScene

@export var deactivate: bool = true

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var default_attack_timer: Timer = $default_attack_timer
@onready var special_attack_timer: Timer = $special_attack_timer


@onready var mat: ShaderMaterial = sprite_2d.material

@onready var hurt_box: HurtBox = $HurtBox
@onready var hook: Hook = $Hook
@onready var aggro_area: Area2D = $AggroArea

@onready var collision_polygon_2d: CollisionShape2D = $CollisionPolygon2D

var is_dead: bool = false

var current_state: State = State.IDLE


func _ready() -> void:
	default_attack_timer.timeout.connect(_on_default_attack_timeout)
	special_attack_timer.timeout.connect(_on_special_attack_timemout)
	
	hurt_box.damage_taken.connect(_on_damage_taken)

	aggro_area.body_entered.connect(_on_aggro_area_entered)

	default_attack_timer.start()
	special_attack_timer.start()

	var tween = create_tween()
	tween.set_loops()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(sprite_2d, "offset:y", -10, 1.5)
	tween.tween_property(sprite_2d, "offset:y", 0, 1.5)

#func _process(_delta: float) -> void:
	#if is_dead or deactivate:
		#return
	#
	#match current_state:
		#State.IDLE:
			#var tween = create_tween()
			#tween.set_ease(Tween.EASE_IN_OUT)
			#tween.set_trans(Tween.TRANS_SINE)
			#tween.tween_property(sprite_2d, "offset:y", -10, 1.5)
			#tween.tween_property(sprite_2d, "offset:y", 0, 1.5)


func _on_default_attack_timeout():
	if is_dead or deactivate:
		return

	match current_state:
		State.IDLE:
			pass

		State.ATTACKING:
			pass
			default_attack()

	default_attack_timer.start()

func _on_special_attack_timemout():
	if is_dead or deactivate:
		return

	match current_state:
		State.IDLE:
			pass

		State.ATTACKING:
			pass
			special_attack()

	var duration = randf_range(special_attack_wait_time_min, special_attack_wait_time_max)
	special_attack_timer.wait_time = duration
	special_attack_timer.start()

func default_attack():
	for i in bullet_count:
		var angle: float = TAU * float(i) / float(bullet_count)

		var direction: Vector2 = Vector2.RIGHT.rotated(angle)

		var bullet = default_projectile_scene.instantiate()
		add_sibling(bullet)

		bullet.global_position = global_position
		bullet.direction = direction
		bullet.rotation = direction.angle()

		await get_tree().create_timer(0.1).timeout

func special_attack():
	var direction: Vector2 = Vector2.ONE * Vector2([-1, 1].pick_random(), 0)

	var bullet = targeted_projectile_scene.instantiate()
	add_sibling(bullet)

	bullet.global_position = global_position
	bullet.direction = direction
	bullet.rotation = direction.angle()
	bullet.target = player


func activate():
	deactivate = false


func _on_aggro_area_entered(body: PhysicsBody2D):
	if !(body is Player) or deactivate or is_dead:
		return
	player = body
	current_state = State.ATTACKING

#func _on_attack_timeout():
	#if is_dead or deactivate:
		#return
#
	#print("attack timourt")
#
	#if player == null:
		#print("NO PLAYER FOUND")
		#return
#
	#var to_player: Vector2 = player.global_position - global_position
	#var distance: float = to_player.length()
#
	#var time_to_hit: float = distance / projectile_speed
#
	#var predicted_position: Vector2 = player.global_position + player.linear_velocity * time_to_hit
#
	#var random_offset = Vector2(
	#randf_range(-shoot_inaccuracy, shoot_inaccuracy),
	#randf_range(-shoot_inaccuracy, shoot_inaccuracy)
	#)
#
	#predicted_position += random_offset
#
	#var shoot_dir: Vector2 = global_position.direction_to(predicted_position)
#
	#shoot(shoot_dir)
	#restart_timer()
#
#func shoot(direction: Vector2):
	#if is_dead or deactivate:
		#return
#
	#var new_bullet: Bullet = projectile_scene.instantiate()
	#add_sibling(new_bullet)
#
	#setup_projectile(new_bullet)
	#new_bullet.global_position = global_position
	#new_bullet.direction = direction
	#new_bullet.rotation = direction.angle()
#
#func restart_timer():
	#if is_dead or deactivate:
		#return
#
	#attack_timer.wait_time = randf_range(attack_wait_time_min, attack_wait_time_max)
	#attack_timer.start()

func _on_damage_taken(amount: float, _causer: Node2D):
	if is_dead or deactivate:
		return

	life -= amount
	flash()
	if life <= 0:
		current_state = State.DEAD
		call_deferred("die")

func flash():
	if !mat:
		return
	mat.set_shader_parameter("tint_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("tint_strength", 0)


func die():
	print("disabled:", collision_polygon_2d.disabled)
	print("layer:", collision_layer)
	print("mask:", collision_mask)
	print("diede")
	is_dead = true
	sprite_2d.modulate = Color(0.3, 0.3, 0.4)

	sleeping = false
	freeze = false
	set_deferred("sleeping", false)

	mass = 1
	lock_rotation = false
	hook.initialize(player)

#func cutscene():
	#var y_offset: int = -10
	#var duration: float = 1.5
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	#tween.tween_property(sprite_2d, "offset:y", 0, duration)
	#tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	#tween.tween_property(sprite_2d, "offset:y", 0, duration)
	#tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	#tween.tween_property(sprite_2d, "offset:y", 0, duration)
