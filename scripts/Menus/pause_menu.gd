extends Control

var was_pressed := false

func _ready():
	get_tree().paused=false
	hide()

func resume():
	was_pressed=true
	PLAYSFX.MenuSelect()
	hide()
	get_tree().paused=false

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
	get_tree().reload_current_scene()

func _process(_delta):
	pause_screen()

func playMenuMove():
	if !was_pressed:
		PLAYSFX.MenuMove()

func _on_continue_focus_exited() -> void:
	playMenuMove()


func _on_options_focus_exited() -> void:
	playMenuMove()


func _on_restart_focus_exited() -> void:
	playMenuMove()

func _on_quit_game_focus_exited() -> void:
	playMenuMove()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	BGM.stopMusic()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
