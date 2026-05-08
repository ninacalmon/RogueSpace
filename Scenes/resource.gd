extends BodySetup
class_name SpaceResource

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.frame = randi_range(0, sprite_2d.hframes - 1)
