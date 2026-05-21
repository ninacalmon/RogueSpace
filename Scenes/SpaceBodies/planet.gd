extends BodySetup

func _ready() -> void:
	##setup
	if gravitational_field: gravitational_field.initialize()
	if body_randomizer: body_randomizer.initialize(sprite, collision)

	sprite.frame = randi_range(0, 0)

func _process(_delta: float) -> void:
	linear_velocity = Vector2.ZERO
