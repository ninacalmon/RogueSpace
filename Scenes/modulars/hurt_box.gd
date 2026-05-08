extends Area2D
class_name HurtBox

@export var bullet_sensible: bool = true
signal damage_taken(amount: float, causer: Node2D)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if bullet_sensible and area is Bullet:
		var _bullet: Bullet = area as Bullet
		damage_taken.emit(_bullet.damage, _bullet)
