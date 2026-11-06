extends Resource
class_name Suit

@export var helmet: Texture2D
@export var body_palette: MonRanger_pallete
@export var name: String
@export var description: String
@export var stat_boost: Stat_Boost
@export var effect_added: GDScript 
var broken:=false

var max_ammo: float = 1.625
var current_ammo: float = 1.625
