extends CharacterBody2D

var switching := false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if switching:
		return

	switching = true
	call_deferred("switch")


func switch() -> void:

	var current_level = GLOBAL.current_level
	var tree := get_tree()

	if tree == null:
		return

	if current_level % 7 == 0:
		GLOBAL.current_level += 1
		tree.change_scene_to_file("res://scenes/worlds/shop_world.tscn")
	else:
		GLOBAL.current_level += 1
		if tree.current_scene.scene_file_path == "res://scenes/worlds/shop_world.tscn":
			BGM.playStageMusic()
		tree.change_scene_to_file("res://scenes/worlds/rng_world.tscn")