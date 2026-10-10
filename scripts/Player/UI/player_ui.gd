extends Control

var max_hp
@onready var hp = $HP
@onready var ammo = $Ammo
var flash_tween: Tween
var maxATK 
var regeneration_rate 
var depletion_rate 
var melee_depletion_rate 
var startingATK
var currentATK
var min_ammo
var current_weapon: Weapon
var weapon_type

func _ready() -> void:
	hp.material.set_shader_parameter("flash_modifier", 0.0)
	max_hp=GLOBAL.base_health
	set_hp(GLOBAL.health,false)
	set_icon(GLOBAL.suit)
	ammo_setup(GLOBAL.weapon)

func ammo_setup(weapon: Weapon):
	current_weapon = weapon
	maxATK = weapon.max_ammo
	regeneration_rate = weapon.reload_rate
	depletion_rate = weapon.depletion_rate
	melee_depletion_rate = weapon.melee_depletion_rate
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	min_ammo = weapon.min_ammo
	weapon_type = weapon.weapon_type
	set_ammo(startingATK)

func reduce_ammo(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_ammo(currentATK)


func set_hp(new_hp: float, spawned=true):  
	var old_hp=GLOBAL.health

	GLOBAL.health=clamp(new_hp,0,max_hp)
	hp.value=GLOBAL.health

	if hp.value > max_hp/2:
		hp_color(Color.GREEN)
	elif hp.value > max_hp/4:
		hp_color(Color.YELLOW)
	else:
		hp_color(Color.RED)

	if new_hp<old_hp:
		flash(Color.RED)
	
	if new_hp>old_hp and spawned:
		PLAYSFX.heal()
		flash(Color.GREEN)

func hp_color(color: Color):
	var sb = hp.get_theme_stylebox("fill") as StyleBoxFlat
	if sb == null:
		sb = StyleBoxFlat.new()
		hp.add_theme_stylebox_override("fill", sb)
	sb.bg_color = color

func flash(color):
	var sb = hp.get_theme_stylebox("fill") as StyleBoxFlat

	if sb == null:
		return

	# Stop any previous flash
	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	# Save the current HP color before flashing
	var original_color = sb.bg_color

	sb.bg_color = color

	flash_tween = create_tween()
	flash_tween.tween_property(
		sb,
		"bg_color",
		original_color,
		0.3
	)

func set_ammo(current_ammo):
	ammo.value=current_ammo

func set_icon(suit:Suit):
	$PlayerIcon.texture=suit.helmet
