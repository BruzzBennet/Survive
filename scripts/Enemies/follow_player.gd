extends Area2D

@export var follow_sfx: AudioStream
@onready var sfx_player = $AudioStreamPlayer
@onready var this_enemy 
# @export var stationary_enemy:=false
var last_direction

func _ready():
	# if !stationary_enemy:
		this_enemy = get_parent().get_node("EnemyMovement")
	# else:
	# 	this_enemy=get_parent()

func _on_body_entered(body) -> void:
	if body is Player_Unit:
		if follow_sfx:
			sfx_player.bus="SFX"
			sfx_player.stream = follow_sfx
			if GLOBAL.sfx_on:
				sfx_player.play()
		last_direction = (body.global_position - this_enemy.global_position).normalized()
		# if !stationary_enemy:
		this_enemy.last_direction=last_direction
		this_enemy.chasing=true
		# else:
		# 	move()	


func _on_body_exited(_body) -> void:
	# if !stationary_enemy:
		this_enemy.chasing=false

func move():
	this_enemy.velocity = last_direction*500
	this_enemy.move_and_slide()
