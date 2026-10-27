extends Control

var was_pressed := true
var current_focused_button = null
var base_weapon=preload("res://resources/characters/Weapons/weaponless.tres")
var base_suit=preload("res://resources/characters/MR/Suits/Sergyo.tres")
var ui
var player

func _ready() -> void:
	update_deck()
	$Screen.hide()
	for child in %Panel.get_children():
		if child is Button:
			child.focus_entered.connect(display_info.bind(child))

func _physics_process(_delta: float):
	if !get_tree().paused:
		screen()
		for child in %Panel.get_children():
			if child is Button and child.has_focus():
				_play_or_discard(child)
	

func _play_or_discard(button:Button):
	if button.get_child(0).visible == true:	
		if Input.is_action_just_pressed("ui_accept"):
			equip(button)
		elif Input.is_action_just_pressed("shoot"):
			discard(button)

func discard(button: Button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		ui=get_tree().current_scene.get_node("UI")
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
		GLOBAL.deck.erase(item)
		PLAYSFX.unequip()
		button.get_child(0).visible = false		

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
		match item.item_is:
			item.item_type.weapon:
				description(item.weapon.name,item.weapon.description)
			item.item_type.suit:
				description(item.suit.name,item.suit.description)
	else:
		description("","")
		

func description(item_name:String, desc:String):
	if item_name=="" && desc=="":
		$Screen/Label.text=""
	else:
		$Screen/Label.text=item_name + ":\n" + desc
	
func _on_any_button_pressed(button: Button) -> void:
	if button.get_child(0).visible == true:
		equip(button)



func equip(button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		var equipment
		ui=get_tree().current_scene.get_node("UI")
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
	var player = player_scene.instantiate()
	get_tree().current_scene.add_child(player)
	player.position = body.global_position
	body.queue_free()
	player.equip(GLOBAL.suit,weapon)
	GLOBAL.weapon=weapon

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	if here:
		fx.global_position = here.global_position
		get_tree().current_scene.add_child(fx)
	# queue_free()
