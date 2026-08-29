extends Resource
class_name Weapon

@export var sprite: Texture2D
@export var name: String
@export var description: String
@export var melee_depletion_rate: float = 0.0 
@export var weapon_type: type

enum type {
    blade,
	gun,
	arm,
	boot
}

@export var bullet_scene : PackedScene
@export var enemies_bullet_pierces: int = 1 
var max_ammo: float = 35.0
var min_ammo: float = 7.0
var bullet_damage: float = 1.0
var bullet_speed: int = 250
var bullet_time_on_field: float = 0.4
var reload_rate: float = 5.0
var depletion_rate: float = 2.0
@export var shot_type: shot_pattern 

enum shot_pattern{
	simple_shot,
	continuous_shot_double,
	continuous_shot_triple,
	triple_shot
}

@export var boost_this: boost
enum boost {
    speed,
    bullet_reach,
    ammo_saving,
    defense,
    bullet_damage,
    melee_damage
}

@export var but_bane_this: bane
enum bane {
    speed,
    bullet_reach,
    ammo_saving,
    defense,
    bullet_damage,
    melee_damage
}

@export var effect: GDScript 


