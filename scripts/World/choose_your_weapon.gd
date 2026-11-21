extends Node2D

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
	$PlayerSpawn.spawn_player()
	$Node2D/Suit.add_child(spawn_weapon(blade))
	$Node2D/Weapon.add_child(spawn_weapon(gun))
	$Node2D/Item.add_child(spawn_weapon(boot))

func spawn_weapon(weapon:Array):
	var weapon_to_spawn: PackedScene = weapon.get(0)
	var spawned_weapon = weapon_to_spawn.instantiate()
	spawned_weapon.item = weapon.get(1)
	return spawned_weapon
