extends Node

var pages: Dictionary = {
	1: {
		"head": "[b]Teste dia 1 bla bla",
		"main": "Yapping yapping oi oioi oi oi oi oi!!!!Yapping yapping oi oioi oi oi oi oi!!!!

Yapping yapping oi oioi oi oi oi oi!!!!oi oi oi!!!!",
		"sketch": preload("res://Sprites(main)/SpaceshipInterior/drawingTest.png")
	},

	2: {
		"head": "[b]Teste dia 2 ohmagaaah",
		"main": "Fodaseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
		"sketch": null
	},

	3: {
		"head": "[b]deimos fodido 3",
		"main": "kakakakakkakakakakakakkaka merda fodasse",
		"sketch": preload("res://Sprites(main)/SpaceshipInterior/drawingTest2.png")
	}
}

const EMPTY_PAGE: Dictionary = {
	"head": "",
	"main": "",
	"sketch": null
}

func get_page(day: int) -> Dictionary:
	return pages.get(day, EMPTY_PAGE)
