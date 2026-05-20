extends Camera2D
class_name SpaceshipCam

@onready var pan_view_module: PanViewModule = $PanViewModule
@onready var focus_module: Node2D = $FocusModule

var is_busy: bool
var is_focused: bool

func _ready() -> void:
	pan_view_module.initialize()
	focus_module.initialize()
