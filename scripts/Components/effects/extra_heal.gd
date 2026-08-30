extends Node2D

func setup():
	get_parent().set_collision_mask_value(1, true)
	var hurt_box = get_parent().get_node("HurtBox")

	if !hurt_box.area_entered.is_connected(heal):
		hurt_box.area_entered.connect(heal)

func heal(body) -> void:
	if body is Healing_Item:
		body.heal_amount += 0.5