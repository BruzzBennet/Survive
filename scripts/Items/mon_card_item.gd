extends Node2D

@export var item: Equipment
@export var duplicated:=false

func _ready() -> void:
	if duplicated:
		new_item(item)
	build_w_Mon(item)
		

func build_w_Mon(this_one_item: Equipment):
	if this_one_item.mon_sprite:
			$MonSpirit.build_Mon(this_one_item.mon_sprite)
	description(this_one_item.mon_name,stat_shwocase(this_one_item.stat_boost)+this_one_item.equipment_description)
	# item_icon_is(this_one_item)

func description(item_name:String, desc:String):
	$PanelContainer/Label.text=item_name + ":\n" + desc

func stat_shwocase(equipment:Stat_Boost):
		var desc=""
		if equipment.bullet_speed_boost!=0:
			desc+="Bullet Speed " + ifplus(equipment.bullet_speed_boost) + ". "
		if equipment.stamina_boost!=0:
			desc+="Stamina " + ifplus(equipment.stamina_boost) + ". "
		if equipment.bullet_power_boost!=0:
			desc+="Buller Pierce " + ifplus(equipment.bullet_power_boost) + ". "
		if equipment.bullet_reach_boost!=0:
			desc+="Bullet Reach " + ifplus(equipment.bullet_reach_boost) + ". "
		if equipment.stamina_recover_boost!=0:
			desc+="Recover  " + ifplus(equipment.stamina_recover_boost) + ". "
		if desc == "":
			return desc
		else:
			return desc + "\n"

func ifplus(value:int):
	if value>0:
		return "+" + str(value)
	else:
		return str(value)

func new_item(this_one_item: Equipment):
	item=this_one_item.duplicate()

func item_icon_is(this_one_item: Item):
	var item_type: String
	var item_type_icon: String
	match this_one_item.item_is:
		this_one_item.item_type.normal_item:
			item_type="item"
		this_one_item.item_type.weapon:
			match this_one_item.weapon.weapon_type:
				Weapon.type.boot:
					item_type="boot"
				Weapon.type.gun:
					item_type="gun"
				Weapon.type.blade:
					item_type="blade"
		this_one_item.item_type.suit:
			item_type="suit"
	if item_type!="item":
		item_type_icon = "res://assets/cards/icons/"+item_type+".png"
		$CardNode/Type.texture=load(item_type_icon)

func _on_area_2d_body_entered(body) -> void:
	if body is Player_Unit:
		add_card()

func add_card():
	if GLOBAL.deck.size() < GLOBAL.deck_size:
			PLAYSFX.get_card()
			GLOBAL.add_card(item)						
			queue_free()

func switch_weapon_to_item(body):
		match item.item_is:
			item.item_type.weapon:
				PLAYSFX.equip()
				if GLOBAL.weapon.weapon_type != item.weapon.weapon_type \
				# or GLOBAL.weapon==preload("res://resources/characters/Weapons/weaponless.tres")
				:
					call_deferred("switch_weapon", item.weapon, body)
				else:
					body.equip(GLOBAL.suit,item.weapon)
			item.item_type.suit:
				PLAYSFX.equip()
				body.equip(item.suit,GLOBAL.weapon)
		get_parent().get_parent().done()
