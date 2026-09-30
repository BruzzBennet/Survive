extends Node2D

var idle_time=0.0
var move = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	idle_time+=delta
	get_parent().position.y+=move
	if idle_time>=0.4:
		move=move*-1
		idle_time=0.0
