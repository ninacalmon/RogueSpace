extends Node

var pages: Dictionary = {
	0: {
		"head": "",
		"main": "",
		"sketch": null
	},
	
	1: {
		"head": "[b]Primeiro log.",
		"main": "Vasily costumava manter um diário de bordo da expedição. Agora que estou sozinho, acho que essa tarefa passou para mim.

A Icarus está funcionando à base de aparelhos, cada vez mais tenho saído apenas para conseguir recursos para mantê-la operacional.

Isso está ficando cansativo.",
		"sketch": null
	},

	2: {
		"head": "[b]Eu odeio insetos!",
		"main": "O sistema de aquecimento da nave quebrou há alguns dias e só agora consegui arrumar.
 
A pior parte de tudo são aquelas pestes, que mesmo servindo como almoço, são um grande estorvo.",
		"sketch": preload("res://Sprites(main)/SpaceshipInterior/drawingTest.png")
	},

	3: {
		"head": "[b]Eu amo comer insetos...",
		"main": "Aprendi a preparar uma sopa deliciosa com esses pestinhas. Vou anotar a receita aqui por precaução:",
		"sketch": preload("res://Sprites(main)/SpaceshipInterior/DesenhoDiario.png")
	}
}

const EMPTY_PAGE: Dictionary = {
	"head": "",
	"main": "",
	"sketch": null
}

func get_page(day: int) -> Dictionary:
	return pages.get(day, EMPTY_PAGE)
