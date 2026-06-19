extends Node

var day: int = 3

#### RESOURCES BANK ####
var resources_needed: int = 0
var current_resources: int = 200

var player_has_cadaver: bool = false

#### POWER UPS ####
var PowerUpsLevels: Dictionary = {
	"Impulse": {
		"current_level": 0,
		"max_level": 3
	},
	"Fuel": {
		"current_level": 0,
		"max_level": 3
	},
	"Teleport": {
		"current_level": 0,
		"max_level": 1
	}
}

#### COUNTERS ####
var current_day: int = 1
var death_count: int = 0

#### PLAYER CONST BASE STATS ####

var player_current_bullet: String = "res://Scenes/Bullets/basic_bullet.tscn"
var player_have_perfurator: bool = true

#region CONST BaseLifeStats
const PLAYER_MAX_HEALTH: float = 100.0
const PLAYER_MAX_FUEL: float = 550.0
const FUEL_USE_STEP: float = 0.1
const FUEL_IMPULSE_USE_STEP: = 0.5
#endregion
#region CONST BaseMovementStats
const PLAYER_SPEED: float = 700.0
const PLAYER_IMPULSE_SPEED: float = 1000.0
const PLAYER_IMPULSE_COOLDOWN_DURATION: float = 3.0
const PLAYER_BREAK_SPEED: float = 2.0
const PLAYER_MAX_VELOCITY: float = 1000.0
const PLAYER_MAX_TURN: float = 0.01
#endregion

#### PLAYER VARIABLE BASE STATS ####
#region var BaseLifeStats
var player_max_health: float = PLAYER_MAX_HEALTH
var player_max_fuel: float = PLAYER_MAX_FUEL
#endregion
#region var BaseMovementStats
var player_speed: float = PLAYER_SPEED
var player_impulse_speed: float = PLAYER_IMPULSE_SPEED
var player_impulse_cooldown_duration: float = PLAYER_IMPULSE_COOLDOWN_DURATION
var player_break_speed: float = PLAYER_BREAK_SPEED
var player_max_velocity: float = PLAYER_MAX_VELOCITY
var player_max_turn: float = PLAYER_MAX_TURN
#endregion

#### PLAYER CURRENT STATS ####
#region CurrentLifeStats
var player_current_health: float = player_max_health
var player_current_fuel: float = player_max_fuel
#endregion
#region CurrentMovementStats
var player_current_linear_velocity: Vector2
#endregion
