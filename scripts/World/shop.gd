extends Node2D

var tile_maps =[
			preload("res://assets/Tiles/Tiles.png"),
			preload("res://assets/Tiles/Tiles1.png"),
			preload("res://assets/Tiles/Tiles2.png"),
			preload("res://assets/Tiles/Tiles3.png"),
			preload("res://assets/Tiles/Tiles4.png")
		]
var item =[
			preload("res://scenes/items/suit_item.tscn"),
			preload("res://scenes/items/boot_item.tscn"),
			preload("res://scenes/items/normal_item.tscn")
		]
var boot=[
			preload("res://resources/items/Boot_Chomwing.tres"),
			preload("res://resources/items/Boot_Icie.tres"),
			preload("res://resources/items/Boot_Pozzap.tres")
		]
var suit=[
			preload("res://resources/items/Suit_Chomwing.tres"),
			preload("res://resources/items/Suit_Icie.tres"),
			preload("res://resources/items/Suit_Pozzap.tres")
		]
var normal_item=[
			preload("res://resources/items/healing_item.tres")
		]
var map_texture


# Called when the node enters the scene tree for the first time.
func _ready():
	BGM.ShopTheme()
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	$PlayerSpawn.spawn_player()
	$Node2D/Suit.add_child(create_item(item))
	$Node2D/Weapon.add_child(create_item(item))
	$Node2D/Item.add_child(create_item(item))

func create_item(this_item:Array):
	var item_to_spawn: PackedScene =this_item.pick_random()
	var spawned_item = item_to_spawn.instantiate()
	match item_to_spawn:
		preload("res://scenes/items/boot_item.tscn"):
			spawned_item.item = boot.pick_random()
		preload("res://scenes/items/suit_item.tscn"):
			spawned_item.item = suit.pick_random()
		preload("res://scenes/items/normal_item.tscn"):
			spawned_item.item = normal_item.pick_random()
	return spawned_item
