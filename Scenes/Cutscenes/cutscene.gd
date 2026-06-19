extends Control
class_name CutsceneControl

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_progress: TextureProgressBar = $SkipProgress

@export var hold_duration: float = 1
var hold_time: float = 0.0
var decay_speed: = 2


func _ready() -> void:
	InputGuide.clear_guides()
	InputGuide.show_guide(InputGuide.ActionType.SKIP)

	video_stream_player.finished.connect(finish_cutscene)

	setup_bar()

	video_stream_player.play()

func setup_bar():
	skip_progress.max_value = hold_duration
	skip_progress.value = hold_time

func _process(delta: float) -> void:
	var holding: bool = Input.is_action_pressed("return")

	if holding:
		skip_progress.visible = true
		hold_time += delta
	else:
		hold_time -= delta * decay_speed

		if hold_time <= 0.01:
			skip_progress.visible = false

	hold_time = clamp(hold_time, 0.0, hold_duration)

	skip_progress.value = hold_time

	if hold_time >= hold_duration:
		finish_cutscene()

func finish_cutscene():
	video_stream_player.stop()
	LevelTransition.change_scene_to(Globals.next_scene_path)
