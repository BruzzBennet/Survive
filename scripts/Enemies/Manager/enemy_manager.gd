extends Node2D


@export var fx_scene : PackedScene
	

func _on_game_summon() -> void:
	var fx = fx_scene.instantiate()
	add_child(fx)