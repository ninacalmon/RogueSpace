extends RichTextLabel

var current_resources: int = 0

func _ready() -> void:
	EventBus.space_resource_collected.connect(_on_resource_collected)
	EventBus.player_out_of_bounds.connect(_on_player_out_off_bounds)

func _on_resource_collected():
	current_resources += 1
	text = "%d/200" %current_resources

func _on_player_out_off_bounds():
	current_resources = floor(current_resources / 2.0)
	text = "%d/200" %current_resources
