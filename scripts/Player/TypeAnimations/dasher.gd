extends CharacterBody2D

@export var max_speed: float = 185
@export var accel: float = 10
@export var friction: float = 0.25
@export var dodge_speed = 1
@export var suit: Suit
@export var weapon: Weapon
@export var palette: MonRanger_pallete
@export var footstep_frames: Array[int] = [0, 1]
@export var attack_frames: Array[int]
@export var dodge_min: float = 5.0
@onready var animated_sprite_2d = %AnimationPlayer2D
@onready var dodgeUI = get_tree().current_scene.get_node("Dodge")
const margin = 12
var last_direction = Vector2.DOWN
var screen_size: Vector2
var is_attacking: bool = false
var is_shooting: bool = false
var is_dodging = false
var can_dodge = true	

func _ready():
	if suit:
		$Skeleton/Head_Back.texture=suit.helmet
		$Skeleton/Head_Front.texture=suit.helmet
		$Skeleton/Sprite.set_palette(suit.body_palette)
	else:
		$Skeleton/Head_Back.texture=null
		$Skeleton/Head_Front.texture=null
		if palette:
			$Skeleton/Sprite.set_palette(palette)
	equip(suit)	
	screen_size=get_viewport_rect().size

func equip(equipped_suit: Suit):
	var sprite_type
	if equipped_suit:
		sprite_type = "Base"
	else:
		sprite_type = ""
	if weapon:
		$Skeleton/Weapon_Back.texture=weapon.sprite
		$Skeleton/Weapon_Front.texture=weapon.sprite	
		if weapon.weapon_type==Weapon.type.boot:
			$Skeleton/Sprite.texture=load("res://assets/MR/BodyParts/MRDash"+sprite_type+".png")
	else:
		$Skeleton/Sprite.texture=load("res://assets/MR/BodyParts/MRNormal"+sprite_type+".png")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	dodge(delta)
	walk_sfx()
	if Input.is_action_pressed("attack"):
		is_attacking=true
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		is_attacking=false
	if Input.is_action_pressed("shoot"):
		is_shooting=true
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		is_shooting=false
	if dodgeUI:
		if !can_dodge and dodgeUI.currentDodge >= dodge_min:
			can_dodge = true

func dodge(delta):
	if last_direction != Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dodge:
		dash_fx(last_direction.angle(), position, last_direction)
		PLAYSFX.dash()
	if last_direction != Vector2.ZERO and Input.is_action_pressed("dash") and can_dodge:
		is_dodging = true
		$HurtBox.becomes_invincible()
		dodgeUI.reduce(delta)
	else:
		$HurtBox.is_invincible=false
		is_dodging = false
	if dodgeUI.currentDodge <= 0:
		can_dodge = false

func dash_fx(angle,pos,dir):
	var dash_scene = preload("res://scenes/dashparticles.tscn")
	var dash=dash_scene.instantiate()
	add_child(dash)
	dash.rotation=angle  + deg_to_rad(-90)
	if dir == Vector2.UP:
		dash.global_position = pos - dir * 10
	else:
		dash.global_position = pos + Vector2(0, 16) - dir * 10
	dash.direction = dir.normalized()
	dash.z_index = -1

func player_movement(delta):
	position = position.clamp(Vector2(margin, 0), Vector2(screen_size.x - margin, screen_size.y - margin))
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_dodging:
			dodge_speed = 2
	else:
			dodge_speed = 1
	if direction != Vector2.ZERO:
		last_direction = direction
		# print(last_direction)
		
	if direction != Vector2.ZERO:
			velocity = velocity.lerp(direction * max_speed * dodge_speed, accel * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	process_animation(direction)
	move_and_slide()


func process_animation(direction) -> void:
	if direction != Vector2.ZERO:
		if is_attacking or is_shooting:
			play_animation("Walk_Attack_", direction)			
		else:
			play_animation("Walk_", direction)
	else:
		if is_attacking or is_shooting:		
			play_animation("Attack_", last_direction)
		else:
			play_animation("Idle_", last_direction)


func play_animation(prefix: String, dir: Vector2) -> void:
	var anim_name := ""

	if dir.x > 0:
		anim_name = prefix + "0"
	elif dir.y < 0:
		anim_name = prefix + "3"
	elif dir.y > 0:
		anim_name = prefix + "1"
	elif dir.x < 0:
		anim_name = prefix + "2"

	# if animated_sprite_2d != anim_name:
	animated_sprite_2d.play(anim_name)

	# if is_dodging:
	# 	animated_sprite_2d.speed_scale = 2.0
	# else:
	# 	animated_sprite_2d.speed_scale = 1.0


func walk_sfx():
	if $Skeleton/Sprite.frame in footstep_frames:
		PLAYSFX.walk()
	if $Skeleton/Sprite.frame in attack_frames:
		PLAYSFX.slash()	
		
