extends Node

func apply_power_up(power_up: String):
	match power_up:
		"Impulse":
			Globals.player_burst_speed *= 2
		"Fuel":
			Globals.max_fuel *= 1.5
		"Teleport":
			Globals.can_teleport = true
