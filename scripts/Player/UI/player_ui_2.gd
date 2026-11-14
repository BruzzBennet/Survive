extends Control

var was_pressed := true
var current_focused_button = null
var base_weapon=GLOBAL.base_weapon
var base_suit=GLOBAL.base_suit
var ui
var located_in
@onready var hp = $HP
@onready var ammo = $Ammo
var flash_tween: Tween
var current_weapon: Equipment
var min_ammo:=1.0
var depletion_rate:=1.0
var max_hp
var maxATK 
var startingATK
var currentATK
var weapon_type
var deck
var original_color=Color(0.0,0.5,0.65,1.0)
var ready_card

func _ready() -> void:
	hp.material.set_shader_parameter("flash_modifier", 0.0)
	max_hp=GLOBAL.base_health
	hp.max_value=max_hp
	set_hp(GLOBAL.health,false)
	set_equipment(GLOBAL.suit,GLOBAL.weapon)
	ammo_setup(GLOBAL.weapon,false)
	bar_color(ammo,ammo.max_value,ammo.max_value,true,original_color)
	$Screen.hide()
	for child in %Panel.get_children():
		if child is Button:
			located_in=child.get_child(0).position.y
			child.focus_entered.connect(display_info.bind(child))
			child.focus_entered.connect(take_card.bind(child))
			child.focus_exited.connect(take_card.bind(child,false))

func set_hp(new_hp: float, spawned=true):
	set_health(new_hp,spawned)

func set_health(add: float,spawned=true):
	var old_hp=GLOBAL.health
	var new_hp
	if spawned:
		new_hp=old_hp+add
	else:
		new_hp=old_hp
	GLOBAL.health=clamp(new_hp,0,max_hp)
	hp.value=GLOBAL.health
	bar_color(hp,old_hp,new_hp,spawned)

func bar_color(bar,old_value:float,new_value:float,spawned=true,color:Color=Color.GREEN,damage=true):
	var new_color
	if bar.value >= bar.max_value*6/10:
		new_color=color
	elif bar.value >= bar.max_value*3/10:
		new_color=Color.YELLOW
	else:
		new_color=Color.RED

	var sb = bar.get_theme_stylebox("fill") as StyleBoxFlat
	sb.bg_color=new_color

	if new_value<old_value and damage:
		flash(Color.RED,bar,new_color)
	
	if new_value>old_value and spawned:
		PLAYSFX.heal()
		flash(Color.GREEN,bar,new_color)

func flash(color,bar,past_color=original_color):
	var sb = bar.get_theme_stylebox("fill") as StyleBoxFlat

	if sb == null:
		return

	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	sb.bg_color = color

	flash_tween = create_tween()
	flash_tween.tween_property(
		sb,
		"bg_color",
		past_color,
		0.3
	)

func set_equipment(suit:Equipment,weapon:Equipment):
	set_suit(suit)
	set_weapon(weapon)

func set_suit(item:Equipment=null):
	if item:
		$Panel/Card1/CardBase.visible=true
		GLOBAL.suit=item
		$Panel/Card1/CardBase.setup(GLOBAL.suit)
	else:
		$Panel/Card1/CardBase.visible=false
		GLOBAL.suit=base_weapon
	
func set_weapon(item:Equipment=null):
	if item:
		$Panel/Card2/CardBase2.visible=true
		GLOBAL.weapon=item
		$Panel/Card2/CardBase2.setup(GLOBAL.weapon)
	else:
		$Panel/Card2/CardBase2.visible=false
		GLOBAL.weapon=base_weapon

func ammo_setup(weapon: Equipment, _flash_it=true):
	current_weapon = weapon
	maxATK = weapon.max_ammo
	# $Ammo.max_value=maxATK
	startingATK= weapon.current_ammo
	currentATK= weapon.current_ammo
	set_ammo(startingATK)
	# bar_color(ammo,maxATK,currentATK,flash_it,original_color,false)

func set_ammo(_current_ammo):
	# ammo.value=current_ammo
	var weapon_card=get_node("Panel/Card2/CardBase2")
	if weapon_card.item_summoned!=GLOBAL.base_weapon:
		weapon_card.update_ammo()

func display_info(button: Button):
	if button.get_child(0).visible == true:
		var item =  button.get_child(0).item_summoned
		stat_info(item)
	else:
		description("","")

func stat_info(item:Equipment):
	description(item.mon_name,stat_shwocase(item.stat_boost)+item.equipment_description)

func description(item_name:String, desc:String):
	if item_name=="" && desc=="":
		$Screen/Label.text=""
	else:
		$Screen/Label.text=item_name + ":\n" + desc

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

func _physics_process(_delta: float):
	if !get_tree().paused:
		screen()
		for child in %Panel.get_children():
			if child is Button and child.has_focus():
				_play_or_discard(child)

func screen():
	update_deck()
	if Input.is_action_just_pressed("henshin_menu"):
		if was_pressed:
			open_menu()
		else:
			close_menu()

func update_deck(extra_deck:=true):
	var panel = %Panel
	var index_num=0
	for child in panel.get_children():
		if child is Button:
			child.get_child(0).visible = false

	if extra_deck:
		if GLOBAL.deck.size() > 0:
			for i in GLOBAL.deck:
				index_num+=1
				var card = panel.get_node("Card"+str(index_num+2)).get_child(0)
				card.visible=true
				card.setup(GLOBAL.deck[index_num-1])
				if index_num==1:
					ready_card=card

	if GLOBAL.suit!=base_suit:
		panel.get_node("Card1/CardBase").visible=true
	else:
		panel.get_node("Card1/CardBase").visible=false

	if GLOBAL.weapon!=base_weapon:
		panel.get_node("Card2/CardBase2").visible=true
	else:
		panel.get_node("Card2/CardBase2").visible=false

	deck=GLOBAL.deck

