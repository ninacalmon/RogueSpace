extends Control

@onready var counter: RichTextLabel = $Counter
@onready var button: Button = $Button
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var value: int = 0
var last_int: int = -1

var can_progress: bool

func _ready() -> void:
	can_progress = Globals.resources_gathered >= Globals.resources_needed
	button.pressed.connect(_on_button_pressed)
	
	button.disabled = true
	button.hide()
	
	counter.text = "[b]%d[/b]/%d" %[0, Globals.resources_needed]
	await animate_number()
	show_button()

func animate_number():
	var tween_time: float
	if can_progress:
		tween_time = min(Globals.resources_gathered/10.0, 15.0)
	else: tween_time = max(Globals.resources_gathered/10.0, 5.0)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_update_text, 0, Globals.resources_gathered, tween_time)
	await tween.finished

func _update_text(v):
	var current_value = int(v)
	counter.text = "[b]%d[/b]/%d" %[current_value, Globals.resources_needed]

	if current_value != last_int:
		last_int = current_value
		audio_stream_player.play()
		audio_stream_player.pitch_scale += 0.01

func show_button():
	if can_progress:
		button.text = "Continuar...-->"
	else: button.text = "<--...Tentar novamente"

	button.disabled = false
	button.show()
	button.grab_focus()

func _on_button_pressed():
	if can_progress:
		LevelTransition.change_scene_to("res://Scenes/LevelTest.tscn")
	else:
		LevelTransition.change_scene_to("res://Scenes/LevelTest.tscn")
