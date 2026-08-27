extends Node2D

@export var speed = 70.0
const margin = 12
var screen_size: Vector2
var last_direction = Vector2.RIGHT
var chasing: bool
var idle_time := 0.0
var boost = 1.0
@onready var animated_sprite_2d = get_parent().get_node("AnimationPlayer")
@onready var this_enemy = get_parent()

func _ready() -> void:
	add_to_group("enemy")
	screen_size = get_viewport_rect().size
	chasing = false

func _physics_process(_delta):
	this_enemy.position = this_enemy.position.clamp(Vector2(margin, 40), Vector2(screen_size.x - margin, screen_size.y - margin))
	move()
	if !chasing:
		idle_time += _delta
		if idle_time >= 1.6:
			last_direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			idle_time = 0.0
	process_animation(last_direction)

func move():
	if chasing:
		boost = 1.5
	else:
		boost = 1.0
	this_enemy.velocity = last_direction * speed * boost
	this_enemy.move_and_slide()
	

func play_animation(dir: Vector2) -> void:
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
		# Keep the previous animation when nearly diagonal
		# return
		if dir.x > 0:
			anim_name = "0"
		else:
			anim_name = "2"

	animated_sprite_2d.play(anim_name)

func process_animation(direction) -> void:
	play_animation(direction)


func choose(array):
	array.shuffle()
	return array.front()
