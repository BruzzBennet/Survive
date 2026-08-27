extends CharacterBody2D

signal died
signal shoot
var last_direction = Vector2.RIGHT
var chasing: bool
@onready var pozzap = $EnemyMovement

func _on_timer_timeout() -> void:
	# if !chasing:
		shoot_bullet()
	
func shoot_bullet():
	#if !shot_sfx.playing:
	PLAYSFX.shot()
	shoot.emit(pozzap.last_direction.angle(), position, pozzap.last_direction)

func choose(array):
	array.shuffle()
	return array.front()


func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("bullet") or area.is_in_group("slash"):
		PLAYSFX.died()
		died.emit(global_position)
		queue_free()
	if area.is_in_group("enemies"):
		last_direction=-last_direction
