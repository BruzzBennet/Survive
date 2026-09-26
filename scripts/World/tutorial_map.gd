extends Node2D


func _ready():
	BGM.playOverworldMusic()
	$PlayerSpawn.spawn_player()
