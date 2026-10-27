extends Node

var starting_level="res://scenes/worlds/start_world.tscn"

var base_weapon=preload("res://resources/characters/Weapons/weaponless.tres")
var base_suit=preload("res://resources/characters/MR/Suits/Sergyo.tres")
var first_suit=preload("res://resources/items/Suit_MR.tres")
var base_health=6.0
var base_enemy_amount: = 3
var modified_health=false
var base_ammo = 0.65

var normal: PackedScene = preload("res://scenes/PlayerTypes/base.tscn")
var weaponless: PackedScene = load("res://scenes/PlayerTypes/weaponless.tscn")
var shooter: PackedScene = preload("res://scenes/PlayerTypes/Shooter.tscn")
var dasher: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var slasher: PackedScene = preload("res://scenes/PlayerTypes/Slasher.tscn")
var base_player_type=weaponless

var player_type=base_player_type
var player_palette: MonRanger_pallete = preload("res://resources/characters/MR/palettes/turquoise.tres")
var weapon: Weapon = base_weapon.duplicate()
var suit: Suit = base_suit
var current_level:= 1
var starting_enemy_amount= base_enemy_amount
var increase_dificulty: float = 0.0
var max_speed: float = 200
var health=base_health
var melee_damage = 2.0
var defense = 0
var ammo = base_ammo
var about_to_henshin:=false
var weapon_item
var suit_item
var music_on:=true
var sfx_on:=true


func mute_music():
	var bus_index = AudioServer.get_bus_index("Music")
	if GLOBAL.music_on:
		AudioServer.set_bus_mute(bus_index, true)
		GLOBAL.music_on=false
	else:
		AudioServer.set_bus_mute(bus_index, false)
		GLOBAL.music_on=true

func mute_sfx():
	var bus_index = AudioServer.get_bus_index("SFX")
	if GLOBAL.sfx_on:
		AudioServer.set_bus_mute(bus_index, true)
		GLOBAL.sfx_on=false
	else:
		AudioServer.set_bus_mute(bus_index, false)
		GLOBAL.sfx_on=true

var deck = [first_suit]
var deck_size:= 3

func add_card(card:Item):
	if deck.size() < deck_size:
		deck.append(card)

func equip_weapon(this_weapon:Weapon):
	weapon=this_weapon

func restart():
	SCORE.actual=0
	player_type=base_player_type
	weapon = base_weapon.duplicate()
	suit= base_suit
	starting_enemy_amount= base_enemy_amount
	increase_dificulty = 0.0
	max_speed = 185
	health=base_health
	melee_damage = 2.0
	defense = 0
	ammo = base_ammo
	current_level= 1
	about_to_henshin=false
	deck = [first_suit]
	modified_health=false
	weapon_item=null
	suit_item=null
