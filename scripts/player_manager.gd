extends Node

@export var player_to_spawn: PackedScene

@export var hp_to_spawn: PackedScene

@export var stamina_to_spawn: PackedScene


func spawn_player(spawn_point):
	var hp=hp_to_spawn.instantiate()
	get_tree().current_scene.add_child(hp)
	hp.position = Vector2(320, 5)
	
	var stamina=stamina_to_spawn.instantiate()
	get_tree().current_scene.add_child(stamina)
	stamina.position = Vector2(370, 21)

	var player=player_to_spawn.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = spawn_point