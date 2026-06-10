extends Control

@export var startingHP: float = 35.0
@export var maxHP: float = 35.0
@onready var healthbar = %HPBar

func _ready():
	healthbar.value=startingHP

func set_value(health) -> void:
	healthbar.value=health
