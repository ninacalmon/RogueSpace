extends SubArea

@onready var counter_text: ResourceCounter = %CounterText
@onready var sprite_valve: Sprite2D = $SpriteValve

var was_counted: bool = false

var has_showed_text: bool = false

func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)
	#clickable_highlight.is_on_hover.connect(_on_hover)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)
	#clickable_highlight.clicked_outside.connect(_was_clicked_outside)

func _on_clicked():
	if was_counted:
		return
	was_counted = true
	can_exit_sub_area = false
	sprite_valve.frame = 1
	counter_text.initialize()

func _on_resource_count_finished():
	can_exit_sub_area = true
	StatsManager.current_resources -= StatsManager.resources_needed
	SpaceshipEventBus.resources_spent.emit()
	SpaceshipEventBus.focus_off.emit()

#func _on_hover():
	#if !has_showed_text:
		#has_showed_text = true
		#PopUpSystem.show_text("Clique para inserir recursos.", 3)
		#await PopUpSystem.text_vanished
		#has_showed_text = false

func _process(_delta: float) -> void:
	if clickable_highlight.is_mouse_over_area:
		if !has_showed_text:
			has_showed_text = true
			PopUpSystem.show_text("Clique para inserir recursos.", 3)
	else:
		has_showed_text = false
