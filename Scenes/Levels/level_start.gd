extends Node2D
class_name LevelStart

@export var pool_layer: Node2D
@export var enemy_scene: PackedScene
@export var resources_scene: PackedScene

@export var enemy_pool_amount: int = 50
@export var resources_pool_amount: int = 200

func _ready() -> void:
	ObjectPool.pool_layer = pool_layer
	ObjectPool.create_and_pool_instances(enemy_scene, enemy_pool_amount, "Enemy")
	ObjectPool.create_and_pool_instances(resources_scene, resources_pool_amount, "Resource")
