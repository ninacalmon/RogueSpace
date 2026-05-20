extends MainArea

@export var sub_area_screen: SubArea

func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)

func _on_clicked():
	if !is_focused:
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

	elif  focus == true and subject == self:
		activate_sub_areas()

func activate_sub_areas():
	sub_area_screen.clickable_highlight.active = true
	sub_area_screen.collision_shape_2d.disabled = false
