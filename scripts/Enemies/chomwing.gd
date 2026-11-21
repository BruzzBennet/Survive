extends CharacterBody2D

@onready var in_battlefield = get_tree().current_scene.get_node_or_null("RNG_Map")	

func _ready():
    if !in_battlefield:
        set_collision_mask_value(1,true)