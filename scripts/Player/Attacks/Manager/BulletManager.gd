extends Node2D


@export var bullet_scene : PackedScene


func _on_node_2d_shoot(pos,dir):
	var anim_name
	var bullet=bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = pos + dir * 10
	# bullet.rotation=angle  + deg_to_rad(-90)
	if dir.x > 0:
		anim_name = "0"
	elif dir.y < 0:
		anim_name = "3"
	elif dir.y > 0:
		anim_name = "1"
	elif dir.x < 0:
		anim_name = "2"
	bullet.get_node("AnimationPlayer").play(anim_name)
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
