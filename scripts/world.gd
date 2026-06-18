extends Node2D

var spawn_points = [
	Vector2(15, 280),
	Vector2(15, 175),
	Vector2(15, 105),
	Vector2(80, 175),
	Vector2(270, 207),
	Vector2(270, 105),
	Vector2(365, 207),
	Vector2(400, 175),
	Vector2(560, 280),
	Vector2(560, 175),
	Vector2(560, 85)
]

var current_round: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SCORE.actual=0
	SCORE.get_highest()
	$EnemyManager.current_round=current_round
	$EnemyManager.spawn_points=spawn_points
	var point = spawn_points.pick_random()
	$EnemyManager.summon_enemy(point)
	$PlayerManager.spawn_player(Vector2(320,270))
	$Transition.color = Color.BLACK
	$Transition/AnimationPlayer.play("Fade_Out")
	BGM.playStage1()


func _on_death_timer_timeout() -> void:
	SCORE.check()
	$Transition/AnimationPlayer.play("Fade_In")
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
