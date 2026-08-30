extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Transition.color = Color.BLACK
	%Transition/AnimationPlayer.play("Fade_Out")
	BGM.playOverworldMusic()
	$Red.grab_focus()
	for child in get_children():
		# Verify if the node is actually a Button type
		if child is Button:
			# Connect the pressed signal and bind the child node itself as an argument
			child.pressed.connect(_on_any_button_pressed.bind(child))

# This central function handles every button click
func _on_any_button_pressed(button: Button) -> void:
	
	GLOBAL.player_palette = button.get_child(0).color
	BGM.stopMusic()
	%Transition/AnimationPlayer.play("Fade_In")
	PLAYSFX.start_tune()
	await %Transition/AnimationPlayer.animation_finished
	BGM.playStageMusic()
	get_tree().change_scene_to_file("res://scenes/worlds/rng_world.tscn")

	# print("Button pressed: ", button.name)
	
	# # Match by button name or property to trigger specific actions
	# match button.name:
	# 	"StartButton":
	# 		print("Starting game...")
	# 	"ExitButton":
	# 		print("Exiting...")
