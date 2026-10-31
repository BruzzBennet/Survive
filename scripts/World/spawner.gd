extends Marker2D

var lvl_1_enemies=[
	preload("res://scenes/enemies/Icie.tscn")
	]
var lvl_2_enemies=[
	preload("res://scenes/enemies/chomwing.tscn")
	]
var lvl_3_enemies=[
	preload("res://scenes/enemies/Bombry.tscn")
]
var lvl_4_enemies=[
	preload("res://scenes/enemies/pucklam.tscn"),
	preload("res://scenes/enemies/clamik.tscn")
	]
var lvl_5_enemies=[
	preload("res://scenes/pozzap.tscn")
	]
var lvl_6_enemies=[
	preload("res://scenes/opozzap.tscn")
	]


var items=[
	preload("res://scenes/items/healing_item.tscn"),
	preload("res://scenes/items/coin.tscn"),
	preload("res://scenes/items/recharge_item.tscn"),
	preload("res://scenes/items/coin.tscn"),
	preload("res://scenes/items/recharge_item.tscn"),
	preload("res://scenes/items/coin.tscn")
	]

var spawn_this_player: PackedScene = GLOBAL.player_type

var spawn_points = []
var current_round: float = 1.0
var rng_map
var enemies = []

func _ready():
	if get_tree().current_scene.get_node_or_null("RNG_Map"):
		rng_map=get_tree().current_scene.get_node("RNG_Map")
		enemies = rng_map.enemies
	

func get_enemies_by_level(lvl:int):
	var enemy
	match lvl:
		1:
			enemy=preload("res://scenes/enemies/Icie.tscn")
		2:
			enemy=preload("res://scenes/enemies/chomwing.tscn")
		3:
			enemy=preload("res://scenes/enemies/Bombry.tscn")
		4:
			enemy=preload("res://scenes/enemies/pucklam.tscn")
		5:
			enemy=preload("res://scenes/enemies/clamik.tscn")
		6:
			enemy=preload("res://scenes/pozzap.tscn")
		7:
			enemy=preload("res://scenes/opozzap.tscn")
	return enemy

func spawn_enemy(lvl:int) -> void:
	# var enemy_list=get_enemies_by_level(lvl)
	# var spawn_this_enemy=enemy_list[randi_range(0, enemy_list.size() - 1)]
	# spawn_this_enemy=preload("res://scenes/opozzap.tscn")
	# var enemy=spawn_this_enemy.instantiate()
	var enemy=get_enemies_by_level(lvl).instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	var hitbox = enemy.get_node("HurtBox")
	hitbox.died.connect(enemy_died.bind(enemy))

func enemy_died(enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		rng_map.call_deferred("next_level")

func spawn_player(_first_time=false):
	var player_ui = preload("res://scenes/henshin_menu/henshin_menu.tscn").instantiate()
	get_tree().current_scene.add_child(player_ui)
	player_ui.position=Vector2(0,0)

	var player = spawn_this_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = global_position
	player.equip(GLOBAL.suit,GLOBAL.weapon)


func spawn_item() -> void:
	var spawn_this_enemy=items[randi_range(0, items.size() - 1)]
	var item=spawn_this_enemy.instantiate()
	add_child(item)
	item.global_position = global_position
