extends Node2D

func _ready():
	get_parent().get_node("HurtBox").area_entered.connect(heal)

func heal(body) -> void:
	# print("it detects!")
	if body is Healing_Item:
		# print("original heal amount: " + str(body.heal_amount))
		body.heal_amount+=0.5 
		# print("new heal amount: " + str(body.heal_amount))
		# print("detects healer!")
		# if get_parent().get_node("HurtBox"):
		# 	print("HurtBox exists!")
		# get_parent().get_node("HurtBox").heals(0.5)
