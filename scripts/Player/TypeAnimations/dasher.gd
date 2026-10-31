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
@onready var atkUI = get_tree().current_scene.get_node("HenshinMenu/UI")
const margin = 12
var last_direction = Vector2.DOWN
var screen_size: Vector2
var is_attacking: bool = false
var is_shooting: bool = false
var is_dodging = false
var can_dodge = true
var can_shoot: bool = true
var can_hit: bool = true
var idle_time: = 0.0
var invincible_time:=0.0
var start_end: = false
var ammo_reduce:=1.0
var broken:=false
var melee_shot_pattern
var shot_pattern
signal weapon_broken

func _ready():
	broken=false
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


func equip(this_suit:Suit,this_weapon:Weapon):
	suit=this_suit
	weapon=this_weapon
	equip_suit(this_suit)
	equip_weapon(this_weapon)
	$BulletManager.setup(this_weapon,this_suit)
	stats_setup(this_suit,this_weapon)

func stats_setup(this_suit:Suit,this_weapon:Weapon):
	set_collision_mask_value(1, true)
	$SuitEffect.set_script(null)
	$WeaponEffect.set_script(null)
	if this_suit.effect_added != null:
		$SuitEffect.set_script(this_suit.effect_added)
		$SuitEffect.setup()
	if this_weapon.effect_added != null:
		$WeaponEffect.set_script(this_weapon.effect_added)
		$WeaponEffect.setup()
	max_speed=GLOBAL.max_speed + ((GLOBAL.max_speed * 0.125) * (this_suit.speed_boost+this_weapon.speed_boost))
	$HurtBox.defense = GLOBAL.defense + (0.125 * (this_suit.defense_boost+this_weapon.defense_boost))
	var new_ammo = 1.0 - (0.2 * (this_suit.ammo_boost+this_weapon.ammo_boost))
	ammo_reduce = max(new_ammo,0.1)
	if this_weapon.weapon_type == Weapon.type.boot:
		max_speed+=(GLOBAL.max_speed * 0.125)

func equip_weapon(this_weapon:Weapon):
	GLOBAL.weapon=this_weapon
	$Skeleton/Weapon_Back.texture = this_weapon.sprite
	$Skeleton/Weapon_Front.texture = this_weapon.sprite
	weapon_attack_pattern(this_weapon)
	atkUI.ammo_setup(this_weapon,false)


func weapon_attack_pattern(this_weapon:Weapon):
	match this_weapon.weapon_type:
		Weapon.type.boot:
			melee_shot_pattern = "short_shot"
			shot_pattern = "small_area_shot"
		Weapon.type.gun:
			melee_shot_pattern = "simple_shot"
			shot_pattern = "triple_shot"
		Weapon.type.blade:
			melee_shot_pattern = "short_shot"
			shot_pattern = "simple_shot"
		Weapon.type.none:
			melee_shot_pattern = "short_shot"
			shot_pattern = "medium_shot"

func equip_suit(this_suit:Suit):
	if this_suit:
		$Skeleton/Head_Back.texture = this_suit.helmet
		$Skeleton/Head_Front.texture = this_suit.helmet
		GLOBAL.player_palette=this_suit.body_palette
		GLOBAL.suit=this_suit
		$Skeleton/Sprite.set_palette(this_suit.body_palette)
	else:
		$Skeleton/Sprite.set_palette(GLOBAL.player_palette) 

func _physics_process(delta: float) -> void:
	if atkUI.currentATK < atkUI.min_ammo and weapon.weapon_type != Weapon.type.none:
		weapon_broken.emit()
		broken = true
		broken_weapon()
	if is_not_attacking() and broken:
		remove_weapon()
	if GLOBAL.about_to_henshin==false:
		walk_sfx()
		player_movement(delta)
		if Input.is_action_pressed("attack"):
			attack()
		if Input.is_action_pressed("shoot"):
			shoot()
	else:
		play_animation("Idle_", last_direction)


func attack():
	is_attacking = true
	if weapon.weapon_type == Weapon.type.gun:
		atkUI.reduce_ammo(ammo_reduce)
	elif weapon.weapon_type == Weapon.type.boot:
		atkUI.reduce_ammo(ammo_reduce*0.5)
	elif weapon.weapon_type == Weapon.type.blade:
		atkUI.reduce_ammo(ammo_reduce*0.35)
	elif weapon.weapon_type == Weapon.type.none:
		atkUI.reduce_ammo(ammo_reduce*0.35)
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
		# elif weapon.weapon_type == Weapon.type.gun:
		# 	PLAYSFX.out_of_ammo()
		else:
			PLAYSFX.slash()			
		can_hit = false

func shoot():
	# if weapon.weapon_type == Weapon.type.boot:
	# 		atkUI.reduce(ammo_reduce*3)
	if weapon.weapon_type == Weapon.type.gun:
			atkUI.reduce_ammo(ammo_reduce*2)
	elif weapon.weapon_type in [Weapon.type.none]:
			atkUI.reduce_ammo(ammo_reduce*0.65)
	else:
		atkUI.reduce_ammo(ammo_reduce)

	if atkUI.currentATK >= atkUI.min_ammo:
		$HurtBox.cancel_flash()
		Long_Range_Attack()
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		can_shoot = true
		is_shooting = false
	# elif weapon.weapon_type != Weapon.type.none:
	# 	broken_weapon()
	else:
		attack()
		can_shoot = false
		is_shooting = false

func Long_Range_Attack():
	is_shooting = true
	if can_shoot:
		$BulletManager.shoot(position, last_direction, shot_pattern)
		can_shoot = false

func broken_weapon():
	GLOBAL.deck.erase(GLOBAL.weapon_item)
	atkUI.set_weapon()
	var fx = preload("res://scenes/hurtParticles.tscn").instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)
	PLAYSFX.crunchyMash()
	PLAYSFX.unequip()
	get_tree().current_scene.get_node("HenshinMenu").update_deck()
	equip(GLOBAL.suit,GLOBAL.base_weapon)
	
func remove_weapon():
		GLOBAL.player_type=GLOBAL.weaponless
		var player= GLOBAL.player_type.instantiate()
		get_tree().current_scene.add_child(player)
		player.position = global_position
		player.equip(GLOBAL.suit,GLOBAL.base_weapon)
		# broken=false
		reset_broken.call_deferred()
		queue_free()

func reset_broken():
	broken = false

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

func recovering(delta):
	idle_time += delta
	if idle_time >=1:
		atkUI.regenerate_more(delta)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)
	else:
		$HurtBox.cancel_flash()

func reset_ammo(on_start=true):
	GLOBAL.weapon.current_ammo+=GLOBAL.weapon.max_ammo/4
	GLOBAL.weapon.current_ammo=clamp(GLOBAL.weapon.current_ammo,0,GLOBAL.weapon.max_ammo)
	atkUI.ammo_setup(GLOBAL.weapon)
	if !on_start:
		# atkUI.flash(Color.GREEN)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)

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

func is_not_attacking():
	if is_idle() or is_walking():
		return true
	return false

func is_idle():
	if animated_sprite_2d.current_animation in ["Idle_0","Idle_1","Idle_2","Idle_3"]:
		return true
	return false

func is_walking():
	if animated_sprite_2d.current_animation in ["Walk_0","Walk_1","Walk_2","Walk_3"]:
		return true
	return false

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
