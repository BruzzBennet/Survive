extends CharacterBody2D

@export var item_summoned: Item

func _ready():
	if item_summoned:
		add_item(item_summoned)

func add_item(item:Item):
	$Node2D.setup(item)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var item = $Node2D.get_item() 
	if body is Player_Unit:
		if item:
			match item.item_is:
				item.item_type.weapon:
					# print("will add weapon")
					GLOBAL.add_weapon(item.weapon)
					if GLOBAL.weapons.size() <= GLOBAL.deck_size:
						queue_free()
				item.item_type.suit:
					# print("will add suit")
					GLOBAL.add_suit(item.suit)
					if GLOBAL.suits.size() <= GLOBAL.deck_size:
						queue_free()
		else:
			print("no item!")
			queue_free()
