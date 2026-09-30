extends CharacterBody2D
# class_name Recharge_Item

func _on_area_2d_body_entered(body):
	if body is Player_Unit: 
		body.reset_ammo(false)
		# print("works?")
		queue_free()
