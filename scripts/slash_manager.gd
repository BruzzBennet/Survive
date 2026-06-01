extends Node2D


@export var slash_scene : PackedScene

func _on_player_slash(angle,pos,dir,player) -> void:
	var slash = slash_scene.instantiate()
	add_child(slash)

	slash.global_position = pos + dir * 50
	slash.rotation = angle + deg_to_rad(-90)

	if dir.x > 0:
		slash.set_flip(true)

	slash.direction = dir.normalized()
	slash.player = player