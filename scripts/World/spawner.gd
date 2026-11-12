extends Marker2D


var items=[
	load("res://scenes/items/coin.tscn"),
	load("res://scenes/items/recharge_item.tscn"),
	load("res://scenes/enemies/icie.tscn"),
	load("res://scenes/enemies/chomwing.tscn"),
	load("res://scenes/enemies/Minole.tscn"),
	load("res://scenes/enemies/pucklam.tscn"),
	load("res://scenes/pozzap.tscn"),
	load("res://scenes/enemies/Bombry.tscn"),
	load("res://scenes/enemies/clamik.tscn"),
	load("res://scenes/opozzap.tscn")
	]

var enemy_list=[
	load("res://scenes/enemies/miminzombie.tscn"),
	load("res://scenes/enemies/mimintank.tscn")
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
			enemy=load("res://scenes/enemies/miminrage.tscn")
		2:
			enemy=load("res://scenes/enemies/miminfast.tscn")
		3:
			enemy=load("res://scenes/enemies/miminzombie.tscn")
		4:
			enemy=load("res://scenes/enemies/miminflyer.tscn")
		5:
			enemy=load("res://scenes/enemies/mimintank.tscn")
	return enemy

func spawn_enemy(lvl:int) -> void:
	# var enemy_list=get_enemies_by_level(lvl)
	# var spawn_this_enemy=enemy_list[randi_range(0, enemy_list.size() - 1)]
	# # spawn_this_enemy=preload("res://scenes/opozzap.tscn")
	# var enemy=spawn_this_enemy.instantiate()

	var enemy=get_enemies_by_level(lvl).instantiate()
	
	# var enemy=load("res://scenes/enemies/miminzombie.tscn").instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	GLOBAL.mimin+=1
	var hitbox = enemy.get_node("HurtBox")
	hitbox.died.connect(enemy_died.bind(enemy))

func spawn_minole():
	var enemy=preload("res://scenes/enemies/Minole.tscn").instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	var hitbox = enemy.get_node("HurtBox")
	hitbox.died.connect(enemy_died.bind(enemy))

func enemy_died(enemy):
	enemies.erase(enemy)
	if GLOBAL.mimin>0:
		GLOBAL.mimin-=1
	if enemies.is_empty():
		rng_map.call_deferred("next_level")

func spawn_player(_first_time=false):
	var player_ui = preload("res://scenes/UI/PlayerUI_2.tscn").instantiate()
	get_tree().current_scene.add_child(player_ui)
	player_ui.position=Vector2(0,0)

	var player = spawn_this_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = global_position
	player.equip(GLOBAL.suit,GLOBAL.weapon)


func spawn_item() -> void:
	var spawn_this_enemy=items[randi_range(0, items.size() - 1)]
	var item=spawn_this_enemy.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = global_position
