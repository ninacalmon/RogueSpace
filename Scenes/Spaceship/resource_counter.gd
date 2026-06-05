extends RichTextLabel
class_name ResourceCounter

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var min_tween_duration: float = 1
var max_tween_duration: float = 6

var value: int = 0
var last_int: int = -1

func _ready() -> void:
	text = "[b]%d[/b]/%d" %[0, StatsManager.resources_needed]

func initialize():
	await animate_number()
	SpaceshipEventBus.resource_count_finished.emit()

func animate_number():
	var tween_time: float
	tween_time = min(StatsManager.current_resources/10.0, max_tween_duration)
	SpaceshipEventBus.resource_count_started.emit(tween_time)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_update_text, 0, StatsManager.current_resources, tween_time)
	await tween.finished

func _update_text(v):
	var current_value = int(v)
	text = "[b]%d[/b]/%d" %[current_value, StatsManager.resources_needed]

	if current_value != last_int:
		last_int = current_value
		audio_stream_player.play()
		audio_stream_player.pitch_scale += 0.01
