extends Control

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
	get_tree().paused=false
	hide()

func resume():
	was_pressed=true
	PLAYSFX.MenuSelect()
	hide()
	get_tree().paused=false
	var henshin_menu=get_tree().current_scene.get_node_or_null("HenshinMenu")
	if henshin_menu:
		if henshin_menu.get_node("Screen").visible==true:
			henshin_menu.open_menu()
		# 	henshin_menu.get_node("Panel/Card1").grab_focus()

func pause():
	show()
	$Panel/VBoxContainer/Continue.grab_focus()
	get_tree().paused=true

func _on_continue_pressed() -> void:
	resume()
	was_pressed=false

func pause_screen():
	if Input.is_action_just_pressed("pause"):
		was_pressed=false
		if !get_tree().paused:
			pause()
		else:
			resume()

func _on_quit_game_pressed() -> void:
	was_pressed=true
	get_tree().quit()

func _on_restart_pressed() -> void:
	was_pressed=true
	PLAYSFX.MenuSelect()
	GLOBAL.restart()
	BGM.playStageMusic()
	get_tree().change_scene_to_file(GLOBAL.starting_level)

func _process(_delta):
	pause_screen()

func playMenuMove():
	if !was_pressed:
		PLAYSFX.MenuMove()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	BGM.stopMusic()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


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
