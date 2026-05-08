extends Node2D
class_name DamageModule

@export var owner_body: RigidBody2D
@export var minimum_impact: float = 50

signal damage_taken(amount: float, causer: RigidBody2D)
signal enemy_damage_taken(amount: float)

func _ready() -> void:
	owner_body.body_entered.connect(_on_body_collided)

func _on_body_collided(body: RigidBody2D):
	if body is BlackHole \
	or body is SuperMBlackHole \
	or body is CollectableResource:
		return

	if body is Enemy:
		var enemy: Enemy = body
		enemy_damage_taken.emit(enemy.damage)

	else:
		var relative_velocity = owner_body.linear_velocity - body.linear_velocity
		var impact_hardness = relative_velocity.length()
		
		if impact_hardness <= minimum_impact:
			return
		damage_taken.emit(impact_hardness, body)
