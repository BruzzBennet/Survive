extends Control

@export var startingATK: float = 35.0
@export var minDodge: float = 0.0
@export var currentATK: float = 35.0
@export var maxATK: float = 35.0
@export var regeneration_rate: float = 5.0
@export var depletion_rate: float = 0.5
@onready var bar = %ATKBar
@onready var atk_shown := bar.material as ShaderMaterial

func _ready():
	set_value(startingATK)

func set_value(atk: float):
	#bar.value = atk
	var percent = clamp(atk / maxATK, 0.0, 1.0)
	atk_shown.set_shader_parameter("value", percent)
	if atk > maxATK * 0.4:
		atk_shown.set_shader_parameter("bar_color", Color.GREEN)
	elif atk > maxATK * 0.2:
		atk_shown.set_shader_parameter("bar_color", Color.YELLOW)
	else:
		atk_shown.set_shader_parameter("bar_color", Color.RED)

func regenerate(delta) -> void:
	currentATK += regeneration_rate * delta
	currentATK = min(currentATK, maxATK)
	set_value(currentATK)

func reduce():
	var depletion: float = depletion_rate
	currentATK = max(0, currentATK - depletion)
	set_value(currentATK)

func _process(delta: float) -> void:
	if currentATK < maxATK:
		regenerate(delta)
