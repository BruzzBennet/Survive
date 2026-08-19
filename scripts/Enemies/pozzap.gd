extends CharacterBody2D

signal died
signal shoot
const speed = 70.0
const margin = 12
var screen_size: Vector2
var last_direction = Vector2.RIGHT
var chasing: bool
@onready var animated_sprite_2d = %SpriteAnimation

func _ready() -> void:
	add_to_group("enemy")
	screen_size = get_viewport_rect().size
	chasing = false

func _physics_process(_delta):
	position = position.clamp(Vector2(margin, 0), Vector2(screen_size.x - margin, screen_size.y))
	move()
	process_animation(last_direction)

func move():
	if !chasing:
		velocity = last_direction * speed
	move_and_slide()
	

func play_animation(dir: Vector2) -> void:
	var anim_name := ""

	if dir.x > 0:
		anim_name = "Right"
	elif dir.y < 0:
		anim_name = "Up"
	elif dir.y > 0:
		anim_name = "Down"
	elif dir.x < 0:
		anim_name = "Left"

	animated_sprite_2d.play(anim_name)

func process_animation(direction) -> void:
	play_animation(direction)

func _on_timer_timeout() -> void:
	if !chasing:
		shoot_bullet()
		last_direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])

func shoot_bullet():
	#if !shot_sfx.playing:
	PLAYSFX.shot()
	shoot.emit(last_direction.angle(), position, last_direction)

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
