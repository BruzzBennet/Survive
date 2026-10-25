extends Node2D

@onready var body = get_parent()
@export var bounce_sfx: AudioStream
@export var speed:= 150
var play_sfx:=0

func _ready():
	if body is CharacterBody2D:
		body.velocity=Vector2(-200,-200).normalized() * speed

func _physics_process(delta):
	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		play_sfx+=1
		if play_sfx==3 and bounce_sfx:
			playsfx()
			play_sfx=0
		body.velocity = body.velocity.bounce(collision.get_normal())


func playsfx():
	var sfx = $sfx
	if sfx:
		sfx.stream=bounce_sfx
	if not sfx.is_playing():
		sfx.pitch_scale = randf_range(0.9, 1.35)
		sfx.play()
