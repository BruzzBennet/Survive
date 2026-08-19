extends Node

@export var player_to_spawn: PackedScene
@export var hp_to_spawn: PackedScene
@export var stamina_to_spawn: PackedScene
@export var atk_to_spawn: PackedScene


func spawn_player(spawn_point):
	var atk = atk_to_spawn.instantiate()
	get_tree().current_scene.add_child(atk)
	atk.position = Vector2(270, 2)

	var hp = hp_to_spawn.instantiate()
	get_tree().current_scene.add_child(hp)
	hp.position = Vector2(305, 2)
	
	var stamina = stamina_to_spawn.instantiate()
	get_tree().current_scene.add_child(stamina)
	stamina.position = Vector2(355, 18)

	var player = player_to_spawn.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = spawn_point
	player.get_node("Sprite").set_palette(GLOBAL.player_palette)
