extends Node2D


@export var fx_scene : PackedScene

func _on_main_body_hurt_fx(pos) -> void:
	var fx = fx_scene.instantiate()
	fx.global_position = pos
	add_child(fx)
