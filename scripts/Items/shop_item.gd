extends Node2D

@export var item: Item
@export var monCard:=false
@export var duplicated:=false

func _ready() -> void:
	build(item)

func build(this_one_item):
	var sprite
	match this_one_item.item_is:
		this_one_item.item_type.normal_item:
			$Sprite2D.add_child(this_one_item.item_scene.instantiate())
			description(this_one_item.name,this_one_item.description)
		this_one_item.item_type.weapon:
			this_one_item.weapon=this_one_item.weapon.duplicate()	
			sprite=this_one_item.weapon.sprite
			description(this_one_item.weapon.name,this_one_item.weapon.description)
		this_one_item.item_type.suit:
			this_one_item.suit=this_one_item.suit.duplicate()	
			sprite=this_one_item.suit.helmet
			description(this_one_item.suit.name,this_one_item.suit.description)
	build_sprite(sprite)
	if this_one_item.mon_sprite and this_one_item.item_is!=this_one_item.item_type.normal_item:
		$MonSpirit.build_Mon(this_one_item)

func description(item_name:String, desc:String):
	$PanelContainer/Label.text=item_name + ":\n" + desc

func build_sprite(sprite_origin):
	if sprite_origin:
		$Sprite2D.texture=sprite_origin
	if get_node_or_null("AnimationPlayer"):
		$AnimationPlayer.play("idle")
