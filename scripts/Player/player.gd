extends CharacterBody2D
class_name Player_Unit

var max_speed
var accel: float = 50
var friction: float = 0.25
var dodge_speed: = 1.0
var able_to_dodge:=true
@export var weapon_is: type

enum type {
	blade,
	gun,
	arm,
	boot,
	none
}
var weapon_type
@export var suit: Equipment
@export var weapon: Equipment
@export var palette: MonRanger_pallete
@export var footstep_frames: Array[int] = [4,6,8,10,12,14,16,18]
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
var starting_invincibility=true
signal weapon_broken

func _ready():
	broken=false
	screen_size = get_viewport_rect().size
	await $HurtBox.invincible(1.0,false)
	starting_invincibility=false


func equip(this_suit:Equipment,this_weapon:Equipment):
	suit=this_suit
	weapon=this_weapon
	equip_suit(this_suit)
	equip_weapon(this_weapon)
	$BulletManager.setup(this_weapon,this_suit,weapon_type)
	stats_setup(this_suit,this_weapon)

func stats_setup(this_suit:Equipment,this_weapon:Equipment):
	var suit_boost=this_suit.stat_boost
	var weapon_boost=this_weapon.stat_boost
	max_speed=GLOBAL.max_speed + ((GLOBAL.max_speed * 0.1) * (suit_boost.bullet_speed_boost+weapon_boost.bullet_speed_boost))
	$HurtBox.defense = GLOBAL.defense + suit_boost.stamina_boost+weapon_boost.stamina_boost
	var new_ammo = 1.0 - (0.25 * (suit_boost.stamina_boost+weapon_boost.stamina_boost))
	ammo_reduce = max(new_ammo,0.05)
	if weapon_is == type.boot:
		max_speed+=(GLOBAL.max_speed * 0.1)

func equip_weapon(this_weapon:Equipment):
	GLOBAL.weapon=this_weapon
	weapon_setup(this_weapon)
	atkUI.ammo_setup(this_weapon)


func weapon_setup(this_weapon:Equipment):
	var weapon_sprite = null
	match weapon_is:
		type.boot:
			melee_shot_pattern = "short_shot"
			shot_pattern = "small_area_shot"
			weapon_sprite=this_weapon.boot_sprite
			weapon_type="boot"
		type.gun:
			melee_shot_pattern = "medium_shot"
			shot_pattern = "triple_shot"
			weapon_sprite=this_weapon.gun_sprite
			weapon_type="gun"
		type.blade:
			melee_shot_pattern = "short_shot"
			shot_pattern = "simple_shot"
			weapon_sprite=this_weapon.blade_sprite
			weapon_type="blade"
		type.none:
			melee_shot_pattern = "very_short_shot"
			shot_pattern = "medium_shot"
			weapon_type="none"
	$Skeleton/Weapon_Back.texture = weapon_sprite
	$Skeleton/Weapon_Front.texture = weapon_sprite

func equip_suit(this_suit:Equipment):
	if this_suit:
		$Skeleton/Head_Back.texture = this_suit.helmet
		$Skeleton/Head_Front.texture = this_suit.helmet
		# GLOBAL.player_palette=this_suit.body_palette
		GLOBAL.suit=this_suit
		$Skeleton/Sprite.set_palette(this_suit.body_palette)
	else:
		$Skeleton/Sprite.set_palette(GLOBAL.player_palette) 

func _physics_process(delta: float) -> void:
	check_weapon_durability()
	# check_suit_durability()
	if GLOBAL.about_to_henshin==false:
		walk_sfx()
		player_movement(delta)
		if !is_dodging:
			if Input.is_action_pressed("attack"):
				attack()
			if Input.is_action_pressed("shoot"):
				shoot()
	else:
		play_animation("Idle_", last_direction)

func check_weapon_durability():
	if GLOBAL.weapon.current_ammo <= 0 \
	and GLOBAL.weapon != GLOBAL.base_weapon:
		weapon_broken.emit()
		broken = true
		broken_weapon()
	if is_not_attacking() and broken:
		remove_weapon()

func check_suit_durability():
	if atkUI.currentSuitHP < atkUI.min_suit_hp and suit != GLOBAL.base_suit:
		broken_suit()

func broken_suit():
	GLOBAL.deck.erase(GLOBAL.suit)
	atkUI.set_suit()
	explode_fx()
	PLAYSFX.crunchyMash()
	PLAYSFX.unequip()
	get_tree().current_scene.get_node("HenshinMenu").update_deck()
	equip(GLOBAL.base_suit,GLOBAL.weapon)
	

func explode_fx():
	var fx = preload("res://scenes/hurtParticles.tscn").instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)

func broken_weapon():
	GLOBAL.deck.erase(GLOBAL.weapon)
	atkUI.set_weapon()
	explode_fx()
	PLAYSFX.crunchyMash()
	PLAYSFX.unequip()
	get_tree().current_scene.get_node("HenshinMenu/UI").update_deck()
	equip(GLOBAL.suit,GLOBAL.base_weapon)
	GLOBAL.player_type=GLOBAL.base_player_type
	
