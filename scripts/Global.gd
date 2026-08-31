extends Node

var player_palette: MonRanger_pallete = preload("res://resources/characters/MR/palettes/turquoise.tres")
var weapon: Weapon = preload("res://resources/characters/Weapons/Boots/1_boot.tres")
var suit: Suit = preload("res://resources/characters/MR/Suits/Sergyo.tres")
var current_level:= 1
var starting_enemy_amount:= 3
var increase_dificulty: float = 0.0
var max_speed: float = 185
var health:=3.0
var melee_damage = 2.0
var defense = 0
var ammo = 1.0

func restart():
    SCORE.actual=0
    weapon = preload("res://resources/characters/Weapons/Boots/1_boot.tres")
    suit=  preload("res://resources/characters/MR/Suits/Sergyo.tres")
    current_level= 1
    starting_enemy_amount= 3
    increase_dificulty = 0.0
    max_speed = 185
    health=3.0
    melee_damage = 2.0
    defense = 0
    ammo = 1.0