extends SubArea

@onready var counter_text: ResourceCounter = %CounterText

var was_counted: bool = false

func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)
	clickable_highlight.is_on_hover.connect(_on_hover)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)
	#clickable_highlight.clicked_outside.connect(_was_clicked_outside)

func _on_clicked():
	if was_counted:
		return
	was_counted = true
	can_exit_sub_area = false
	counter_text.initialize()

func _on_resource_count_finished():
	can_exit_sub_area = true

func _on_hover():
	PopUpSystem.show_text("Clique para inserir recursos.", 3)
