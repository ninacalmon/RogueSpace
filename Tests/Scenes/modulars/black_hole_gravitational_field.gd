extends GravitationalField
class_name BlackHoleGravitationalField

@export var spin_strength: float = 0.6
@export var radial_boost_power: float = 2.5 # >2 = stronger near center
@export var horizon_stickiness: float = 0.9 # slows escape

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
	var distance = max(direction.length(), 5.0)

	var dir_normalized = direction.normalized()
	
	var G = 1000.0
	
	# 🔹 stronger-than-normal gravity near center
	var base_force = G * (owner_body.mass * near_body.mass) / pow(distance, radial_boost_power)

	# 🔹 tangent direction (perpendicular = causes orbit/spin)
	var tangent = Vector2(-dir_normalized.y, dir_normalized.x)

	var radial_force = dir_normalized * base_force
	var tangential_force = tangent * base_force * spin_strength * spin_factor

	var total_force = (radial_force + tangential_force)

	# Apply asymmetrically (your system)
	near_body.apply_central_force(total_force * attraction_executed_multuply)
	owner_body.apply_central_force(-total_force * attraction_received_multiply)

	# 🌑 EVENT HORIZON EFFECT
	if distance < event_horizon_radius:
		# Pull MUCH harder inside
		var extra_pull = dir_normalized * base_force * 2.0
		near_body.apply_central_force(extra_pull)

		# Add damping so things spiral instead of escaping
		near_body.linear_velocity *= horizon_stickiness
