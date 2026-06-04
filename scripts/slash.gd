extends Node2D
var direction: Vector2
var player
var distance = 10
@onready var animated_sprite_2d = %AnimatedSlash2D

func set_flip(value: bool):
	animated_sprite_2d.flip_h = value

func _ready():
	animated_sprite_2d.play("Slash")
	await animated_sprite_2d.animation_finished
	queue_free()
	
func _process(delta):

	if player:
		global_position = player.global_position + direction * distance