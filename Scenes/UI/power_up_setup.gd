extends VBoxContainer
class_name PowerUpSetup

@export_enum("Impulse", "Fuel", "Teleport", "Health", "Propulsors", "Bullet") var effect: String
@export var title: String
@export var price: int = 100
@export var texture: Texture
@export var description: String
@export var max_level: int = 1

@export var price_label: RichTextLabel
@export var texture_button: TextureButton
@export var description_label: RichTextLabel

@export var default_color: Color
@export var unavailiable_color: Color
@export var focused_color: Color
@export var unavailiable_focused_color: Color
@export var bought_color: Color

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var bought_power_up: AudioStreamPlayer = $BoughtPowerUp

var have_enough_to_buy: bool
var current_level: int

var custom_tooltip_text

func _ready() -> void:
	modulate = default_color
	
	setup_nodes()
	check_availability()
	
	SpaceshipEventBus.resources_spent.connect(_on_resources_spent)
	
	texture_button.pressed.connect(_on_button_pressed)
	texture_button.focus_entered.connect(_on_focus_entered)
	texture_button.focus_exited.connect(_on_focus_exited)
	#texture_button.mouse_entered.connect(_on_focus_entered)
	#texture_button.mouse_exited.connect(_on_focus_exited)

func _grab_focus():
	texture_button.grab_focus()

func setup_nodes():
	price_label.text = "%d recursos" %price
	description_label.text = "%s[br]* %s *" %[title, description]
	var next_level: int = min(current_level + 1, max_level)
	var next_level_string: String = str(next_level)
	description_label.text = description_label.text.replace("&", next_level_string)
	texture_button.texture_normal = texture

func check_availability():
	have_enough_to_buy = StatsManager.current_resources >= price
	if !have_enough_to_buy:
		deactivate_buying("Not enough resources")
	if current_level >= max_level:
		deactivate_buying("Already at max level")

func deactivate_buying(reason: String):
	default_color = unavailiable_color
	focused_color = unavailiable_focused_color
	modulate = default_color
	if reason == "Not enough resources":
		custom_tooltip_text = "Sem recursos suficientes. [color=68b820]%d / %d[/color] recursos" %[StatsManager.current_resources, price]
	if reason == "Already at max level":
		custom_tooltip_text = "Já alcançou o nível máximo. nível [color=68b820]%d / %d[/color]" %[current_level, max_level]

func _on_button_pressed():
	if !have_enough_to_buy:
		shake()
		return
	buy_power_up()



func buy_power_up():
	current_level += 1
	modulate = bought_color
	default_color = bought_color
	PowerUps.apply_power_up(effect)
	StatsManager.current_resources -= price
	SpaceshipEventBus.resources_spent.emit()
	progress_bar.show()
	SFXManager.play_sound(bought_power_up)
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", progress_bar.max_value, 1)
	await tween.finished
	progress_bar.hide()
	
	


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
	if custom_tooltip_text:
		CustomTooltip.show_tooltip(custom_tooltip_text, self.global_position)

func _on_focus_exited():
	modulate = default_color
	if custom_tooltip_text:
		CustomTooltip.hide_tooltip()

func _on_resources_spent():
	check_availability()
