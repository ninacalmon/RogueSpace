extends AnimationPlayer

var current_index: int = 1
var waiting_for_input: bool = false
var is_playing_animation: bool = false

@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	Globals.next_scene_path = "res://Scenes/start_limbo.tscn"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#music.play()
	play("context1")
	is_playing_animation = true
	animation_finished.connect(_on_animation_finished)
	animation_started.connect(_on_animation_started)

func _on_animation_finished(_anim_name: StringName) -> void:
	is_playing_animation = false
	waiting_for_input = true

func _on_animation_started(anim: String):
	match anim:
		"context1": music.stream = preload("res://Music/musicsCutscene/cena1cutscene.wav")
		"context2" : music.stream = preload("res://Music/musicsCutscene/cena2cutscene.wav")
		"context3" : music.stream = preload("res://Music/musicsCutscene/cena3cutscene.wav")
		"context4" : music.stream = preload("res://Music/musicsCutscene/cena4cutscene.mp3")
		"context5" : music.stream = preload("res://Music/musicsCutscene/cena5cutscene.mp3")
	music.stop()
	music.play()

func _input(event: InputEvent) -> void:
	if not waiting_for_input:
		return
	
	if event.is_action_pressed("confirm"):
		advance_animation()

func advance_animation() -> void:
	waiting_for_input = false
	current_index += 1

	if current_index > 5:
		return

	var next_anim := "context%d" % current_index
	play(next_anim)
	is_playing_animation = true
