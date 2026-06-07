extends Area2D

var speed: int = 250
var direction: Vector2 

func _ready():
	add_to_group("bullet")

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()