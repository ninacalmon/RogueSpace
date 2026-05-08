extends Area2D

@export var tutorial_warning: TutorialControl

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_warning.label.text = "Mas algumas vezes, seu traje não será suficiente."
		tutorial_warning.show_warning()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		tutorial_warning.hide_warning()
