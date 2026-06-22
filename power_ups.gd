extends Node

var impulse_current_level: int = 0
var fuel_current_level: int = 0
var health_current_level: int = 0
var propulsors_current_level: int = 0
var bullet_current_level: int = 0
var teleport_current_level: int = 0


func add_current_level(power_up: String):
	match power_up:
		"Impulse":
			impulse_current_level += 1

		"Fuel":
			fuel_current_level += 1

		"Teleport":
			teleport_current_level += 1

		"Health":
			health_current_level += 1

		"Propulsors":
			propulsors_current_level += 1

		"Bullet":
			bullet_current_level += 1

func get_current_level(power_up: String) -> int:
	match power_up:
		"Impulse":
			return impulse_current_level

		"Fuel":
			return fuel_current_level

		"Teleport":
			return teleport_current_level

		"Health":
			return health_current_level

		"Propulsors":
			return propulsors_current_level

		"Bullet":
			return bullet_current_level
	return 0

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

		"Perfurator":
			StatsManager.player_have_perfurator = true
