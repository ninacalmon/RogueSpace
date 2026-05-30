extends Node

func _ready() -> void:
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	InputGuide.clear_guides()
	show_default()

func _on_focus_changed(focus: bool, subject: Node2D):
	if focus:
		if subject is ResourcesMachine:
			InputGuide.clear_guides()
			InputGuide.show_guide(InputGuide.ActionType.CLICK)
			InputGuide.show_guide(InputGuide.ActionType.POINT)
			InputGuide.show_guide(InputGuide.ActionType.RETURN)
		elif subject is Monitor:
			InputGuide.clear_guides()
			InputGuide.show_guide(InputGuide.ActionType.UI_MOVEMENT)
			InputGuide.show_guide(InputGuide.ActionType.CONFIRM)
			InputGuide.show_guide(InputGuide.ActionType.RETURN)
		else:
			InputGuide.clear_guides()
			show_default()

func show_default():
	InputGuide.show_guide(InputGuide.ActionType.CLICK)
	InputGuide.show_guide(InputGuide.ActionType.POINT)
