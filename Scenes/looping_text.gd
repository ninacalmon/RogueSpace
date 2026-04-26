extends HBoxContainer

@onready var text1 = $LoopingText
@onready var text2 = $LoopingText2
@onready var text3 = $LoopingText3

var speed := 100.0

func _process(delta):
	position.x -= speed * delta

	# largura de UM bloco de texto
	var width = get_combined_minimum_size().x / 3

	# quando sair completamente, reseta
	if position.x <= -width:
		position.x = 0
