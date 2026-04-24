extends Area2D
class_name ResourceCollector

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: RigidBody2D):
	if body is SpaceResource:
		EventBus.space_resource_collected.emit()
		body.queue_free()
