extends Control

var was_pressed := false

func _ready():
	$Transition.color = Color.BLACK
	$Transition/AnimationPlayer.play("Fade_Out")
	$Panel/VBoxContainer/Restart.grab_focus()

func playMenuMove():
	if !was_pressed:
		PLAYSFX.MenuMove()	

func _on_quit_game_pressed() -> void:
	was_pressed=true
	get_tree().quit()

func _on_restart_pressed() -> void:
	was_pressed=true
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, false)
	$Transition/AnimationPlayer.play("Fade_In")
	PLAYSFX.start_tune()
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_restart_focus_exited() -> void:
	playMenuMove()

func _on_quit_game_focus_exited() -> void:
	playMenuMove()
