extends Path2D
class_name PathOrbit

@export var radius: float = 400
@export var point_count: int = 12
@export var speed: float = 50.0
@export_range(0, 1, 0.001) var initi_progress_ration = 0.0
@export var body_scene: PackedScene

@onready var path_follow_2d: PathFollowOrbit = $PathFollow2D

func _ready() -> void:
	var new_body = body_scene.instantiate()
	path_follow_2d.add_child(new_body)
	path_follow_2d.speed = speed
	curve.clear_points()
	curve = make_circle_path(radius, point_count)
	path_follow_2d.progress_ratio = initi_progress_ration

func make_circle_path(_radius: float, _point_count: int) -> Curve2D:
	var _curve = Curve2D.new()
	
	for i in range(_point_count):
		var angle = (TAU * i) / _point_count
		var x = cos(angle) * _radius
		var y = sin(angle) * _radius
		
		_curve.add_point(Vector2(x, y))
	
	_curve.add_point(_curve.get_point_position(0))
	
	return _curve
