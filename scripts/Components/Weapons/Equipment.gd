extends Resource
class_name Equipment

@export var mon_sprite: Texture2D

@export var mon_name: String

@export var helmet: Texture2D
@export var body_palette: MonRanger_pallete

@export var blade_sprite: Texture2D
@export var gun_sprite: Texture2D
@export var boot_sprite: Texture2D
@export var arm_sprite: Texture2D

@export var equipment_description: String

@export var bullet_scene : PackedScene
@export var normal_attack_sfx : AudioStream = preload("res://assets/audio/slash.mp3")
@export var special_attack_sfx: AudioStream = preload("res://assets/audio/slashshot.mp3")
@export var shot_type: shot_pattern 

enum shot_pattern{
	simple_shot,
	continuous_shot_double,
	continuous_shot_triple,
	triple_shot
}

@export var stat_boost: Stat_Boost
@export var effect_added: PackedScene

var max_ammo: float = 100.0
var current_ammo: float = 100.0
var broken:=false