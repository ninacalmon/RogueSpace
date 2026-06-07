extends CanvasLayer
class_name PanViewModule

@export var camera: SpaceshipCam
@export var total_rooms_range: Vector2i = Vector2i(-1, 1)
@export var room_width: int
#@export var viewport_border_width: float = 530
@export var camera_speed: float = 0.8

@onready var button_l: Button = $ButtonL
@onready var button_r: Button = $ButtonR

#var viewport_size: Vector2
#var viewport_center: Vector2

var can_look_left: bool = true
var can_look_right: bool = true

var current_room: int = 0

var deactivated: bool = true

func initialize() -> void: 
	#viewport_size = get_viewport_rect().size
	#viewport_center = camera.get_screen_center_position()
	deactivated = false
	button_l.pressed.connect(_on_left_button_pressed)
	button_r.pressed.connect(_on_right_button_pressed)

func _on_left_button_pressed():
	if camera.is_busy or \
	camera.is_focused or \
	current_room <= total_rooms_range.x or \
	deactivated:
		return
	look_side("left")

func _on_right_button_pressed():
	if camera.is_busy or \
	camera.is_focused or \
	current_room >= total_rooms_range.y or \
	deactivated:
		return
	look_side("right")

func look_side(side: String):
	var new_pos = camera.global_position
	camera.is_busy = true


	match side:
		"left":
			can_look_left = false
			new_pos -= Vector2(room_width, 0)
			current_room -= 1
		"right":
			can_look_right = false
			new_pos += Vector2(room_width, 0)
			current_room += 1

	var tween = create_tween()
	tween.tween_property(camera, "global_position", new_pos, camera_speed)
	
	await tween.finished
	
	#viewport_center = camera.get_screen_center_position()
	camera.is_busy = false


#func _input(event: InputEvent) -> void:
	#if camera.is_busy or \
	#camera.is_focused or \
	#deactivated:
		#return
	#look_side("left")
#
	#if event.is_action_pressed("left_click"):
		#viewport_center = camera.get_screen_center_position()
		#var mouse_pos: Vector2 = get_global_mouse_position()
#
		#if mouse_pos.x < viewport_center.x - viewport_border_width and \
		#current_room > total_rooms_range.x and \
		 #can_look_left:
		#
			#look_side("left")
#
		#if mouse_pos.x > viewport_center.x + viewport_border_width and \
		#current_room < total_rooms_range.y and \
		 #can_look_right:
			#look_side("right")
#
		#if mouse_pos.x > viewport_center.x - viewport_border_width and \
		#mouse_pos.x < viewport_center.x + viewport_border_width:
			#can_look_left = true
			#can_look_right = true
