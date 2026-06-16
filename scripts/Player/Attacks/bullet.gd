extends Area2D

var speed: int = 350
var direction: Vector2 

func _ready():
	add_to_group("bullet")

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area) -> void:
	if area.name=="HurtBox":
		queue_free()
