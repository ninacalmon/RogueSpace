extends RigidBody2D
class_name BlackHoleEventHorizon

@export var radius_multiplier: float = 3.0
@export var event_horizon_ratio: float = 0.2 # % of total radius
@export var G: float = 5000.0 # much stronger than normal gravity
@export var spin_force: float = 200.0 # makes objects spiral

@onready var event_horizon_range: CollisionShape2D = $EventHorizonRange

var bodies_near: Array[RigidBody2D] = []

func _ready() -> void:
	var range_circle: CircleShape2D = _range.shape.duplicate()
	range_circle.radius = owner_body.mass * radius_multiplier
	_range.shape = range_circle

	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)

func _on_enter(area: BlackHoleField):
	var body = area.owner_body
	bodies_near.append(body)

func _on_exit(area: BlackHoleField):
	var body = area.owner_body
	bodies_near.erase(body)

func _physics_process(_delta: float) -> void:
	for b in bodies_near:
		apply_black_hole_force(b)

func apply_black_hole_force(body: RigidBody2D):
	if body == owner_body:
		return
	
	if not is_instance_valid(body):
		return

	var direction = owner_body.global_position - body.global_position
	var distance = direction.length()

	if distance < 1.0:
		return

	var dir_normalized = direction.normalized()

	# --- GRAVITY (strong inverse square) ---
	var force_mag = G * (owner_body.mass * body.mass) / (distance * distance)
	var gravity_force = dir_normalized * force_mag

	# --- SPIN (tangential force for orbit/swirl) ---
	var tangent = Vector2(-dir_normalized.y, dir_normalized.x)
	var spin = tangent * spin_force

	# --- EVENT HORIZON ---
	var event_horizon = (_range.shape.radius) * event_horizon_ratio

	if distance < event_horizon:
		# "consumed" by black hole
		body.queue_free()
		return

	# Apply both forces
	body.apply_central_force(gravity_force + spin)
