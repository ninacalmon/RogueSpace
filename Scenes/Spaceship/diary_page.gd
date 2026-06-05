extends VBoxContainer
class_name DiaryPage

@export var head_text: String
@export var main_text: String
@export var sketch_texture: CompressedTexture2D

@onready var day_label: RichTextLabel = $DayLabel
@onready var head_label: RichTextLabel = $HeadLabel
@onready var main_label: RichTextLabel = $MainLabel
@onready var sketch: TextureRect = $SketchTexture

var base_day_text: String

func _ready():
	base_day_text = day_label.text


func setup_page(day: int, data: Dictionary):
	head_label.text = ""
	main_label.text = ""
	sketch.texture = null
	sketch.hide()

	day_label.text = base_day_text.replace("#", str(day))

	head_label.text = data.get("head", "")
	main_label.text = data.get("main", "")

	var tex = data.get("sketch", null)
	if tex:
		sketch.texture = tex
		sketch.show()
