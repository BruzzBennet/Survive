extends Control

var was_pressed := true
var current_focused_button = null
var base_weapon=preload("res://resources/characters/Weapons/weaponless.tres")
var base_suit=preload("res://resources/characters/MR/Suits/Sergyo.tres")
var ui
var located_in

func _ready() -> void:
	ui=get_tree().current_scene.get_node("HenshinMenu/UI")
	update_deck()
	$Screen.hide()
	for child in %Panel.get_children():
		if child is Button:
			located_in=child.get_child(0).position.y
			child.focus_entered.connect(display_info.bind(child))
			child.focus_entered.connect(take_card.bind(child))
			child.focus_exited.connect(take_card.bind(child,false))

func _physics_process(_delta: float):
	if !get_tree().paused:
		screen()
		for child in %Panel.get_children():
			if child is Button and child.has_focus():
				_play_or_discard(child)
	
func take_card(button:Button,up=true):
	var card =  button.get_child(0)
	var dist = 6
	if up:
		tween_it(card,located_in-dist)
		# card.position.y = card.position.y-dist
	else:
		tween_it(card,located_in)
		# card.position.y=card.position.y+dist

func tween_it(node:Node,dist:int):
	var tween = create_tween()
	tween.tween_property(node, "position:y", dist, 0.25)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func _play_or_discard(button:Button):
	if button.get_child(0).visible == true:	
		if Input.is_action_just_pressed("ui_accept"):
			equip(button)
		elif Input.is_action_just_pressed("shoot"):
			discard(button)

