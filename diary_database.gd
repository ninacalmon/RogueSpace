extends Node

var pages := {
	0: {
		"left": {
			"head": "[b]Primeiro log.",
			"main": "Vasily costumava manter um diário de bordo da expedição. Agora que estou sozinho, acho que essa tarefa passou para mim.",
			"sketch": preload("res://sprites/spaceship_interior/drawingTest.png")
		},
		"right": {
			"main": "Meu nome é Deimos.

Sou ex-tripulante, agora capitão, da espaçonave Ikarus.

Meu dia-a-dia por aqui se resume a coletar fragmentos para alimentar a nave e mantê-la funcionando. Não é uma tarefa fácil de se fazer sozinho, às vezes sinto falta deles...",
			"sketch": null
		}
	},

	1: {
		"left": {
			"head": "[b]De mal a pior!",
			"main": "Ikarus está funcionando à base de aparelhos, e a cada dia parece precisar de mais e mais fragmentos para manter-se semi-funcional.

Ah! Aquelas pestes nojentas estão por toda parte no espaço! É um tremendo estorvo ter de matá-las, mas ao menos, contribuem para o momento mais feliz do meu dia: quando posso desossa-las e preparar uma bela sopa!",
			"sketch": null
		},
		"right": {
			"main": "Bem, preciso ir descansar.

Amanhã devo coletar fragmentos extra para me preparar...",
			"sketch": preload("res://sprites/spaceship_interior/drawing_day1_3.png")
		}
	},

	2: {
		"left": {
			"head": "[b]Preparativos.",
			"main": "Amanhã é o grande dia, o que coletei lá fora deve ser o bastante pra me ajudar.

Não vou mentir, estou me sentindo mal. Preciso concentrar meus pensamentos em coisas boas.

Finalmente poderei retomar a missão, [b]retomar a missão com Ela!",
			"sketch": null
		},
		"right": {
			"main": "Se ao menos alguém estivesse aqui para ver… Uma pena que eles tenham escolhido aquele final…

Acho que estou pronto.",
			"sketch": preload("res://sprites/spaceship_interior/drawing_day3.png")
		}
	},

	3: {
		"left": {
			"head": "[b]Sim!",
			"main": "Consegui, finalmente consegui!

A Matriarca está aqui comigo. Sua gloriosa carcaça proverá energia o suficiente para me conceder novamente o acesso às coordenadas.

Enfim darei sequência à expedição. [b]Sim! A fonte do sinal será encontrada.",
			"sketch": null
		},
		"right": {
			"main": "",
			"sketch": preload("res://sprites/spaceship_interior/drawing_day4.png")
		}
	}
}

const EMPTY_DAY := {
	"left": {
		"head": "",
		"main": "",
		"sketch": null
	},
	"right": {
		"main": "",
		"sketch": null
	}
}

#var pages: Dictionary = {
	#0: {
		#"head": "",
		#"main": "",
		#"sketch": null
	#},
	#
	#1: {
		#"head": "[b]Primeiro log.",
		#"main": "Vasily costumava manter um diário de bordo da expedição. Agora que estou sozinho, acho que essa tarefa passou para mim.
#
#A Icarus está funcionando à base de aparelhos, cada vez mais tenho saído apenas para coletar os fragmentos para mantê-la operacional.
#
#Isso está ficando cansativo.",
		#"sketch": null
	#},
#
	#2: {
		#"head": "[b]Eu odeio insetos!",
		#"main": "O sistema de aquecimento da nave quebrou há alguns dias e só agora consegui arrumar.
 #
#A pior parte de tudo são aquelas pestes, que mesmo servindo como almoço, são um grande estorvo.",
		#"sketch": preload("res://sprites/spaceship_interior/drawingTest.png")
	#},
#
	#3: {
		#"head": "[b]Eu amo comer insetos...",
		#"main": "Aprendi a preparar uma sopa deliciosa com esses pestinhas. Vou anotar a receita aqui por precaução:",
		#"sketch": preload("res://sprites/spaceship_interior/DesenhoDiario.png")
	#}
#}
#
#const EMPTY_PAGE: Dictionary = {
	#"head": "",
	#"main": "",
	#"sketch": null
#}

func get_day(day: int) -> Dictionary:
	return pages.get(day, EMPTY_DAY)
