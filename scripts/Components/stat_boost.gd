extends Resource
class_name Stat_Boost

@export var bullet_speed_boost: int = clamp(0,-1,1)
@export var stamina_boost: int = clamp(0,-1,1)
@export var bullet_power_boost: int = clamp(0,-1,1)
@export var bullet_reach_boost: int = clamp(0,-1,1)
@export var stamina_recover_boost: int = clamp(0,-1,1)