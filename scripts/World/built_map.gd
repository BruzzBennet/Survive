extends Node2D

@onready var spawn_points = $Spawner.get_children()
var enemies = []
var starting_player_amount: int = 1
var map_texture
var tile_maps =[
			preload("res://assets/Tiles/Tiles.png"),
			preload("res://assets/Tiles/Tiles1.png"),
			preload("res://assets/Tiles/Tiles2.png"),
			preload("res://assets/Tiles/Tiles3.png"),
			preload("res://assets/Tiles/Tiles4.png")
		]
var enemy_difficulty:= 1
var first_player_starting_point
var current_level=0

func _ready() -> void:
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	spawn(1,GLOBAL.starting_enemy_amount,[])


func portal_opens():
	var portal = preload("res://scenes/boxes/summon_spot.tscn").instantiate()
	add_child(portal)
	portal.global_position = first_player_starting_point

func next_round():
	current_level+=1
	if GLOBAL.starting_enemy_amount<36:
		GLOBAL.increase_dificulty +=0.5
		if GLOBAL.increase_dificulty >= 1:
			GLOBAL.starting_enemy_amount += 1
			GLOBAL.increase_dificulty = 0.0
	if current_level % 3 == 0:
		PLAYSFX.portal_opens()
		portal_opens()	
	else:
		spawn(0, GLOBAL.starting_enemy_amount, [])

func spawn(players: int, enemy_amount: int, spawned_already: Array):
	var times: = 0
	var enemy_level=0
	for instance in spawn_points:	
		var spawner = get_node_or_null("Spawner")
		if players > 0 and times == 0:
			times +=1
			spawner.spawn_player(instance.global_position)
			players -= 1
			spawned_already.append(instance)
			first_player_starting_point=instance.global_position
		if spawner:
			var type = randi_range(0,2)
			if type == 0 && enemy_amount>0 && !spawned_already.has(instance):
				var max_level = 4
				if enemy_amount>enemy_level:
					enemy_level= randi_range(1, max_level)
					if enemy_level>enemy_amount:
						enemy_level=max_level-enemy_amount
				spawner.spawn_enemy(enemy_level, instance.global_position)
				enemy_amount -= enemy_level
				spawned_already.append(instance)
		else:
			print("Spawner not found")
	if players > 0 and spawned_already.size()<9 or enemy_amount > 0 and spawned_already.size()<9:
		spawn(players, enemy_amount, spawned_already)
