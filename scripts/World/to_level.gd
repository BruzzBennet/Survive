extends Area2D

@export var change_to_scene: scene_is

enum scene_is{
	tutorial,
	mon_pod
}

var level_is="res://scenes/worlds/start_world.tscn"

func _ready() -> void:
	match_level()

func match_level():
	match change_to_scene:
		scene_is.tutorial:
			level_is="res://scenes/worlds/start_world.tscn"
		scene_is.mon_pod:
			level_is="res://scenes/worlds/mon_poc_world.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body is Player_Unit:
		GLOBAL.last_scene=get_tree().current_scene.scene_file_path
		get_tree().call_deferred("change_scene_to_file", level_is)
