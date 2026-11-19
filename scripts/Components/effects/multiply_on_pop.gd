extends Node2D

var parent


func _ready() -> void:
	setup()

func setup():
	parent = get_parent()
	add_to_group("pops")
	if parent.has_signal("hit_enemy"):
		if not parent.hit_enemy.is_connected(on_popped):
			parent.hit_enemy.connect(on_popped)

func on_popped():
	PLAYSFX.pop()
	call_deferred("double_shot",parent.global_position,parent.direction)
	parent.queue_free()

func double_shot(pos,dir):
	simple_shot(pos,dir.rotated(deg_to_rad(12)))
	simple_shot(pos,dir.rotated(deg_to_rad(-8.5)))

func simple_shot(pos,dir):
	var anim_name
	var bullet=parent.duplicate()
	bullet.enemies_pierced-=1
	for child in bullet.get_children():
		if child.is_in_group("pops"):
			child.free()
			break
	get_tree().current_scene.add_child(bullet)
	bullet.direction = dir.normalized()
	bullet.global_position = pos + dir.normalized() * 10
	if dir.x > 0:
		anim_name = "0"
		bullet.rotation = bullet.direction.angle()
	elif dir.y > 0:
		anim_name = "1"
		bullet.rotation = bullet.direction.angle() + deg_to_rad(-90)
	elif dir.x < 0:
		anim_name = "2"
		bullet.rotation = bullet.direction.angle() + deg_to_rad(180)
	elif dir.y < 0:
		anim_name = "3"
		bullet.rotation = bullet.direction.angle() + deg_to_rad(90)
	if bullet.get_node_or_null("AnimationPlayer"):
		bullet.get_node("AnimationPlayer").play(anim_name)
	bullet.add_to_group("bullets")
