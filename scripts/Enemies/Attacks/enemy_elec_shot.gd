extends CharacterBody2D

signal parried
var speed: int = 250
var direction: Vector2 

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
	if get_slide_collision_count() > 0:
		queue_free()

func _on_timer_timeout():
	queue_free()


func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("bullet") or area.is_in_group("slash"):
		PLAYSFX.parried()
		parried.emit(global_position)
		queue_free()
	if area.get_parent().is_in_group("player"):
		queue_free() 


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
