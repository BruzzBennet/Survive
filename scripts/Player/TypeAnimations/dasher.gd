extends CharacterBody2D
class_name Player_Unit

var max_speed: float = 185
var accel: float = 10
var friction: float = 0.25
var dodge_speed = 1
var dodge_min: float = 5.0
@export var suit: Suit
@export var weapon: Weapon
@export var palette: MonRanger_pallete
@export var footstep_frames: Array[int] = [0, 1]
@export var attack_frames: Array[int]
@onready var animated_sprite_2d = %AnimationPlayer2D
# @onready var dodgeUI = get_tree().current_scene.get_node("Dodge")
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
	if suit:
		equip_suit(GLOBAL.suit,GLOBAL.weapon)
	else:
		$Skeleton/Head_Back.texture = null
		$Skeleton/Head_Front.texture = null
		if palette:
			$Skeleton/Sprite.set_palette(palette)

	# equip_weapon(GLOBAL.weapon, GLOBAL.suit)
	screen_size = get_viewport_rect().size

func equip_weapon(this_weapon:Weapon, this_suit:Suit):
	var boost_bane = 0.25
	modifiers(GLOBAL.weapon,boost_bane,-1)
	GLOBAL.weapon=this_weapon
	$BulletManager.setup(this_weapon,this_suit)
	equip_suit_type(this_suit,this_weapon)
	modifiers(this_weapon,boost_bane)
	weapon_attack_pattern(this_weapon)

func weapon_attack_pattern(this_weapon:Weapon):
	if this_weapon.weapon_type == Weapon.type.boot:
		melee_shot_pattern = "no_shot"
		shot_pattern = "four_way_shot"

func equip_suit(this_suit:Suit,this_weapon:Weapon):
	if this_suit:
		var boost_bane = 0.25
		modifiers(GLOBAL.suit,boost_bane,-1)
		$Skeleton/Head_Back.texture = this_suit.helmet
		$Skeleton/Head_Front.texture = this_suit.helmet
		GLOBAL.player_palette=this_suit.body_palette
		GLOBAL.suit=this_suit
		$Skeleton/Sprite.set_palette(this_suit.body_palette)
		modifiers(this_suit,boost_bane)
	else:
		$Skeleton/Sprite.set_palette(GLOBAL.player_palette) 
	equip_suit_type(this_suit,this_weapon)
	

func modifiers(this_suit:Variant,boost_bane:float,increase_by:int=1):
	var speed_boost=0.0
	var ammo_boost=0.0
	var def_boost=0.0
	var melee_boost=0.04
	boost_bane=boost_bane*increase_by
	
	if this_suit.boost:
		match this_suit.boost_this:
				this_suit.boost.speed:
					speed_boost+=(max_speed*boost_bane)
				this_suit.boost.ammo_saving:
					ammo_boost-=boost_bane
				this_suit.boost.defense:
					def_boost+=(boost_bane*2)
				this_suit.boost.effect:
					if this_suit is Suit:
						$SuitEffect.set_script(null)
						if increase_by>0:
							$SuitEffect.set_script(this_suit.effect)
							if this_suit.effect:
								$SuitEffect.setup()
								print("set up in suit!")
					elif this_suit is Weapon:
						$WeaponEffect.set_script(null)
						if increase_by>0:
							$WeaponEffect.set_script(this_suit.effect)
							if this_suit.effect:
								$WeaponEffect.setup()
								# print(
								# 	"set up in weapon! | increase_by: ",
								# 	increase_by,
								# 	" | weapon: ",
								# 	this_suit,
								# 	" | caller stack:"
								# )
								# print_stack()
	
	if this_suit.bane:
		match this_suit.but_bane_this:
				this_suit.bane.speed:
					speed_boost-=(max_speed*boost_bane)
				this_suit.bane.ammo_saving:
					ammo_boost+=boost_bane
				this_suit.bane.defense:
					def_boost-=(boost_bane*4)
				this_suit.bane.melee_damage:
					melee_boost-=(boost_bane*2)

	max_speed=GLOBAL.max_speed+speed_boost*increase_by
	atkUI.depletion_rate= GLOBAL.ammo+ammo_boost*increase_by
	$HurtBox.defense=GLOBAL.defense+def_boost*increase_by
	$HitBox.attack.damage_done=GLOBAL.melee_damage+melee_boost*increase_by

func equip_suit_type(equipped_suit: Suit, this_weapon:Weapon):
	var sprite_type
	if equipped_suit:
		sprite_type = "Base"
	else:
		sprite_type = ""
	if this_weapon:
		$Skeleton/Weapon_Back.texture = this_weapon.sprite
		$Skeleton/Weapon_Front.texture = this_weapon.sprite
		if this_weapon.weapon_type == Weapon.type.boot:
			$Skeleton/Sprite.texture = load("res://assets/MR/BodyParts/MRDash" + sprite_type + ".png")
	else:
		$Skeleton/Sprite.texture = load("res://assets/MR/BodyParts/MRNormal" + sprite_type + ".png")

func _physics_process(delta: float) -> void:
	healingATK(delta)
	walk_sfx()
	player_movement(delta)
	if Input.is_action_pressed("attack"):
		attack()
	if Input.is_action_pressed("shoot"):
		shoot()
	if !can_hit and atkUI.currentATK >= atkUI.min_ammo:
		can_hit = true
	if !is_attacking:
		$HurtBox.no_longer_invincible()

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
		$HurtBox.no_longer_invincible()

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
	atkUI.flash(Color.RED)

# func dodge(delta):
# 	if last_direction != Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dodge:
# 		dash_fx(last_direction.angle(), position, last_direction)
# 		PLAYSFX.dash()
# 	if last_direction != Vector2.ZERO and Input.is_action_pressed("dash") and can_dodge:
# 		is_dodging = true
# 		$HurtBox.becomes_invincible()
# 		# dodgeUI.reduce(delta)
# 	else:
# 		$HurtBox.is_invincible = false
# 		is_dodging = false
# 	if dodgeUI.currentDodge <= 0:
# 		can_dodge = false
# 		dodgeUI.flash(Color.RED)

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
	position = position.clamp(Vector2(margin, 40), Vector2(screen_size.x - margin, screen_size.y - margin))
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


func healingATK(delta):
	# if atkUI.currentATK < atkUI.maxATK or dodgeUI.currentDodge < dodgeUI.maxDodge:
	if atkUI.currentATK < atkUI.maxATK:
		var idle = animated_sprite_2d.current_animation in [
		"Idle_0",
		"Idle_1",
		"Idle_2",
        "Idle_3"
		]

		if idle:
			recovering(delta)
		else: 
			if animated_sprite_2d.current_animation != "":
				# print(animated_sprite_2d.current_animation)
				idle_time = 0.0
				PLAYSFX.recover_stop()

func recovering(delta):
	idle_time += delta
	if idle_time >=1:
		atkUI.regenerate_more(delta)
		# dodgeUI.regenerate_more(delta)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)
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

	animated_sprite_2d.play(anim_name)


func walk_sfx():
	if $Skeleton/Sprite.frame in footstep_frames:
		PLAYSFX.walk()
	if $Skeleton/Sprite.frame in attack_frames:
		PLAYSFX.slash()
