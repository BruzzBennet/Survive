extends Node2D

func _ready():
	BGM.playOverworldMusic()
	$PlayerSpawn.spawn_player(true)
	for i in $ChooseBetween3.get_children():
		i.get_node("Area2D").body_entered.connect($ChooseBetween3.done)
