extends Node2D

func _ready():
	BGM.playOverworldMusic()
	if GLOBAL.last_scene=="res://scenes/worlds/mon_poc_world.tscn":
		$PlayerSpawn.global_position=Vector2(48,272)
		$ChooseBetween3.queue_free()
	else:
		for i in $ChooseBetween3.get_children():
			i.get_node("Area2D").body_entered.connect($ChooseBetween3.done)
	for i in $Zoo.get_children():
		i.spawn_zoo()
	$PlayerSpawn.spawn_player(true)
