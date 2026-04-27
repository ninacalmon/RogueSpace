extends Control

@export var arrow: Node2D
@export var mothership: RigidBody2D
@export var player: Player


func _process(_delta: float) -> void:
	if !arrow or !player or !mothership:
		return
	
	visible = !Globals.is_cutscene
	var direction = mothership.global_position - player.global_position
	arrow.rotation = direction.angle()
