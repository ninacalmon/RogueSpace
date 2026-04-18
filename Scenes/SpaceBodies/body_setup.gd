extends RigidBody2D

@export var collision: CollisionShape2D
@export var sprite: Sprite2D
@onready var gravitational_field: GravitationalField = $GravitationalField
@onready var body_randomizer: BodyRandomizer = $BodyRandomizer

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
