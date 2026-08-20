extends CharacterBody2D

var speed: int = 250
var direction: Vector2 

func _ready():
	add_to_group("bullet")

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
	if get_slide_collision_count() > 0:
		queue_free()

func _on_timer_timeout():
	queue_free()
