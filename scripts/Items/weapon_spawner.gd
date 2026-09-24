extends Node2D
var done_once=0.0

func done():
	if done_once<1:
		call_deferred("begin")

func begin():
	done_once+=1
	var start: PackedScene = preload("res://scenes/boxes/summon_spot.tscn")
	var start_spot = start.instantiate()
	start_spot.global_position = Vector2(320,104)
	get_tree().current_scene.add_child(start_spot)
	get_tree().current_scene.move_child(start_spot,1)