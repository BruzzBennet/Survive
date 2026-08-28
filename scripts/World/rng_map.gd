extends Node2D

@export var max_lvl: int = 1
@export var max_lvl_n = [13,31,17]
@export var starting_enemy_amount: int = 1
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
var increase_dificulty: float = 0.0
var enemy_difficulty:= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	create_map()
	spawn(1,starting_enemy_amount,[])

func next_round():
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	transition()
	for section in spawn_points:
		section.queue_free()
	spawn_points.clear()
	create_map()
	if starting_enemy_amount<36:
		increase_dificulty +=0.5
		if increase_dificulty >= 1:
			starting_enemy_amount += 1
			increase_dificulty = 0.0
	spawn(0,starting_enemy_amount,[])	

func transition():
	var transition_node = get_tree().current_scene.get_node("Transition")
	transition_node.color = Color.BLACK
	transition_node.get_node("AnimationPlayer").play("Fade_Out")

func create_map():
	for grid_section in map_grid:
		var difficulty = randi_range(0,5)
		var lvl
		if difficulty < 2:
			lvl = 0
		elif difficulty < 4:
			lvl = 1
		else:
			lvl = 2
		# var lvl = randi_range(0,max_lvl)
		# lvl = 0
		var lvl_n = max_lvl_n[lvl]
		var n = randi_range(0,lvl_n)
		# n = 0
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
	for instance in spawn_points:
		var spawner = instance.get_node_or_null("Spawner")
		if spawner:
			var type = randi_range(0,2)
			if type == 0 && enemy_amount>0 && !spawned_already.has(spawner):
				var enemy_level
				var max_level = 4
				if enemy_amount>=max_level:
					enemy_level= randi_range(1, max_level)
				if enemy_amount<max_level:
					enemy_level=enemy_amount
				if spawned_already.size()>=8:
					enemy_level=max_level
				spawner.spawn_enemy(enemy_level)
				enemy_amount -= enemy_level
				# enemy_amount -=1
				spawned_already.append(spawner)
			if type == 1 && players>0 && !spawned_already.has(spawner):
				spawner.spawn_player()
				players -= 1
				spawned_already.append(spawner)
		else:
			print("Spawner not found")
	if players > 0 or enemy_amount > 0:
		spawn(players, enemy_amount, spawned_already)
