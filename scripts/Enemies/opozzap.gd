extends CharacterBody2D

var summon_frames = [10]
@onready var animated_sprite_2d = get_node("Sprite")
@export var pozzap_to_summon : PackedScene
var idle=0

func _ready() -> void:
	add_to_group("enemy")

func summon_pozzap():
	$sfx.play()
	var pozzap=pozzap_to_summon.instantiate()
	get_tree().current_scene.add_child(pozzap)
	pozzap.global_position = global_position +  Vector2.RIGHT * 25
	pozzap.blank()
	var spawner = get_tree().current_scene.get_node_or_null("RNG_Map")
	spawner=spawner.get_child(1)
	spawner=spawner.get_node_or_null("Spawner")
	if spawner:
		spawner.enemies.append(pozzap)
		pozzap.add_to_group("enemies")
		var hitbox = pozzap.get_node("HurtBox")
		hitbox.died.connect(spawner.enemy_died.bind(pozzap))
	else:
		print("Spawner Not Found")
		get_tree().current_scene.print_tree_pretty()


func _on_sprite_frame_changed() -> void:
	if animated_sprite_2d.frame in summon_frames:
		idle+=1
		if idle>=2:
			summon_pozzap()
			idle=0
