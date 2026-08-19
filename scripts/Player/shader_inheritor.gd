extends Node2D

var current_focused_button: Button = null

func _ready() -> void:
	# Loop through all nodes inside the panel
	for child in %Panel.get_children():
		if child is Button:
			# Connect the built-in focus entered signal
			child.focus_entered.connect(_on_button_focused.bind(child))

func _on_button_focused(button: Button) -> void:
	PLAYSFX.MenuMove()	
	current_focused_button = button
	#print("Currently focused button in this panel: ", button.name)
	%Preview.set_palette(current_focused_button.get_child(0).color)
