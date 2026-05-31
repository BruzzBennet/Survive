extends Node2D


@export var bullet_scene : PackedScene

func _on_player_shoot(angle,pos,dir):
	# print("SIGNAL RECEIVED")
	var bullet=bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.rotation=angle  + deg_to_rad(-90)
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
