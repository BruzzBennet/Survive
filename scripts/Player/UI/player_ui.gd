extends Control

@onready var hp = $HP
@onready var ammo = $Ammo
var suit_ammo
var flash_tween: Tween
var current_weapon: Equipment
var current_suit: Equipment
var min_ammo:=1.0
var depletion_rate:=7.0
var max_hp
var maxSuitHP
var startingSuitHP
var currentSuitHP
var maxATK 
var startingATK
var currentATK
var min_suit_hp:=0.1
var original_color=Color(0.0,0.5,0.65,1.0)

func _ready() -> void:
	max_hp=GLOBAL.base_health
	hp.max_value=max_hp
	set_hp(GLOBAL.health,false)
	set_equipment(GLOBAL.suit,GLOBAL.weapon)
	bar_color(ammo,ammo.max_value,ammo.max_value,true,original_color)
	ammo_setup(GLOBAL.weapon)
	suit_ammo_setup(GLOBAL.suit)

func set_equipment(suit:Equipment,weapon:Equipment):
	set_suit(suit)
	set_weapon(weapon)

func set_suit(item:Equipment=null):
	if item and item != GLOBAL.base_suit:
		$CardBase.visible=true
		GLOBAL.suit=item
		$CardBase.setup(GLOBAL.suit)
	else:
		$CardBase.visible=false
		GLOBAL.suit=GLOBAL.base_suit
	
func set_weapon(item:Equipment=null):
	if item and item != GLOBAL.base_weapon:
		$CardBase2.visible=true
		GLOBAL.weapon=item
		$CardBase2.setup(GLOBAL.weapon)
	else:
		$CardBase2.visible=false
		GLOBAL.weapon=GLOBAL.base_weapon

func set_hp(new_hp: float, spawned=true):
	set_health(new_hp,spawned)

func set_health(add: float,spawned=true):
	var old_hp=GLOBAL.health
	var new_hp
	if spawned:
		new_hp=old_hp+add
	else:
		new_hp=old_hp
	GLOBAL.health=clamp(new_hp,0,max_hp)
	hp.value=GLOBAL.health
	bar_color(hp,old_hp,new_hp,spawned)

func bar_color(bar,old_value:float,new_value:float,spawned=true,color:Color=Color.GREEN,damage=true):
	var new_color
	if bar.value >= bar.max_value*6/10:
		new_color=color
	elif bar.value >= bar.max_value*3/10:
		new_color=Color.YELLOW
	else:
		new_color=Color.RED

	var sb = bar.get_theme_stylebox("fill") as StyleBoxFlat
	sb.bg_color=new_color

	if new_value<old_value and damage:
		flash(Color.RED,bar,new_color)
	
	if new_value>old_value and spawned:
		PLAYSFX.heal()
		flash(Color.GREEN,bar,new_color)
		

func flash(color,bar,past_color=original_color):
	var sb = bar.get_theme_stylebox("fill") as StyleBoxFlat

	if sb == null:
		return

	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	sb.bg_color = color

	flash_tween = create_tween()
	flash_tween.tween_property(
		sb,
		"bg_color",
		past_color,
		0.3
	)

	
func set_icon(suit:Suit):
	$PlayerIcon.texture=suit.helmet

func ammo_setup(weapon: Equipment,_spawned=true):
	current_weapon = weapon
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	set_ammo(startingATK)

func reduce_ammo(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_ammo(currentATK)

func set_ammo(_current_ammo):
	var weapon_card=get_node("CardBase2")
	if not weapon_card.item_summoned in [GLOBAL.base_weapon,null]:
		weapon_card.update_ammo()
	
func suit_ammo_setup(weapon: Equipment):
	current_suit = weapon
	currentSuitHP= weapon.current_ammo
	set_ammo_suit()
	
func set_ammo_suit():
	var weapon_card=get_node("CardBase")
	if not weapon_card.item_summoned in [GLOBAL.base_weapon,null]:
		weapon_card.update_ammo()

func reduce_ammo_suit(times: float = 1):
	var depletion: float = times
	currentSuitHP = max(0, currentSuitHP - depletion)
	current_suit.current_ammo = currentSuitHP
	set_ammo_suit()

func reduce_stamina(value:float):
	if ammo.value >= 0:
		ammo.value-=value
		bar_color(ammo,ammo.max_value,ammo.value,true,original_color,false)

func increase_stamina(value:float):
	if ammo.value < ammo.max_value:
		ammo.value+=value
		bar_color(ammo,ammo.value,ammo.max_value,false,original_color)
