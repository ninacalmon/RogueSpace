extends Sprite2D
class_name PlayerSprite2D

@onready var motor_gpu_particles: GPUParticles2D = $MotorGPUParticles
@onready var backpack_sprite_2d: Sprite2D = $BackpackSprite2D

func update_sprite(facing_direction: String):
	match facing_direction:
		"up":
			frame_coords.y = 2
			motor_gpu_particles.show_behind_parent = false
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

#func animate_start_propelling():
	#if frame_coords.y == 0:
		#frame_coords.x = 1
		#await get_tree().create_timer(0.1).timeout
		#frame_coords.x = 2
		#await get_tree().create_timer(0.1).timeout
		#frame_coords.x = 3
#
#func animate_stop_propelling():
	#if frame_coords.y == 0:
		#frame_coords.x = 2
		#await get_tree().create_timer(0.1).timeout
		#frame_coords.x = 1
		#await get_tree().create_timer(0.1).timeout
		#frame_coords.x = 0
