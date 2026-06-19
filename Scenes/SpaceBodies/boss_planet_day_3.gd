extends BodySetup

@export var _rotate: bool = true

@export var rotation_speed: float = 0.05

@onready var boss: Boss = $Boss
@onready var breaking_particles: GPUParticles2D = $BreakingParticles
@onready var smooth_shake: SmoothShake = $SmoothShake

func _ready() -> void:
	boss.add_collision_exception_with(self)
	
	##setup
	if gravitational_field: gravitational_field.initialize()
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	
	EventBus.start_planet_break.connect(start_cutscene)

func _process(delta: float) -> void:
	linear_velocity = Vector2.ZERO
	
	if _rotate:
		sprite.rotation += rotation_speed * delta

func start_cutscene():
	var duration: float = 10
	smooth_shake.shake_peak(sprite, duration, 12)

	await get_tree().create_timer(duration * 0.1).timeout
	var tween = create_tween()
	tween.tween_property(breaking_particles, "amount_ratio", 1, duration * 0.6)
	tween.tween_property(breaking_particles, "amount_ratio", 0, duration * 0.3)

	await get_tree().create_timer(duration * 0.7).timeout
	
	boss.cutscene()
	await tween_shader_param(sprite.material, "dissolve_value", 1.0, 0.0, 4)

	boss.cutscene_finished.emit()

	var parent = get_parent()

	## SAFE REPARENTING AND QUEUE FREEING
	if boss.get_parent():
		boss.get_parent().remove_child(boss)

	parent.add_child(boss)

	await get_tree().process_frame

	queue_free()

func tween_shader_param(mat: ShaderMaterial, param: String, from: float, to: float, duration: float):
	var _tween = create_tween()
	_tween.tween_method(
		func(value):
			mat.set_shader_parameter(param, value),
		from, to, duration
	)
	await _tween.finished
