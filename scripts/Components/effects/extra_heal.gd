extends Node2D

var hurt_box

func setup():
	get_parent().set_collision_mask_value(1, true)
	hurt_box = get_parent().get_node("HurtBox")
	hurt_box.extra_heal+=0.5