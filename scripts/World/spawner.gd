extends Marker2D

@export var spawn_this_enemy: PackedScene = preload("res://scenes/pozzap.tscn")
@export var spawn_this_player: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var hp_to_spawn: PackedScene = preload("res://scenes/hp.tscn")
var stamina_to_spawn: PackedScene = preload("res://scenes/Dodge.tscn")
var atk_to_spawn: PackedScene = preload("res://scenes/ShootStamina.tscn")
var spawn_points = []
var current_round: float = 1.0
@onready var rng_map=get_tree().current_scene.get_node("RNG_Map")
@onready var enemies = rng_map.enemies

func spawn_enemy() -> void:
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
	player.get_node("Skeleton/Sprite").set_palette(GLOBAL.player_palette)
