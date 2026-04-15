extends Area2D
class_name GravitationalField

@export var owner_body: RigidBody2D
@export var mass_to_radius_multiply: float = 2.0
@export var attraction_received_multiply: float = 1.0
@export var attraction_executed_multuply: float = 1.0
@onready var _range: CollisionShape2D = $Range

signal grav_field_entered(body: RigidBody2D)

var body_near: Array[RigidBody2D] = []

func _ready() -> void: ##needs to be changed later to initialize() and called from the parent of the scene tree.
	var range_circle: CircleShape2D = _range.shape.duplicate()
	range_circle.radius = owner_body.mass * mass_to_radius_multiply
	_range.shape = range_circle

	area_entered.connect(_on_grav_field_entered_by_area)
	area_exited.connect(_on_grav_field_exited_by_area)

func _on_grav_field_entered_by_area(area: GravitationalField):
	var body = area.owner_body
	grav_field_entered.emit(body)
	body_near.append(body)

func _on_grav_field_exited_by_area(area: GravitationalField):
	var body = area.owner_body
	grav_field_entered.emit(body)
	body_near.erase(body)

func _physics_process(_delta: float) -> void:
	for b in body_near:
		apply_gravity(b)
		

func apply_gravity(near_body: RigidBody2D):
	if near_body == owner_body:
		return
	
	if not is_instance_valid(near_body):
		return

	var direction = owner_body.global_position - near_body.global_position
	var distance = max(direction.length(), 10.0)

	var dir_normalized = direction.normalized()
	
	var G = 1000.0
	var base_force = G * (owner_body.mass * near_body.mass) / (distance * distance)

	# Force applied to the OTHER body (how much we attract it)
	var force_on_other = dir_normalized * base_force * attraction_executed_multuply


	# Force applied to THIS body (how much we get attracted)
	var force_on_self = -dir_normalized * base_force * attraction_received_multiply

	near_body.apply_central_force(force_on_other)
	owner_body.apply_central_force(force_on_self)
