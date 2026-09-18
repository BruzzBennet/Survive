extends Node2D

var lvl_1_enemies=[
	preload("res://scenes/enemies/Icie.tscn")
	]
var lvl_2_enemies=[
	preload("res://scenes/enemies/chomwing.tscn"),
	]
var lvl_3_enemies=[
	preload("res://scenes/pozzap.tscn")
]
var lvl_4_enemies=[
	preload("res://scenes/opozzap.tscn"),
	]

var normalplayer: PackedScene = preload("res://scenes/player.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var spawn_this_player: PackedScene = dashplayer

var hp_to_spawn: PackedScene = preload("res://scenes/hp.tscn")
var stamina_to_spawn: PackedScene = preload("res://scenes/UI/Run_Stamina.tscn")
var atk_to_spawn: PackedScene = preload("res://scenes/ShootStamina.tscn")
var spawn_points = []
var current_round: float = 1.0
var map
var enemies = []

func _ready():
	if get_tree().current_scene.get_node_or_null("Built_Map"):
		map=get_tree().current_scene.get_node("Built_Map")
	else:
		map=get_parent()
		enemies = map.enemies
	

func get_enemies_by_level(lvl:int):
	var enemy_list
	match lvl:
		1:
			enemy_list=lvl_1_enemies
		2:
			enemy_list=lvl_2_enemies
		3:
			enemy_list=lvl_3_enemies
		4:
			enemy_list=lvl_4_enemies
	return enemy_list

func spawn_enemy(lvl:int, location: Vector2) -> void:
	var enemy_list=get_enemies_by_level(lvl)
	var spawn_this_enemy=enemy_list[randi_range(0, enemy_list.size() - 1)]
	var enemy=spawn_this_enemy.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = location
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	var hitbox = enemy.get_node("HurtBox")
	hitbox.died.connect(enemy_died.bind(enemy))

func enemy_died(enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		map.call_deferred("next_round")

func spawn_player(location:Vector2):
	var atk = atk_to_spawn.instantiate()
	get_tree().current_scene.add_child(atk)
	atk.setup(GLOBAL.weapon)
	atk.position = Vector2(270, 2)

	var hp = hp_to_spawn.instantiate()
	get_tree().current_scene.add_child(hp)
	hp.set_value(GLOBAL.health, false)
	hp.position = Vector2(305, 2)
	
	var player = spawn_this_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = location
	player.equip_weapon(GLOBAL.weapon,GLOBAL.suit)
	player.equip_suit(GLOBAL.suit,GLOBAL.weapon)
