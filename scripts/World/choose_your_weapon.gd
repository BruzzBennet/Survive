extends Node2D

var tile_maps =[
			preload("res://assets/Tiles/Tiles.png"),
			preload("res://assets/Tiles/Tiles1.png"),
			preload("res://assets/Tiles/Tiles2.png"),
			preload("res://assets/Tiles/Tiles3.png"),
			preload("res://assets/Tiles/Tiles4.png"),
			preload("res://assets/Tiles/Tiles5.png")
		]
var boot=[
			preload("res://scenes/items/boot_item.tscn"),
			preload("res://resources/items/Boot_1.tres")
		]
var gun=[
			preload("res://scenes/items/gun_item.tscn"),
			preload("res://resources/items/Gun_Lazer.tres")
		]
var blade=[
			preload("res://scenes/items/blade_item.tscn"),
			preload("res://resources/items/Blade_1.tres")
		]
var map_texture


func _ready():
	BGM.playOverworldMusic()
	# map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	# $Map.tile_set.get_source(4).texture = map_texture
	$PlayerSpawn.spawn_player()
	$Node2D/Suit.add_child(spawn_weapon(blade))
	$Node2D/Weapon.add_child(spawn_weapon(gun))
	$Node2D/Item.add_child(spawn_weapon(boot))

func spawn_weapon(weapon:Array):
	var weapon_to_spawn: PackedScene = weapon.get(0)
	var spawned_weapon = weapon_to_spawn.instantiate()
	spawned_weapon.item = weapon.get(1)
	return spawned_weapon
