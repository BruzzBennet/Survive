extends Node2D

@export var max_lvl: int = 1
@export var max_lvl_n = [13,31,17,9]
# @export var starting_enemy_amount: int = 1
var map_grid=[Vector2(0,62), 
			Vector2(0,190),
			Vector2(128,62), 
			Vector2(128,190),
			Vector2(256,62), 
			Vector2(256,190),
			Vector2(384,62), 
			Vector2(384,190),
			Vector2(512,62), 
			Vector2(512,190)]
var spawn_points = []
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	create_map()
	spawn(1,GLOBAL.starting_enemy_amount,[])

func portal_opens():
	var portal = preload("res://scenes/boxes/summon_spot.tscn").instantiate()
	add_child(portal)
	portal.global_position = first_player_starting_point

func next_round():
	GLOBAL.current_level+=1
	if GLOBAL.starting_enemy_amount<36:
		GLOBAL.increase_dificulty +=0.5
		if GLOBAL.increase_dificulty >= 1:
			GLOBAL.starting_enemy_amount += 1
			GLOBAL.increase_dificulty = 0.0
	if GLOBAL.current_level % 7 == 0:
		PLAYSFX.portal_opens()
		portal_opens()	
	else:
		spawn(0, GLOBAL.starting_enemy_amount, [])

func transition():
	var transition_node = get_tree().current_scene.get_node("Transition")
	transition_node.color = Color.BLACK
	transition_node.get_node("AnimationPlayer").play("Fade_Out")

func create_map():
	for grid_section in map_grid:
		var difficulty = randi_range(0,(8 + GLOBAL.current_level/7))
		var lvl
		if difficulty < 4:
			lvl = 0
		elif difficulty < 7:
			lvl = 1
		elif difficulty < 9:
			lvl = 2
		else:
			lvl=3
		var lvl_n = max_lvl_n[lvl]
		var n = randi_range(0,lvl_n)
		var section_path="res://assets/maps/Sections/Level" + str(lvl) + "_" + str(n) + ".tscn"
		var section=load(section_path)
		if !section:
			section=load("res://assets/maps/Sections/Level0_0.tscn")
	
		var instance = section.instantiate()
		instance.position = grid_section
		add_child(instance)
		instance.tile_set.get_source(4).texture=map_texture
		spawn_points.append(instance)

func spawn(players: int, enemy_amount: int, spawned_already: Array):
	var times: = 0
	var enemy_level=0
	for instance in spawn_points:	
		var spawner = instance.get_node_or_null("Spawner")
		if players > 0 and times == 0:
			times +=1
			spawner.spawn_player()
			players -= 1
			spawned_already.append(spawner)
			first_player_starting_point=spawner.global_position
		if spawner:
			var type = randi_range(0,2)
			if type == 0 && enemy_amount>0 && !spawned_already.has(spawner):
				var max_level = 4
				if enemy_amount>enemy_level:
					enemy_level= randi_range(1, max_level)
					if enemy_level>enemy_amount:
						enemy_level=max_level-enemy_amount
				spawner.spawn_enemy(enemy_level)
				enemy_amount -= enemy_level
				spawned_already.append(spawner)
		else:
			print("Spawner not found")
	if players > 0 and spawned_already.size()<9 or enemy_amount > 0 and spawned_already.size()<9:
		spawn(players, enemy_amount, spawned_already)
