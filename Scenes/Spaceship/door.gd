extends MainArea

var has_energy: bool = false

@onready var door_sfx: AudioStreamPlayer = $DoorSFX

func _ready() -> void:
	#has_energy = true
	_connect_signals()


func _connect_signals():
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.focus_changed.connect(_on_focus_changed)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)

func _on_resource_count_finished():
	has_energy = true

### CODIGO FEIAO vvvv
func _on_clicked():
	if !has_energy:
		PopUpSystem.show_text("Sem energia.")
		return
	SFXManager.play_sound(door_sfx)
	await get_tree().create_timer(1.2).timeout
	StatsManager.day += 1
	LevelTransition.change_scene_to("res://Scenes/Levels/Level1.tscn", 3, 2)

func _on_focus_changed(focus: bool, _subject: Node2D):
	## If there is a race condition with the activation of the clickable_highlight here and the disabling of it
	## on the ClickableHighlight module, we can work around this problem having a state here that changes
	## clickable_highlight.active on process based off this state
	if focus == false:
		clickable_highlight.is_mouse_over_area = false
		clickable_highlight.active = true
		is_focused = false
