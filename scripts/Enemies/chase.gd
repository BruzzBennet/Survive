extends Node2D

var this_enemy

func _ready():
	this_enemy = get_parent().get_node("EnemyMovement")
	this_enemy.dumb=true

func _process(_delta: float) -> void:
	if get_player():
		this_enemy.last_direction=(get_player().global_position - this_enemy.global_position).normalized()

func get_player():
	for child in get_tree().current_scene.get_children():
		if child is Player_Unit:
			return child
