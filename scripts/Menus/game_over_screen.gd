extends Control

var was_pressed := false

func _ready():
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, false)
	SCORE.get_highest()
	$Transition.color = Color.BLACK
	$Transition/AnimationPlayer.play("Fade_Out")
	$Panel/VBoxContainer/Restart.grab_focus()

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
	GLOBAL.restart()
	BGM.playStageMusic()
	get_tree().change_scene_to_file(GLOBAL.starting_level)

func _on_main_menu_pressed() -> void:
	GLOBAL.restart()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
