extends Node2D


@export var dash_scene : PackedScene

func _on_node_2d_dash_fx(angle,pos,dir):
	var dash=dash_scene.instantiate()
	add_child(dash)
	dash.rotation=angle  + deg_to_rad(-90)
	if dir == Vector2.UP:
		dash.global_position = pos - dir * 10
	#elif dir == Vector2.RIGHT or dir==Vector2.LEFT:
	#	dash.global_position = pos + Vector2(0, 16) + dir * 10
	else:
		dash.global_position = pos + Vector2(0, 16) - dir * 10
	dash.direction = dir.normalized()
	dash.z_index = -1