extends RigidBody2D
class_name BodySetupPoolable

@export var collision: CollisionShape2D
@export var sprite: Sprite2D
@export var gravitational_field: GravitationalField
@export var gravitational_field_resources: GravitationalField
@export var body_randomizer: BodyRandomizer

@export var deactivate: bool

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()
