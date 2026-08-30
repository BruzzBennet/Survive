extends Node2D

@export var item: Item

func _ready() -> void:
	build(item)
	

func build(this_one_item):
	var sprite
	match this_one_item.item_is:
		this_one_item.item_type.normal_item:
			$Sprite2D.add_child(this_one_item.item_scene.instantiate())
			description(this_one_item.name,this_one_item.description)
		this_one_item.item_type.weapon:
			sprite=this_one_item.weapon.sprite
			build_sprite(sprite)
			description(this_one_item.weapon.name,this_one_item.weapon.description)
		this_one_item.item_type.suit:
			sprite=this_one_item.suit.helmet
			build_sprite(sprite)
			description(this_one_item.suit.name,this_one_item.suit.description)

func description(item_name:String, desc:String):
	$PanelContainer/Label.text=item_name + ":\n" + desc

func build_sprite(sprite_origin):
	$Sprite2D.texture=sprite_origin
	$AnimationPlayer.play("idle")


func _on_area_2d_body_entered(body) -> void:
	if body is Player_Unit:
		match item.item_is:
			item.item_type.weapon:
				body.equip_weapon(item.weapon,GLOBAL.suit)
				PLAYSFX.equip()
			item.item_type.suit:
				body.equip_suit(item.suit,GLOBAL.weapon)
				PLAYSFX.equip()
		PLAYSFX.crunchyMash()
		get_parent().get_parent().done()
