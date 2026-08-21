extends Node2D

@export var weapon: Weapon
var bullet_scene
var speed
var durability
var time_on_field
var shot_type
var timeout_value = 0.1

func setup(bullet:Weapon):
	weapon=bullet
	bullet_scene = weapon.bullet_scene
	speed = weapon.bullet_speed
	time_on_field = weapon.bullet_time_on_field
	durability = weapon.enemies_bullet_pierces
	shot_type=weapon.shot_type

func shoot(pos,dir,shot_pattern_is=null):
	var shot_is
	match shot_type:
		weapon.shot_pattern.simple_shot:
			shot_is="simple_shot"
		weapon.shot_pattern.continuous_shot_double:
			shot_is="continuous_shot_double"
		weapon.shot_pattern.continuous_shot_triple:
			shot_is="continuous_shot_triple"
		weapon.shot_pattern.simple_shot:
			shot_is="triple_shot"
	shot_pattern(pos,dir,shot_pattern_is,shot_is)

func shot_pattern(pos,dir,shoot_pattern,shot_is):
	match shoot_pattern:
		"simple_shot":
			simple_shot(pos,dir)
		"circle_shot":
			circle_shot(pos,dir,shot_is)
		"four_way_shot":
			four_way_shot(pos,dir,shot_is)
		null:
			simple_shot(pos,dir)

func no_shot():
	pass

func simple_shot(pos,dir):
	var anim_name
	var bullet=bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = pos + dir * 10
	# bullet.rotation=angle  + deg_to_rad(-90)
	if dir.x > 0:
		anim_name = "0"
	elif dir.y < 0:
		anim_name = "3"
	elif dir.y > 0:
		anim_name = "1"
	elif dir.x < 0:
		anim_name = "2"
	bullet.get_node("AnimationPlayer").play(anim_name)
	bullet.direction = dir.normalized()
	bullet.speed=speed
	bullet.max_time_on_field = time_on_field
	bullet.max_enemies_pierced = durability
	bullet.add_to_group("bullets")

func continuous_shot_double(pos,dir):
	simple_shot(pos,dir)
	await get_tree().create_timer(timeout_value).timeout
	simple_shot(pos,dir)

func continuous_shot_triple(pos,dir):
	await continuous_shot_double(pos,dir)
	await get_tree().create_timer(timeout_value).timeout
	simple_shot(pos,dir)

func triple_shot(pos,dir):
	simple_shot(pos,dir)
	simple_shot(pos,dir.rotated(deg_to_rad(45)))
	simple_shot(pos,dir.rotated(deg_to_rad(-45)))

func circle_shot(pos,dir,func_to_use):
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
	
func four_way_shot(pos,_dir,func_to_use):
	var my_func = Callable(self, func_to_use)
	my_func.call(pos,Vector2.UP)
	my_func.call(pos,Vector2.RIGHT)
	my_func.call(pos,Vector2.DOWN)
	my_func.call(pos,Vector2.LEFT)
