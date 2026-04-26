extends Node

func play_sound(audio_player: AudioStreamPlayer):
	var new_audio_player = audio_player.duplicate()
	add_child(new_audio_player)
	
	new_audio_player.play()
	
	new_audio_player.finished.connect(func():
		new_audio_player.queue_free()
	)
