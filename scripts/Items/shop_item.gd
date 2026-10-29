extends Node2D

@export var item: Item
@export var monCard:=false
@export var duplicated:=false

func _ready() -> void:
	if monCard:
		build_w_Mon(item)
		if duplicated:
			new_item(item)
	else:
		build(item)

func build_w_Mon(this_one_item: Item):
	if this_one_item.mon_sprite:
			$MonSpirit.build_Mon(this_one_item)
	match this_one_item.item_is:	
		this_one_item.item_type.weapon:			
			this_one_item.weapon=this_one_item.weapon			
			description(this_one_item.weapon.name,this_one_item.weapon.description)
		this_one_item.item_type.suit:
			this_one_item.suit=this_one_item.suit
			description(this_one_item.suit.name,this_one_item.suit.description)
	item_icon_is(this_one_item)

func new_item(this_one_item: Item):
	match this_one_item.item_is:	
		this_one_item.item_type.weapon:			
			this_one_item.weapon=this_one_item.weapon.duplicate()			
		this_one_item.item_type.suit:
			this_one_item.suit=this_one_item.suit.duplicate()

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

func build(this_one_item):
	var sprite
	match this_one_item.item_is:
		this_one_item.item_type.normal_item:
			$Sprite2D.add_child(this_one_item.item_scene.instantiate())
			description(this_one_item.name,this_one_item.description)
		this_one_item.item_type.weapon:
			this_one_item.weapon=this_one_item.weapon.duplicate()	
			sprite=this_one_item.weapon.sprite
			description(this_one_item.weapon.name,this_one_item.weapon.description)
		this_one_item.item_type.suit:
			this_one_item.suit=this_one_item.suit.duplicate()	
			sprite=this_one_item.suit.helmet
			description(this_one_item.suit.name,this_one_item.suit.description)
	build_sprite(sprite)
	if this_one_item.mon_sprite and this_one_item.item_is!=this_one_item.item_type.normal_item:
		$MonSpirit.build_Mon(this_one_item)

func description(item_name:String, desc:String):
	$PanelContainer/Label.text=item_name + ":\n" + desc

func build_sprite(sprite_origin):
	if sprite_origin:
		$Sprite2D.texture=sprite_origin
	if get_node_or_null("AnimationPlayer"):
		$AnimationPlayer.play("idle")

var shootplayer: PackedScene = preload("res://scenes/PlayerTypes/Shooter.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var slashplayer: PackedScene = preload("res://scenes/PlayerTypes/Slasher.tscn")

func switch_weapon(weapon,body):
	weapon.current_ammo = weapon.max_ammo
	var player_scene
	match weapon.weapon_type:
		Weapon.type.boot:
			player_scene=dashplayer
		Weapon.type.gun:
			player_scene=shootplayer
		Weapon.type.blade:
			player_scene=slashplayer
	GLOBAL.player_type=player_scene
	var player = player_scene.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = body.global_position
	body.queue_free()
	var new_weapon = weapon.duplicate()
	player.equip(GLOBAL.suit,new_weapon)
	GLOBAL.weapon=new_weapon

func _on_area_2d_body_entered(body) -> void:
	if body is Player_Unit:
		add_card()

func add_card():
	if GLOBAL.deck.size() < GLOBAL.deck_size:
		# match item.item_is:
		# 	item.item_type.weapon:
		# 		item.weapon=item.weapon.duplicate()
		# 	item.item_type.suit:
		# 		item.suit=item.suit.duplicate()
		if item.item_is == item.item_type.weapon or item.item_is == item.item_type.suit:
			PLAYSFX.get_card()
			GLOBAL.add_card(item.duplicate())						
			queue_free()

func switch_weapon_to_item(body):
		match item.item_is:
			item.item_type.weapon:
				PLAYSFX.equip()
				if GLOBAL.weapon.weapon_type != item.weapon.weapon_type or GLOBAL.weapon==preload("res://resources/characters/Weapons/weaponless.tres"):
					call_deferred("switch_weapon", item.weapon, body)
				else:
					body.equip(GLOBAL.suit,item.weapon)
			item.item_type.suit:
				PLAYSFX.equip()
				body.equip(item.suit,GLOBAL.weapon)
		get_parent().get_parent().done()
