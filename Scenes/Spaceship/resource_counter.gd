class_name ResourceCounter
extends RichTextLabel

var min_tween_duration: float = 4

var max_tween_duration: float = 8

var value: int = 0

var last_int: int = -1

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	modulate.a = 0
	text = "[b]%d[/b][color=68b820]/%d[/color]" %[0, StatsManager.resources_needed]

func initialize():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)
	await animate_number()
	SpaceshipEventBus.resource_count_finished.emit()


	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)

func animate_number():
	var tween_time: float

	var min_res: int = 100
	var max_res: float = 500

	var t: float = (StatsManager.current_resources - min_res) / (max_res - min_res)
	t = clamp(t, 0.0, 1.0)

	tween_time = lerp(min_tween_duration, max_tween_duration, t)

	SpaceshipEventBus.resource_count_started.emit(tween_time)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_update_text, 0, StatsManager.current_resources, tween_time)
	await tween.finished

func _update_text(v):
	var current_value = int(v)
	text = "[b]%d[/b][color=68b820]/%d[/color]" %[current_value, StatsManager.resources_needed]

	if current_value != last_int:
		last_int = current_value
		audio_stream_player.play()
		audio_stream_player.pitch_scale += 0.01
