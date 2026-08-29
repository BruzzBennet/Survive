extends Area2D
class_name Healing_Item

var idle:float=0.0
var heal_amount=1.0	

func _process(delta: float) -> void:
	idle+=delta
	if idle>=5.0:
		get_parent().queue_free()


func _on_area_entered(body) -> void:
	if body is HurtBox_Component: 
		# print("why?")
		await body.heals(heal_amount)
		# print(str(heal_amount))
		get_parent().queue_free()
		# print("Are you serious?")
