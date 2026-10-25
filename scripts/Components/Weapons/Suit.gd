extends Resource
class_name Suit

@export var helmet: Texture2D
@export var body_palette: MonRanger_pallete
@export var name: String
@export var description: String
@export var speed_boost: int = clamp(0,-1,1)
@export var defense_boost: int = clamp(0,-1,1)
@export var ammo_boost: int = clamp(0,-1,1)
@export var bullet_pierce_boost: int = clamp(0,-1,1)
@export var bullet_reach_boost: int = clamp(0,-1,1)
@export var effect_added: GDScript 