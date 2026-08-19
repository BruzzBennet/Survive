extends Area2D

@export var attack: Attack

func _on_area_entered(body):
	if body is HurtBox_Component: 
		body.damage(attack)