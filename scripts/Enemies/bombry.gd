extends CharacterBody2D



func _on_hit_box_area_entered(area: Area2D) -> void:
	if area is HurtBox_Component and area.takes_damage_from == area.attack_source.enemy:
		var explode = preload("res://scenes/enemies/explosion.tscn")
		var explosion=explode.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		$HurtBox.died.emit()
		PLAYSFX.died()
		queue_free()
