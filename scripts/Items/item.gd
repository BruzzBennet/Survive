extends Resource
class_name Item

@export var name: String
@export var description: String
@export var item_is: item_type
enum item_type{
	normal_item,
	weapon,
	suit
}
@export var weapon: Weapon
@export var suit: Suit
@export var item_scene: PackedScene
