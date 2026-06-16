extends Node2D


@export var fx_scene : PackedScene

func die(pos):
	var fx = fx_scene.instantiate()
	fx.global_position = pos
	get_tree().current_scene.add_child(fx)

func _on_pozzap_died(pos) -> void:
	die(pos)

func _on_opozzap_died(pos) -> void:
	die(pos)

func _on_player_died(pos) -> void:
	die(pos)