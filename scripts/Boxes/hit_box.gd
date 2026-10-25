extends Area2D
class_name HitBox_Component

@export var attack: Attack

func _on_area_entered(body):
	if body is HurtBox_Component: 
		body.damage(attack)
	if body is InvincibleBox_Component:
		PLAYSFX.parried()
		if get_parent().is_in_group("bullets"):
			get_parent().queue_free()
		# body.blocked()
		parried()

func parried():
	var fx = preload("res://scenes/hurtParticles.tscn").instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)

func _ready() -> void:
	if attack:
		if attack.source == attack.attack_source.player:
			set_collision_layer_value(4, true)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
		elif attack.source == attack.attack_source.enemy:
			set_collision_layer_value(2, true)
			set_collision_mask_value(4, true)