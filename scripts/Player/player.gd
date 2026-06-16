extends CharacterBody2D


signal died
signal shoot(angle, pos, dir)
signal slash(angle, pos, dir, player)
signal hurt_fx(pos)
signal dash_fx
const margin = 12
var last_direction = Vector2.DOWN
var can_shoot: bool = true
var can_slash: bool = true
var can_dodge: bool = true
var is_attacking: bool = false
var is_shooting: bool = false
var is_hurt: bool = false
var is_dodging: bool = false
var footstep_frames = [0, 2]
var enemyCollisions = []
var screen_size: Vector2
@export var max_speed: float = 185
@export var accel: float = 10
@export var friction: float = 0.15
@export var knockbackPower: int = 500
@export var dodge_speed = 1
@export var dodge_min: float = 5.0
@export var health: int = 35
@export var damage_taken: int = 12
@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var slash_sfx = %SlashSFX
@onready var slash_shot_sfx = %SlashShotSFX
@onready var walk_sfx = %WalkSFX
@onready var dash_sfx = %DashSFX
@onready var hurt_sfx = %HurtSFX
@onready var hit_fx = %FX
@onready var hurt_time = %HurtTimer
@onready var dodge_time = %DodgeTimer
@onready var stamina_recover_time = %StaminaRecoverTimer
@onready var died_sfx = %DiedSFX
@onready var hp = %HP
@onready var dodgeUI = %Dodge


func _ready():
	#global_position = Vector2(320, 160)
	screen_size = get_viewport_rect().size
	hit_fx.play("RESET")
	add_to_group("player")


func _physics_process(delta: float) -> void:
	update_fx()
	player_movement(delta)
	dodge(delta)
	if Input.is_action_pressed("attack"):
	#	Short_Range_Attack()
	#if Input.is_action_pressed("shoot"):
		Long_Range_Attack()
	if !can_dodge and dodgeUI.currentDodge >= dodge_min:
		can_dodge = true
	if !is_hurt and !is_dodging:
		for enemyArea in enemyCollisions:
			HurtByEnemy(enemyArea)

func update_fx():
	if is_hurt:
		hit_fx.play("HurtBlink")
	elif is_dodging:
		hit_fx.play("Dodge")
	else:
		hit_fx.play("RESET")

func player_movement(delta):
	position = position.clamp(Vector2(margin, 0), Vector2(screen_size.x - margin, screen_size.y))
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_dodging:
		dodge_speed = 2
	else:
		dodge_speed = 1
	if direction != Vector2.ZERO:
		last_direction = direction
		
	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * max_speed * dodge_speed, accel * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	process_animation(direction)
	move_and_slide()

func dodge(delta):
	if last_direction != Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dodge:
		dash_fx.emit(last_direction.angle(), position, last_direction)
		dash_sfx.play()
	if last_direction != Vector2.ZERO and Input.is_action_pressed("dash") and can_dodge:
#		dash_sfx.play()
		is_dodging = true
		dodgeUI.reduce(delta)
	else:
		is_dodging = false
	if dodgeUI.currentDodge <= 0:
		can_dodge = false

func Long_Range_Attack():
	Short_Range_Attack()
	is_shooting = true
	if can_shoot:
		slash_shot_sfx.play_sound()
		shoot.emit(last_direction.angle(), position, last_direction)
		can_shoot = false
		$ShotTimer.start()

func Short_Range_Attack():
	if can_slash:
		is_attacking = true
		slash.emit(last_direction.angle(), position, last_direction, self )
		can_slash = false
		slash_sfx.play()
		$SlashTimer.start()

func play_animation(prefix: String, dir: Vector2) -> void:
	var anim_name := ""

	if dir.x > 0:
		anim_name = prefix + "0"
	elif dir.y < 0:
		anim_name = prefix + "1"
	elif dir.y > 0:
		anim_name = prefix + "3"
	elif dir.x < 0:
		anim_name = prefix + "2"

	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)

	if is_dodging:
		animated_sprite_2d.speed_scale = 2.0
	else:
		animated_sprite_2d.speed_scale = 1.0


func process_animation(direction) -> void:
	if direction != Vector2.ZERO:
		if is_attacking or is_shooting:
			play_animation("walk_slash", direction)
		else:
			play_animation("walk", direction)
	else:
		if is_attacking or is_shooting:
			play_animation("stand_slash", last_direction)
		else:
			play_animation("stand", last_direction)

func _on_shot_timer_timeout() -> void:
	can_shoot = true # Replace with function body.
	is_shooting = false

func _on_slash_timer_timeout() -> void:
	can_slash = true
	is_attacking = false


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "stand0": return
	if animated_sprite_2d.animation == "stand1": return
	if animated_sprite_2d.animation == "stand2": return
	if animated_sprite_2d.animation == "stand3": return
	if animated_sprite_2d.frame in footstep_frames:
		walk_sfx.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation.begins_with("walk_slash"):
		is_shooting = false
		
	if animated_sprite_2d.animation.begins_with("stand_slash"):
		is_shooting = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func HurtByEnemy(area):
	is_hurt = true
	willdie()
	hurt_fx.emit(global_position)
	hurt_sfx.play()
	knockback(area.get_parent().velocity)
	hurt_time.start()
	await hurt_time.timeout
	is_hurt = false

func _on_hurt_box_area_entered(area):
	if area.name == "HurtBox":
		enemyCollisions.append(area)


func willdie():
	health -= damage_taken
	hp.set_value(health)
	if health <= 0:
		var parent = get_tree().current_scene
		remove_child(died_sfx)
		parent.add_child(died_sfx)
		died_sfx.global_position = global_position
		died_sfx.play()
		died.emit(global_position)
		var death_timer = $"../DeathTimer"
		death_timer.start()
		BGM.GameOver()
		var bus_index = AudioServer.get_bus_index("SFX")
		var current_state: bool = AudioServer.is_bus_mute(bus_index)
		AudioServer.set_bus_mute(bus_index, !current_state)
		queue_free()

func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)
