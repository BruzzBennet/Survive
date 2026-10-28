extends Node2D

var hurt_box

func setup():
	var parent = get_parent()

	hurt_box = parent.get_node("HurtBox")

	if parent.has_signal("weapon_broken"):
		if not parent.weapon_broken.is_connected(on_weapon_broken):
			parent.weapon_broken.connect(on_weapon_broken)

func on_weapon_broken():
	hurt_box.call_deferred("heals",0.5)
