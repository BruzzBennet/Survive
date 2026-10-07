extends Node2D

# var tile_maps =[
# 			preload("res://assets/Tiles/Tiles.png"),
# 			preload("res://assets/Tiles/Tiles1.png"),
# 			preload("res://assets/Tiles/Tiles2.png"),
# 			preload("res://assets/Tiles/Tiles3.png"),
# 			preload("res://assets/Tiles/Tiles4.png"),
# 			preload("res://assets/Tiles/Tiles5.png")
# 		]
var item = [
			preload("res://scenes/items/suit_item.tscn"),
			preload("res://scenes/items/boot_item.tscn"),
			preload("res://scenes/items/normal_item.tscn"),
			preload("res://scenes/items/gun_item.tscn"),
			preload("res://scenes/items/blade_item.tscn")
		]
var boot = [
			preload("res://resources/items/Boot_1.tres"),
			preload("res://resources/items/Boot_Chomwing.tres"),
			preload("res://resources/items/Boot_Icie.tres"),
			preload("res://resources/items/Boot_Pozzap.tres"),
			preload("res://resources/items/Boot_Bombry.tres")
		]
var gun = [
			preload("res://resources/items/Gun_Lazer.tres"),
			preload("res://resources/items/Gun_Bombry.tres"),
			preload("res://resources/items/Gun_Chomwing.tres"),
			preload("res://resources/items/Gun_Clamik.tres"),
			preload("res://resources/items/Gun_Pozzap.tres")
		]
var blade = [
			preload("res://resources/items/Blade_1.tres"),
			preload("res://resources/items/Blade_Bombry.tres"),
			preload("res://resources/items/Blade_Pozzap.tres"),
			preload("res://resources/items/Blade_Icie.tres"),
			preload("res://resources/items/Blade_Clamik.tres"),
			preload("res://resources/items/Blade_Chomwing.tres")
		]
var suit = [
			preload("res://resources/items/Suit_MR.tres"),
			preload("res://resources/items/Suit_Chomwing.tres"),
			preload("res://resources/items/Suit_Icie.tres"),
			preload("res://resources/items/Suit_Pozzap.tres"),
			preload("res://resources/items/Suit_Bombry.tres"),
			preload("res://resources/items/Suit_Clamik.tres")
		]
var normal_item = [
			preload("res://resources/items/healing_item.tres"),
			preload("res://resources/items/recharge_item.tres")
		]
var map_texture


func _ready():
	BGM.ShopTheme()
	# map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	# $Map.tile_set.get_source(4).texture = map_texture
	$PlayerSpawn.spawn_player()
	$ChooseBetween3/Suit.add_child(create_item(item))
	$ChooseBetween3/Weapon.add_child(create_item(item))
	$ChooseBetween3/Item.add_child(create_item(item))
	for i in $ChooseBetween3.get_children():
		# i.add_item(item[index])
		i.get_child(0).get_node("Area2D").body_entered.connect($ChooseBetween3.done)

func create_item(this_item: Array):
	var item_to_spawn: PackedScene = this_item.pick_random()
	var spawned_item = item_to_spawn.instantiate()
	match item_to_spawn:
		preload("res://scenes/items/boot_item.tscn"):
			spawned_item.item = boot.pick_random().duplicate()
		preload("res://scenes/items/suit_item.tscn"):
			spawned_item.item = suit.pick_random().duplicate()
		preload("res://scenes/items/normal_item.tscn"):
			spawned_item.item = normal_item.pick_random().duplicate()
		preload("res://scenes/items/gun_item.tscn"):
			spawned_item.item = gun.pick_random().duplicate()
		preload("res://scenes/items/blade_item.tscn"):
			spawned_item.item = blade.pick_random().duplicate()
	return spawned_item
