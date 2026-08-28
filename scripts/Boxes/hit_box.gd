extends Area2D

@export var attack: Attack

func _on_area_entered(body):
	if body is HurtBox_Component: 
		body.damage(attack)

func _ready() -> void:
	if attack:
		if attack.source == attack.attack_source.player:
			set_collision_layer_value(4, true)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
		elif attack.source == attack.attack_source.enemy:
			set_collision_layer_value(2, true)
			set_collision_mask_value(4, true)