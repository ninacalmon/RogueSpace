extends Node2D
class_name Spawner

@export var resources_scene: PackedScene
@export var critters_scene: PackedScene
@export var res_amount_min: int
@export var res_amount_max: int
@export var chance_of_critters: bool
@export var cri_amount_min: int
@export var cri_amount_max: int
@export_range(0, 100, 1) var chance_percentage: int

var amount_to_spawn: int
var will_spawn: bool

func spawn():
	spawn_resources()
	if chance_of_critters:
		spawn_critters()

func spawn_resources():
	amount_to_spawn = randi_range(res_amount_min, res_amount_max)
	var activated_array: Array = ObjectPool.activate_instances("Resource", amount_to_spawn)
	for i: RigidBody2D in activated_array:
		i.global_position = global_position

func spawn_critters():
	will_spawn = randi_range(0, 100) < chance_percentage
	if !will_spawn:
		return
	amount_to_spawn = randi_range(cri_amount_min, cri_amount_max)
	var activated_array: Array = ObjectPool.activate_instances("Enemy", amount_to_spawn)
	for i: RigidBody2D in activated_array:
		i.global_position = global_position
