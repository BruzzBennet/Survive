extends Node

var starting_level="res://scenes/worlds/start_world.tscn"

var base_weapon=preload("res://resources/Mons/sergyo.tres")
var base_suit=base_weapon
var base_health:=100
var base_enemy_amount: = 1
var base_ammo: = 0.65
var base_defense:=14.0
var mon_max_level:=7

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
var defense = base_defense
var ammo = base_ammo
var about_to_henshin:=false
var weapon_item
var suit_item
var music_on:=true
var sfx_on:=true
var last_scene=null

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
	weapon = base_weapon
	suit= weapon
	starting_enemy_amount= base_enemy_amount
	increase_dificulty = 0.0
	max_speed = 200
	health=base_health
	melee_damage = 2.0
	defense = base_defense
	ammo = base_ammo
	current_level= 1
	about_to_henshin=false
	last_scene=null
	# deck = []


var items=[
	preload("res://scenes/items/coin.tscn"),
	preload("res://scenes/items/recharge_item.tscn")
	]

var zoo=[
	preload("res://scenes/enemies/icie.tscn"),
	preload("res://scenes/enemies/chomwing.tscn"),
	preload("res://scenes/enemies/Minole.tscn"),
	preload("res://scenes/enemies/pucklam.tscn"),
	preload("res://scenes/pozzap.tscn"),
	preload("res://scenes/enemies/Bombry.tscn"),
	preload("res://scenes/enemies/clamik.tscn"),
	preload("res://scenes/enemies/bubbler.tscn"),
	preload("res://scenes/opozzap.tscn")
]

var mimin=[
	preload("res://scenes/enemies/miminrage.tscn"),
	preload("res://scenes/enemies/miminfast.tscn"),
	preload("res://scenes/enemies/miminzombie.tscn"),
	preload("res://scenes/enemies/miminflyer.tscn"),
	preload("res://scenes/enemies/mimintank.tscn")
]