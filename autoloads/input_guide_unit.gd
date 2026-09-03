class_name InputGuideUnit
extends HBoxContainer

@export var texture_rect: TextureRect

@export var text_label: RichTextLabel

var action: int

var icon_array: Array[CompressedTexture2D]

func setup(icon: CompressedTexture2D, text: String, action_type: int):
	action = action_type
	texture_rect.texture = icon
	text_label.text = text

func set_icon(icon: CompressedTexture2D):
	texture_rect.texture = icon
