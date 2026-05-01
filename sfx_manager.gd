extends Node


func play_sound(audio_player: AudioStreamPlayer):
	if !get_tree().current_scene or !audio_player:
		return                                                                                                                                                                                                                                  
	var new_audio_player: AudioStreamPlayer = audio_player.duplicate()
	get_tree().current_scene.add_child(new_audio_player)
	
	new_audio_player.play()
	
	new_audio_player.finished.connect(func():
		if new_audio_player and is_instance_valid(new_audio_player):
			queue_free_audio_player(new_audio_player))

func queue_free_audio_player(audio_player: AudioStreamPlayer):
	if audio_player and is_instance_valid(audio_player):
		audio_player.queue_free()
