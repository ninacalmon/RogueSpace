class_name PowerUpList
extends VBoxContainer

@export var power_up_options_array: Array[PowerUpSetup]

var is_on: bool

@onready var power_up_pop_up_sfx: AudioStreamPlayer = $PowerUpPopUpSFX

func initialize() -> void:
	if is_on:
		return
	await get_tree().create_timer(1).timeout
	show_power_ups()

func show_power_ups():
	for p in power_up_options_array:
		p.show()
		SFXManager.play_sound(power_up_pop_up_sfx)
		await flash(p, p.modulate)
	is_on = true
	var first_pu: PowerUpSetup = power_up_options_array.get(0)
	first_pu._grab_focus()

func hide_power_ups():
	for p in power_up_options_array:
		p.hide()

func flash(what: Control, original_color):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(what, "modulate", Color(0, 0, 0, 1), 0.04)
	tween.tween_property(what, "modulate", Color(10, 10, 10, 10), 0.1)
	tween.tween_property(what, "modulate", original_color, 0.4)
	await tween.finished