func discard(button: Button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		match item.item_is:
			item.item_type.weapon:
				# ui.set_weapon(item)
				if GLOBAL.weapon == item.weapon:
					ui.set_weapon()
					call_deferred("switch_weapon", base_weapon, body)
			item.item_type.suit:
				# ui.set_suit(item)
				if GLOBAL.suit == item.suit:
					ui.set_suit()
					body.equip(base_suit,GLOBAL.weapon)
		drop_card(item)
		GLOBAL.deck.erase(item)
		PLAYSFX.unequip()
		button.get_child(0).visible = false		


func drop_card(item_dropped:Item):
	var card_item_drop=preload("res://scenes/items/Mon_card_item.tscn")
	var card_drop = card_item_drop.instantiate()
	card_drop.global_position=get_player().global_position
	var dist_1 = randi_range(1,30)
	var dist_x=plus_or_minus()
	var pos_x=card_drop.global_position.x+(dist_1*dist_x)
	var pos_y=card_drop.global_position.y+(45)
	var new_position=Vector2(pos_x,pos_y)
	card_drop.item=item_dropped
	card_drop.global_position=new_position
	get_tree().current_scene.add_child(card_drop)
	tween_drop(card_drop,new_position)
	card_drop.get_node("PanelContainer").visible=false	

func tween_drop(node:Node,dist:Vector2):
	var duration=0.25
	var tween_movement = create_tween()
	var sprite=node.get_node("CardNode")
	tween_movement.tween_property(sprite, "global_position", dist, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	

func plus_or_minus():
	var dist = randi_range(0,1)
	if dist==0:
		dist=-1
	return dist

func show_ammo(show_it=true):
	for child in %Panel.get_children():
		if child is Button:
			var card = child.get_child(0)
			if !show_it:
				card.hide_ammo()
			else:
				var item =  card.item_summoned
				if item and	item.item_is == item.item_type.weapon:
					# print(str(item))
					card.show_ammo()
				

func get_player():
	for child in get_tree().current_scene.get_children():
		if child is Player_Unit:
			return child

func display_info(button: Button):
	if button.get_child(0).visible == true:
		var item =  button.get_child(0).item_summoned
		stat_info(item)
	else:
		description("","")

func stat_info(item:Item):
		match item.item_is:
			item.item_type.weapon:
				description(item.weapon.name,stat_shwocase(item.weapon)+item.weapon.description)
			item.item_type.suit:
				description(item.suit.name,stat_shwocase(item.suit)+item.suit.description)

func stat_shwocase(equipment):
	var desc=""
	if equipment is Suit or equipment is Weapon:
		if equipment.speed_boost!=0:
			desc+="Speed " + ifplus(equipment.speed_boost) + ". "
		if equipment.defense_boost!=0:
			desc+="Defense " + ifplus(equipment.defense_boost) + ". "
		if equipment.ammo_boost!=0:
			desc+="Ammo " + ifplus(equipment.ammo_boost) + ". "
		if equipment.bullet_pierce_boost!=0:
			desc+="Pierce " + ifplus(equipment.bullet_pierce_boost) + ". "
		if equipment.bullet_reach_boost!=0:
			desc+="Bullet Reach " + ifplus(equipment.bullet_reach_boost) + ". "
	# if desc == "":
		return desc
	# else:
	# 	return desc + "\n"

func ifplus(value:int):
	if value>0:
		return "+" + str(value)
	else:
		return str(value)

func description(item_name:String, desc:String):
	if item_name=="" && desc=="":
		$Screen/Label.text=""
	else:
		$Screen/Label.text=item_name + ":\n" + desc
	
func _on_any_button_pressed(button: Button) -> void:
	if button.get_child(0).visible == true:
		equip(button)

func equip_switch(button):
	var body = get_player()
	var item =  button.get_child(0).item_summoned
	var equipment
	var past_suit=GLOBAL.suit_item
	var past_weapon=GLOBAL.weapon_item
	match item.item_is:
		item.item_type.weapon:
			ui.set_weapon(item)
			equipment = item.weapon
			henshin(body)
			if GLOBAL.weapon.weapon_type != equipment.weapon_type:
				call_deferred("switch_weapon", equipment, body)
			else:
				body.equip(GLOBAL.suit,equipment)
		item.item_type.suit:
			ui.set_suit(item)
			henshin(body)
			body.equip(item.suit,GLOBAL.weapon)
	GLOBAL.deck.erase(item)
	match item.item_is:
		item.item_type.weapon:
			GLOBAL.weapon_item=item
			if past_weapon and past_weapon!=GLOBAL.base_weapon:
				GLOBAL.add_card(past_weapon)
		item.item_type.suit:
			GLOBAL.suit_item=item
			if past_suit and past_suit!=GLOBAL.base_suit:
				GLOBAL.add_card(past_suit)
	close_menu()

func equip(button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		var equipment
		match item.item_is:
			item.item_type.weapon:
				ui.set_weapon(item)
				GLOBAL.weapon_item=item
				if GLOBAL.weapon != item.weapon:
					equipment = item.weapon
					henshin(body)
				else:
					ui.set_weapon()
					equipment=base_weapon
					PLAYSFX.unequip()
				if GLOBAL.weapon.weapon_type != equipment.weapon_type:
					call_deferred("switch_weapon", equipment, body)
				else:
					body.equip(GLOBAL.suit,equipment)
			item.item_type.suit:
				ui.set_suit(item)
				if GLOBAL.suit != item.suit:
					equipment = item.suit
					henshin(body)
				else:
					ui.set_suit()
					equipment = base_suit
					PLAYSFX.unequip()
				body.equip(equipment,GLOBAL.weapon)	
		close_menu()

func henshin(body):
	PLAYSFX.equip()
	explode(body)

func update_deck():
	var panel = %Panel
	var index_num=0
	for child in panel.get_children():
		if child is Button:
			child.get_child(0).visible = false

	if GLOBAL.deck.size() > 0:
		for i in GLOBAL.deck:
			index_num+=1
			var card = panel.get_node("Card"+str(index_num)).get_child(0)
			card.visible=true
			card.setup(GLOBAL.deck[index_num-1])

func screen():
	update_deck()
	if Input.is_action_just_pressed("henshin_menu"):
		if was_pressed:
			open_menu()
		else:
			close_menu()

func open_menu():
	# update_deck()
	BGM.standBy()
	show_ammo()
	%Panel/Card1.grab_focus()
	GLOBAL.about_to_henshin=true
	was_pressed=false
	$Screen.show()

func close_menu():
	BGM.stop_standBy()
	show_ammo(false)
	for i in %Panel.get_children():
		i.release_focus()
	GLOBAL.about_to_henshin=false
	was_pressed=true
	PLAYSFX.MenuSelect()
	$Screen.hide()

var shootplayer: PackedScene = preload("res://scenes/PlayerTypes/Shooter.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var slashplayer: PackedScene = preload("res://scenes/PlayerTypes/Slasher.tscn")
var weaponless: PackedScene = preload("res://scenes/PlayerTypes/weaponless.tscn")

func switch_weapon(weapon,body):
	var player_scene
	match weapon.weapon_type:
		Weapon.type.boot:
			player_scene=dashplayer
		Weapon.type.gun:
			player_scene=shootplayer
		Weapon.type.blade:
			player_scene=slashplayer
		Weapon.type.none:
			player_scene=weaponless
	GLOBAL.player_type=player_scene
	var this_player = player_scene.instantiate()
	get_tree().current_scene.add_child(this_player)
	this_player.position = body.global_position
	body.queue_free()
	this_player.equip(GLOBAL.suit,weapon)
	GLOBAL.weapon=weapon

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	if here:
		fx.global_position = here.global_position
		get_tree().current_scene.add_child(fx)
	# queue_free()
