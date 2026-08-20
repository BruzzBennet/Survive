extends Marker2D

var lvl_1_enemies=[
	preload("res://scenes/pozzap.tscn"),
	]
var lvl_5_enemies=[
	preload("res://scenes/opozzap.tscn"),
	]

var normalplayer: PackedScene = preload("res://scenes/player.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var spawn_this_player: PackedScene = dashplayer

var hp_to_spawn: PackedScene = preload("res://scenes/hp.tscn")
var stamina_to_spawn: PackedScene = preload("res://scenes/Dodge.tscn")
var atk_to_spawn: PackedScene = preload("res://scenes/ShootStamina.tscn")
var spawn_points = []
var current_round: float = 1.0
@onready var rng_map=get_tree().current_scene.get_node("RNG_Map")
@onready var enemies = rng_map.enemies

func get_enemies_by_level(lvl:int):
	var enemy_list
	match lvl:
		1:
			enemy_list=lvl_1_enemies
		5:
			enemy_list=lvl_5_enemies
	return enemy_list

func spawn_enemy(lvl:int) -> void:
	var enemy_list=get_enemies_by_level(lvl)
	var spawn_this_enemy=enemy_list[randi_range(0, enemy_list.size() - 1)]
	var enemy=spawn_this_enemy.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	var hitbox = enemy.get_node("HurtBox")
	hitbox.died.connect(enemy_died.bind(enemy))

func enemy_died(enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		rng_map.call_deferred("next_round")

func spawn_player():
	var atk = atk_to_spawn.instantiate()
	get_tree().current_scene.add_child(atk)
	atk.setup(GLOBAL.weapon)
	atk.position = Vector2(270, 2)

	var hp = hp_to_spawn.instantiate()
	get_tree().current_scene.add_child(hp)
	hp.position = Vector2(305, 2)
	
	var stamina = stamina_to_spawn.instantiate()
	get_tree().current_scene.add_child(stamina)
	stamina.position = Vector2(355, 18)

	var player = spawn_this_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = global_position
	player.get_node("BulletManager").setup(GLOBAL.weapon)
	player.get_node("Skeleton/Sprite").set_palette(GLOBAL.player_palette)
