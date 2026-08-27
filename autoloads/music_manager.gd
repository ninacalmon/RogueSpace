extends Node

@onready var player_a: AudioStreamPlayer = $PlayerA
@onready var player_b: AudioStreamPlayer = $PlayerB

var active_player: AudioStreamPlayer
var inactive_player: AudioStreamPlayer

var current_track: AudioStream = null

var default_volume: float = 0.0
var default_pitch: float = 1.0

var fade_tween: Tween = null 

var music_map: Dictionary = {
	"res://scenes/levels/menu.tscn": {
		"stream": preload("res://music/msc_menu.mp3"),
		"volume": 0.0,
		"pitch": 1.0
	},
	"res://scenes/levels/Tutorial.tscn": {
		"stream": preload("res://music/msc_main_theme.mp3"),
		"volume": -24.0,
		"pitch": 0.6 
	},
	"res://scenes/levels/Level_Day1.tscn": {
		"stream": preload("res://music/msc_main_theme.mp3"),
		"volume": -20.0,
		"pitch": 1.0
	},
	"res://scenes/levels/Level_Day2.tscn": {
		"stream": preload("res://music/msc_main_theme.mp3"),
		"volume": -20.0,
		"pitch": 1.0
	},
	"res://scenes/levels/Level_Day3.tscn": {
		"stream": preload("res://music/msc_boss_matriarch.mp3"),
		"volume": -12.0,
		"pitch": 1.0
	},
	"res://scenes/cutscenes/cutscene_final2.tscn": {
		"stream": preload("res://music/cutscene_music/msc_final_scene.mp3"),
		"volume": -12.0,
		"pitch": 0.7
	},
	"res://scenes/cutscenes/cutscene_credits.tscn": {
		"stream": preload("res://music/msc_main_theme.mp3"),
		"volume": -17.0,
		"pitch": 0.6
	}
}

@export var fade_time: float = 1.5

func _ready():
	active_player = player_a
	inactive_player = player_b
	
	player_a.volume_db = 0
	player_b.volume_db = -40


func changing_scene(next_scene_path: String):

	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

	if not music_map.has(next_scene_path):
		current_track = null
		await _fade_out_active()
		return
	
	var data = music_map[next_scene_path]
	var new_track: AudioStream = data.stream
	
	if new_track == current_track:

		active_player.volume_db = data.get("volume", 0.0)
		return
	
	current_track = new_track
	_crossfade_to(data)


func _crossfade_to(data: Dictionary):
	var stream: AudioStream = data.stream
	var bus: String = "Music"
	var target_volume: float = data.get("volume", 0.0)
	var pitch: float = data.get("pitch", 1.0)
	
	inactive_player.stream = stream
	inactive_player.bus = bus
	inactive_player.pitch_scale = pitch
	
	inactive_player.volume_db = -40.0
	inactive_player.play()
	
	var old_active = active_player
	var new_active = inactive_player
	
	active_player = new_active
	inactive_player = old_active

	default_volume = target_volume
	default_pitch = pitch

	fade_tween = create_tween()
	fade_tween.tween_property(old_active, "volume_db", -40.0, fade_time)
	fade_tween.parallel().tween_property(new_active, "volume_db", target_volume, fade_time)
	
	await fade_tween.finished
	
	if old_active and not old_active == active_player:
		old_active.stop()


func _fade_out_active():
	fade_tween = create_tween()
	fade_tween.tween_property(active_player, "volume_db", -40.0, fade_time)
	await fade_tween.finished
	active_player.stop()


func set_pause_music(paused: bool):
	if active_player == null:
		return
	
	var pause_tween = create_tween()
	pause_tween.set_trans(Tween.TRANS_SINE)
	pause_tween.set_ease(Tween.EASE_IN_OUT)
	
	if paused:
		pause_tween.tween_property(active_player, "pitch_scale", 0.6, 0.5)
		pause_tween.parallel().tween_property(active_player, "volume_db", default_volume - 10.0, 0.5)
	else:
		pause_tween.tween_property(active_player, "pitch_scale", default_pitch, 0.5)
		pause_tween.parallel().tween_property(active_player, "volume_db", default_volume, 0.5)
