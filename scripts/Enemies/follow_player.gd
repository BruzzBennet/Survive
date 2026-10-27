extends Area2D

@export var follow_sfx: AudioStream
@onready var sfx_player = $AudioStreamPlayer
@onready var this_enemy = get_parent().get_node("EnemyMovement")

func _on_body_entered(body) -> void:
	if body is Player_Unit:
		if follow_sfx:
			sfx_player.bus="SFX"
			sfx_player.stream = follow_sfx
			if GLOBAL.sfx_on:
				sfx_player.play()
		this_enemy.last_direction = (
body.global_position - this_enemy.global_position
		).normalized()
		this_enemy.chasing=true


func _on_body_exited(_body) -> void:
	this_enemy.chasing=false
