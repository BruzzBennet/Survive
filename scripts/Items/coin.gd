extends CharacterBody2D

var score = [50,100,200,500]

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player_Unit:
		SCORE.actual+=score.pick_random()
		PLAYSFX.pick_coin()
		queue_free()

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	fx.global_position = here.global_position
	get_tree().current_scene.add_child(fx)
	queue_free()