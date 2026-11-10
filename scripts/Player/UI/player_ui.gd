extends Control

@onready var hp = $HP
@onready var ammo = $Ammo
var suit_ammo
var flash_tween: Tween
var current_weapon: Equipment
var current_suit: Equipment
var min_ammo:=1.0
var depletion_rate:=0.65
var max_hp
var maxSuitHP
var maxATK 
var startingATK
var currentATK
var startingSuitHP
var currentSuitHP:=0.2
var min_suit_hp:=0.1
# var weapon_type
var original_color=Color(0.0,0.5,0.65,1.0)

func _ready() -> void:
	max_hp=GLOBAL.base_health
	hp.max_value=max_hp
	set_hp(GLOBAL.health,false)
	set_equipment(GLOBAL.suit_item,GLOBAL.weapon_item)
	# set_icon(GLOBAL.suit)
	ammo_setup(GLOBAL.weapon)
	suit_ammo=get_node_or_null("Suit_Ammo")
	if suit_ammo:
		suit_ammo_setup(GLOBAL.suit,false)

func set_equipment(suit:Equipment,weapon:Equipment):
	set_suit(suit)
	set_weapon(weapon)

func set_suit(item:Equipment=null):
	if item:
		$CardBase.visible=true
		GLOBAL.suit_item=item
		$CardBase.setup(GLOBAL.suit_item)
	else:
		$CardBase.visible=false
		GLOBAL.suit_item=null
	
func set_weapon(item:Equipment=null):
	if item:
		$CardBase2.visible=true
		GLOBAL.weapon_item=item
		$CardBase2.setup(GLOBAL.weapon_item)
	else:
		$CardBase2.visible=false
		GLOBAL.weapon_item=null

func set_hp(new_hp: float, spawned=true):
	# hp.value=GLOBAL.health  
	# if GLOBAL.suit==GLOBAL.base_suit:
		# print("set_hp "+str(spawned))
	set_health(new_hp,spawned)
	# else:
	# 	set_ammo_suit(new_hp, spawned)

func set_health(add: float,spawned=true):
	var old_hp=GLOBAL.health
	var new_hp
	# if old_hp==max_hp:
	# 	new_hp=old_hp
	# else:
	if spawned:
		new_hp=old_hp+add
	else:
		new_hp=old_hp
	GLOBAL.health=clamp(new_hp,0,max_hp)
	hp.value=GLOBAL.health
	# print("current health: "+str(GLOBAL.health))

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

	# Stop any previous flash
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

func ammo_setup(weapon: Equipment,spawned=true):
	current_weapon = weapon
	# weapon_type = weapon.weapon_type
	maxATK = weapon.max_ammo
	ammo.max_value=maxATK
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	set_ammo(startingATK)
	bar_color(ammo,maxATK,currentATK,spawned,original_color,false)

func reduce_ammo(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_ammo(currentATK)
	bar_color(ammo,maxATK,currentATK,true,original_color,false)

func set_ammo(current_ammo):
	ammo.value=current_ammo

func suit_ammo_setup(weapon: Equipment, flash_it=true):
	suit_ammo=get_node_or_null("Suit_Ammo")
	if suit_ammo:
		current_suit = weapon
		if current_suit!=GLOBAL.base_suit:
			maxSuitHP=weapon.max_ammo
			suit_ammo.max_value=maxSuitHP
			currentSuitHP=weapon.current_ammo
			set_ammo_suit(currentSuitHP,flash_it)
		else:
			suit_ammo.value=0

func set_ammo_suit(current_ammo,flash_it=true):
	if suit_ammo:
		var past_hp=currentSuitHP
		if flash_it:
			currentSuitHP+=current_ammo
			currentSuitHP=clamp(currentSuitHP,0,current_suit.max_ammo)
		suit_ammo.value=currentSuitHP
		current_suit.current_ammo=currentSuitHP
		bar_color(suit_ammo,past_hp,currentSuitHP,flash_it,original_color,flash_it)
