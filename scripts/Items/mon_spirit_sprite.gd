extends Sprite2D

@export var item_summoned: Item

func build_Mon(sprite: Texture2D):
	if sprite:
		texture=sprite
		modulate=Color(0,0.5,0.5,0.5)