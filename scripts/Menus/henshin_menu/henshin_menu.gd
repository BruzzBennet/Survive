extends Control

var was_pressed := true
var current_focused_button = null
var base_weapon=preload("res://resources/characters/Weapons/weaponless.tres")
var base_suit=preload("res://resources/characters/MR/Suits/Sergyo.tres")

func _ready() -> void:
	update_deck()
	hide()
	for child in $Panel.get_children():
		if child is Button:
			# child.pressed.connect(_play_or_discard.bind(child))
			child.focus_entered.connect(display_info.bind(child))

func _physics_process(_delta: float):
	for child in $Panel.get_children():
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
		match item.item_is:
			item.item_type.weapon:
				if GLOBAL.weapon == item.weapon:
					call_deferred("switch_weapon", base_weapon, body)
			item.item_type.suit:
				if GLOBAL.suit == item.suit:
					body.equip_suit(base_suit,GLOBAL.weapon)
		GLOBAL.deck.erase(item)
		PLAYSFX.unequip()
		button.get_child(0).visible = false		
		# close_menu()

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
		$Label.text=""
	else:
		$Label.text=item_name + ":\n" + desc
	
func _on_any_button_pressed(button: Button) -> void:
	if button.get_child(0).visible == true:
		equip(button)

func equip(button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		var equipment
		match item.item_is:
			item.item_type.weapon:
				if GLOBAL.weapon != item.weapon:
					equipment = item.weapon
					henshin(body)
				else:
					equipment=base_weapon
					PLAYSFX.unequip()
				if GLOBAL.weapon.weapon_type != equipment.weapon_type:
					call_deferred("switch_weapon", equipment, body)
				else:
					body.equip_weapon(equipment,GLOBAL.suit)
			item.item_type.suit:
				if GLOBAL.suit != item.suit:
					equipment = item.suit
					henshin(body)
				else:
					equipment = base_suit
					PLAYSFX.unequip()
				body.equip_suit(equipment,GLOBAL.weapon)			
		close_menu()

func henshin(body):
	PLAYSFX.equip()
	explode(body)

func update_deck():
	var panel = $Panel
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

func _process(_delta):
	screen()

func screen():
	if Input.is_action_just_pressed("henshin_menu"):
		update_deck()
		if was_pressed:
			open_menu()
		else:
			close_menu()

func open_menu():
	update_deck()
	$Panel/Card1.grab_focus()
	GLOBAL.about_to_henshin=true
	was_pressed=false
	show()

func close_menu():
	GLOBAL.about_to_henshin=false
	was_pressed=true
	PLAYSFX.MenuSelect()
	hide()

var shootplayer: PackedScene = preload("res://scenes/PlayerTypes/Shooter.tscn")
var dashplayer: PackedScene = preload("res://scenes/PlayerTypes/Dasher.tscn")
var slashplayer: PackedScene = preload("res://scenes/PlayerTypes/Slasher.tscn")
var weaponless: PackedScene = preload("res://scenes/PlayerTypes/weaponless.tscn")

func switch_weapon(weapon,body):
	# weapon.current_ammo = weapon.max_ammo
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
	player.equip_suit(GLOBAL.suit,weapon)
	player.equip_weapon(weapon,GLOBAL.suit)
	GLOBAL.weapon=weapon

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	fx.global_position = here.global_position
	get_tree().current_scene.add_child(fx)
	# queue_free()
