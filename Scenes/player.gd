extends RigidBody2D
class_name Player

@export var speed: float = 1000
@export var break_speed: float = 2
@export var max_velocity: float = 1000.0

@onready var camera: Camera2D = $Camera2D

var player_init_pos: Vector2
var original_speed: float = speed
var impulse_burst: float = 100

var start_of_game: bool = true

func _ready() -> void:
	player_init_pos = global_position
	EventBus.player_almost_out_of_bounds.connect(_on_player_almost_out_of_bounds)
	EventBus.player_out_of_bounds.connect(_on_player_out_of_bounds)
	EventBus.cutscene_off.connect(start_game)

func start_game():
	if start_of_game:
		print("hello")
		self.apply_force(Vector2(0.0, -speed * 30))
		start_of_game = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Globals.is_cutscene:
		return

	Globals.player_linear_velocity = state.linear_velocity

	## Movement here vvv
	if Input.is_action_pressed("move_down"):
		if Input.is_action_just_pressed("impulse_burst"):
			speed *= impulse_burst
		state.apply_central_force(Vector2(0, speed))
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_left"):
		if Input.is_action_just_pressed("impulse_burst"):
			speed *= impulse_burst
		state.apply_central_force(Vector2(-speed, 0))
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_up"):
		if Input.is_action_just_pressed("impulse_burst"):
			speed *= impulse_burst
		state.apply_central_force(Vector2(0.0, -speed))
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()

	if Input.is_action_pressed("move_right"):
		if Input.is_action_just_pressed("impulse_burst"):
			speed *= impulse_burst
		state.apply_central_force(Vector2(speed, 0))
		if speed!= original_speed: speed = original_speed
		EventBus.fuel_used.emit()
	
	if state.linear_velocity.length() > max_velocity:
		state.linear_velocity = state.linear_velocity.normalized() * max_velocity
	
	# Break vvvvvv
	if Input.is_action_pressed("break_stop"):
		state.linear_velocity = state.linear_velocity.move_toward(Vector2.ZERO, break_speed)


func _on_player_almost_out_of_bounds():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "linear_velocity", linear_velocity / 3, 1)

func _on_player_out_of_bounds():
	execute_teletransport()

func execute_teletransport():
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
