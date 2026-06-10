extends RigidBody2D

var player: Player

@export var life: float = 100

@export var attack_wait_time_min: float = 1
@export var attack_wait_time_max: float = 3

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 800
@export var projectile_damage: float = 5
@export var projectile_lifespan: float = 8.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $attack_timer
@onready var mat: ShaderMaterial = sprite_2d.material

@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	print("i was born")
	player = get_tree().get_first_node_in_group("Player_Group")

	attack_timer.timeout.connect(_on_attack_timeout)
	hurt_box.damage_taken.connect(_on_damage_taken)

	restart_timer()

func _on_attack_timeout():
	print("attack timourt")

	if player == null:
		print("NO PLAYER FOUND")
		return

	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()

	var time_to_hit: float = distance / projectile_speed

	var predicted_position: Vector2 = player.global_position + player.linear_velocity * time_to_hit

	var random_offset = Vector2(
	randf_range(-50, 50),
	randf_range(-50, 50)
	)

	predicted_position += random_offset

	var shoot_dir: Vector2 = global_position.direction_to(predicted_position)

	shoot(shoot_dir)
	restart_timer()

func shoot(direction: Vector2):
	var new_bullet: Bullet = projectile_scene.instantiate()
	add_sibling(new_bullet)

	setup_projectile(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.direction = direction
	new_bullet.rotation = direction.angle()

func restart_timer():
	attack_timer.wait_time = randf_range(attack_wait_time_min, attack_wait_time_max)
	attack_timer.start()

func _on_damage_taken(amount: float, _causer: Node2D):
	life -= amount
	flash()
	if life <= 0:
		queue_free()

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