func open_menu():
	# update_deck()
	BGM.standBy()
	# show_ammo()
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

func show_ammo(show_it=true):
	for child in %Panel.get_children():
		if child is Button:
			var card = child.get_child(0)
			if !show_it:
				card.hide_ammo()
			else:
				card.show_ammo()

func close_menu():
	BGM.stop_standBy()
	# show_ammo(false)
	for i in %Panel.get_children():
		i.release_focus()
	GLOBAL.about_to_henshin=false
	was_pressed=true
	PLAYSFX.MenuSelect()
	$Screen.hide()


func _play_or_discard(button:Button):
	if button.get_child(0).visible == true:	
		var equipment =  button.get_child(0).item_summoned
		if Input.is_action_just_pressed("ui_accept"):
			if GLOBAL.weapon == equipment:
				equip_weapon(GLOBAL.suit)
			equip_suit(equipment)
		elif Input.is_action_just_pressed("shoot"):
			if GLOBAL.suit == equipment:
				equip_suit(GLOBAL.weapon)
			equip_weapon(equipment)
		if Input.is_action_just_pressed("dash"):
			discard(button)
		
func equip_suit(button):
	var body = get_player()
	var item =  button
	var equipment
	var past_suit=GLOBAL.suit
	var past_weapon=GLOBAL.weapon
	if GLOBAL.suit != item:	
		equipment = item
		henshin(body)
		if item==GLOBAL.base_weapon:
			set_suit()
		else:
			set_suit(equipment)
		body.equip(equipment,GLOBAL.weapon)	
		clear_item_from_deck(equipment,button)
		if past_suit!=GLOBAL.base_suit and (past_suit!=past_weapon):
			trade_cards(past_suit)
		close_menu()
	else:
		PLAYSFX.MenuMove()


func trade_cards(equipment:Equipment):
	if GLOBAL.deck.size()<GLOBAL.deck_size:
		GLOBAL.add_card(equipment)

func clear_item_from_deck(item:Equipment,_button):
		GLOBAL.deck.erase(item)
		
	
func get_player():
	for child in get_tree().current_scene.get_children():
		if child is Player_Unit:
			return child

func equip_weapon(button):
	var body = get_player()
	var equipment =  button
	var past_suit=GLOBAL.suit
	var past_weapon=GLOBAL.weapon
	var do_it=true
	match GLOBAL.player_type:
		GLOBAL.base_player_type:
			if equipment==GLOBAL.base_suit:
				set_weapon()
			else:
				set_weapon(equipment)
			call_deferred("switch_weapon", equipment, body, GLOBAL.player_type2)
			henshin(body)
		GLOBAL.player_type2:
			if GLOBAL.weapon == equipment:
				PLAYSFX.MenuMove()
				do_it=false
			else:
				if equipment==GLOBAL.base_suit:
					unequip_weapon(body,GLOBAL.base_suit)
				else:
					set_weapon(equipment)
					body.equip(GLOBAL.suit,equipment)
					henshin(body)
	clear_item_from_deck(equipment,button)
	if past_weapon!=GLOBAL.base_weapon and (past_weapon!=past_suit) and do_it:
		trade_cards(past_weapon)
	if do_it:
		close_menu()


func unequip_weapon(body,template_weapon):
	set_weapon()
	call_deferred("switch_weapon", template_weapon, body, GLOBAL.base_player_type)
	PLAYSFX.unequip()


func switch_weapon(weapon,body,type):
	var player_scene
	player_scene=type
	GLOBAL.player_type=player_scene
	var this_player = player_scene.instantiate()
	get_tree().current_scene.add_child(this_player)
	this_player.position = body.global_position
	body.queue_free()
	this_player.equip(GLOBAL.suit,weapon)
	GLOBAL.weapon=weapon
		

func henshin(body):
	PLAYSFX.equip()
	explode(body)

func explode(here):
	var consume: PackedScene = preload("res://scenes/DiedExplosion.tscn")
	var fx = consume.instantiate()
	if here:
		fx.global_position = here.global_position
		get_tree().current_scene.add_child(fx)

func discard(button: Button):
		var body = get_player()
		var item =  button.get_child(0).item_summoned
		if GLOBAL.weapon == item:
			set_weapon()
			unequip_weapon(body,GLOBAL.base_suit)
		if GLOBAL.suit == item:
			set_suit()
			body.equip(base_suit,GLOBAL.weapon)
		drop_card(item)
		GLOBAL.deck.erase(item)
		PLAYSFX.unequip()
		button.get_child(0).visible = false	

func drop_card(item_dropped:Equipment):
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

func reduce_ammo(times: float = 1):
	var depletion: float = depletion_rate * times
	currentATK = max(0, currentATK - depletion)
	current_weapon.current_ammo = currentATK
	set_ammo(currentATK)
	# bar_color(ammo,maxATK,currentATK,true,original_color,false)

func reduce_stamina(value:float):
	if ammo.value >= 0:
		ammo.value-=value
		bar_color(ammo,ammo.max_value,ammo.value,true,original_color,false)

func increase_stamina(value:float):
	if ammo.value < ammo.max_value:
		ammo.value+=value
		bar_color(ammo,ammo.value,ammo.max_value,false,original_color)