extends Node2D

@export var weapon: Weapon

func _ready() -> void:
	$Sprite2D.texture=weapon.sprite
	$AnimationPlayer.play("idle")
	$PanelContainer/Label.text=weapon.name + ":\n" + weapon.description