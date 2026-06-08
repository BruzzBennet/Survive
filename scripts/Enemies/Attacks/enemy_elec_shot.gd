extends Node2D

signal parried
var speed: int = 250
var direction: Vector2 
@onready var parried_sfx = %ParriedSFX


func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("bullet") or area.is_in_group("slash"):
		var parent = get_tree().current_scene

		remove_child(parried_sfx)
		parent.add_child(parried_sfx)

		parried_sfx.global_position = global_position
		
		parried_sfx.play()
		parried.emit(global_position)
		queue_free()
	if area.get_parent().is_in_group("player"):
		queue_free() 


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
