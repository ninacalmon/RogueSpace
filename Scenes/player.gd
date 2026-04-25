extends BodySetup
class_name Player

@export var speed: float = 1000
@export var break_speed: float = 2
@export var max_velocity: float = 1000.0

@onready var camera: Camera2D = $Camera2D
@onready var propulsor_sfx: AudioStreamPlayer = $SFX/PropulsorSFX
@onready var teleport_sfx: AudioStreamPlayer = $SFX/TeleportSFX
@onready var space_winds_sfx: AudioStreamPlayer = $SFX/SpaceWindsSFX

@export var base_burst_cooldown: float = 3.0
var burst_cooldown_timer: float

var player_init_pos: Vector2
var original_speed: float = speed
var impulse_burst: float = 100

var start_of_game: bool = true

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

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
	burst_cooldown_timer -= delta
	if burst_cooldown_timer <= 0:
		burst_cooldown_timer = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Globals.is_cutscene:
		return

	Globals.player_linear_velocity = state.linear_velocity

	## Movement here vvv
	if Input.is_action_pressed("move_down"):
		if Input.is_action_just_pressed("impulse_burst")\
		and burst_cooldown_timer <= 0:
			burst_cooldown_timer = base_burst_cooldown
			speed *= impulse_burst
		state.apply_central_force(Vector2(0, speed))
		SFXManager.play_sound(propulsor_sfx)
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_left"):
		if Input.is_action_just_pressed("impulse_burst")\
		and burst_cooldown_timer <= 0:
			burst_cooldown_timer = base_burst_cooldown
			speed *= impulse_burst
		state.apply_central_force(Vector2(-speed, 0))
		SFXManager.play_sound(propulsor_sfx)
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_up"):
		if Input.is_action_just_pressed("impulse_burst")\
		and burst_cooldown_timer <= 0:
			burst_cooldown_timer = base_burst_cooldown
			speed *= impulse_burst
		state.apply_central_force(Vector2(0.0, -speed))
		SFXManager.play_sound(propulsor_sfx)
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_right"):
		if Input.is_action_just_pressed("impulse_burst")\
		and burst_cooldown_timer <= 0:
			burst_cooldown_timer = base_burst_cooldown
			speed *= impulse_burst
		state.apply_central_force(Vector2(speed, 0))
		SFXManager.play_sound(propulsor_sfx)
		if speed != original_speed: speed = original_speed
		EventBus.fuel_used.emit()
	
	if state.linear_velocity.length() > max_velocity:
		state.linear_velocity = state.linear_velocity.normalized() * max_velocity
	
	# Break vvvvvv
	if Input.is_action_pressed("break_stop"):
		state.linear_velocity = state.linear_velocity.move_toward(Vector2.ZERO, break_speed)

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

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
