extends Node2D

@export var weapon:=false

func done(_body):
	# if !weapon:
	# 	print("!weapon")
	# 	do_it()
	# elif GLOBAL.deck.size()<GLOBAL.deck_size:
	# 	print("no weapon")
		do_it()
		

func do_it():
	for i in get_children():
		explode(i)
	queue_free()

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	PLAYSFX.crunchyMash()
	fx.global_position = here.global_position
	get_tree().current_scene.add_child(fx)
