extends SubArea

@export var canvas_layer_monitor: CanvasLayer
@export var power_ups_conteiner: PowerUpList

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	canvas_layer_monitor.hide()
	if clickable_highlight:
		clickable_highlight.was_clicked.connect(_on_clicked)

func _on_clicked():
	if Input.get_connected_joypads():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	canvas_layer_monitor.show()
	power_ups_conteiner.initialize()

func deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	canvas_layer_monitor.hide()

func _on_focus_changed(focus: bool, _subject: Node2D):
	if focus == false:
		deactivate()
