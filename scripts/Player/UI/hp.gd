extends Control

@export var startingHP: float = 35.0
@export var maxHP: float = 35.0
@onready var healthbar = %HPBar

func _ready():
	global_position = Vector2(320, 300)
	healthbar.value=startingHP

func set_value(health) -> void:
	healthbar.value=health
