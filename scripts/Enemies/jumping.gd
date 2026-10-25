extends Node2D

@export var jump_distance = 16.0
@export var time_to_change_dir:=1.6
# @export var jumps_at_a_time:=1
@export var jump_sfx: AudioStream = preload("res://assets/audio/GiantsStepWalk.wav")
const margin = 12
var screen_size: Vector2
var last_direction = Vector2.RIGHT
var chasing: bool
var idle_time = time_to_change_dir
var boost = 1.0
# var jumps=0
@onready var animated_sprite_2d = get_parent().get_node("AnimationPlayer")
@onready var this_enemy = get_parent()
@onready var sprite = this_enemy.get_node("Sprite")
# var jumping:=false

func _ready() -> void:
	add_to_group("enemy")
	screen_size = get_viewport_rect().size
	chasing = false

func _physics_process(_delta):
	this_enemy.position = this_enemy.position.clamp(
		Vector2(margin, 40), 
		Vector2(screen_size.x - margin, screen_size.y - margin)
		)
	if !chasing:
		idle_time += _delta
		if idle_time >= time_to_change_dir:
			var new_position=get_new_position()
			if !can_jump_to(new_position):	
				new_position=this_enemy.position
			jump(new_position)
			idle_time = 0.0				
			

func get_new_position():
	last_direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
	var new_position = this_enemy.position + last_direction * jump_distance
	new_position = new_position.clamp(
		Vector2(margin, 40),
		Vector2(screen_size.x - margin, screen_size.y - margin)
	)
	return new_position

func can_jump_to(new_position: Vector2) -> bool:

	var space_state = get_world_2d().direct_space_state

	var query = PhysicsRayQueryParameters2D.create(
		this_enemy.global_position,
		new_position
	)

	query.collision_mask = 1

	var result = space_state.intersect_ray(query)

	return result.is_empty()

func jump(new_position: Vector2):

	playsfx()
	process_animation(last_direction)

	# 1. Definir la duración del salto
	var duration = time_to_change_dir/2
	var jump_height = 15.0 # Pixeles que se elevará el sprite
	# 2. Mover el cuerpo lógicamente hacia el destino
	var tween_movement = create_tween()
	tween_movement.tween_property(this_enemy, "position", new_position, duration)
	
	# 3. Mover el sprite hacia ARRIBA (Efecto de subida)
	var tween_sprite = create_tween()
	tween_sprite.tween_property(sprite, "position:y", -jump_height, duration / 2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# 4. Mover el sprite hacia ABAJO (Efecto de caída)
	tween_sprite.tween_property(sprite, "position:y", 0.0, duration / 2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

	await tween_sprite.finished
	animated_sprite_2d.play("Idle")
	

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

	if animated_sprite_2d.has_animation("Jump_"+anim_name):
		animated_sprite_2d.play("Jump_"+anim_name)
	else:
		print("Jump animation not found")

func process_animation(direction) -> void:
	play_animation(direction)


func choose(array):
	array.shuffle()
	return array.front()

func playsfx():
	var sfx = $AudioStreamPlayer2D
	if jump_sfx:
		sfx.stream=jump_sfx
	if not sfx.is_playing():
		sfx.pitch_scale = randf_range(0.9, 1.35)
		sfx.play()
