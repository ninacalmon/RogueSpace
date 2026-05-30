extends Area2D
class_name MotherShipEntrance

@export var disable: bool = true
@onready var door_sfx: AudioStreamPlayer = $DoorSFX
var door_sfx_pitch: float

var is_entering: bool

func _ready() -> void:
	door_sfx_pitch = door_sfx.pitch_scale
	Globals.changing_scene = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: RigidBody2D):
	if !(body is Player):
		return
	if disable:
		return
	if StatsManager.current_resources < StatsManager.resources_needed:
		var resources_you_need: int = StatsManager.resources_needed - StatsManager.current_resources
		PopUpSystem.show_text("Colete [b]%d[/b] ou mais recursos para retornar à nave-mãe." %resources_you_need, 5)
	EventBus.mothership_entrance_entered.emit()


func _on_body_exited(body: RigidBody2D):
	if body is Player:
		disable = false
		EventBus.mothership_entrance_exited.emit()

func _input(event: InputEvent) -> void:
	if Globals.is_cutscene:
		return
	if event.is_action_pressed("confirm"):
		if StatsManager.current_resources < StatsManager.resources_needed:
			## feebback!!
			door_sfx.pitch_scale = 5
			SFXManager.play_sound(door_sfx)
			door_sfx.pitch_scale = door_sfx_pitch
			return
		if !is_entering:
			is_entering = true
			EventBus.player_wants_to_enter_mothership.emit()
			Globals.changing_scene = true
			SFXManager.play_sound(door_sfx)
			LevelTransition.change_scene_to("res://Scenes/Levels/spaceship_interior.tscn", 1.2)
