extends Node

## THIS WAS MADE ONLY FOR RIGIDBODIES2D!!!

var pooled_instances_info: Dictionary = {
	
}

var deactive_instances_dic: Dictionary = {
	"Enemy" : {
		"instances" : []
	},
	"Resource" : {
		"instances" : []
	}
}

var active_instances_dic: Dictionary = {
	"Enemy" : {
		"instances" : []
	},
	"Resource" : {
		"instances" : []
	}
}

var pool_layer: Node2D

func _ready() -> void:
	pool_layer = get_tree().get_first_node_in_group("Pool_Group")

func create_and_pool_instances(what_to_spawn: PackedScene, amount: int, _name: String):
	print(pool_layer)
	if !pool_layer: return
	var instances_array: Array[RigidBody2D] = []

	for x in amount:
		var new_instance = what_to_spawn.instantiate()
		instances_array.append(new_instance)
		pool_layer.add_child(new_instance)

	storage_info(instances_array.get(0), _name)
	deactivate_instances(instances_array, _name)


func storage_info(instance_exemple: RigidBody2D, _name: String):
	var _collision_layer: Array = []
	var _collision_mask: Array = []

	for i in range(1, 33):
		if instance_exemple.get_collision_layer_value(i):
			_collision_layer.append(i)
		if instance_exemple.get_collision_mask_value(i):
			_collision_mask.append(i)

	pooled_instances_info[_name] = {
	"collision_layer": _collision_layer, 
	"collision_mask": _collision_mask
	}
	print(pooled_instances_info)


func deactivate_instances(instances: Array[RigidBody2D], _name):
	for x in instances:
		if x in deactive_instances_dic[_name]["instances"]:
			continue
		
		if x in active_instances_dic[_name]["instances"]:
			active_instances_dic[_name]["instances"].erase(x)

		var rb: RigidBody2D = x

		rb.global_position = Vector2.ZERO
		rb.position = Vector2.ZERO

		rb.linear_velocity = Vector2.ZERO
		rb.angular_velocity = 0.0

		rb.collision_layer = 0
		rb.collision_mask = 0

		rb.set_deferred("deactivate", true)
		rb.set_deferred("sleeping", true)
		rb.set_deferred("freeze", true)
		rb.set_deferred("visible", false)
		rb.process_mode = Node.PROCESS_MODE_DISABLED

		deactive_instances_dic[_name]["instances"].append(rb)


func activate_instances(_name: String, amount: int) -> Array[RigidBody2D]:
	var activated_array: Array[RigidBody2D]
	
	var rb: RigidBody2D
	
	if deactive_instances_dic[_name]["instances"].size() < amount:
		print("no more ", _name, "s left")
		return []

	for x in amount:
		rb = deactive_instances_dic[_name]["instances"].pop_back()
		
		if !rb: continue
		
		if !rb: continue

		if rb in active_instances_dic[_name]["instances"]:
			deactive_instances_dic[_name]["instances"].append(rb)
			continue
		
		if rb in active_instances_dic[_name]["instances"]:
			continue
		
		
		for l in pooled_instances_info[_name]["collision_layer"]:
				rb.set_collision_layer_value(l, true)
		
		for m in pooled_instances_info[_name]["collision_mask"]:
				rb.set_collision_mask_value(m, true)

		rb.process_mode = Node.PROCESS_MODE_INHERIT
		
		rb.set_deferred("sleeping", false)
		rb.set_deferred("freeze", false)
		rb.set_deferred("visible", true)
		
		rb.call_deferred("reset_variables")
			
		active_instances_dic[_name]["instances"].append(rb)
		activated_array.append(rb)
		
	return activated_array

func clean_variables():
	pooled_instances_info = {
	
}

	deactive_instances_dic = {
		"Enemy" : {
			"instances" : []
		},
		"Resource" : {
			"instances" : []
		}
	}

	active_instances_dic = {
		"Enemy" : {
			"instances" : []
		},
		"Resource" : {
			"instances" : []
		}
	}

	pool_layer = null
