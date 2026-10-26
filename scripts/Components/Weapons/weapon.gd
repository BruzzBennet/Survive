extends Resource
class_name Weapon

@export var sprite: Texture2D
@export var name: String
@export var description: String
@export var weapon_type: type

enum type {
    blade,
	gun,
	arm,
	boot,
    none
}

@export var shot_type: shot_pattern 

enum shot_pattern{
	simple_shot,
	continuous_shot_double,
	continuous_shot_triple,
	triple_shot
}

@export var bullet_scene : PackedScene
@export var normal_attack_sfx : AudioStream = preload("res://assets/audio/slash.mp3")
@export var special_attack_sfx: AudioStream = preload("res://assets/audio/slashshot.mp3")
@export var speed_boost: int = clamp(0,-1,1)
@export var defense_boost: int = clamp(0,-1,1)
@export var ammo_boost: int = clamp(0,-1,1)
@export var bullet_pierce_boost: int = clamp(0,0,1)
@export var bullet_reach_boost: int = clamp(0,-1,1)
@export var effect_added: GDScript 

var max_ammo: float = 100.0
var current_ammo: float = 100.0
var broken:=false