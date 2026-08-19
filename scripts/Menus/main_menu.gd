extends Node2D

var was_pressed := false

func _ready():
	$ButtonManager/VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	was_pressed=true
	$ButtonManager/VBoxContainer/Start.release_focus()
	$Transition.show()
	$Transition/AnimationPlayer.play("Fade_In")
	#PLAYSFX.start_tune()
	PLAYSFX.MenuSelect()
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/EquipMenu.tscn")


func _on_options_pressed() -> void:
	was_pressed=true
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	was_pressed=true
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	pass

func playMenuMove():
	if !was_pressed:
		PLAYSFX.MenuMove()		

func _on_start_focus_exited() -> void:
	playMenuMove()

func _on_options_focus_exited() -> void:
	playMenuMove()

func _on_quit_focus_exited() -> void:
	playMenuMove()
