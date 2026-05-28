extends VBoxContainer
class_name PowerUpSetup

@export_enum("Impulse", "Fuel", "Teleport") var effect: String
@export var title: String
@export var price: int = 100
@export var texture: Texture
@export var description: String

@export var price_label: RichTextLabel
@export var texture_button: TextureButton
@export var description_label: RichTextLabel

@export var default_color: Color
@export var unavailiable_color: Color
@export var focused_color: Color
@export var unavailiable_focused_color: Color
@export var bought_color: Color

var have_enough_to_buy: bool


func _ready() -> void:
	modulate = default_color
	
	setup_nodes()
	check_availability()
	
	SpaceshipEventBus.resources_spent.connect(_on_resources_spent)
	
	texture_button.pressed.connect(_on_button_pressed)
	texture_button.focus_entered.connect(_on_focus_entered)
	texture_button.focus_exited.connect(_on_focus_exited)
	texture_button.mouse_entered.connect(_on_focus_entered)
	texture_button.mouse_exited.connect(_on_focus_exited)

func _grab_focus():
	texture_button.grab_focus()

func setup_nodes():
	price_label.text = "%d recursos" %price
	description_label.text = "%s[br]%s" %[title, description]
	texture_button.texture_normal = texture

func check_availability():
	have_enough_to_buy = StatsManager.current_resources >= price
	if !have_enough_to_buy:
		default_color = unavailiable_color
		focused_color = unavailiable_focused_color
		modulate = default_color

func _on_button_pressed():
	if !have_enough_to_buy:
		shake()
		return
	if StatsManager.current_resources >= price:
		modulate = bought_color
		default_color = bought_color
		PowerUps.apply_power_up(effect)
		StatsManager.current_resources -= price
		#EventBus.resources_used.emit()
		SpaceshipEventBus.resources_spent.emit()
		print("aplied")
	else:
		shake()

func shake():
	var original_pos_x = position.x
	var tween = create_tween()
	tween.tween_property(self, "position:x", original_pos_x-4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x+4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x-4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x+4, 0.1)
	tween.tween_property(self, "position:x", original_pos_x, 0.1)

func _on_focus_entered():
	modulate = focused_color

func _on_focus_exited():
	modulate = default_color

func _on_resources_spent():
	check_availability()
