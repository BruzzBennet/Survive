extends Resource
class_name Stat_Boost

@export var mon_sprite: Texture2D
@export var speed_boost: int = clamp(0,-1,1)
@export var defense_boost: int = clamp(0,-1,1)
@export var ammo_boost: int = clamp(0,-1,1)
@export var bullet_pierce_boost: int = clamp(0,0,1)
@export var bullet_reach_boost: int = clamp(0,-1,1)
