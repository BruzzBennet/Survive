extends CharacterBody2D



func _on_hit_box_area_entered(area: Area2D) -> void:
	if area is HurtBox_Component and area.takes_damage_from == area.attack_source.enemy:
		$HurtBox.dead_enemy(false)
		queue_free()
