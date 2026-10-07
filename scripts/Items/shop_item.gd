extends Node2D

@export var item: Item

func _ready() -> void:
	build(item)
	

func build(this_one_item):
	var sprite
	match this_one_item.item_is:
		this_one_item.item_type.normal_item:
			$Sprite2D.add_child(this_one_item.item_scene.instantiate())
			description(this_one_item.name,this_one_item.description)
		this_one_item.item_type.weapon:
			sprite=this_one_item.weapon.sprite
			build_sprite(sprite)
			description(this_one_item.weapon.name,this_one_item.weapon.description)
		this_one_item.item_type.suit:
			sprite=this_one_item.suit.helmet
			build_sprite(sprite)
			description(this_one_item.suit.name,this_one_item.suit.description)

func description(item_name:String, desc:String):
	$PanelContainer/Label.text=item_name + ":\n" + desc

func build_sprite(sprite_origin):
	$Sprite2D.texture=sprite_origin
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
	player.equip_suit(GLOBAL.suit,weapon)
	var new_weapon = weapon.duplicate()
	player.equip_weapon(new_weapon,GLOBAL.suit)
	GLOBAL.weapon=new_weapon

func _on_area_2d_body_entered(body) -> void:
	if body is Player_Unit:
		# switch_weapon_to_item(body)
		add_card()

func add_card():
	if GLOBAL.deck.size() < GLOBAL.deck_size:
		if item.item_is == item.item_type.weapon or item.item_is == item.item_type.suit:
			PLAYSFX.get_card()
			GLOBAL.add_card(item)						
			queue_free()

func switch_weapon_to_item(body):
		match item.item_is:
			item.item_type.weapon:
				PLAYSFX.equip()
				if GLOBAL.weapon.weapon_type != item.weapon.weapon_type or GLOBAL.weapon==preload("res://resources/characters/Weapons/weaponless.tres"):
					call_deferred("switch_weapon", item.weapon, body)
				else:
					body.equip_weapon(item.weapon,GLOBAL.suit)
			item.item_type.suit:
				PLAYSFX.equip()
				body.equip_suit(item.suit,GLOBAL.weapon)
				
		# PLAYSFX.crunchyMash()
		get_parent().get_parent().done()