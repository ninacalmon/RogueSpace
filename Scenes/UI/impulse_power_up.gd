extends TextureButton
class_name PowerUp

@export var price: int = 100
@export var price_label: RichTextLabel

var self_modulate_color = Color(0.49, 0.678, 0.286)

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	pressed.connect(_on_button_pressed)
	price_label.text = "%d recursos" %price

func _on_button_pressed():
	print("prewssed")
	if Globals.resources_gathered < price:
		shake()
		return
	modulate = Color(0.153, 0.212, 0.086)
	PowerUps.apply_power_up("Impulse")
	Globals.resources_gathered -= price
	EventBus.resources_used.emit()
	print("aplied")

func shake():
	var original_pos_x = position.x
	var tween = create_tween()
	tween.tween_property(self, "position:x", original_pos_x-4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x+4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x-4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x+4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x, 0.1)

func _on_focus_entered():
	self_modulate = Color(1, 1, 1)

func _on_focus_exited():
	self_modulate = self_modulate_color
