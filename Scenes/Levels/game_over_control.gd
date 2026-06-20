extends Control
class_name GameOverScene

@export var background_texture: TextureRect
@export var sub_text: RichTextLabel
@onready var pressable: VBoxContainer = $CanvasLayer/Pressable

var cause_of_death: String

func _ready() -> void:
	InputGuide.clear_guides()
	PopUpSystem.clear()


#func initialize() -> void:
	#var death_cause_texture: Texture = background_texture.texture
	#var death_cause_text: String = sub_text.text
	#
	#match cause_of_death:
		#"Out of Fuel":
			#death_cause_text =  "SEM COMBUSTÍVEL, Deimos vagou pelo espaço sideral por tempo imesurável."
			#death_cause_texture = preload("res://Sprites/background.png")
		#"Enemy: Basic":
			#death_cause_text = "TRAÇAS DESGRAÇADAS, devoraram Deimos até seu fim."
			#death_cause_texture = preload("res://Sprites/panorama6.jpg")
	#
	#sub_text.text = death_cause_text
	#background_texture.texture = death_cause_texture
