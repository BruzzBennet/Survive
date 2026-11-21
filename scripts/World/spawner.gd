extends Marker2D

var player_ui = preload("res://scenes/henshin_menu/henshin_menu.tscn").instantiate()

var spawn_this_player: PackedScene = GLOBAL.player_type
var spawn_points = []
var current_round: float = 1.0
var rng_map
var enemies = []
var mimin=GLOBAL.mimin
var items=GLOBAL.items
var zoo=GLOBAL.zoo

func _ready():
	if get_tree().current_scene.get_node_or_null("RNG_Map"):
		rng_map=get_tree().current_scene.get_node("RNG_Map")
		enemies = rng_map.enemies

func get_enemies_by_level(lvl:int):
	var enemy
	enemy=mimin[lvl-1]
	return enemy

func spawn_enemy(lvl:int) -> void:
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
	get_tree().current_scene.add_child(player_ui)
	player_ui.position=Vector2(0,0)

	var player = spawn_this_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = global_position
	player.equip(GLOBAL.suit,GLOBAL.weapon)


func spawn_item() -> void:
	var item_or_mon = randi_range(0,1)
	var spawn_this_enemy
	if item_or_mon==0:
		spawn_this_enemy=items[randi_range(0, items.size() - 1)]
	else:
		spawn_this_enemy=zoo[randi_range(0, zoo.size() - 1)]
	var item=spawn_this_enemy.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = global_position

func spawn_zoo() -> void:
	var spawn_this_enemy=zoo[randi_range(0, zoo.size() - 1)]
	var item=spawn_this_enemy.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = global_position
