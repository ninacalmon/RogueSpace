extends Node2D
class_name BulletShooter

@export var bullet_scene: PackedScene
@export var base_cooldown: float = 0.4
#@export var player: Player
var cooldown: float


var last_aim_direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if Globals.is_cutscene:
		return

	get_input_controller()
	get_input_mouse()


func get_input_controller():
	var current_input: Vector2 = Input.get_vector(
		"r_stk_left", "r_stk_right", 
		"r_stk_up", "r_stk_down"
	)

	if current_input.length() > 0.1: 
		last_aim_direction = current_input.normalized()

	else:
		if last_aim_direction != Vector2.ZERO:
			shoot(last_aim_direction)
			last_aim_direction = Vector2.ZERO

func get_input_mouse():
	if Input.is_action_just_released("left_click"):
		var aim_direction = global_position.direction_to(get_global_mouse_position())
		shoot(aim_direction)


func shoot(direction: Vector2):
	var new_bullet: Bullet = bullet_scene.instantiate()
	add_sibling(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.direction = direction
	new_bullet.rotation = direction.angle()


#func shoot(direction: Vector2):
	#if cooldown <= 0:
		#cooldown = base_cooldown
		#var new_bullet: Bullet = bullet_scene.instantiate()
		##new_bullet.global_position = player.global_position
		#new_bullet.direction = direction
		#player.add_child(new_bullet)
#
#
#func _process(delta: float) -> void:
	#cooldown -= delta
	#if cooldown <= 0:
		#cooldown = 0
#
	#var input_dir: Vector2 = Vector2(
		#Input.get_action_strength("r_stk_right") - Input.get_action_strength("r_stk_left"),
		#Input.get_action_strength("r_stk_down") - Input.get_action_strength("r_stk_up")
	#).normalized()
#
	#if input_dir == Vector2.ZERO:
		#return
#
	#shoot(input_dir)
