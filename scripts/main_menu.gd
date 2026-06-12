extends Node2D

var button_type=null

func _ready():
	$ButtonManager/VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	button_type="start"
	$Transition.show()
	$Transition/AnimationPlayer.play("Fade_In")
	PLAYSFX.start_tune()
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	pass
	#if button_type=="start":
		
