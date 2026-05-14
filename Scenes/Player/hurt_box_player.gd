extends Area2D
class_name HurtBoxPlayer

@export var bullet_sensible: bool = false
@export var enemy_body_sensible: bool = false

signal damage_taken(amount: float, causer: Node2D)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D):
	if bullet_sensible and area is Bullet:
		var _bullet: Bullet = area as Bullet
		damage_taken.emit(_bullet.damage, _bullet)

func _on_body_entered(body: RigidBody2D):
	if enemy_body_sensible and body is Enemy:
		var _enemy: Enemy = body as Enemy
		damage_taken.emit(_enemy.damage, _enemy)
		print("emiti")
