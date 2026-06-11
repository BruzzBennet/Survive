extends Node2D


@export var summon_scene : PackedScene
	
func _on_opozzap_summon(pos,dir) -> void:
	var pozzap=summon_scene.instantiate()
	get_tree().current_scene.add_child(pozzap)
	pozzap.global_position = pos + dir * 10
	pozzap.add_to_group("enemies")
