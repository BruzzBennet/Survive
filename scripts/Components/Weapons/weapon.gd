extends Resource
class_name Weapon

@export var sprite: Texture2D
@export var melee_depletion_rate: float = 0.0 
@export var weapon_type: type

enum type {
    blade,
	gun,
	arm,
	boot
}

@export var bullet_scene : PackedScene

@export var speed: int = 250
@export var max_ammo: float = 35.0
@export var min_ammo: float = 7.0
@export var reload_rate: float = 5.0
@export var depletion_rate: float = 0.5
@export var shot_type: shot_pattern 

enum shot_pattern{
	simple_shot,
	continuous_shot_double,
	continuous_shot_triple,
	triple_shot
}


