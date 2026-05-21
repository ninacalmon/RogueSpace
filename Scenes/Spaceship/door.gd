extends MainArea

func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)

func _on_clicked():
	LevelTransition.change_scene_to("res://Scenes/Levels/Level1.tscn", 1, 1)

func _on_focus_changed(focus: bool, _subject: Node2D):
	## If there is a race condition with the activation of the clickable_highlight here and the disabling of it
	## on the ClickableHighlight module, we can work around this problem having a state here that changes
	## clickable_highlight.active on process based off this state
	if focus == false:
		clickable_highlight.active = true
		is_focused = false
