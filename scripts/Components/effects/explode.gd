extends Node2D

var hurt_box

func setup():
	get_parent().set_collision_mask_value(1, true)
	hurt_box = get_parent().get_node("HurtBox")
	hurt_box.area_entered.connect(explode)

func explode(area: Area2D):
	if area is HitBox_Component and area.attack.source == area.attack.attack_source.enemy:
		var exploded = preload("res://scenes/effects/explosion.tscn")
		var explosion=exploded.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", explosion)
	