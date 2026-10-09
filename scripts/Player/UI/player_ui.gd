extends Control

var max_hp
@onready var hp = $HP
@onready var ammo = $Ammo
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
#  hp_shown.set_shader_parameter("flash_modifier", 0.0)
 
	# if new_hp<GLOBAL.health:
	# 	flash(Color.RED)

	if new_hp>=GLOBAL.health:
		if spawned == true:
			PLAYSFX.heal()
		# flash(Color.GREEN)

	GLOBAL.health=new_hp
	GLOBAL.health=clamp(GLOBAL.health,0,max_hp)
	hp.value=GLOBAL.health

func set_ammo(current_ammo):
	ammo.value=current_ammo

func set_icon(suit:Suit):
	$PlayerIcon.texture=suit.helmet
