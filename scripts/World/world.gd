extends Node2D

@export var this_level: level

var current_round: float = 1.0
var map_layout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, false)
	map_layout = this_level.map_layout.instantiate()
	add_child(map_layout)
	move_child(map_layout,0)
	SCORE.actual = 0
	SCORE.get_highest()
	$Transition.color = Color.BLACK
	$Transition/AnimationPlayer.play("Fade_Out")
	BGM.playStageMusic()

func _on_death_timer_timeout() -> void:
	SCORE.check()
	$Transition/AnimationPlayer.play("Fade_In")
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
