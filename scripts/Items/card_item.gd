extends CharacterBody2D

@export var item_summoned: Item

func _ready():
	if item_summoned:
		add_item(item_summoned)

func add_item(item:Item):
	item.duplicate()
	match item.item_is:
			item.item_type.weapon:
				var card = item.weapon.duplicate()
				item.weapon = card
			item.item_type.suit:
				var card = item.suit.duplicate()
				item.suit = card
	$Node2D.setup(item)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var item = $Node2D.get_item() 
	if body is Player_Unit:
		if item and GLOBAL.deck.size() < GLOBAL.deck_size:
			if item.item_is == item.item_type.weapon or item.item_is == item.item_type.suit:
				PLAYSFX.get_card()
				GLOBAL.add_card(item.duplicate())						
				queue_free()
