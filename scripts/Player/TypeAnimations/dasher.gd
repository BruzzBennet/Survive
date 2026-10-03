extends CharacterBody2D
class_name Player_Unit

var max_speed
var accel: float = 50
var friction: float = 0.25
# var dodge_speed: = 1.0
# var dodge_min: float = 5.0
@export var suit: Suit
@export var weapon: Weapon
@export var palette: MonRanger_pallete
@export var footstep_frames: Array[int] = [0, 1]
@export var attack_frames: Array[int]
@onready var animated_sprite_2d = $AnimationPlayer2D
@onready var atkUI = get_tree().current_scene.get_node("ATK")
# @onready var hpUI = get_tree().current_scene.get_node("HP")
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
var idle_time: = 0.0
var invincible_time:=0.0
var start_end: = false
var ammo_reduce
var is_thick

func _ready():
	reset_stats()
	$HurtBox.invincible(1.0,false)
	if suit:
		$Skeleton/Head_Back.texture = suit.helmet
		$Skeleton/Head_Front.texture = suit.helmet
		$Skeleton/Sprite.set_palette(suit.body_palette)
	else:
		$Skeleton/Head_Back.texture = null
		$Skeleton/Head_Front.texture = null
		if palette:
			$Skeleton/Sprite.set_palette(palette)

	screen_size = get_viewport_rect().size

func reset_ammo(on_start=true):
	GLOBAL.weapon.current_ammo=GLOBAL.weapon.max_ammo
	atkUI.setup(GLOBAL.weapon)
	if !on_start:
		atkUI.flash(Color.GREEN)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)

func equip_weapon(this_weapon:Weapon, this_suit:Suit):
	if GLOBAL.weapon != this_weapon:
		modifiers(GLOBAL.weapon,-1)
	GLOBAL.weapon=this_weapon
	$Skeleton/Weapon_Back.texture = this_weapon.sprite
	$Skeleton/Weapon_Front.texture = this_weapon.sprite
	$BulletManager.setup(this_weapon,this_suit)
	modifiers(this_weapon)
	weapon_attack_pattern(this_weapon)
	atkUI.setup(this_weapon)


func weapon_attack_pattern(this_weapon:Weapon):
	match this_weapon.weapon_type:
		Weapon.type.boot:
			melee_shot_pattern = "short_shot"
			shot_pattern = "area_shot"
		Weapon.type.gun:
			melee_shot_pattern = "simple_shot"
			shot_pattern = "triple_shot"
		Weapon.type.blade:
			melee_shot_pattern = "short_shot"
			shot_pattern = "simple_shot"
		Weapon.type.none:
			melee_shot_pattern = "short_shot"
			shot_pattern = "medium_shot"

func equip_suit(this_suit:Suit,_this_weapon:Weapon):
	if GLOBAL.suit != this_suit:
		GLOBAL.modified_health=false
		modifiers(GLOBAL.suit,-1)
	if this_suit:
		$Skeleton/Head_Back.texture = this_suit.helmet
		$Skeleton/Head_Front.texture = this_suit.helmet
		GLOBAL.player_palette=this_suit.body_palette
		GLOBAL.suit=this_suit
		$Skeleton/Sprite.set_palette(this_suit.body_palette)
		modifiers(this_suit)
	else:
		$Skeleton/Sprite.set_palette(GLOBAL.player_palette) 

func reset_stats():
	is_thick=false
	max_speed=GLOBAL.max_speed
	$HurtBox.defense = GLOBAL.defense
	ammo_reduce=GLOBAL.ammo
	max_speed=GLOBAL.max_speed


