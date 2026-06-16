extends Node2D


@export var bullet_scene : PackedScene


func _on_node_2d_shoot(angle,pos,dir):
	# print("SIGNAL RECEIVED")
	var bullet=bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = pos + dir * 10
	bullet.rotation=angle  + deg_to_rad(-90)
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
