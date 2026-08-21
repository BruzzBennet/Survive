extends Control

@onready var bar = %DodgeBar
@onready var atk_shown := bar.material as ShaderMaterial
@export var startingDodge: float = 35.0
@export var minDodge: float = 0.0
@export var currentDodge: float = 35.0
@export var maxDodge: float = 35.0
@export var regeneration_rate: float = 5.0
@export var depletion_rate: float = 50.0
@onready var dodgebar = %DodgeBar


func _ready():
	set_value(startingDodge)

func set_value(run: float):
	#bar.value = atk
	var percent = clamp(run/ maxDodge, 0.0, 1.0)
	atk_shown.set_shader_parameter("value", percent)
	if run > maxDodge * 0.4:
		atk_shown.set_shader_parameter("bar_color", Color.GREEN)
	elif run > maxDodge * 0.2:
		atk_shown.set_shader_parameter("bar_color", Color.YELLOW)
	else:
		atk_shown.set_shader_parameter("bar_color", Color.RED)

func flash(color):
	atk_shown.set_shader_parameter("flash_color", color)
	atk_shown.set_shader_parameter("flash_modifier", 1.0)
	var tween = create_tween()

	# 2. Smoothly animate the parameter back to 0.0 over 1 second
	tween.tween_property(
		atk_shown,
		"shader_parameter/flash_modifier",
		0.0,
		1
	)

func regenerate(delta) -> void:
	currentDodge += regeneration_rate * delta
	currentDodge = min(currentDodge, maxDodge)
	set_value(currentDodge)

func regenerate_more(delta) -> void:
	if currentDodge < maxDodge:
		flash(Color.GREEN)
	currentDodge += regeneration_rate * 1.5 * delta
	currentDodge = min(currentDodge, maxDodge)
	set_value(currentDodge)

func reduce(delta):
	var depletion: float = depletion_rate * delta
	currentDodge = max(0, currentDodge - depletion)
	set_value(currentDodge)

func _process(delta: float) -> void:
	if currentDodge < maxDodge:
		regenerate(delta)
