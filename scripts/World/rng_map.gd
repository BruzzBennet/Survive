extends Node2D

@export var max_lvl: int = 3
@export var max_lvl_n = [13,31,17,18]
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
			preload("res://assets/Tiles/Tiles4.png"),
			preload("res://assets/Tiles/Tiles5.png")
		]
var enemy_difficulty:= 1
var first_player_starting_point
var current_level
var max_enemy_amount:= 24
var portal_points = []
var level_treshold = 3

func _ready() -> void:
	print(str(GLOBAL.current_level))
	if GLOBAL.starting_enemy_amount<max_enemy_amount and several_enemies_level():
			GLOBAL.starting_enemy_amount += 1
	current_level=GLOBAL.current_level
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	create_map()
	spawn(1,GLOBAL.starting_enemy_amount,[])

func portal_opens(spawner_point):
	var portal = preload("res://scenes/boxes/summon_spot.tscn").instantiate()
	add_child(portal)
	portal.global_position = spawner_point

func next_round():
	remove_items()
	GLOBAL.current_level+=1
	if GLOBAL.starting_enemy_amount<max_enemy_amount:
		# GLOBAL.increase_dificulty +=0.5
		# if GLOBAL.increase_dificulty >= 1.5:
		if several_enemies_level():
			GLOBAL.starting_enemy_amount += 1
	# 		GLOBAL.increase_dificulty = 0.0
	# if current_level % 3 == 0:
	PLAYSFX.portal_opens()
	for i in portal_points:
		portal_opens(i)	
	# else:
	# 	spawn(0, GLOBAL.starting_enemy_amount, [])

func transition():
	var transition_node = get_tree().current_scene.get_node("Transition")
	transition_node.color = Color.BLACK
	transition_node.get_node("AnimationPlayer").play("Fade_Out")

func create_map():
	for grid_section in map_grid:
		var difficulty = randi_range(0,(10 + GLOBAL.current_level/6))
		var lvl
		if difficulty < 8:
			lvl = 0
		elif difficulty < 10:
			lvl = 1
		elif difficulty < 11:
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

func several_enemies_level():
	if GLOBAL.current_level%(level_treshold) == 0:
		# print("several enemies level!")
		# print("| current level: "+str(current_level))
		return true
	else:
		return false

func spawn(players: int, enemy_amount: int, spawned_already: Array):
	var times: = 0
	var enemy_level=0
	var max_level
	var max_current_level=round(GLOBAL.current_level/level_treshold)
	for instance in spawn_points:	
		var spawner = instance.get_node_or_null("Spawner")
		if spawner:
			if times == 5:
				if players > 0:
					spawner.spawn_player()
					players -= 1
					spawned_already.append(spawner)
				portal_points.append(spawner.global_position)
			times +=1
			var type = randi_range(0,2)		
			if type == 0 && enemy_amount>0 && !spawned_already.has(spawner):
				if GLOBAL.current_level < (level_treshold*3):
					enemy_level=1
				else:
					max_level=clamp(1+max_current_level,1,max_lvl)
					enemy_level= randi_range(1, max_level)
					if enemy_level > enemy_amount:
						enemy_level=enemy_level-enemy_amount	
				spawner.spawn_enemy(enemy_level)
				enemy_amount -= enemy_level
				spawned_already.append(spawner)
		else:
			print("Spawner not found")
		var item = instance.get_node_or_null("Item")
		if item:
			var do_or_not= randi_range(0,1)
			# if GLOBAL.starting_enemy_amount>=max_enemy_amount and !spawned_already.has(item):
			# 	if do_or_not == 1:
			# 		max_level=clamp(max_current_level,1,max_lvl)
			# 		enemy_level= randi_range(1, max_level)
			# 		item.spawn_enemy(enemy_level)
			# 		spawned_already.append(spawner)
			# 	if do_or_not ==2:
			# 		item.spawn_minole()
			# 		spawned_already.append(spawner)			
			# 	elif do_or_not == 0 :
			# 		item.spawn_item()
			# 		spawned_already.append(item)
			if do_or_not == 0 && !spawned_already.has(item):
				item.spawn_item()	
				spawned_already.append(item)
	if players > 0 or enemy_amount > 0:
		spawn(players, enemy_amount, spawned_already)

func remove_items():
	for instance in spawn_points:
		var item = instance.get_node_or_null("Item")
		if item:
			var item_spawned=item.get_node_or_null("Coin")
			if item_spawned: 
				item_spawned.explode(item_spawned)
				item_spawned.queue_free()

var switching := false


func next_level():
	if switching:
		return

	switching = true
	call_deferred("switch")


func switch() -> void:
	if not is_inside_tree():
		return

	var tree := get_tree()

	GLOBAL.current_level += 1

	if tree.current_scene.scene_file_path != "res://scenes/worlds/rng_world.tscn":
		BGM.playStageMusic()
		tree.change_scene_to_file("res://scenes/worlds/rng_world.tscn")
	else:
		var change_scene_to
		if GLOBAL.current_level % (level_treshold) == 0:
			change_scene_to=0
		else:
			change_scene_to=1
		
		if change_scene_to == 0:
			tree.change_scene_to_file("res://scenes/worlds/shop_world.tscn")
		else:
			tree.change_scene_to_file("res://scenes/worlds/rng_world.tscn")

	# tree.change_scene_to_file("res://scenes/worlds/rng_world.tscn")
