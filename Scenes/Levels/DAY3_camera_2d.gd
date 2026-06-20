extends Camera2D

@export var zoom_speed: float = 0.2
@export var zoom_smoothness: float = 3.0

@export_subgroup("Start Cutscene")
@export var target: Node2D

@export var full_view_zoom: Vector2 = Vector2(0.45, 0.45)
@export var full_view_pos: Vector2 = Vector2(0.0, -500)
@export var full_view_duration: float = 1.0
@export var zoom_in_speed: float = 4.0

@onready var zoom_in_cutscene_sfx: AudioStreamPlayer = $"../SFX/ZoomInCutsceneSFX"

const default_zoom: Vector2 = Vector2(1, 1)

var min_zoom = 0.1 #0.6 
var max_zoom = 4.5
var target_zoom: Vector2 = default_zoom

@export var deactivate_cutscene: bool = false

func _ready():
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("Boss_Group")
	
	target_zoom = Vector2(1, 1)
	if !deactivate_cutscene:
		start_cutscene()
	else: Globals.is_cutscene = false


func start_cutscene():
	EventBus.cutscene_on.emit()
	zoom = full_view_zoom
	position += full_view_pos
	await get_tree().create_timer(full_view_duration).timeout
	SFXManager.play_sound(zoom_in_cutscene_sfx)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "zoom", Vector2(0.6, 0.6), zoom_in_speed)
	tween.parallel().tween_property(self, "position", target.global_position + Vector2(0, -50), zoom_in_speed)
	await tween.finished
	EventBus.start_planet_break.emit()

	await get_tree().create_timer(12).timeout

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "zoom", Vector2.ONE, zoom_in_speed)
	tween.parallel().tween_property(self, "position", Vector2.ZERO, zoom_in_speed)
	await tween.finished
	
	EventBus.cutscene_off.emit()
