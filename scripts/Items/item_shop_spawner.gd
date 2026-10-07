extends Node2D


func done(_body):
	# if GLOBAL.deck.size() < GLOBAL.deck_size:
		for i in get_children():
			explode(i)
		queue_free()

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	PLAYSFX.crunchyMash()
	fx.global_position = here.global_position
	get_tree().current_scene.add_child(fx)