extends RigidBody2D
class_name SuperMBlackHole

@onready var gravitational_field: GravitationalField = $GravitationalField
@onready var gulp_sfx: AudioStreamPlayer = $GulpSFX

var player: Player
var check_distance: bool = false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	gravitational_field.body_entered.connect(_on_gravitational_field_body_entered)
	gravitational_field.body_exited.connect(_on_gravitational_field_body_exited)

func _on_gravitational_field_body_entered(_body: RigidBody2D):
	if _body is Player:
		player = _body
		check_distance = true

func _on_gravitational_field_body_exited(_body: RigidBody2D):
	if _body is Player:
		check_distance = false

func _process(_delta: float) -> void:
	if !check_distance:
		return
	if player and player.global_position.distance_to(global_position) < 70:
		SFXManager.play_sound(gulp_sfx)

func _on_body_entered(body: Node2D):
	spin_death(body)

func _integrate_forces(state):
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0.0

func spin_death(body: RigidBody2D): #AI vvvvvvv
	if !body:
		return
	var center = global_position
	var start_pos = body.global_position
	var radius = start_pos.distance_to(center)
	var angle = (start_pos - center).angle()

	var duration = 2.0
	var tween = get_tree().create_tween()

	tween.tween_method(func(t):
		if not is_instance_valid(body):
			return
		# shrink radius over time
		var current_radius = lerp(radius, 0.0, t)
		
		# increase angle → orbit
		var current_angle = angle + t * TAU * 3
		
		var offset = Vector2(cos(current_angle), sin(current_angle)) * current_radius
		body.global_position = center + offset
		
		# also shrink
		body.scale = Vector2.ONE * lerp(1.0, 0.1, t)
		
	, 0.0, 1.0, duration)

	await tween.finished
	
	if is_instance_valid(body) and body is Player:
		get_tree().reload_current_scene()
	elif is_instance_valid(body):
		body.queue_free()
