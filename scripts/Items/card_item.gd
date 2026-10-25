extends CharacterBody2D

@export var item_summoned: Item

func _ready():
	if item_summoned:
		add_item(item_summoned)

func add_item(item:Item):
	if item.item_is == item.item_type.weapon:
		item.weapon.current_ammo = item.weapon.max_ammo
	$Node2D.setup(item)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var item = $Node2D.get_item() 
	if body is Player_Unit and item:
		if GLOBAL.deck.has(item):
			match item.item_is:
				item.item_type.weapon:
					item.weapon.current_ammo = item.weapon.max_ammo
					if GLOBAL.weapon==item.weapon:
						get_tree().current_scene.get_node("ATK").setup(item.weapon)
					PLAYSFX.recover()
					queue_free()
				item.item_type.suit:
					SCORE.actual+=500
					PLAYSFX.pick_coin()
					queue_free()
		elif GLOBAL.deck.size() < GLOBAL.deck_size:
			if item.item_is == item.item_type.weapon or item.item_is == item.item_type.suit:
				PLAYSFX.get_card()
				GLOBAL.add_card(item)						
				queue_free()
		get_tree().current_scene.get_node("HenshinMenu").update_deck()
