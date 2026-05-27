extends Area2D
class_name HurtBoxPlayer

@export var player: Player
@export var bullet_sensible: bool = false
@export var enemy_body_sensible: bool = false

@onready var damage_sfx: AudioStreamPlayer = $DamageSFX

signal damage_taken(amount: float, causer: Node2D)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D):
	if bullet_sensible and area is Bullet:
		var _bullet: Bullet = area as Bullet
		_on_enemy_damage_taken(_bullet.damage, _bullet)

func _on_body_entered(body: RigidBody2D):
	if enemy_body_sensible and body is Enemy:
		var _enemy: Enemy = body as Enemy
		_on_enemy_damage_taken(_enemy.damage, _enemy)

func _on_enemy_damage_taken(amount: float, _causer: Node2D):
	EventBus.damage_taken.emit(player, amount)
	StatsManager.player_current_health -= amount
	SFXManager.play_sound(damage_sfx)
	flash()
	ControllerVibration.vibrate_controller()

	if StatsManager.player_current_health <= 0:
		print("mori")
		EventBus.player_death.emit(true)

func flash():
	player.sprite_2d.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	player.sprite_2d.modulate = Color(1, 1, 1)
