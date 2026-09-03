extends Node

##
## strength_index guide:
## 0: low
## 1: medium
## 2: high
## 3: very high
func vibrate_controller(strength_index: int = 0, duration: float = 0.1, controller_index: int = 0):
	var weak_mag: float = 0.2
	var strong_mag: float = 0.6
	match strength_index:
		0:
			weak_mag = 0.2
			strong_mag = 0.6
		1:
			weak_mag = 0.1
			strong_mag = 0.7
		2:
			weak_mag = 0.0
			strong_mag = 0.8
		3:
			weak_mag = 0.0
			strong_mag = 1.0

	Input.start_joy_vibration(controller_index, weak_mag, strong_mag, duration)
