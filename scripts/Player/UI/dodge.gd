extends Control

@export var startingDodge: float = 35.0
@export var minDodge: float = 0.0
@export var currentDodge: float = 35.0
@export var maxDodge: float = 35.0
@export var regeneration_rate: float = 5.0
@export var depletion_rate: float = 50.0
@onready var dodgebar = %DodgeBar

func _ready():
	global_position = Vector2(355, 300)
	set_value(currentDodge)

func set_value(dodge_value) -> void:
	dodgebar.value = dodge_value

func regenerate(delta) -> void:
	currentDodge += regeneration_rate * delta
	currentDodge = min(currentDodge, maxDodge)
	set_value(currentDodge)

func reduce(delta) -> void:
	var depletion: float = depletion_rate * delta
	currentDodge = max(0, currentDodge - depletion)
	set_value(currentDodge)

func _process(delta: float) -> void:
	if currentDodge < maxDodge:
		regenerate(delta)
