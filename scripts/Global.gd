extends Node

var base_weapon=preload("res://resources/characters/Weapons/no_weapon.tres")
var base_suit=preload("res://resources/characters/MR/Suits/MR_OG.tres")
var base_health=5.0

var normalplayer: PackedScene = preload("res://scenes/PlayerTypes/base.tscn")
var shootplayer: PackedScene = preload("res://scenes/PlayerTypes/Shooter.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var slashplayer: PackedScene = preload("res://scenes/PlayerTypes/Slasher.tscn")
var base_player_type=normalplayer

var player_type=base_player_type
var player_palette: MonRanger_pallete = preload("res://resources/characters/MR/palettes/turquoise.tres")
var weapon: Weapon = base_weapon
var suit: Suit = base_suit
var current_level:= 1
var starting_enemy_amount:= 6
var increase_dificulty: float = 0.0
var max_speed: float = 200
var health=base_health
var melee_damage = 2.0
var defense = 0
var ammo = 1.0

func restart():
    SCORE.actual=0
    player_type=base_player_type
    weapon = base_weapon
    suit= base_suit
    starting_enemy_amount= 3
    increase_dificulty = 0.0
    max_speed = 185
    health=base_health
    melee_damage = 2.0
    defense = 0
    ammo = 1.0