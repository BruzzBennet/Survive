extends Resource
class_name Suit

@export var helmet: Texture2D
@export var body_palette: MonRanger_pallete
@export var description: String
# @export var speed_level: int=1
# @export var bullet_time_increase:=0.0
# @export var reload_boost:=0.0
# @export var ammo_saving:=0.0
# @export var health_boost: float=0.0
# @export var defense_boost: int=0
# @export var damage_boost: float=0.0
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
