extends Node2D
class_name DamageModule

@export var owner_body: RigidBody2D
@export var minimum_impact: float = 80

signal damage_taken(amount: float)

func _ready() -> void:
	owner_body.body_entered.connect(_on_body_collided)

func _on_body_collided(body: RigidBody2D):
	var relative_velocity = owner_body.linear_velocity - body.linear_velocity
	var impact_hardness = relative_velocity.length()
	if impact_hardness <= minimum_impact:
		return
	print("Impact hardness: ", impact_hardness)
	damage_taken.emit(impact_hardness)
