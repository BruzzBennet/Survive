extends Node2D


@export var fx_scene : PackedScene

func _on_node_2d_hurt_fx(pos) -> void:
	var fx = fx_scene.instantiate()
	add_child(fx)
	fx.global_position = pos
