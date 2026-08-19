
extends Node2D

@export var color: MonRanger_pallete


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = material.duplicate()
	set_palette(color)

func set_palette(new_color: MonRanger_pallete):
	color = new_color
	material.set_shader_parameter("palette_to", color.palette)
