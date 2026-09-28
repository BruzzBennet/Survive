extends Node2D

@export var item_summoned: Item
var item_name
var item_description
var item_type: String
var item_type_icon: String


func _ready():
	if item_summoned:
		setup(item_summoned)

func setup(item:Item):
	if item.mon_sprite:
		$Mon.texture=item.mon_sprite
	item_name = item.name
	item_description = item.description
	item_icon_is(item)


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