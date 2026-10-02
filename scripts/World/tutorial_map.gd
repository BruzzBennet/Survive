extends Node2D

var item=[
			preload("res://resources/items/Suit_MR.tres"),
			preload("res://resources/items/Blade_1.tres"),
			preload("res://resources/items/Gun_Lazer.tres"),
			preload("res://resources/items/Boot_1.tres"),
			]

func _ready():
	BGM.playOverworldMusic()
	$PlayerSpawn.spawn_player(true)
	var index=0
	for i in $BaseCards.get_children():
		i.add_item(item[index])
		index+=1
