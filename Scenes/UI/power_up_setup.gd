extends VBoxContainer

@export_enum("Impulse", "Fuel", "Teleport") var effect: String
@export var title: String
@export var price: int = 100
@export var texture: Texture
@export var description: String

@export var price_label: RichTextLabel
@export var texture_button: TextureButton
@export var description_label: RichTextLabel

@onready var default_color: Color = modulate
var not_focused_color: Color = Color(1.0, 1.0, 1.0, 0.3)

var have_enough_to_buy: bool

func _ready() -> void:
	modulate = not_focused_color
	
	setup_nodes()
	check_availability()
	
	texture_button.pressed.connect(_on_button_pressed)
	texture_button.focus_entered.connect(_on_focus_entered)
	texture_button.focus_exited.connect(_on_focus_exited)
	texture_button.mouse_entered.connect(_on_focus_entered)
	texture_button.mouse_exited.connect(_on_focus_exited)

func setup_nodes():
	price_label.text = "%d recursos" %price
	description_label.text = "%s[br]%s" %[title, description]
	texture_button.texture_normal = texture

func check_availability():
	have_enough_to_buy = Globals.resources_gathered >= price
	if !have_enough_to_buy:
		texture_button.modulate = Color(0.0, 0.0, 0.0, 0.4)

func _on_button_pressed():
	if !have_enough_to_buy:
		shake()
		return
	if Globals.resources_gathered >= price:
		modulate = Color(0.153, 0.212, 0.086)
		PowerUps.apply_power_up(effect)
		Globals.resources_gathered -= price
		EventBus.resources_used.emit()
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
	self_modulate = default_color

func _on_focus_exited():
	self_modulate = not_focused_color
