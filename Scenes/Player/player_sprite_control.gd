extends Sprite2D
class_name PlayerSprite2D

@onready var motor_gpu_particles: GPUParticles2D = $MotorGPUParticles
@onready var backpack_sprite_2d: Sprite2D = $BackpackSprite2D

func update_sprite(facing_direction: String):
	match facing_direction:
		"up":
			frame_coords = Vector2(0, 2)
			motor_gpu_particles.show_behind_parent = false
		"down":
			frame_coords = Vector2(0, 0)
			motor_gpu_particles.show_behind_parent = true
		"left":
			frame_coords = Vector2(0, 3)
			motor_gpu_particles.show_behind_parent = true
		"right":
			frame_coords = Vector2(0, 1)
			motor_gpu_particles.show_behind_parent = true
	
	backpack_sprite_2d.frame_coords.y = frame_coords.y
