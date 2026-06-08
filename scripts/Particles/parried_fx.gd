extends Node2D


@export var fx_scene : PackedScene

func parried(pos):
	var fx = fx_scene.instantiate()
	fx.global_position = pos
	get_tree().current_scene.add_child(fx)


func _on_elec_shot_parried(pos) -> void:
	parried(pos)
