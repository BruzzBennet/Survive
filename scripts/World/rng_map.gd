extends Node2D

@export var max_lvl: int = 1
@export var max_lvl_n = [13,27]
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
@export var starting_enemy_amount: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_map()
	spawn(1,starting_enemy_amount,[])

func next_round():
	transition()
	for section in spawn_points:
		section.queue_free()
	spawn_points.clear()
	create_map()
	if starting_enemy_amount<9:
		starting_enemy_amount += 1
	spawn(0,starting_enemy_amount,[])	

func transition():
	var transition_node = get_tree().current_scene.get_node("Transition")
	transition_node.color = Color.BLACK
	transition_node.get_node("AnimationPlayer").play("Fade_Out")

func create_map():
	for grid_section in map_grid:
		var lvl = randi_range(0,max_lvl)
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
		spawn_points.append(instance)

func spawn(players: int, enemy_list: int, spawned_already: Array):
	for instance in spawn_points:
		var spawner = instance.get_node_or_null("Spawner")
		if spawner:
			var type = randi_range(0,2)
			if type == 0 && enemy_list>0 && !spawned_already.has(spawner):
				spawner.spawn_enemy()
				enemy_list -= 1
				spawned_already.append(spawner)
			if type == 1 && players>0 && !spawned_already.has(spawner):
				spawner.spawn_player()
				players -= 1
				spawned_already.append(spawner)
		else:
			print("Spawner not found")
	if players > 0 or enemy_list > 0:
		spawn(players, enemy_list, spawned_already)
