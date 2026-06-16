extends Node2D

var button_type=null
var was_pressed := false

func _ready():
	$ButtonManager/VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	button_type="start"
	was_pressed=true
	$Transition.show()
	$Transition/AnimationPlayer.play("Fade_In")
	PLAYSFX.start_tune()
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_options_pressed() -> void:
	was_pressed=true
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	was_pressed=true
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	pass
	#if button_type=="start":

func playMenuMove():
	if !was_pressed:
		PLAYSFX.MenuMove()		

func _on_start_focus_exited() -> void:
	playMenuMove()

func _on_options_focus_exited() -> void:
	playMenuMove()

func _on_quit_focus_exited() -> void:
	playMenuMove()
