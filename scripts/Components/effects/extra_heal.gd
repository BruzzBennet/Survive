extends Node2D

var hurt_box

func setup():
	get_parent().set_collision_mask_value(1, true)
	hurt_box = get_parent().get_node("HurtBox")
	hurt_box.extra_heal+=0.5
	print("extra heal!")

# 	if !hurt_box.area_entered.is_connected(heal):
# 		hurt_box.area_entered.connect(heal)

# func heal(body) -> void:
# 	if body is Healing_Item:
# 		hurt_box.heals(0.5)