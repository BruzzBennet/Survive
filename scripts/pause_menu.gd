extends Control

func _ready():
	get_tree().paused=false
	hide()

func resume():
	hide()
	get_tree().paused=false

func pause():
	show()
	$Panel/VBoxContainer/Continue.grab_focus()
	get_tree().paused=true

func _on_continue_pressed() -> void:
	resume()

func pause_screen():
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
		else:
			resume()
		
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	#PLAYSFX.start_tune()
	get_tree().reload_current_scene()

func _process(delta):
	pause_screen()
