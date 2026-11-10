extends Area2D

@export var attack_sfx: AudioStream
@onready var sfx_player = $AudioStreamPlayer
var this_enemy
var animated_sprite_2d
var is_attacking=false
var og_speed


func _ready():
	this_enemy = get_parent().get_node("EnemyMovement")
	og_speed=this_enemy.speed
	animated_sprite_2d = get_parent().get_node_or_null("AnimationPlayer")

func _on_body_entered(body: Node2D) -> void:
	if body is Player_Unit:
		this_enemy.stopped=true
		play_attack_sfx()
		play_animation(this_enemy.last_direction)

func play_attack_sfx():
	if attack_sfx:
		sfx_player.bus="SFX"
		sfx_player.stream = attack_sfx
		if GLOBAL.sfx_on:
			sfx_player.pitch_scale = randf_range(0.9, 1.25)
			sfx_player.play()

func play_animation(dir: Vector2):
	var anim_name := "0"

	if abs(dir.x) > abs(dir.y) * 1.1:
		if dir.x > 0:
			anim_name = "0"
		else:
			anim_name = "2"

	elif abs(dir.y) > abs(dir.x) * 1.1:
		if dir.y > 0:
			anim_name = "1"
		else:
			anim_name = "3"
	else:
		if dir.x > 0:
			anim_name = "0"
		else:
			anim_name = "2"
	animation_finished(anim_name)

func animation_finished(anim_name:String):
	anim_name="Attack_"+anim_name
	animated_sprite_2d.play(anim_name)
	await animated_sprite_2d.animation_finished
	this_enemy.stopped=false
