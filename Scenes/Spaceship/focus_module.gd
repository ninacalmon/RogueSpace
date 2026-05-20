extends Node2D

@export var camera: SpaceshipCam
@export var zoom_speed: float = 1.0


@onready var init_zoom: Vector2 = camera.zoom
@onready var init_offset: Vector2 = camera.offset


func initialize() -> void:
	SpaceshipEventBus.focus_on.connect(_on_focus_on_requested)
	SpaceshipEventBus.focus_off.connect(_on_focus_off_requested)

func _on_focus_on_requested(zoom_in_amount: float, zoom_offset: Vector2, emitter: Node2D):
	if camera.is_busy or camera.is_focused:
		return

	camera.is_busy = true
	camera.is_focused = true
	var new_zoom = camera.zoom * zoom_in_amount
	var new_offset = emitter.global_position + zoom_offset
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(camera, "zoom", new_zoom, zoom_speed)
	tween.parallel().tween_property(camera, "offset", new_offset, zoom_speed)
	
	await tween.finished
	SpaceshipEventBus.focus_changed.emit(true, emitter)
	
	camera.is_busy = false

func _on_focus_off_requested():
	if camera.is_busy or !camera.is_focused:
		return

	camera.is_busy = true
	camera.is_focused = false
	SpaceshipEventBus.focus_changed.emit(false, null)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(camera, "zoom", init_zoom, zoom_speed)
	tween.parallel().tween_property(camera, "offset", init_offset, zoom_speed)
	
	await tween.finished
	print("emitidno falsooooooooooooo")
	
	camera.is_busy = false
