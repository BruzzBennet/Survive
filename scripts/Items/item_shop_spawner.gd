extends Node2D


func done():
	explode($Suit)
	explode($Weapon)
	explode($Item)

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	fx.global_position = here.global_position
	get_tree().current_scene.add_child(fx)
	queue_free()