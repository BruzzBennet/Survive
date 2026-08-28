extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().set_collision_mask_value(1, false)
	print(str(get_parent()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# print(str(get_parent()))
	pass
