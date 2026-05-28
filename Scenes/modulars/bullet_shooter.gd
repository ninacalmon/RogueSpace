extends Node2D
class_name BulletShooter

@export var base_cooldown: float = 0.2

var cooldown: float = 0
var aim_direction: Vector2 = Vector2.RIGHT

@onready var bullet_sfx: AudioStreamPlayer = $BulletSFX
@onready var arrow_pivot: Node2D = $ArrowPivot

@onready var bullet_scene: PackedScene = load(StatsManager.player_current_bullet)

func _process(delta: float) -> void:
	if Globals.is_cutscene:
		return

	cooldown -= delta
	if cooldown < 0:
		cooldown = 0

	handle_aim()
	handle_aim_mouse()
	handle_shoot()


func handle_aim():
	if !Input.get_connected_joypads():
		return

	var input_dir: Vector2 = Vector2(
		Input.get_action_strength("r_stk_right") - Input.get_action_strength("r_stk_left"),
		Input.get_action_strength("r_stk_down") - Input.get_action_strength("r_stk_up")
	)

	if input_dir.length() > 0.2:
		aim_direction = input_dir.normalized()

		arrow_pivot.rotation = aim_direction.angle()

func handle_aim_mouse():
	if Input.get_connected_joypads():
		return

	var cursor_dir: Vector2 = global_position.direction_to(get_global_mouse_position())
	
	if cursor_dir.length() > 0.2:
		aim_direction = cursor_dir.normalized()

		arrow_pivot.rotation = aim_direction.angle()


func handle_shoot():
	if Input.is_action_just_pressed("shoulderR") or Input.is_action_pressed("left_click"):
		shoot(aim_direction)


func get_input_mouse() -> Vector2:
	if Input.is_action_pressed("left_click"):
		print("clcik")
		#var aim_direction = global_position.direction_to(get_global_mouse_position())
	return global_position.direction_to(get_global_mouse_position())

func shoot(direction: Vector2):
	if cooldown > 0:
		return

	cooldown = base_cooldown

	var new_bullet: Bullet = bullet_scene.instantiate()
	add_sibling(new_bullet)

	new_bullet.global_position = global_position
	new_bullet.direction = direction
	new_bullet.rotation = direction.angle()

	SFXManager.play_sound(bullet_sfx)
	
#extends Node2D
#class_name BulletShooter
#
#@export var bullet_scene: PackedScene
#@export var base_cooldown: float = 0.4
##@export var player: Player
#var cooldown: float
#
#
#var last_aim_direction: Vector2 = Vector2.ZERO
#@onready var bullet_sfx: AudioStreamPlayer = $BulletSFX
#@onready var arrow_pivot: Node2D = $ArrowPivot
#
#
##func _process(_delta: float) -> void:
	##if Globals.is_cutscene:
		##return
##
	##get_input_controller()
	##get_input_mouse()
#
#
#func get_input_controller():
	#var current_input: Vector2 = Input.get_vector(
		#"r_stk_left", "r_stk_right", 
		#"r_stk_up", "r_stk_down"
	#)
#
	#if current_input.length() > 0.1: 
		#last_aim_direction = current_input.normalized()
#
	#else:
		#if last_aim_direction != Vector2.ZERO:
			#shoot(last_aim_direction)
			#last_aim_direction = Vector2.ZERO
#
##func get_input_mouse() -> Vector2:
	##if Input.is_action_pressed("left_click"):
		##print("clcik")
		###var aim_direction = global_position.direction_to(get_global_mouse_position())
	##return global_position.direction_to(get_global_mouse_position())
##
##
##func shoot(direction: Vector2):
	##var new_bullet: Bullet = bullet_scene.instantiate()
	##add_sibling(new_bullet)
	##new_bullet.global_position = global_position
	##new_bullet.direction = direction
	##new_bullet.rotation = direction.angle()
#
#
#func shoot(direction: Vector2):
	#if cooldown <= 0:
		#cooldown = base_cooldown
		#var new_bullet: Bullet = bullet_scene.instantiate()
		##new_bullet.global_position = player.global_position
		#new_bullet.direction = direction
		#add_sibling(new_bullet)
		#SFXManager.play_sound(bullet_sfx)
#
#
#func _process(delta: float) -> void:
	#if Globals.is_cutscene:
		#return
#
	#cooldown -= delta
	#if cooldown <= 0:
		#cooldown = 0
#
	#var input_dir: Vector2 = Vector2.ZERO
	#if Input.get_connected_joypads():
		#input_dir = Vector2(
			#Input.get_action_strength("r_stk_right") - Input.get_action_strength("r_stk_left"),
			#Input.get_action_strength("r_stk_down") - Input.get_action_strength("r_stk_up")
		#).normalized()
	#elif Input.is_action_pressed("left_click"):
		#input_dir = global_position.direction_to(get_global_mouse_position())
#
	#if input_dir == Vector2.ZERO:
		#return
#
	#shoot(input_dir)
