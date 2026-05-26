extends Area2D
class_name MotherShipEntrance

var check_input: bool = false

@export var disable: bool
@onready var door_sfx: AudioStreamPlayer = $DoorSFX

func _ready() -> void:
	Globals.changing_scene = false
	check_input = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: RigidBody2D):
	if !(body is Player) or \
	StatsManager.current_resources <= 0:
		return
	check_input = true
	if disable:
		return
	EventBus.mothership_entrance_entered.emit()

func _on_body_exited(body: RigidBody2D):
	if body is Player:
		check_input = false
		EventBus.mothership_entrance_exited.emit()

func _input(event: InputEvent) -> void:
	if !check_input:
		return
	if event.is_action_pressed("confirm"):
		EventBus.player_wants_to_enter_mothership.emit()
		check_input = false
		Globals.changing_scene = true
		SFXManager.play_sound(door_sfx)
		LevelTransition.change_scene_to("res://Scenes/Levels/spaceship_interior.tscn", 1.2)
