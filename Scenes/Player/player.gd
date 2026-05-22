extends BodySetup
class_name Player

var speed: float = StatsManager.player_speed
var impulse_speed: float = StatsManager.player_impulse_speed
var break_speed: float = StatsManager.player_break_speed
var max_velocity: float = StatsManager.player_max_velocity
var impulse_cooldown_timer: float = StatsManager.player_impulse_cooldown_duration

@export var camera: Camera2D
@onready var propulsor_sfx: AudioStreamPlayer = $SFX/PropulsorSFX
@onready var teleport_sfx: AudioStreamPlayer = $SFX/TeleportSFX
@onready var space_winds_sfx: AudioStreamPlayer = $SFX/SpaceWindsSFX
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var dash_sfx: AudioStreamPlayer = $SFX/DashSFX

@export var hurt_box_player: HurtBoxPlayer


@export var base_destroy_tolerance_timer: float = 0.5
var destroy_tolerance_timer: float


var player_init_pos: Vector2
var original_speed: float = speed

@export var start_of_game: bool = true

var can_destroy: bool
var emitted_fuel_waning: bool = false

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

	StatsManager.player_current_fuel = StatsManager.player_max_fuel
	player_init_pos = global_position + Vector2(0.0, -50)
	EventBus.player_almost_out_of_bounds.connect(_on_player_almost_out_of_bounds)
	EventBus.player_out_of_bounds.connect(_on_player_out_of_bounds)
	EventBus.cutscene_off.connect(start_game)


func start_game():
	if start_of_game:
		self.apply_force(Vector2(0.0, -speed * 30))
		propulsor_sfx.volume_db = -22
		SFXManager.play_sound(propulsor_sfx)
		propulsor_sfx.volume_db = -45
		start_of_game = false

func _process(delta: float) -> void:
	impulse_cooldown_timer -= delta
	destroy_tolerance_timer -= delta
	if impulse_cooldown_timer <= 0:
		impulse_cooldown_timer = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Globals.is_cutscene:
		return
	
	## Movement here vvv
	movement(state)
	steer_velocity(state)
	impulse_burst(state)
	break_stop(state)
	
	StatsManager.player_current_linear_velocity = state.linear_velocity
	
	if state.linear_velocity.length() > max_velocity:
		state.linear_velocity = state.linear_velocity.normalized() * max_velocity

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
	update_fuel()
	SFXManager.play_sound(propulsor_sfx)

func impulse_burst(state):
	if Input.is_action_just_pressed("impulse_burst")\
		and impulse_cooldown_timer <= 0:
			SFXManager.play_sound(dash_sfx)
			impulse_cooldown_timer = StatsManager.player_impulse_cooldown_duration
			update_fuel(true)
			state.apply_impulse(linear_velocity.normalized() * impulse_speed)


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


func update_fuel(is_impulse: bool = false):
	if is_impulse:
		StatsManager.player_current_fuel -= StatsManager.FUEL_IMPULSE_USE_STEP
	else:
		StatsManager.player_current_fuel -= StatsManager.FUEL_USE_STEP
	EventBus.fuel_used.emit()

	if StatsManager.player_current_fuel <= StatsManager.player_max_fuel/5 and !emitted_fuel_waning:
		emitted_fuel_waning = true
		EventBus.almost_out_of_fuel.emit()
	if StatsManager.player_current_fuel <= 0:
		Globals.player_died("Out of Fuel")
