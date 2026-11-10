extends Node2D

@export var speed = 70.0
@export var time_to_change_dir:=1.6
@export var diagonal:=false
@export var choppy:=false
@export var stopped:=false
var dumb:=false
const margin = 12
var screen_size: Vector2
var last_direction
var chasing: bool
var idle_time := 0.0
var boost = 1.0
var animated_sprite_2d 
@onready var this_enemy = get_parent()

func _ready() -> void:
	animated_sprite_2d = get_parent().get_node_or_null("AnimationPlayer")
	if diagonal:
		last_direction = choose([
			Vector2(1, 1),
			Vector2(-1, 1),
			Vector2(1, -1),
			Vector2(-1, -1)
		]).normalized()
	else:
		last_direction = choose([
			Vector2.RIGHT,
			Vector2.UP,
			Vector2.LEFT,
			Vector2.DOWN
		])
	add_to_group("enemy")
	screen_size = get_viewport_rect().size
	chasing = false

func _physics_process(_delta):
	if !choppy:
		move()
	elif chasing:
		move()
	check_margins()
	this_enemy.position = this_enemy.position.clamp(Vector2(margin, 40), Vector2(screen_size.x - margin, screen_size.y - margin))
	if !chasing:
		idle_time += _delta
		if idle_time >= time_to_change_dir:
			if diagonal:
				last_direction = choose([
					Vector2(1, 1),
					Vector2(-1, 1),
					Vector2(1, -1),
					Vector2(-1, -1)
				]).normalized()
			else:
				last_direction = choose([
					Vector2.RIGHT,
					Vector2.UP,
					Vector2.LEFT,
					Vector2.DOWN
				])
			if choppy:
				move()
			idle_time = 0.0
	if animated_sprite_2d and !stopped:
		process_animation(last_direction)

func move():
	if !stopped:		
		if chasing:
			boost = 1.5
		else:
			boost = 1.0
		if diagonal:
			last_direction= last_direction.normalized()
		this_enemy.velocity = last_direction * speed * boost
		this_enemy.move_and_slide()
		if this_enemy.get_slide_collision_count() > 0 and !dumb:
			change_direction_after_wall()
	
func check_margins():

	var pos = this_enemy.position

	if pos.x <= margin:
		# Hit left edge → choose vertical direction
		if last_direction.x < 0:
			change_direction_after_wall()

	elif pos.x >= screen_size.x - margin:
		# Hit right edge → choose vertical direction
		if last_direction.x > 0:
			change_direction_after_wall()

	elif pos.y <= 40:
		# Hit top edge → choose horizontal direction
		if last_direction.y < 0:
			change_direction_after_wall()

	elif pos.y >= screen_size.y - margin:
		# Hit bottom edge → choose horizontal direction
		if last_direction.y > 0:
			change_direction_after_wall()

func change_direction_after_wall():
	if diagonal:
		last_direction.x *= -1
		last_direction.y *= -1

	else:

		if last_direction.x != 0:
			last_direction = choose([
				Vector2.UP,
				Vector2.DOWN
			])
		else:
			last_direction = choose([
				Vector2.LEFT,
				Vector2.RIGHT
			])

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
