extends Node2D

@export var item_summoned: Equipment
var item_name
var item_description
var item_type: String
var item_type_icon: String


func _ready():
	# print("ready to setup item!")
	if item_summoned:
		setup(item_summoned)

func get_item():
	return item_summoned

func setup(item:Equipment):
	item_summoned=item
	if get_node_or_null("Mon") and item.mon_sprite:
		$Mon.texture=item.mon_sprite
	item_name = item.mon_name
	item_description = item.equipment_description
	if get_node_or_null("Ammo"):
		setup_ammo(item)

func hide_ammo():
	$Ammo.visible=false

func show_ammo():
	$Ammo.visible=true

func setup_ammo(item:Equipment):
	var max_ammo
	var current_ammo
	max_ammo=item.max_ammo
	current_ammo=item.current_ammo
	$Ammo.max_value=max_ammo
	$Ammo.value=current_ammo
	if current_ammo >= (max_ammo*6/10):
		set_color(Color(0.0,0.5,0.65,1.0))
	elif current_ammo >= (max_ammo*3/10):
		set_color(Color.YELLOW)
	else:
		set_color(Color.RED)

func update_ammo():
	var current_ammo=item_summoned.current_ammo
	var max_ammo=item_summoned.max_ammo
	$Ammo.value=current_ammo
	if current_ammo >= (max_ammo*6/10):
		set_color(Color(0.0,0.5,0.65,1.0))
	elif current_ammo >= (max_ammo*3/10):
		set_color(Color.YELLOW)
	else:
		set_color(Color.RED)		


func set_color(color):
	var sb = $Ammo.get_theme_stylebox("fill") as StyleBoxFlat
	sb.bg_color=color

func item_icon_is(item: Item):
	match item.item_is:
		item.item_type.normal_item:
			item_type="item"
		item.item_type.weapon:
			match item.weapon.weapon_type:
				Weapon.type.boot:
					item_type="boot"
				Weapon.type.gun:
					item_type="gun"
				Weapon.type.blade:
					item_type="blade"
		item.item_type.suit:
			item_type="suit"
	if item_type!="item":
		item_type_icon = "res://assets/cards/icons/"+item_type+".png"
		$Type.texture=load(item_type_icon)
