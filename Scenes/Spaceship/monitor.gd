extends MainArea
class_name Monitor

@export var sub_area_screen: SubArea
@onready var sprite_background: Sprite2D = $SpriteBackground

var has_energy: bool = false
var lights_on: bool = false

func _ready() -> void:
	has_energy = true
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)

func _on_resource_count_finished():
	has_energy = true

func _on_clicked():
	if !has_energy:
		PopUpSystem.show_text("Sem energia.")
		return
	if !is_focused and clickable_highlight.is_mouse_over_area:
		is_focused = true
		#trocar sprite aqui
		SpaceshipEventBus.focus_on.emit(zoom_in_amount, zoom_offset, self)

func _on_focus_changed(focus: bool, subject: Node2D):
	## If there is a race condition with the activation of the clickable_highlight here and the disabling of it
	## on the ClickableHighlight module, we can work around this problem having a state here that changes
	## clickable_highlight.active on process based off this state
	if focus == false:
		clickable_highlight.active = true
		is_focused = false
		if !lights_on and has_energy:
			turn_lights_on()

	elif  focus == true and subject == self:
		activate_sub_areas()

func activate_sub_areas():
	sub_area_screen.clickable_highlight.active = true
	sub_area_screen.collision_shape_2d.disabled = false

func turn_lights_on():
	await get_tree().create_timer(1.5).timeout
	var tween = create_tween()
	tween.tween_property(sprite_background, "modulate", Color(8, 8, 8), 0.02)
	tween.tween_property(sprite_background, "modulate", Color(0.102, 0.102, 0.102), 0.08)
	
