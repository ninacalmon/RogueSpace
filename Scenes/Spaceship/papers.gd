extends MainArea
class_name Papers

var has_energy: bool = false


func _ready() -> void:
	#has_energy = true
	_connect_signals()



func _connect_signals():
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)



func _on_resource_count_finished():
	has_energy = true


func _on_clicked():
	if !has_energy:
		HandsEventBus.door_interaction.emit()
		PopUpSystem.show_text("Está muito escuro.")
		return

	if !is_focused and clickable_highlight.is_mouse_over_area:
		is_focused = true
		SpaceshipEventBus.focus_on.emit(zoom_in_amount, zoom_offset, self, false)


func _on_focus_changed(focus: bool, _subject: Node2D):
	if !focus:
		clickable_highlight.is_mouse_over_area = false
		clickable_highlight.active = true
		is_focused = false
