extends Node2D

@export var camera: Camera2D

@onready var hands_animation: AnimatedSprite2D = $HandsAnimation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum HandState { IDLE, NEGATIVE, MACHINE, BOOK_NEXT, BOOK_PREV, SNOT }

func _ready() -> void:
	SpaceshipEventBus.focus_off.connect(_on_focus_off)
	
	HandsEventBus.machine_interaction.connect(_on_machine_interaction)
	HandsEventBus.monitor.connect(_on_monitor)
	HandsEventBus.door_interaction.connect(_on_door_interacted)
	hands_animation.play("Idle")

func _on_focus_off():
	animation_player.play("RESET")
	hands_animation.play("Idle")

func _on_machine_interaction():
	animation_player.play("machine_interact")
	hands_animation.play("MachineInteract")
	await hands_animation.animation_finished
	animation_player.play("RESET")
	hands_animation.play("Idle")

func _on_monitor(state: bool):
	if state:
		animation_player.play("monitor")
	elif !state:
		animation_player.play("RESET")

func _on_door_interacted():
	hands_animation.play("Nananinanao")
	await hands_animation.animation_finished
	hands_animation.play("Idle")

func _process(_delta: float) -> void:
	global_position = camera.global_position + camera.offset
