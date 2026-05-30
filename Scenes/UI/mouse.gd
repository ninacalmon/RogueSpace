extends Node

const cursor_speed: float = 500.0
const deadzone: float = 0.2

@onready var mouse_pos: Vector2 = get_viewport().get_mouse_position()


func _process(delta: float) -> void:
	if !Input.get_connected_joypads():
		Globals.fake_mouse_input = false
		return
	
	var move = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	if move.length() < deadzone:
		move = Vector2.ZERO
	else:
		move = move.normalized()
	
	mouse_pos += move * cursor_speed * delta
	Input.warp_mouse(mouse_pos)
	
	if Input.is_action_just_pressed("confirm"):
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		click.position = mouse_pos
		get_viewport().push_input(click)
		
	if Input.is_action_just_released("confirm"):
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = false
		click.position = mouse_pos
		get_viewport().push_input(click)

	Globals.fake_mouse_input = true

#func _process(delta: float) -> void:
	#var move = Vector2(
		#Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		#Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	#)
	#if move.length() < deadzone:
		#move = Vector2.ZERO
	#else:
		#move = move.normalized()
	#
	#var old_pos = global_position
	#global_position += move * cursor_speed * delta
	#
	#if global_position != old_pos:
		#var motion_event: InputEventMouseMotion = InputEventMouseMotion.new()
		#motion_event.position = get_cursor_screen_pos()
		#get_viewport().push_input(motion_event)
	#
	#if Input.is_action_just_pressed("confirm"):
		#var click: InputEventMouseButton = InputEventMouseButton.new()
		#click.button_index = MOUSE_BUTTON_LEFT
		#click.pressed = true
		#click.position = get_cursor_screen_pos()
		#get_viewport().push_input(click)
		#
	#if Input.is_action_just_released("confirm"):
		#var click: InputEventMouseButton = InputEventMouseButton.new()
		#click.button_index = MOUSE_BUTTON_LEFT
		#click.pressed = false
		#click.position = get_cursor_screen_pos()
		#get_viewport().push_input(click)
#
#func get_cursor_screen_pos() -> Vector2:
	#var final_pos: Vector2 = global_position
	#var level_cam: Camera2D = get_viewport().get_camera_2d()
	#if level_cam:
		#final_pos += level_cam.global_position
		#if level_cam.anchor_mode == Camera2D.ANCHOR_MODE_DRAG_CENTER:
			#final_pos += get_viewport_rect().size / 2.0
	#return get_viewport().get_screen_transform().basis_xform(final_pos)
