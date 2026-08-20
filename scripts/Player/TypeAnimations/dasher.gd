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
@onready var atkUI = get_tree().current_scene.get_node("ATK")
const margin = 12
var last_direction = Vector2.DOWN
var screen_size: Vector2
var is_attacking: bool = false
var is_shooting: bool = false
var is_dodging = false
var can_dodge = true
var can_shoot: bool = true
var can_hit: bool = true
var melee_shot_pattern
var shot_pattern
var idle_time = 0.0

func _ready():
	if weapon.weapon_type == Weapon.type.boot:
		melee_shot_pattern = "no_shot"
		shot_pattern = "four_way_shot"
	if suit:
		$Skeleton/Head_Back.texture = suit.helmet
		$Skeleton/Head_Front.texture = suit.helmet
		$Skeleton/Sprite.set_palette(suit.body_palette)
	else:
		$Skeleton/Head_Back.texture = null
		$Skeleton/Head_Front.texture = null
		if palette:
			$Skeleton/Sprite.set_palette(palette)
	equip(suit)
	screen_size = get_viewport_rect().size

func equip(equipped_suit: Suit):
	var sprite_type
	if equipped_suit:
		sprite_type = "Base"
	else:
		sprite_type = ""
	if weapon:
		$Skeleton/Weapon_Back.texture = weapon.sprite
		$Skeleton/Weapon_Front.texture = weapon.sprite
		if weapon.weapon_type == Weapon.type.boot:
			$Skeleton/Sprite.texture = load("res://assets/MR/BodyParts/MRDash" + sprite_type + ".png")
	else:
		$Skeleton/Sprite.texture = load("res://assets/MR/BodyParts/MRNormal" + sprite_type + ".png")

func _physics_process(delta: float) -> void:
	healingATK(delta)
	walk_sfx()
	player_movement(delta)
	dodge(delta)
	if Input.is_action_pressed("attack"):
		attack()
	if Input.is_action_pressed("shoot"):
		shoot()
	if dodgeUI:
		if !can_dodge and dodgeUI.currentDodge >= dodge_min:
			can_dodge = true
	if !can_hit and atkUI.currentATK >= atkUI.min_ammo:
		can_hit = true

func attack():
	is_attacking = true
	atkUI.reduce_by_melee()
	if atkUI.currentATK >= atkUI.min_ammo:
		$HurtBox.cancel_flash()
		Short_Range_Attack()
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		can_hit = true
		is_attacking = false
	else:
		tired()
		can_hit = false
		is_attacking = false

func Short_Range_Attack():
	is_attacking = true
	if can_hit:
		if weapon.weapon_type == Weapon.type.boot:
			$HurtBox.becomes_invincible()
	else:
		$HurtBox.is_invincible = false

func shoot():
	atkUI.reduce()
	if atkUI.currentATK >= atkUI.min_ammo:
		$HurtBox.cancel_flash()
		Long_Range_Attack()
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		can_shoot = true
		is_shooting = false
	else:
		tired()
		can_shoot = false
		is_shooting = false

func Long_Range_Attack():
	# Short_Range_Attack()
	is_shooting = true
	if can_shoot:
		PLAYSFX.slash_shot()
		$BulletManager.shoot(position, last_direction, shot_pattern)
		can_shoot = false

func tired():
	PLAYSFX.out_of_ammo()
	$HurtBox.is_tired()

func dodge(delta):
	if last_direction != Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dodge:
		dash_fx(last_direction.angle(), position, last_direction)
		PLAYSFX.dash()
	if last_direction != Vector2.ZERO and Input.is_action_pressed("dash") and can_dodge:
		is_dodging = true
		$HurtBox.becomes_invincible()
		dodgeUI.reduce(delta)
	else:
		$HurtBox.is_invincible = false
		is_dodging = false
	if dodgeUI.currentDodge <= 0:
		can_dodge = false

func dash_fx(angle, pos, dir):
	var dash_scene = preload("res://scenes/dashparticles.tscn")
	var dash = dash_scene.instantiate()
	add_child(dash)
	dash.rotation = angle + deg_to_rad(-90)
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


func healingATK(delta):
	if atkUI.currentATK < atkUI.maxATK:
		var idle = animated_sprite_2d.current_animation in [
		"Idle_0",
		"Idle_1",
		"Idle_2",
        "Idle_3"
		]

		if idle:
			healing_animation_atk(delta)
		else: 
			if animated_sprite_2d.current_animation != "":
				# print(animated_sprite_2d.current_animation)
				idle_time = 0.0
				PLAYSFX.recover_stop()

func healing_animation_atk(delta):
	idle_time += delta
	if idle_time >=1:
		atkUI.regenerate_more(delta)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color(0.0, 1.0, 0.0, 1.0))
	else:
		$HurtBox.cancel_flash()


func process_animation(direction) -> void:
	if direction != Vector2.ZERO:
		PLAYSFX.recover_stop()
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
