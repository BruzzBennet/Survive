extends CharacterBody2D

var speed: int = 250
var time_on_field: float = 0.0
var max_time_on_field: float = 0.2
var enemies_pierced: int = 0
var max_enemies_pierced: int = 1
var direction: Vector2
var damage_done := 1.0

func new_pierce(amount: int):
	max_enemies_pierced = amount

func _ready():
	add_to_group("bullet")
	
func _physics_process(delta):
	time_on_field += delta
	velocity = direction * speed
	move_and_slide()
	# if !floating:
	if get_slide_collision_count() > 0 or enemies_pierced >= max_enemies_pierced or time_on_field >= max_time_on_field:
		explode()
		queue_free()

func _on_timer_timeout():
	explode()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is HurtBox_Component and body.get_parent().is_in_group("enemies"):
		# print("yes")
		explode()
		# enemies_pierced+=1

func explode():
		PLAYSFX.died()
		var exploded = preload("res://scenes/effects/explosion.tscn")
		var explosion = exploded.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", explosion)
