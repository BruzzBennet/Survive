extends Node2D

@export var weapon: Equipment
var bullet_scene
var base_speed:=250.0
var speed=base_speed
var durability = 1
var time_on_field: float = 0.4
var timeout_value: = 0.1
var bullet_damage:= 1.0
var shot_type
var weapon_type
var weapon_effect
var suit_effect

func reset_stats():
	speed= base_speed
	durability = 1
	time_on_field= 0.4
	timeout_value = 0.1
	bullet_damage= 1.0

func get_player():
	return get_parent()

func setup(bullet:Equipment, suit:Equipment,weapon_is:String):
	reset_stats()
	weapon=bullet
	weapon_type=weapon_is
	var suit_boost=suit.stat_boost
	var weapon_boost=bullet.stat_boost
	var new_durability = durability + weapon_boost.bullet_power_boost + suit_boost.bullet_power_boost
	durability = max(new_durability,1)
	time_on_field+=(time_on_field/4)*(weapon_boost.bullet_reach_boost+suit_boost.bullet_reach_boost)
	speed+=(base_speed/4)*(weapon_boost.bullet_speed_boost+suit_boost.bullet_speed_boost)
	match weapon_type:
		"blade":
			durability+=1
		"gun":
			speed+=base_speed/4
	bullet_scene = weapon.bullet_scene
	weapon_effect=weapon.effect_added
	suit_effect=suit.effect_added
	shot_type=weapon.shot_type
	
	

func playsfx(shot_pattern_is=null):
	var sfx = $AudioStreamPlayer2D
	sfx.bus = "SFX"
	var shot_list=["simple_shot","short_shot","medium_shot"]
	match weapon_type:
		"blade":
			shot_list=["short_shot","medium_shot"]
		"none":
			shot_list=["short_shot"]
	if shot_pattern_is in shot_list or !shot_pattern_is:
		sfx.stream=weapon.normal_attack_sfx
	else:
		sfx.stream=weapon.special_attack_sfx
	if not sfx.is_playing() and GLOBAL.sfx_on:
		sfx.pitch_scale = randf_range(0.9, 1.35)
		sfx.play()

func shoot(pos,dir,shot_pattern_is=null):
	playsfx(shot_pattern_is)
	var shot_is
	match shot_type:
		null:
			shot_is="simple_shot"
		weapon.shot_pattern.simple_shot:
			shot_is="simple_shot"
		weapon.shot_pattern.continuous_shot_double:
			shot_is="continuous_shot_double"
		weapon.shot_pattern.continuous_shot_triple:
			shot_is="continuous_shot_triple"
		weapon.shot_pattern.triple_shot:
			shot_is="triple_shot"
	# print("SHOOT | shot_pattern: "+str(shot_pattern_is))
	# # print("SHOOT | shot_type: "+str(shot_type))
	# print("SHOOT | shot is: "+str(shot_is))
	shot_pattern(pos,dir,shot_pattern_is,shot_is)

func shot_pattern(pos,dir,shoot_pattern,shot_is:String):
	# print("SHOOT PATTERN | shot_pattern: "+str(shoot_pattern))
	# print("SHOOT PATTERN | shot_is: "+str(shot_is))
	match shoot_pattern:
		"simple_shot":
			normal_shot(pos,dir,shot_is,1.0)
		"circle_shot":
			circle_shot(pos,dir,shot_is)
		"four_way_shot":
			four_way_shot(pos,dir,shot_is)
		"triple_shot":
			tri_shot(pos,dir,shot_is,1.0)
		"triple_shot_short":
			tri_shot(pos,dir,shot_is,0.5)
		"triple_shot_medium":
			tri_shot(pos,dir,shot_is,0.75)
		"c_shot_triple":
			c_shot_triple(pos,dir,shot_is,1.0)
		"c_shot_double":
			c_shot_double(pos,dir,shot_is,1.0)
		"short_shot":
			normal_shot(pos,dir,shot_is,0.5)
		"medium_shot":
			normal_shot(pos,dir,shot_is,0.75)
		"double_shot":
			dual_shot(pos,dir,shot_is,1.0)
		"area_shot":
			area_shot(pos,shot_is,0.75)
		"small_area_shot":
			area_shot(pos,shot_is,0.5)
		null:
			normal_shot(pos,dir,shot_is,1.0)

func no_shot():
	pass

func normal_shot(pos,dir,func_to_use="simple_shot",dur:=1.0):
	var my_func = Callable(self, func_to_use)
	my_func.call(pos,dir,func_to_use,dur)

