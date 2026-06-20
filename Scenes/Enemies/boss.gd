extends RigidBody2D
class_name Boss

var player: Player

@export var life: float = 100

@export var attack_wait_time_min: float = 1
@export var attack_wait_time_max: float = 3

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 800
@export var projectile_damage: float = 5
@export var projectile_lifespan: float = 8.0

@export var shoot_inaccuracy: float = 80

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $attack_timer
@onready var mat: ShaderMaterial = sprite_2d.material

@onready var hurt_box: HurtBox = $HurtBox
@onready var hook: Hook = $Hook
@onready var aggro_area: Area2D = $AggroArea

@export var deactivate: bool = true

@onready var collision_polygon_2d: CollisionShape2D = $CollisionPolygon2D

signal cutscene_finished

var is_dead: bool = false


func _ready() -> void:
	attack_timer.timeout.connect(_on_attack_timeout)
	hurt_box.damage_taken.connect(_on_damage_taken)

	aggro_area.body_entered.connect(_on_aggro_area_entered)

	cutscene_finished.connect(activate)

	restart_timer()

func activate():
	deactivate = false
	collision_polygon_2d.disabled = false
	attack_timer.start()

func _on_aggro_area_entered(body: PhysicsBody2D):
	if !(body is Player) or deactivate or is_dead:
		return
	player = body

func _on_attack_timeout():
	if is_dead or deactivate:
		return

	print("attack timourt")

	if player == null:
		print("NO PLAYER FOUND")
		return

	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()

	var time_to_hit: float = distance / projectile_speed

	var predicted_position: Vector2 = player.global_position + player.linear_velocity * time_to_hit

	var random_offset = Vector2(
	randf_range(-shoot_inaccuracy, shoot_inaccuracy),
	randf_range(-shoot_inaccuracy, shoot_inaccuracy)
	)

	predicted_position += random_offset

	var shoot_dir: Vector2 = global_position.direction_to(predicted_position)

	shoot(shoot_dir)
	restart_timer()

func shoot(direction: Vector2):
	if is_dead or deactivate:
		return

	var new_bullet: Bullet = projectile_scene.instantiate()
	add_sibling(new_bullet)

	setup_projectile(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.direction = direction
	new_bullet.rotation = direction.angle()

func restart_timer():
	if is_dead or deactivate:
		return

	attack_timer.wait_time = randf_range(attack_wait_time_min, attack_wait_time_max)
	attack_timer.start()

func _on_damage_taken(amount: float, _causer: Node2D):
	if is_dead or deactivate:
		return

	life -= amount
	flash()
	if life <= 0:
		call_deferred("die")

func flash():
	if !mat:
		return
	mat.set_shader_parameter("tint_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("tint_strength", 0)

func setup_projectile(projectile: Bullet):
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	projectile.lifespan = projectile_lifespan

func _physics_process(_delta):
	if is_dead:
		print(collision_polygon_2d.disabled)

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

func cutscene():
	var y_offset: int = -10
	var duration: float = 1.5
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	tween.tween_property(sprite_2d, "offset:y", 0, duration)
	tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	tween.tween_property(sprite_2d, "offset:y", 0, duration)
	tween.tween_property(sprite_2d, "offset:y", y_offset, duration)
	tween.tween_property(sprite_2d, "offset:y", 0, duration)
