extends CharacterBody2D

signal shoot
signal slash
@export var max_speed: float = 600
@export var accel: float = 10
@export var friction: float = 0.15
var last_direction = Vector2.DOWN
var can_shoot: bool
var can_slash: bool
var can_run: bool
var is_attacking: bool
@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var stamina_label = %Label

var screen_size:Vector2

func _ready() -> void:
	screen_size=get_viewport_rect().size
	position=screen_size/2
	can_shoot=true
	can_run=true
	can_slash=true
	is_attacking=false

func _physics_process(delta: float) -> void:	
	
	position=position.clamp(Vector2.ZERO, screen_size)

	var current_speed = max_speed

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction

	if direction != Vector2.ZERO and Input.is_key_pressed(KEY_C) and can_run:
		current_speed *= 2	
		if $StaminaTimer.is_stopped():
			$StaminaTimer.start()
		
	# Assigns velocity and normalizes it so diagonals aren't faster
	if direction != Vector2.ZERO:
	#if direction != Vector2.ZERO and !is_attacking:
		# Gradually accelerate towards the target speed
		velocity = velocity.lerp(direction * current_speed, accel * delta)
	else:
		# Gradually stop when no input is pressed
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	# Handles movement and collisions
	move_and_slide()
	process_animation(direction)

	if Input.is_key_pressed(KEY_X) and can_shoot:
		# print("SHOOTING")
		shoot.emit(last_direction.angle(), position, last_direction)
		can_shoot=false
		$ShotTimer.start()

	if Input.is_key_pressed(KEY_Z) and can_slash:
		#print("SLASHING")
		is_attacking=true
		slash.emit(last_direction.angle(), position, last_direction, self)
		can_slash=false
		$SlashTimer.start()

	# if is_attacking:
	# 	velocity=Vector2.ZERO
	# 	play_animation("stand", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + "0")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "1")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "3")
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + "2")


func process_animation(direction) -> void:
	if direction != Vector2.ZERO:
		play_animation("walk", direction)
	else:
		play_animation("stand", last_direction)

func _on_shot_timer_timeout() -> void:
	can_shoot=true # Replace with function body.

func _on_stamina_timer_timeout() -> void:
	can_run=false
	$StaminaRecoverTimer.start()

func _on_stamina_recover_timer_timeout() -> void:
	can_run=true

func _on_slash_timer_timeout() -> void:
	can_slash=true
	is_attacking=false