func simple_shot(pos,dir,_func_to_use,dur:=1.0):
	var anim_name
	var bullet=bullet_scene.instantiate()
	bullet.new_pierce(durability)
	bullet.new_time(time_on_field*dur)
	bullet.new_speed(speed)
	bullet.set_player(get_player())
	bullet.damage_done=bullet_damage
	add_child(bullet)
	bullet.global_position = pos + dir * 10
	if dir.x > 0:
		anim_name = "0"
	elif dir.x < 0 and dir.y > 0:
		anim_name = "2"
	elif dir.y > 0:
		anim_name = "1"
	elif dir.x < 0:
		anim_name = "2"
	elif dir.y < 0:
		anim_name = "3"
	if bullet.get_node_or_null("AnimationPlayer"):
		bullet.get_node("AnimationPlayer").play(anim_name)
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
	if weapon_effect:
		var effect=weapon_effect.instantiate()
		bullet.add_child(effect)
		# effect.owner=bullet
	if suit_effect:
		var effect=suit_effect.instantiate()
		bullet.add_child(effect)
		# effect.owner=bullet

func c_shot_double(pos,dir,func_to_use="simple_shot",dur:=1.0):
	normal_shot(pos,dir,func_to_use,dur)
	await get_tree().create_timer(timeout_value).timeout
	normal_shot(pos,dir,func_to_use,dur)

func continuous_shot_double(pos,dir,dur:=1.0):
	simple_shot(pos,dir,dur)
	await get_tree().create_timer(timeout_value).timeout
	simple_shot(pos,dir,dur)

func c_shot_triple(pos,dir,func_to_use="simple_shot",dur:=1.0):
	await continuous_shot_double(pos,dir,dur)
	await get_tree().create_timer(timeout_value).timeout
	normal_shot(func_to_use,pos,dir,dur)

func continuous_shot_triple(pos,dir,dur:=1.0):
	await continuous_shot_double(pos,dir,dur)
	await get_tree().create_timer(timeout_value).timeout
	simple_shot(pos,dir,dur)

func dual_shot(pos,dir,func_to_use="simple_shot",dur:=1.0):
	normal_shot(pos,dir.rotated(deg_to_rad(15)),func_to_use,dur)
	normal_shot(pos,dir.rotated(deg_to_rad(-15)),func_to_use,dur)

func double_shot(pos,dir,dur:=1.0):
	simple_shot(pos,dir.rotated(deg_to_rad(15)),dur)
	simple_shot(pos,dir.rotated(deg_to_rad(-15)),dur)

func tri_shot(pos,dir,func_to_use="simple_shot",dur:=1.0):
	normal_shot(pos,dir,func_to_use,dur)
	normal_shot(pos,dir.rotated(deg_to_rad(15)),func_to_use,dur)
	normal_shot(pos,dir.rotated(deg_to_rad(-15)),func_to_use,dur)

func triple_shot(pos,dir,_func_to_use="simple_shot",dur:=1.0):
	simple_shot(pos,dir,dur)
	simple_shot(pos,dir.rotated(deg_to_rad(15)),dur)
	simple_shot(pos,dir.rotated(deg_to_rad(-15)),dur)

func circle_shot(pos,dir,func_to_use="simple_shot"):
	var shot_directions
	var start_by_right = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]
	var start_by_up = [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]
	var start_by_left = [Vector2.LEFT,Vector2.UP,Vector2.RIGHT,Vector2.DOWN]
	var start_by_down = [Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT]
	if dir.x > 0:
		shot_directions= start_by_right
	elif dir.y < 0:
		shot_directions= start_by_up
	elif dir.x < 0:
		shot_directions= start_by_left
	elif dir.y > 0:
		shot_directions= start_by_down
	for i in shot_directions:
		var my_func = Callable(self, func_to_use)
		my_func.call(pos,i)
		await get_tree().create_timer(timeout_value).timeout
	
func four_way_shot(pos,_dir,func_to_use="simple_shot"):
	var my_func = Callable(self, func_to_use)
	my_func.call(pos,Vector2.UP)
	my_func.call(pos,Vector2.RIGHT)
	my_func.call(pos,Vector2.DOWN)
	my_func.call(pos,Vector2.LEFT)

func area_shot(pos,shot_is="simple_shot",dur:=1.0):
	normal_shot(pos, Vector2.UP,shot_is,dur)
	normal_shot(pos, Vector2.from_angle(deg_to_rad(45)),shot_is,dur)
	normal_shot(pos, Vector2.RIGHT,shot_is,dur)
	normal_shot(pos, Vector2.from_angle(deg_to_rad(135)),shot_is,dur)
	normal_shot(pos, Vector2.DOWN,shot_is,dur)
	normal_shot(pos, Vector2.from_angle(deg_to_rad(225)),shot_is,dur)
	normal_shot(pos, Vector2.LEFT,shot_is,dur)
	normal_shot(pos, Vector2.from_angle(deg_to_rad(315)),shot_is,dur)
