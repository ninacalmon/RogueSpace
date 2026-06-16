extends Sprite2D
class_name PlayerSprite2D

@onready var motor_gpu_particles: GPUParticles2D = $MotorGPUParticles
@onready var backpack_sprite_2d: Sprite2D = $BackpackSprite2D

@export var seconds_per_frame: float = 0.3

var is_propelling: bool = false

func update_sprite(facing_direction: String):
	match facing_direction:
		"up":
			frame_coords.y = 0
			motor_gpu_particles.show_behind_parent = true
		"down":
			frame_coords.y = 0
			motor_gpu_particles.show_behind_parent = true
		"left":
			frame_coords.y = 3
			motor_gpu_particles.show_behind_parent = true
		"right":
			frame_coords.y = 1
			motor_gpu_particles.show_behind_parent = true
	
	backpack_sprite_2d.frame_coords.y = frame_coords.y

func start_animation():
	is_propelling = true

func stop_animation():
	is_propelling = false
	frame_coords.x = 0

func animate_propelling():
	frame_coords.x = 1
	await get_tree().create_timer(seconds_per_frame).timeout
	frame_coords.x = 2
	await get_tree().create_timer(seconds_per_frame).timeout
	frame_coords.x = 3
	await get_tree().create_timer(seconds_per_frame).timeout
	frame_coords.x = 2
	await get_tree().create_timer(seconds_per_frame).timeout
	frame_coords.x = 1
	await get_tree().create_timer(seconds_per_frame).timeout
	frame_coords.x = 0


func _process(_delta: float) -> void:
	if is_propelling:
		await animate_propelling()
