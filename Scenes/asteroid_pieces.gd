extends BodySetup
class_name CollectableResource

@export var speed: float = 300
var collect_offset: float = 10
var following: bool
var target: Node2D

func _ready() -> void:
	if body_randomizer: body_randomizer.initialize(sprite, collision)
	if gravitational_field: gravitational_field.initialize()
	if gravitational_field_resources: gravitational_field_resources.initialize()

func _process(delta: float) -> void:
	if not following or target == null:
		return
	var direction = (target.global_position - global_position).normalized()
	self.global_position += direction * speed * delta
	
	if self.global_position.distance_to(target.global_position) <= collect_offset:
		collect()

func collect():
	if target is Player:
		EventBus.space_resource_collected.emit()
		queue_free()
