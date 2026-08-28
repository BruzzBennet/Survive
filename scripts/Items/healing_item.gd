extends CharacterBody2D
class_name Healing_Item

var idle:float=0.0

func _on_area_2d_area_entered(body) -> void:
	# print("enters area")
	if body is HurtBox_Component: 
		await body.heals(1)
		queue_free()

func _process(delta: float) -> void:
	idle+=delta
	if idle>=5.0:
		queue_free()
