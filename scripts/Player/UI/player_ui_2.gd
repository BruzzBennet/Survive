extends Control

var was_pressed := true
var current_focused_button = null
var base_weapon=preload("res://resources/characters/Weapons/weaponless.tres")
var base_suit=preload("res://resources/characters/MR/Suits/Sergyo.tres")
var ui
var located_in
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
	ammo_setup(GLOBAL.weapon,false)
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

func set_equipment(suit:Item,weapon:Item):
	set_suit(suit)
	set_weapon(weapon)

func set_suit(item:Item=null):
	if item:
		# $Panel/Card1/CardBase.visible=true
		GLOBAL.suit_item=item
		$Panel/Card1/CardBase.setup(GLOBAL.suit_item)
	else:
		# $Panel/Card1/CardBase.visible=false
		GLOBAL.suit_item=null
	
func set_weapon(item:Item=null):
	if item:
		# $Panel/Card2/CardBase2.visible=true
		GLOBAL.weapon_item=item
		$Panel/Card2/CardBase2.setup(GLOBAL.weapon_item)
	else:
		# $Panel/Card3/CardBase2.visible=false
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
	
func take_card(button:Button,up=true):
	var card =  button.get_child(0)
	var dist = 6
	if up:
		tween_it(card,located_in-dist)
	else:
		tween_it(card,located_in)

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
		drop_card(item)
		GLOBAL.deck.erase(item)
		PLAYSFX.unequip()
		button.get_child(0).visible = false

func drop_card(item_dropped:Item):
	var card_item_drop=preload("res://scenes/items/Mon_card_item.tscn")
	var card_drop = card_item_drop.instantiate()
	card_drop.global_position=get_player().global_position
	card_drop.position.x+=25
	card_drop.position.y+=25
	card_drop.item=item_dropped
	get_tree().current_scene.add_child(card_drop)
	card_drop.get_node("PanelContainer").visible=false		

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
	var past_suit=GLOBAL.suit_item
	var past_weapon=GLOBAL.weapon_item
	match item.item_is:
		item.item_type.weapon:
			equipment = item.weapon
			if GLOBAL.weapon != item.weapon:
			# 	equipment=base_weapon
			# 	PLAYSFX.unequip()
			# 	if GLOBAL.deck.size()<GLOBAL.deck_size:
			# 		set_weapon()
			# else:
				set_weapon(item)				
				henshin(body)
				if GLOBAL.weapon.weapon_type != equipment.weapon_type:
					call_deferred("switch_weapon", equipment, body)
				else:
					body.equip(GLOBAL.suit,equipment)
		item.item_type.suit:
			equipment = item.suit
			if GLOBAL.suit != item.suit:
			# 	equipment = base_suit
			# 	PLAYSFX.unequip()
			# 	if GLOBAL.deck.size()<GLOBAL.deck_size:
			# 		set_suit()		
			# else:
				set_suit(item)
				henshin(body)
				body.equip(equipment,GLOBAL.weapon)	
	clear_item_from_deck(item,past_suit,past_weapon)
	close_menu()

func clear_item_from_deck(item:Item,past_suit:Item,past_weapon:Item):
	GLOBAL.deck.erase(item)
	match item.item_is:
		item.item_type.weapon:
			if past_weapon and past_weapon!=GLOBAL.weapon_item:
				GLOBAL.add_card(past_weapon)
		item.item_type.suit:
			if past_suit and past_suit!=GLOBAL.suit_item:
				GLOBAL.add_card(past_suit)

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
			var card = panel.get_node("Card"+str(index_num+2)).get_child(0)
			card.visible=true
			card.setup(GLOBAL.deck[index_num-1])

	if GLOBAL.suit_item:
		$Panel/Card1/CardBase.visible=true
	else:
		$Panel/Card1/CardBase.visible=false

	if GLOBAL.weapon_item:
		$Panel/Card2/CardBase2.visible=true
	else:
		$Panel/Card2/CardBase2.visible=false

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
	var check:=0
	for child in $Panel.get_children():
		if child is Button: 
			if child.get_child(0).visible==true:
				child.grab_focus()
				break
			else:
				check+=1
	if check>=(GLOBAL.deck_size+3):
		$Panel/Card1.grab_focus()
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
