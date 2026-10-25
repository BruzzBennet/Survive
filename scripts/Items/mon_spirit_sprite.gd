extends Sprite2D

@export var item_summoned: Item

func build_Mon(this_one_item: Item):
	var sprite
	if this_one_item.mon_sprite:
			sprite=this_one_item.mon_sprite
			texture=sprite
			modulate=Color(0,0.5,0.5,0.5)