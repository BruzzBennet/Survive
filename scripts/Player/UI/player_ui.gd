extends Control

@onready var hp = $HP
@onready var ammo = $Ammo
var flash_tween: Tween
var current_weapon: Weapon
var min_ammo:=1.0
var depletion_rate:=1.0
var max_hp
var maxATK 
var startingATK
var currentATK
var weapon_type

func _ready() -> void:
	hp.material.set_shader_parameter("flash_modifier", 0.0)
	max_hp=GLOBAL.base_health
	hp.max_value=max_hp
	set_hp(GLOBAL.health,false)
	set_equipment(GLOBAL.suit_item,GLOBAL.weapon_item)
	# set_icon(GLOBAL.suit)
	ammo_setup(GLOBAL.weapon,false)

func set_equipment(suit:Item,weapon:Item):
	set_suit(suit)
	set_weapon(weapon)

func set_suit(item:Item=null):
	if item:
		$CardBase.visible=true
		GLOBAL.suit_item=item
		$CardBase.setup(GLOBAL.suit_item)
	else:
		$CardBase.visible=false
		GLOBAL.suit_item=null
	
func set_weapon(item:Item=null):
	if item:
		$CardBase2.visible=true
		GLOBAL.weapon_item=item
		$CardBase2.setup(GLOBAL.weapon_item)
	else:
		$CardBase2.visible=false
		GLOBAL.weapon_item=null

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
		flash(Color.RED,hp)
	
	if new_hp>old_hp and spawned:
		PLAYSFX.heal()
		flash(Color.GREEN,hp)

func hp_color(color: Color):
	var sb = hp.get_theme_stylebox("fill") as StyleBoxFlat
	if sb == null:
		sb = StyleBoxFlat.new()
		hp.add_theme_stylebox_override("fill", sb)
	sb.bg_color = color

func flash(color,bar):
	var sb = bar.get_theme_stylebox("fill") as StyleBoxFlat

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

func set_icon(suit:Suit):
	$PlayerIcon.texture=suit.helmet

func ammo_setup(weapon: Weapon, flash_it=true):
	current_weapon = weapon
	weapon_type = weapon.weapon_type
	maxATK = weapon.max_ammo
	$Ammo.max_value=maxATK
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	set_ammo(startingATK,flash_it)

func reduce_ammo(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_ammo(currentATK,false)

func set_ammo(current_ammo,flash_it=true):
	if flash_it:
		flash(Color.GREEN,ammo)
	ammo.value=current_ammo