func modifiers(this_suit:Variant,increase_by:int=1):
	$HurtBox.defense = GLOBAL.defense
	if this_suit is Suit:
		if increase_by<0:
			set_collision_mask_value(1, true)
		$SuitEffect.set_script(null)
	if this_suit is Weapon:
		$WeaponEffect.set_script(null)
	
	if this_suit.boost:
		match this_suit.boost_this:
			this_suit.boost.speed:
				max_speed += GLOBAL.max_speed * 0.25 * increase_by
			this_suit.boost.ammo_saving:
				ammo_reduce-= 0.125 * increase_by
			this_suit.boost.defense:
				# $HurtBox.defense = GLOBAL.defense + (0.25 * increase_by)
				if increase_by < 0:
					GLOBAL.modified_health=false
				if !GLOBAL.modified_health:
					# print("--HENSHIN")
					$HurtBox.extra_health(1*increase_by)
					GLOBAL.modified_health=true
			this_suit.boost.effect:
				if this_suit.effect:
					if this_suit is Suit:
						if increase_by>0:
							$SuitEffect.set_script(this_suit.effect)
							$SuitEffect.setup()
					elif this_suit is Weapon:
						if increase_by>0:
							$WeaponEffect.set_script(this_suit.effect)
							$WeaponEffect.setup()

	if this_suit.bane:
		match this_suit.but_bane_this:
			this_suit.bane.speed:
				max_speed -= GLOBAL.max_speed * 0.25 * increase_by
			this_suit.bane.ammo_saving:
				ammo_reduce += 0.125 * increase_by
			this_suit.bane.defense:
				# $HurtBox.extra_health(-1*increase_by)
				$HurtBox.defense = GLOBAL.defense - (0.5 * increase_by) 

# func thick():
# 	if is_thick:
# 		$HurtBox.invincible()

func _physics_process(delta: float) -> void:
	if GLOBAL.about_to_henshin==false:
		walk_sfx()
		player_movement(delta)
		# if Input.is_action_pressed("attack") || Input.is_action_pressed("shoot"):
		# 	thick()
		if Input.is_action_pressed("attack"):
			attack()
		if Input.is_action_pressed("shoot"):
			shoot()
	else:
		play_animation("Idle_", last_direction)


func attack():
	is_attacking = true
	if weapon.weapon_type == Weapon.type.gun:
		atkUI.reduce_by_melee(ammo_reduce*1.5)
	elif weapon.weapon_type == Weapon.type.boot:
		atkUI.reduce_by_melee(ammo_reduce)
	elif weapon.weapon_type == Weapon.type.blade:
		atkUI.reduce_by_melee(ammo_reduce*0.5)
	$HurtBox.cancel_flash()
	Short_Range_Attack()
	$AttackAnimationTimer.start()
	await $AttackAnimationTimer.timeout
	can_hit = true
	is_attacking = false

func Short_Range_Attack():
	is_attacking = true
	if can_hit:
		if atkUI.currentATK >= atkUI.min_ammo:
			$BulletManager.shoot(position, last_direction, melee_shot_pattern)
		else:
			PLAYSFX.slash()
		can_hit = false

func shoot():
	if weapon.weapon_type == Weapon.type.boot:
			atkUI.reduce(ammo_reduce*3)
	elif weapon.weapon_type == Weapon.type.gun:
			atkUI.reduce(ammo_reduce*3)
	else:
		atkUI.reduce(ammo_reduce)
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
	is_shooting = true
	if can_shoot:
		$BulletManager.shoot(position, last_direction, shot_pattern)
		can_shoot = false

func tired():
	PLAYSFX.out_of_ammo()
	# $HurtBox.is_tired()
	atkUI.flash(Color.RED)

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
	# if is_dodging:
	# 		dodge_speed = 2
	# else:
	# 		dodge_speed = 1.35
	if direction != Vector2.ZERO:
		last_direction = direction
		
	if direction != Vector2.ZERO:
			velocity = velocity.lerp(direction * max_speed, accel * delta)
			# print("speed: "+str(direction * max_speed * dodge_speed))
			# print("weight: "+ str(accel * delta))
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
			recovering(delta)
		else: 
			if animated_sprite_2d.current_animation != "":
				idle_time = 0.0
				PLAYSFX.recover_stop()

func recovering(delta):
	idle_time += delta
	if idle_time >=1:
		atkUI.regenerate_more(delta)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)
	else:
		$HurtBox.cancel_flash()


func process_animation(direction) -> void:
	if direction != Vector2.ZERO:
		# PLAYSFX.recover_stop()
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
	# if $Skeleton/Sprite.frame in attack_frames:
	# 	PLAYSFX.slash()
