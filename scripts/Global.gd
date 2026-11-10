extends Node

var starting_level="res://scenes/worlds/start_world.tscn"

var base_Mon=load("res://resources/Mons/clamik.tres")
var base_Mon1=load("res://resources/Mons/minole.tres")

var base_weapon=load("res://resources/Mons/sergyo.tres")
var base_suit=base_weapon
var base_health=100
var base_enemy_amount: = 3
var base_ammo = 0.65

var weaponless = "res://scenes/PlayerTypes/weaponless.tscn"
var shooter= "res://scenes/PlayerTypes/Shooter.tscn"
var dasher = "res://scenes/PlayerTypes/Dasher.tscn"
var slasher = "res://scenes/PlayerTypes/Slasher.tscn"
var base_player_type=load(weaponless)

var player_type=base_player_type
var player_type2=load(slasher)
var weapon: Equipment = base_weapon
var suit: Equipment = base_suit
var current_level:= 1
var starting_enemy_amount= base_enemy_amount
var increase_dificulty: float = 0.0
var max_speed: float = 200
var health=base_health
var melee_damage = 2.0
var defense = 9.0
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

var deck = []
var deck_size:= 3

func add_card(card:Equipment):
	if deck.size() < deck_size:
		deck.append(card)

func restart():
	SCORE.actual=0
	player_type=base_player_type
	weapon = base_weapon.duplicate()
	suit= base_suit
	starting_enemy_amount= base_enemy_amount
	increase_dificulty = 0.0
	max_speed = 200
	health=base_health
	melee_damage = 2.0
	defense = 9.0
	ammo = base_ammo
	current_level= 1
	about_to_henshin=false
	deck = []
	weapon_item=null
	suit_item=null
