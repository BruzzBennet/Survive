extends Node2D

var current_focused_button: Button = null

func _ready() -> void:
	for child in %Panel.get_children():
		if child is Button:
			child.focus_entered.connect(_on_button_focused.bind(child))

func _on_button_focused(button: Button) -> void:
	PLAYSFX.MenuMove()	
	current_focused_button = button
	%Preview.set_palette(current_focused_button.get_child(0).color)
