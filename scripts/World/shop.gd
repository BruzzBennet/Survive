extends Node2D

var tile_maps =[
			preload("res://assets/Tiles/Tiles.png"),
			preload("res://assets/Tiles/Tiles1.png"),
			preload("res://assets/Tiles/Tiles2.png"),
			preload("res://assets/Tiles/Tiles3.png"),
			preload("res://assets/Tiles/Tiles4.png")
		]
var map_texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BGM.ShopTheme()
	map_texture=tile_maps[randi_range(0, tile_maps.size() - 1)]
	$Map.tile_set.get_source(4).texture = map_texture
	var spawner = get_node_or_null("PlayerSpawn")
	spawner.spawn_player()

