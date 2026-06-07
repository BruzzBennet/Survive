extends Node2D


@export var fx_scene : PackedScene

func _on_pozzap_died(pos) -> void:
	var fx = fx_scene.instantiate()
	fx.global_position = pos
	get_tree().current_scene.add_child(fx)