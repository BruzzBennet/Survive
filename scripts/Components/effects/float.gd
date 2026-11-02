extends Node2D

func _ready():
	setup()

func setup():
	get_parent().set_collision_mask_value(1, false)
