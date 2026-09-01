extends CharacterBody2D

@onready var slusshie = preload("res://scenes/items/healing_item.tscn")

func _ready() -> void:
	$HurtBox.yes_or_no_healer=randi_range(0,(1+GLOBAL.current_level/2))