extends Node2D

@export var enemy_to_spawn: PackedScene
var spawn_points = []
var enemies = []
var current_round: float = 1.0

func summon_enemy(spawn_point) -> void:
	var enemy=enemy_to_spawn.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_point
	enemies.append(enemy)
	enemy.add_to_group("enemies")
	enemy.died.connect(enemy_died.bind(enemy))


func enemy_died(enemy):
	print("Before erase:", enemies.size())

	enemies.erase(enemy)

	print("After erase:", enemies.size())

	if enemies.is_empty():
		print("Starting next round")
		call_deferred("next_round")

func next_round():
	print("Enemies list size:", enemies.size())
	if current_round<5:
		current_round+=0.5
	var available_spawn_points = spawn_points.duplicate()
	available_spawn_points.shuffle()
	PLAYSFX.enemySpawn()
	for i in range(floor(current_round)):
		summon_enemy(available_spawn_points[i])
