extends Node2D

@export var item_summoned: Item
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

func setup(item:Item):
	# print("item setup!")
	item_summoned=item
	if get_node_or_null("Mon") and item.mon_sprite:
		$Mon.texture=item.mon_sprite
	item_name = item.name
	item_description = item.description
	item_icon_is(item)
	# print("item set up is: "+ str(item))
	if get_node_or_null("Ammo"):
		setup_ammo(item)


func setup_ammo(item:Item):
	if item.item_is == item.item_type.weapon:
		var max_ammo=item.weapon.max_ammo
		var current_ammo=item.weapon.current_ammo
		var _bar_color=$Ammo.get("theme_override_styles/fill").bg_color
		$Ammo.visible=true
		$Ammo.max_value=max_ammo
		$Ammo.value=current_ammo
		if current_ammo >= (max_ammo*2/5):
			_bar_color=Color.GREEN
		elif current_ammo >= (max_ammo/5):
			_bar_color=Color.YELLOW
		else:
			_bar_color=Color.RED	
	else:
		$Ammo.visible=false

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
