extends Node

func apply_power_up(power_up: String):
	match power_up:
		"Impulse":
			StatsManager.player_impulse_speed *= 2
		"Fuel":
			StatsManager.player_max_fuel *= 1.5
		"Teleport":
			Globals.can_teleport = true
