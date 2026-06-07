extends Node

var pages: Dictionary = {
	1: {
		"head": "[b]Lorem ipsum dolor sit amet, consectetur",
		"main": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
		"sketch": preload("res://Sprites(main)/SpaceshipInterior/drawingTest.png")
	},

	2: {
		"head": "[b]Lorem ipsum!",
		"main": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
		
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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
