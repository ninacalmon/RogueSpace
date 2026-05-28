extends Node

func apply_power_up(power_up: String):
	match power_up:
		"Impulse":
			StatsManager.player_impulse_speed *= 2

		"Fuel":
			StatsManager.player_max_fuel *= 1.5

		"Teleport":
			Globals.can_teleport = true

		"Health":
			StatsManager.player_max_health *= 1.5

		"Propulsors":
			StatsManager.player_max_turn = 0.03
			StatsManager.player_break_speed *= 2

		"Bullet":
			StatsManager.player_current_bullet = "res://Scenes/Bullets/super_bullet.tscn"
