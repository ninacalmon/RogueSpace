extends Node

@onready var player_a: AudioStreamPlayer = $PlayerA
@onready var player_b: AudioStreamPlayer = $PlayerB

var active_player: AudioStreamPlayer
var inactive_player: AudioStreamPlayer

var current_track: AudioStream = null

var default_volume: float = 0.0
var default_pitch: float = 1.0

var music_map: Dictionary = {
	"res://Scenes/Levels/menu.tscn": {
		"stream": preload("res://Music/menu__vox_vacui.mp3"),
		"volume": 0.0,
		"pitch": 1.0
		},
		"res://Scenes/Levels/Tutorial.tscn": {
		"stream": preload("res://Music/MainTheme.mp3"),
		"volume": -30.0,
		"pitch": 0.6 
		},
	"res://Scenes/Levels/LevelFinal2.tscn": {
		"stream": preload("res://Music/MainTheme.mp3"),
		"volume": -20.0,
		"pitch": 1.0
		},
	"res://Scenes/Levels/Level_Day3.tscn": {
		"stream": preload("res://Music/BossTheme.mp3"),
		"volume": -12.0,
		"pitch": 1.0
		}
}


@export var fade_time: float = 1.5

func _ready():
	active_player = player_a
	inactive_player = player_b
	
	player_a.volume_db = 0
	player_b.volume_db = -40


func changing_scene(next_scene_path: String):
	print("PATH:", next_scene_path)
	print("HAS:", music_map.has(next_scene_path))
	if not music_map.has(next_scene_path):
		await _fade_players(active_player)
		current_track = null
		print("music manager caí no return")
		return
	
	var data = music_map[next_scene_path]
	var new_track: AudioStream = data.stream
	
	if new_track == current_track:
		return
	
	current_track = new_track
	_crossfade_to(data)
	print("music manager rodei ate o final")


func _crossfade_to(data: Dictionary):
	var stream: AudioStream = data.stream
	var bus: String = "Music"
	var volume: float = data.get("volume", 0.0)
	var pitch: float = data.get("pitch", 1.0)
	
	inactive_player.stream = stream
	inactive_player.bus = bus
	inactive_player.pitch_scale = pitch
	inactive_player.volume_db = -40
	inactive_player.play()
	
	await _fade_players(active_player, inactive_player, volume)
	
	var temp = active_player
	active_player = inactive_player
	inactive_player = temp

	default_volume = volume
	default_pitch = pitch


func _fade_players(active: AudioStreamPlayer, inactive: AudioStreamPlayer = null, target_volume: float = -40.0):
	var tween = create_tween()
	
	if inactive == null:
		tween.tween_property(active, "volume_db", target_volume, fade_time)
		await tween.finished
		active.stop()
		return
	
	tween.tween_property(active, "volume_db", target_volume, fade_time)
	tween.parallel().tween_property(inactive, "volume_db", target_volume, fade_time)
	
	await tween.finished
	
	active.stop()

func set_pause_music(paused: bool):
	if active_player == null:
		return
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	if paused:
		tween.tween_property(active_player, "pitch_scale", 0.6, 0.5)
		tween.parallel().tween_property(active_player, "volume_db", default_volume - 10.0, 0.5)
	else:
		tween.tween_property(active_player, "pitch_scale", default_pitch, 0.5)
		tween.parallel().tween_property(active_player, "volume_db", default_volume, 0.5)
