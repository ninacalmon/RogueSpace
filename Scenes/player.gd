extends BodySetup
class_name Player

@export var speed: float = 700
@export var burst_speed: float = 3000
@export var break_speed: float = 2
@export var max_velocity: float = 1000.0

@export var camera: Camera2D
@onready var propulsor_sfx: AudioStreamPlayer = $SFX/PropulsorSFX
@onready var teleport_sfx: AudioStreamPlayer = $SFX/TeleportSFX
@onready var space_winds_sfx: AudioStreamPlayer = $SFX/SpaceWindsSFX
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var damage_module: DamageModule
@export var base_burst_cooldown: float = 3.0
var burst_cooldown_timer: float

@export var base_destroy_tolerance_timer: float = 0.5
var destroy_tolerance_timer: float


var player_init_pos: Vector2
var original_speed: float = speed

var start_of_game: bool = true

var can_destroy: bool

@export var enemi: PackedScene

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

	burst_speed = Globals.player_burst_speed
	player_init_pos = global_position + Vector2(0.0, -50)
	EventBus.player_almost_out_of_bounds.connect(_on_player_almost_out_of_bounds)
	EventBus.player_out_of_bounds.connect(_on_player_out_of_bounds)
	EventBus.cutscene_off.connect(start_game)
	damage_module.damage_taken.connect(_on_damage_taken)
	damage_module.enemy_damage_taken.connect(_on_enemy_damage_taken)

func start_game():
	if start_of_game:
		self.apply_force(Vector2(0.0, -speed * 30))
		propulsor_sfx.volume_db = -22
		SFXManager.play_sound(propulsor_sfx)
		propulsor_sfx.volume_db = -45
		start_of_game = false

func _process(delta: float) -> void:
	burst_cooldown_timer -= delta
	destroy_tolerance_timer -= delta
	if burst_cooldown_timer <= 0:
		burst_cooldown_timer = 0
	if destroy_tolerance_timer <= 0:
		destroy_tolerance_timer = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Globals.is_cutscene:
		return
	
	## Movement here vvv
	movement(state)
	steer_velocity(state)
	impulse_burst(state)
	break_stop(state)
	
	Globals.player_linear_velocity = state.linear_velocity
	
	if state.linear_velocity.length() > max_velocity:
		state.linear_velocity = state.linear_velocity.normalized() * max_velocity

	able_destroy()

	if Input.is_action_just_pressed("restart"):
		Globals.reload_current_scene()
	
	if Input.is_action_just_pressed("teleport") and Globals.can_teleport:
		execute_teletransport()

func _on_player_almost_out_of_bounds():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "linear_velocity", linear_velocity / 3, 1)

func _on_player_out_of_bounds():
	execute_teletransport()

func execute_teletransport():
	SFXManager.play_sound(teleport_sfx)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", camera.zoom + Vector2.ONE * 0.3, 0.2)
	tween.tween_property(self, "modulate", Color(18.892, 18.892, 18.892), 0.1)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	await tween.finished
	linear_velocity = Vector2.ZERO
	global_position = player_init_pos

func movement(state):
	var input_dir: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if input_dir == Vector2.ZERO:
		return
	
	state.apply_central_force(input_dir * speed)
	EventBus.fuel_used.emit()
	SFXManager.play_sound(propulsor_sfx)

func impulse_burst(state):
	if Input.is_action_just_pressed("impulse_burst")\
		and burst_cooldown_timer <= 0:
			burst_cooldown_timer = base_burst_cooldown
			EventBus.burst_fuel_used.emit()
			state.apply_impulse(linear_velocity.normalized() * burst_speed)



func break_stop(state):
	if Input.is_action_pressed("break_stop"):
		state.linear_velocity = state.linear_velocity.move_toward(Vector2.ZERO, break_speed)

func steer_velocity(state: PhysicsDirectBodyState2D):
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	if input_dir == Vector2.ZERO:
		return

	var vel = state.linear_velocity
	var magnitude = vel.length()

	if magnitude < 50:
		return

	var target_vel = input_dir * magnitude
	var angle = vel.angle_to(target_vel)

	var max_turn = 0.01
	angle = clamp(angle, -max_turn, max_turn)

	state.linear_velocity = vel.rotated(angle)

func able_destroy():
	if Input.is_action_just_pressed("destroy"):
		
		destroy_tolerance_timer = base_destroy_tolerance_timer
	can_destroy = !(destroy_tolerance_timer <= 0)
	if can_destroy:
		modulate = Color(0, 0, 1)
	else:
		modulate = Color(1, 1, 1)

func _on_damage_taken(amount: float, _causer: RigidBody2D):
	if can_destroy:
		return
	else:
		var damage = amount / 20
		EventBus.damage_taken.emit(self, damage)

func _on_enemy_damage_taken(amount: float):
	flash()
	EventBus.damage_taken.emit(self, amount)

func flash():
	sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	sprite_2d.modulate = Color(1, 1, 1)
