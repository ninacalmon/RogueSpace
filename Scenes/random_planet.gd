extends Sprite2D

@export var texture_options: Array[Texture]
@export var body_randomizer: BodyRandomizer


func _ready() -> void:
	texture = texture_options.pick_random()
