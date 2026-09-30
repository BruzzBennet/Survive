extends Control

var was_pressed := true

func _ready() -> void:
	update_deck()
	hide()

func update_deck():
	var panel = $Panel
	var index_num=0
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
	GLOBAL.about_to_henshin=true
	was_pressed=false
	show()

func close_menu():
	GLOBAL.about_to_henshin=false
	was_pressed=true
	PLAYSFX.MenuSelect()
	hide()
