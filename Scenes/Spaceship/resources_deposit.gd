extends SubArea

@onready var counter: ResourceCounter = %Counter


func _ready() -> void:
	clickable_highlight.was_clicked.connect(_on_clicked)
	SpaceshipEventBus.resource_count_finished.connect(_on_resource_count_finished)
	#clickable_highlight.clicked_outside.connect(_was_clicked_outside)

func _on_clicked():
	can_exit_sub_area = false
	counter.initialize()
	counter.show()

func _on_resource_count_finished():
	can_exit_sub_area = true

func deactivate():
	counter.hide()
