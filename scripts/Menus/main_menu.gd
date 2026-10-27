extends Node2D

var was_pressed := false

func _ready():
	if GLOBAL.music_on:
		%Music.text="Music: ON" 
	else:
		%Music.text="Music: OFF"
	if GLOBAL.sfx_on:
		%SFX.text="SFX: ON" 
	else:
		%SFX.text="SFX: OFF"
	$Panel/VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	was_pressed=true
	$Panel/VBoxContainer/Start.release_focus()
	$Transition.show()
	$Transition/AnimationPlayer.play("Fade_In")
	$Song.stop()
	PLAYSFX.start_tune()
	await $Transition/AnimationPlayer.animation_finished
	BGM.playStageMusic()
	get_tree().change_scene_to_file(GLOBAL.starting_level)

func _on_quit_pressed() -> void:
	was_pressed=true
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	pass

func _on_music_pressed() -> void:
	if GLOBAL.music_on:
		%Music.text="Music: OFF" 
	else:
		%Music.text="Music: ON"
	GLOBAL.mute_music()


func _on_sfx_pressed() -> void:
	if GLOBAL.sfx_on:
		%SFX.text="SFX: OFF" 
	else:
		%SFX.text="SFX: ON"
	GLOBAL.mute_sfx()
