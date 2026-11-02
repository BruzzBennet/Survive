extends Node2D

var hurt_box

func _ready():
	setup()

func setup():
	hurt_box = get_parent().get_node_or_null("HurtBox")
	if !hurt_box:
		hurt_box = get_parent().get_node_or_null("HitBox")
	hurt_box.area_entered.connect(explode)

	if get_parent().has_signal("limit_reached"):
		if not get_parent().limit_reached.is_connected(explosion):
			get_parent().limit_reached.connect(explosion)

func explosion():
	var exploded = preload("res://scenes/effects/explosion.tscn")
	var explosion_fx=exploded.instantiate()
	explosion_fx.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion_fx)
	PLAYSFX.died()

func explode(area: Area2D):
	if area is HitBox_Component and (area.attack.source == area.attack.attack_source.enemy or area.get_parent().is_in_group("enemies")):
		explosion()
	