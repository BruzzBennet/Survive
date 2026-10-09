extends Control

@onready var bar = %ATKBar
@onready var icon = $Sprite2D
@onready var atk_shown := bar.material as ShaderMaterial
var maxATK 
var regeneration_rate 
var depletion_rate 
var melee_depletion_rate 
var startingATK
var currentATK
var min_ammo
var current_weapon: Weapon
var weapon_type

func setup(weapon: Weapon):
	current_weapon = weapon
	atk_shown.set_shader_parameter("flash_modifier", 0.0)
	maxATK = weapon.max_ammo
	regeneration_rate = weapon.reload_rate
	depletion_rate = weapon.depletion_rate
	melee_depletion_rate = weapon.melee_depletion_rate
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	min_ammo = weapon.min_ammo
	weapon_type = weapon.weapon_type
	set_icon(weapon_type)
	set_value(startingATK)

func set_icon(weapon):
	var icon_name = "None"
	match weapon:
		Weapon.type.boot:
			icon_name="Boot"
		Weapon.type.gun:
			icon_name="Gun"
		Weapon.type.blade:
			icon_name="Blade"
		Weapon.type.none:
			icon_name="None"
	icon.texture=load("res://assets/cards/icons/"+icon_name+"_W.png")

func set_value(atk: float):
	atk_shown.set_shader_parameter("flash_modifier", 0.0)
	#bar.value = atk
	var percent = clamp(atk / maxATK, 0.0, 1.0)
	atk_shown.set_shader_parameter("value", percent)
	if atk > maxATK * 0.5:
		atk_shown.set_shader_parameter("bar_color", Color.GREEN)
	elif atk > maxATK * 0.25:
		atk_shown.set_shader_parameter("bar_color", Color.YELLOW)
	else:
		# PLAYSFX.alert()
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
	currentATK += regeneration_rate * 2 * delta
	currentATK = min(currentATK, maxATK)
	set_value(currentATK)

func reduce(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_value(currentATK)

func reduce_by_melee(times: float = 1):
	var depletion: float = melee_depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_value(currentATK)

func _process(delta: float) -> void:
	if currentATK < maxATK:
		regenerate(delta)
