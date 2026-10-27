extends Node2D

var current_focused_button: Button = null
var current_selected_button: Button = null
@export var select_sfx: AudioStream = preload("res://assets/audio/MenuButtonSelect.wav")
@export var has_vbox:=false
var panel

func _ready() -> void:
	if has_vbox:
		panel=%Panel/VBoxContainer
	else:
		panel=%Panel
	for child in panel.get_children():
		if child is Button:
			child.focus_entered.connect(_on_button_focused.bind(child))
			child.pressed.connect(_on_button_pressed.bind(child))

func _on_button_focused(button: Button) -> void:
	PLAYSFX.MenuMove()	
	current_focused_button = button

func _on_button_pressed(button: Button) -> void:
	playsfx()
	current_selected_button = button

func playsfx():
	var sfx = $AudioStreamPlayer2D
	if sfx:
		sfx.bus = "SFX"
		sfx.stream=select_sfx
		if GLOBAL.sfx_on:
			sfx.play()
