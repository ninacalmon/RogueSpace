extends RichTextLabel

var current_resources: int = 0

func _ready() -> void:
	Globals.resources_gathered = 0
	text = "recursos: [b]%d/%d[/b]" %[current_resources, Globals.resources_needed]
	EventBus.space_resource_collected.connect(_on_resource_collected)
	EventBus.player_out_of_bounds.connect(_on_player_out_off_bounds)

func _on_resource_collected():
	Globals.resources_gathered += 1
	current_resources = Globals.resources_gathered
	text = "recursos: [b]%d/%d[/b]" %[current_resources, Globals.resources_needed]

func _on_player_out_off_bounds():
	Globals.resources_gathered = floor(current_resources / 2.0)
	current_resources = Globals.resources_gathered
	text = "recursos: [b]%d/%d[/b]" %[current_resources, Globals.resources_needed]
