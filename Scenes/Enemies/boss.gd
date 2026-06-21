extends RigidBody2D
class_name Boss

enum State { IDLE, ATTACKING, DEAD }


var player: Player

@export var life: float = 100

@export var bullet_count: int = 24

@export var attack_wait_time: float = 4
@export var special_attack_wait_time_min: float = 8
@export var special_attack_wait_time_max: float = 15

@export var projectile_time_offset: float = 0.05
@export var attack_offset_change: float = 0.5

@export var default_projectile_scene: PackedScene
@export var child_scene: PackedScene
@export var targeted_projectile_scene: PackedScene

@export var deactivate: bool = true

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var sprite_2d_dead_head: Sprite2D = $Sprite2D/Sprite2DDeadHead



@onready var default_attack_timer: Timer = $default_attack_timer
@onready var special_attack_timer: Timer = $special_attack_timer


@onready var mat: ShaderMaterial = sprite_2d.material

@onready var hurt_box: HurtBox = $HurtBox
@onready var hook: Hook = $Hook
@onready var aggro_area: Area2D = $AggroArea

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var is_dead: bool = false

var current_state: State = State.IDLE

var is_attacking_now: bool = false

var attack_offset: float = 0.0

var float_tween: Tween

func _ready() -> void:
	sprite_2d_dead_head.hide()
	sprite_2d.play("default")

	default_attack_timer.timeout.connect(_on_default_attack_timeout)
	special_attack_timer.timeout.connect(_on_special_attack_timemout)
	
	hurt_box.damage_taken.connect(_on_damage_taken)

	aggro_area.body_entered.connect(_on_aggro_area_entered)

	default_attack_timer.start()
	special_attack_timer.start()

	var base_y = sprite_2d.position.y

	float_tween = create_tween()
	float_tween.set_loops()

	float_tween.set_ease(Tween.EASE_IN_OUT)
	float_tween.set_trans(Tween.TRANS_SINE)

	float_tween.tween_property(sprite_2d, "position:y", base_y - 10, 1.5)
	float_tween.tween_property(sprite_2d, "position:y", base_y + 10, 1.5)

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
	if is_dead or deactivate or is_attacking_now:
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
			special_attack()

	var duration = randf_range(special_attack_wait_time_min, special_attack_wait_time_max)
	special_attack_timer.wait_time = duration
	special_attack_timer.start()


func default_attack():
	is_attacking_now = true

	for i in bullet_count:
		var angle: float = TAU * float(i) / float(bullet_count) + attack_offset

		var direction: Vector2 = Vector2.RIGHT.rotated(angle)

		var bullet = default_projectile_scene.instantiate()
		add_sibling(bullet)

		bullet.global_position = global_position
		bullet.direction = direction
		bullet.rotation = direction.angle()

		await get_tree().create_timer(projectile_time_offset).timeout

	attack_offset += TAU / float(bullet_count) * attack_offset_change

	attack_offset = fmod(attack_offset, TAU)

	is_attacking_now = false

func birth_attack():
	var new_child: Enemy = child_scene.instantiate()
	add_sibling(new_child)

	new_child.add_collision_exception_with(self)
	new_child.global_position = global_position
	new_child.player = player
	
func special_attack():
	var direction: Vector2 = global_position.direction_to(player.global_position)

	var bullet: BossBullet = targeted_projectile_scene.instantiate()
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
	sprite_2d.material = null

	print("disabled:", collision_polygon_2d.disabled)
	print("layer:", collision_layer)
	print("mask:", collision_mask)
	print("diede")
	is_dead = true
	sprite_2d.play("dead")
	sprite_2d.modulate = Color(0.3, 0.3, 0.4)
	#sprite_2d_dead_head.modulate = sprite_2d.modulate
	sprite_2d_dead_head.show()

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
