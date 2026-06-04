extends SubArea
class_name Screen

@export var canvas_layer_monitor: CanvasLayer
@export var power_ups_conteiner: PowerUpList

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var can_exit: bool

func _ready() -> void:
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	canvas_layer_monitor.hide()
	#if clickable_highlight:
		#clickable_highlight.was_clicked.connect(_on_clicked)

func activate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	canvas_layer_monitor.show()
	power_ups_conteiner.initialize()

func deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	canvas_layer_monitor.hide()
	CustomTooltip.hide_tooltip()
	await power_ups_conteiner.hide_power_ups()
	power_ups_conteiner.is_on = false

func _on_focus_changed(focus: bool, _subject: Node2D):
	if focus == false:
		deactivate()

func _process(_delta: float) -> void:
	can_exit = power_ups_conteiner.is_on