func remove_weapon():
		var player= GLOBAL.player_type.instantiate()
		get_tree().current_scene.add_child(player)
		player.position = global_position
		player.equip(GLOBAL.suit,GLOBAL.base_weapon)
		# broken=false
		reset_broken.call_deferred()
		queue_free()

func reset_broken():
	broken = false

func attack():
	is_attacking = true
	match weapon_is:
		type.gun:
			atkUI.reduce_ammo(ammo_reduce*0.5)
		type.boot:
			atkUI.reduce_ammo(ammo_reduce*0.5)
		type.blade:
			atkUI.reduce_ammo(ammo_reduce*0.35)
		type.none:
			atkUI.reduce_stamina(ammo_reduce*0.1)
			# atkUI.reduce_ammo(ammo_reduce*0.35)
	$HurtBox.cancel_flash()
	Short_Range_Attack()
	$AttackAnimationTimer.start()
	await $AttackAnimationTimer.timeout
	can_hit = true
	is_attacking = false

func Short_Range_Attack():
	is_attacking = true
	if GLOBAL.weapon==GLOBAL.base_weapon and atkUI.ammo.value<atkUI.ammo.max_value*2/5:
		can_hit=false
	if can_hit:
		if GLOBAL.weapon.current_ammo >= 0:
			$BulletManager.shoot(position, last_direction, melee_shot_pattern)
		else:
			PLAYSFX.slash()			
		can_hit = false

func shoot():
	if weapon_is == type.gun:
			atkUI.reduce_ammo(ammo_reduce*2)
	elif weapon_is in [type.none]:
		atkUI.reduce_stamina(ammo_reduce*0.15)
	else:
		atkUI.reduce_ammo(ammo_reduce)

	if GLOBAL.weapon.current_ammo >= 0:
		$HurtBox.cancel_flash()
		Long_Range_Attack()
		$AttackAnimationTimer.start()
		await $AttackAnimationTimer.timeout
		can_shoot = true
		is_shooting = false
	else:
		attack()
		can_shoot = false
		is_shooting = false

func Long_Range_Attack():
	is_shooting = true
	if GLOBAL.weapon==GLOBAL.base_weapon and atkUI.ammo.value<atkUI.ammo.max_value*3/5:
		can_shoot=false
	if can_shoot:
		$BulletManager.shoot(position, last_direction, shot_pattern)
		can_shoot = false

func player_movement(delta):
	position = position.clamp(Vector2(margin, 40), Vector2(screen_size.x - margin, screen_size.y - margin))
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	dodge(delta)
	if is_dodging:
		dodge_speed = 2
	else:
		dodge_speed = 1
	if direction != Vector2.ZERO:
		last_direction = direction
		
	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * max_speed * dodge_speed, accel * delta)
	else:
		if !is_dodging:
			atkUI.increase_stamina(delta)
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	process_animation(direction)
	move_and_slide()

func dodge(value:float):
	var stamina=atkUI.ammo
	if stamina.value>stamina.max_value*3/5:
		able_to_dodge=true
	if Input.is_action_pressed("dash"):
		if stamina.value > 0 and able_to_dodge:
			is_dodging = true
			able_to_dodge = false
			dash_fx(rotation, global_position, last_direction)
	else:
		is_dodging=false

	if is_dodging:
		if stamina.value > 0:
			atkUI.reduce_stamina(value)
			$HurtBox.becomes_invincible()
		else:
			is_dodging = false
			if !starting_invincibility:
				$HurtBox.no_longer_invincible()
	else:
		is_dodging = false
		if !starting_invincibility:
			$HurtBox.no_longer_invincible()

func dash_fx(angle, pos, dir):
	PLAYSFX.dash()
	var dash_scene = preload("res://scenes/dashparticles.tscn")
	var dash = dash_scene.instantiate()
	get_tree().current_scene.add_child(dash)
	dash.rotation = angle + deg_to_rad(-90)
	if dir == Vector2.UP:
		dash.global_position = pos - dir * 10
	else:
		dash.global_position = pos + Vector2(0, 16) - dir * 10
	dash.direction = dir.normalized()
	# dash.z_index = -1

# func tired():
# 	$HurtBox.no_longer_invincible()
# 	is_dodging=false
# 	return false

func recovering(delta):
	idle_time += delta
	if idle_time >=1:
		atkUI.regenerate_more(delta)
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)
	else:
		$HurtBox.cancel_flash()

func reset_ammo(on_start=true):
	GLOBAL.weapon.current_ammo+=GLOBAL.weapon.max_ammo/2
	GLOBAL.weapon.current_ammo=clamp(GLOBAL.weapon.current_ammo,0,GLOBAL.weapon.max_ammo)
	atkUI.ammo_setup(GLOBAL.weapon)
	if !on_start:
		PLAYSFX.recover()
		$HurtBox.play_flash(Color.GREEN)

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
