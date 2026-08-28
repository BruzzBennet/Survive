extends Node2D

var player=get_parent()
var weapon=player.weapon
var suit=player.suit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon.bullet_time_on_field+=suit.bullet_time_increase
	weapon.reload_rate+=suit.reload_boost
	weapon.depletion_rate-=suit.ammo_saving


	
