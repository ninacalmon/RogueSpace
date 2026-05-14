extends Camera2D

@export var total_rooms_range: Vector2i = Vector2i(-1, 1)
@export var viewport_border_width: float = 530
@export var camera_speed: float = 0.8

var viewport_size: Vector2
var viewport_center: Vector2

var can_look_left: bool = true
var can_look_right: bool = true

var current_room: int = 0

func _ready() -> void: 
	viewport_size = get_viewport_rect().size
	viewport_center = get_screen_center_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = get_global_mouse_position()

		if mouse_pos.x < viewport_center.x - viewport_border_width and \
		current_room > total_rooms_range.x and \
		 can_look_left:
		
			look_side("left")

		if mouse_pos.x > viewport_center.x + viewport_border_width and \
		current_room < total_rooms_range.y and \
		 can_look_right:
			look_side("right")

		if mouse_pos.x > viewport_center.x - viewport_border_width and \
		mouse_pos.x < viewport_center.x + viewport_border_width:
			can_look_left = true
			can_look_right = true

func look_side(side: String):
	var new_pos = global_position

	match side:
		"left":
			can_look_left = false
			new_pos -= Vector2(viewport_size.x, 0)
			current_room -= 1
		"right":
			can_look_right = false
			new_pos += Vector2(viewport_size.x, 0)
			current_room += 1

	var tween = create_tween()
	tween.tween_property(self, "global_position", new_pos, camera_speed)
	
	await tween.finished
	
	viewport_center = get_screen_center_position()






#
#@export var backgound: Sprite2D
#@export var screen_horizontal_border: int = 500
#
#var backgroud_width
#var viewport_width
#var true_center_pos: Vector2
#var center_left_pos: Vector2
#var center_right_pos: Vector2
#
#var look_state: int = 0 # -1 = left, 0 = center, 1 = right
#
#@export var deactivate: bool
#
#func _ready() -> void:
	#backgroud_width = backgound.texture.get_width() * backgound.scale.x
	#viewport_width = get_viewport_rect().size.x
	#
	#true_center_pos = get_screen_center_position()
	#center_left_pos = true_center_pos - Vector2(backgroud_width / 3, 0)
	#center_right_pos = true_center_pos + Vector2(backgroud_width / 3, 0)
#
#func _process(_delta: float) -> void:
	#if deactivate:
		#return
	#
	#var screen_center = get_screen_center_position()
	#var mouse_offset_x = get_global_mouse_position().x - screen_center.x
#
	#if mouse_offset_x < -screen_horizontal_border:
		#if look_state != -1:
			#look_left()
#
#
	#elif mouse_offset_x > screen_horizontal_border:
		#if look_state != 1:
			#look_right()
#
	#else:
		#if look_state != 0:
			#screen_horizontal_border = 500
			#look_center()
	#
	#var target_offset = true_center_pos
#
	#if look_state == -1:
		#target_offset = center_left_pos
	#elif look_state == 1:
		#target_offset = center_right_pos
#
	#var curved_t = ease(0.05, 1)
	#offset = offset.lerp(target_offset, curved_t)
#
#func look_left():
	#look_state = -1
#
#func look_right():
	#look_state = 1
#
#func look_center():
	#look_state = 0



#@export var min_offset: int = -1000000
#@export var max_offset: int = 1000000
##@export var border_size: int = 200
#@export var screen_horizontal_border: int = 400
#
#var is_focused: bool = false
#var original_offset: Vector2
#var screen_center: Vector2
#
#var is_looking_left: bool = false
#
#func _ready() -> void:
	#original_offset = offset
	#screen_center = get_screen_center_position()
#
#func _process(_delta):
	#if is_focused:
		#return
#
	#var mouse_offset_x = get_global_mouse_position().x - screen_center.x
	#
	#if abs(mouse_offset_x) > screen_horizontal_border:
		#if mouse_offset_x < screen_center.x:
			#look_left(mouse_offset_x)
		#elif mouse_offset_x > screen_center.x:
			#look_right(mouse_offset_x)
			#
#
#
#func look_left(mouse_offset_x):
	#var new_offset = Vector2(-800, 0)
	#var curved_t = ease(0.05, 1)
	#offset = offset.lerp(new_offset, curved_t)
	##var new_screen_center = get_screen_center_position()
	##if mouse_offset_x < new_screen_center.x:
			#
	#
#
#func look_right(mouse_offset_x):
	#var new_offset = Vector2(800, 0)
	#var curved_t = ease(0.05, 1)
	#offset = offset.lerp(new_offset, curved_t)
