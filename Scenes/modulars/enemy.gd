extends BodySetup
class_name Enemy

@export var speed: float = 100
@export var max_velocity: float = 400.0
@export var life: float = 3
@export var damage: float = 3
@export var player: Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_box: Area2D = $HurtBox

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

	hurt_box.damage_taken.connect(_on_damage_taken)
	

func _process(_delta: float) -> void:
	sprite_2d.flip_v = global_position > player.global_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not is_instance_valid(player):
		return
		
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	if direction == Vector2.ZERO:
		return
		
	state.apply_central_force(direction * speed)
	steer_enemy_velocity(state, direction)

	if state.linear_velocity.length() > max_velocity:
		state.linear_velocity = state.linear_velocity.normalized() * max_velocity


func steer_enemy_velocity(state: PhysicsDirectBodyState2D, target_dir: Vector2):
	var vel = state.linear_velocity
	var magnitude = vel.length()

	if magnitude < 50:
		return

	var target_vel = target_dir * magnitude
	var angle = vel.angle_to(target_vel)
	
	var max_turn = 0.02 
	angle = clamp(angle, -max_turn, max_turn)

	state.linear_velocity = vel.rotated(angle)


func _on_damage_taken(amount: float, _causer: Node2D):
	life -= amount
	flash()
	if life <= 0:
		queue_free()

func flash():
	sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)
