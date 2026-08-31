extends Control

@onready var bar = %ATKBar
@onready var atk_shown := bar.material as ShaderMaterial
var maxATK 
var regeneration_rate 
var depletion_rate 
var melee_depletion_rate 
var startingATK
var currentATK
var min_ammo


func setup(weapon: Weapon):
	atk_shown.set_shader_parameter("flash_modifier", 0.0)
	maxATK = weapon.max_ammo
	regeneration_rate = weapon.reload_rate
	depletion_rate = weapon.depletion_rate
	melee_depletion_rate = weapon.melee_depletion_rate
	startingATK= maxATK
	currentATK= maxATK
	min_ammo = weapon.min_ammo
	set_value(startingATK)

func set_value(atk: float):
	atk_shown.set_shader_parameter("flash_modifier", 0.0)
	#bar.value = atk
	var percent = clamp(atk / maxATK, 0.0, 1.0)
	atk_shown.set_shader_parameter("value", percent)
	if atk > maxATK * 0.4:
		atk_shown.set_shader_parameter("bar_color", Color.GREEN)
	elif atk > maxATK * 0.2:
		atk_shown.set_shader_parameter("bar_color", Color.YELLOW)
	else:
		PLAYSFX.alert()
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
	currentATK += regeneration_rate * delta
	currentATK = min(currentATK, maxATK)
	set_value(currentATK)

func regenerate_more(delta) -> void:
	if currentATK < maxATK:
		flash(Color.GREEN)
	currentATK += regeneration_rate * 1.5 * delta
	currentATK = min(currentATK, maxATK)
	set_value(currentATK)

func reduce():
	var depletion: float = depletion_rate
	currentATK = max(0, currentATK - depletion)
	set_value(currentATK)

func reduce_by_melee():
	var depletion: float = melee_depletion_rate
	currentATK = max(0, currentATK - depletion)
	set_value(currentATK)

func _process(delta: float) -> void:
	if currentATK < maxATK:
		regenerate(delta)
