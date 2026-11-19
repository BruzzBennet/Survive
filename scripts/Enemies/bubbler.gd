extends CharacterBody2D

var idle:=0.0
@onready var in_battlefield = get_tree().current_scene.get_node_or_null("RNG_Map")	

func _process(delta:float) -> void:
	if in_battlefield:
		idle+=delta
		if idle >= 3.5:
			summon_bubbly()
			idle=0

func summon_bubbly():
	if GLOBAL.sfx_on:
		$sfx.play()
	var bubbly=load("res://scenes/enemies/bubbly.tscn").instantiate()
	get_tree().current_scene.add_child(bubbly)
	bubbly.global_position = global_position +  Vector2.RIGHT * 32
	var spawner = get_tree().current_scene.get_node_or_null("RNG_Map")	
	if spawner:
		spawner=spawner.get_child(1)
		spawner=spawner.get_node_or_null("Spawner")
		bubbly.add_to_group("enemies")
		var hurtbox = bubbly.get_node("HurtBox")
		hurtbox.died.connect(spawner.enemy_died.bind(bubbly))
