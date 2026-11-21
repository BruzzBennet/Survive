extends Node2D

func _ready() -> void:
    BGM.playMenuMusic()
    $PlayerSpawn.spawn_player()